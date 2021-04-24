package Torbridge::Options;
use Getopt::Long qw(&GetOptionsFromArray);
use namespace::autoclean;
use Moose;
use Torbridge::WriteConfigFile;
use Torbridge::Add;
use Torbridge::Clean;
use Term::ANSIColor;

has 'args' => (is => 'ro', isa => 'ArrayRef');

sub BUILD{
  my ($self) = @_;

  GetOptionsFromArray(
		      $self->{args},
		      'add|a' => \my $add,
		      'clean|c' => \my $clean,
		      'help|h' => \my $help,
		     );

  if(defined $add){
    Torbridge::WriteConfigFile->new;
    Torbridge::Add->new;
  }elsif(defined $clean){
    Torbridge::Clean->new;
  }elsif(defined $help)
    print color('bold yellow');
    print <<EOF;
To get Tor bridges and appending them to your torrc file, simply run the script with -a or --add option.
To remove the config file run the script with -c or --clean option. (You need to do this if you want to reconfigure proxy type and torrc file path).\n
EOF
  }
}

__PACKAGE__->meta->make_immutable;

1;
