#!/usr/local/bin/perl
use strict;
use warnings FATAL => 'all';
use WWW::Mechanize;
use Mojo::DOM;
use Getopt::Long;
binmode STDOUT, ":utf8";
our $VERSION = 0.01;

# Getting baseurl from user.
my $torrcfile;
my $proxytype;
my $iptype;
my $FR;
my $FW;
my $txtfile = 'torbridge.conf';
my $base_url;

if (-e $txtfile){
    open $FR, '<', $txtfile, or die "Can't open file $!";
    while (<$FR>){
        if (m/^http/){
            $base_url = $_;
        }elsif (m/^\//){
            $torrcfile = $_;
        }
    }

}else{
    print "Enter your torrcfile path (Default: /etc/tor/torrc) ";
    chomp($torrcfile = <STDIN> || '/etc/tor/torrc');

    print "Enter your desired proxy type (obfsproxy or obfs4proxy)(Default: obfs4proxy) ";
    chomp($proxytype = <STDIN>);
    if ($proxytype =~ /(^$)|(obfs4proxy)/){
        $proxytype = 'obfs4proxy';
    }elsif ($proxytype eq 'obfsproxy'){
        $proxytype = 0;
    }
    print "Do you want to use ipv6? (yes(y) or no(n)) (Default: no) ";
    chomp($iptype = <STDIN>);
    if ($iptype =~ m/Yes|yes|y|Y/){
        $iptype = '&ipv6=yes';
    }elsif ($iptype =~ m/no|No|n|N/){
        $iptype = '';
    }

    open $FW, '>', $txtfile, or die "Can't write file $!";
    $base_url = "https://bridges.torproject.org/bridges?transport=$proxytype$iptype";
    print $FW "$base_url", "\n";
    print $FW $torrcfile;
}

GetOptions(
    "a|add" => \my $add,
    "c|clean" => \my $clean,
);

if (defined $add) {
    # Fetching the captcha photo.
    my $mech = WWW::Mechanize->new;

    my $name = 'photo.jpg';
    $mech->get($base_url);

    my $photo = $mech->find_image(url_regex => qr{(data:image/jpeg;base64,)});
    $mech->clone()->get($photo->url, ':content_file' => $name);
    system "feh $name &";

    # Getting the user response.
    print "Enter the captcha: ";
    chomp(my $captcha = <STDIN>);

    $mech->set_visible($captcha);
    $mech->submit();

    # Entering bridges to torrc file.
    open my $TOR, ">>", "$torrcfile" or die "Can't open file $!";

    my $dom = Mojo::DOM->new($mech->content);
    my $result = $dom->at('.bridge-lines');
    if(defined $result) {
        foreach my $elem ($result->all_text){
            s/^\s+//, s/\s+$//, s/^\n//, s/\n$// for $elem;
            my @bridges = split /\n/, $elem;
            print "|| The bellow bridges has been appended to $torrcfile || ", "\n";
            foreach my $bridge (@bridges) {
                print "Bridge $bridge", "\n";
                print $TOR "Bridge $bridge", "\n";
        }
    }
    }else{
        my $error = $dom->at('.alert')->find('p')->map('text')->last;
        s/^\s+//, s/\s+$//, s/\n// for $error;
        print $error, "\n";
    }

    unlink $name;

    }elsif (defined $clean){
        unlink $txtfile;
        print "$txtfile has been cleaned", "\n";
    }else{
        print "No options specified!\n"
}

__END__
=head1 NAME

TorBridge - A simple Perl script to fetch Tor proxies from https://bridges.torproject.org/bridges website.

=head1 VERSION

$version = 0.01;

=head1 DESCRIPTION

To get Tor bridges and appending them to your torrc file, simply run the script with -a or --add option.
To remove the config file run the script with -c or --clean option. (You need to do this if you want to reconfigure proxy type and torrc file path)

=head1 DEPENDENCIES

WWW::Mechanize;
Mojo::DOM;
Getopt::Long;

=head1 AUTHORS

Ali Moradi (adeadmarshal@gmail.com)

=head1 COPYRIGHT AND LICENSE

Copyright © 2020 Ali Moradi.

GNU General Public License v3.0
