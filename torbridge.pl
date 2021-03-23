use strict;
use warnings;
use Torbridge::Options;
use Torbridge::WriteConfigfile;

our $VERSION = 0.02;

Torbridge::Options->new(args => \@ARGV);

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

=encoding utf8 

Copyright © 2020 Ali Moradi.

GNU General Public License v3.0
