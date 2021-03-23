package Torbridge::Clean;
use namespace::autoclean;
use Moose;

extends 'WriteConfigFile';

sub BUILD{
  my ($self) = @_;
  unlink $self->{txtfile};
  print "$self->{txtfile} has been cleaned", "\n";
}

__PACKAGE__->meta->make_immutable;

1;
