###### NAME

TorBridge - A simple Perl script to fetch Tor proxies from https://bridges.torproject.org website.

###### Screenshot

![Image of TorBridge](https://github.com/deadmarshal/TorBridge/blob/master/torbridge.png)

###### DESCRIPTION

To get Tor bridges and appending them to your torrc file, simply run the script with -a or --add option.
To remove the config file run the script with -c or --clean option. (You need to do this if you want to reconfigure proxy type and torrc file path)

###### DEPENDENCIES

WWW::Mechanize;
Mojo::DOM;
Getopt::Long;
install dependencies with this command:
cpanm --installdeps .

feh (https://feh.finalrewind.org)
###### AUTHOR(S)

Ali Moradi (adeadmarshal@gmail.com)

###### COPYRIGHT AND LICENSE

Copyright © 2020 Ali Moradi.

GNU General Public License v3.0
