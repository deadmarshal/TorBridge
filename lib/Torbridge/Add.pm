package Torbridge::Add;
use WWW::Mechanize;
use Mojo::DOM;
use namespace::autoclean;
use Moose;

extends 'WriteConfigFile';

binmode STDOUT, ":utf8";

has 'name' => (is => 'rw', isa => 'Str', default => 'photo.jpg');
has 'mech_class' => (is => 'rw', default => 'WWW::Mechanize');
has 'mech' => (is => 'rw', isa => 'WWW::Mechanize', lazy => 1, default => sub { shift->mech_class->new });
has 'captcha' => (is => 'rw', isa => 'Str');
has 'dom' => (is => 'rw', isa => 'Mojo::DOM');
has 'bridges' => (is => 'rw', isa => 'ArrayRef[Str]');
has 'result' => (is => 'rw', isa => 'Mojo::DOM');

sub BUILD{
  my ($self) = @_;

  $self->mech->get($self->{baseurl});

  my $photo = $self->{mech}->find_image(url_regex => qr{(data:image/jpeg;base64,)});
  $self->{mech}->clone()->get($photo->url, ':content_file' => $self->{name});
  system "feh $self->{name} &";

  # Getting the user response
  print "Enter the captcha: ";
  chomp($self->{captcha} = <STDIN>);

  $self->{mech}->set_visible($self->{captcha});
  $self->{mech}->submit();

  # Entering bridges to torrc file
  open my $TOR, ">>", "$self->{torrcfile}" or die "Can't open file $!";
  $self->{dom} = Mojo::DOM->new($self->{mech}->content);
  $self->{result} = $self->{dom}->at('.bridge-lines');

  if (defined $self->{result}) {
    foreach my $elem ($self->{result}->all_text) {
      s/^\s+//, s/\s+$//, s/^\n//, s/\n$// for $elem;
      @{$self->{bridges}} = split /\n/, $elem;
      print "|| The bellow bridges has been appended to $self->{torrcfile} || ", "\n";
      foreach my $bridge (@{$self->{bridges}}) {
	print "Bridge $bridge", "\n";
	print $TOR "Bridge $bridge", "\n";
      }
    }
  } else{
    my $error = $self->{result}->at('.alert')->find('p')->map('text')->last;
    s/^\s+//, s/\s+$//, s/\n// for $error;
    print STDERR $error, "\n";
  }
}

__PACKAGE__->meta->make_immutable;

1;

