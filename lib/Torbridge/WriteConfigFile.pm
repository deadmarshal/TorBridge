package Torbridge::WriteConfigFile;
use namespace::autoclean;
use Moose;
use Carp;
use Term::ANSIColor qw(:constants);

has ['torrcfile', 'proxytype', 'iptype', 'baseurl'] => (is => 'rw', isa => 'Str');
has 'txtfile' => (is => 'rw', isa => 'Str', default => 'torbridge.conf');

sub BUILD{
  my ($self) = @_;

  if (-e $self->{txtfile}){
    open my $FR, '<', $self->{txtfile}, or croak "Can't open file: $!";
    while(<$FR>){
      if (m/^http/){
	$self->{baseurl} = $_;
      }elsif(m/^\//){
	$self->{torrcfile} = $_;
      }
    }
  }else{
    print BOLD, GREEN, "Enter your torrcfile path (Default: /etc/torc/torrc) ";
    chomp($self->{torrcfile} = <STDIN> || '/etc/tor/torrc');
    print "Enter your desired proxy type (obfsproxy or obfs4proxy)(Default: obfs4proxy) ";
    chomp($self->{proxytype} = <STDIN>);
    if ($self->{proxytype} =~ /(^$)|(obfs4proxy)/) {
      $self->{proxytype} = 'obfs4proxy';
    } elsif ($self->{proxytype} eq 'obfsproxy') {
      $self->{proxytype} = 0;
    }
    print "Do you want to use ipv6? (yes(y) or no(n)) (Default: no) ", RESET;
    chomp($self->{iptype} = <STDIN>);
    if ($self->{iptype} =~ m/Yes|yes|y|Y/) {
      $self->{iptype} = '&ipv6=yes';
    } elsif ($self->{iptype} =~ m/no|No|n|N/) {
      $self->{iptype} = '';
    }

    open my $FW, '>', $self->{txtfile}, or die "Can't write file $!";
    $self->{base_url} = "https://bridges.torproject.org/bridges?transport=$self->{proxytype}$self->{iptype}";
    print $FW "$self->{base_url}", "\n";
    print $FW $self->{torrcfile};
  }
}

__PACKAGE__->meta->make_immutable;

1;
