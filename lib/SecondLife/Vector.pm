package SecondLife::Vector;
# ABSTRACT: Second Life's vectors (an x, y and z representing a location );
use Any::Moose;
use Regexp::Common qw/ RE_num_real /;

has [qw(x y z)] => (is=>'rw', isa=>'Num');
use overload q{""} => \&stringify;

sub BUILDARGS {
    my $self = shift;
    if ( @_ == 1 ) {
        my( $vec ) = @_;
        my $num = RE_num_real();
        if ( $vec =~ /^ [(<] \s* ($num), \s* ($num), \s* ($num) \s* [)>] $/xo ) {
            return { x=> $1, y=> $2, z=> $3 };
        }
        else {
            require Carp;
            Carp::croak( "Could not parse a vector from $vec" );
        }
    }
    else {
        return { @_ };
    }
}

sub stringify {
    my $self = shift;
    return "<".join(", ",$self->x,$self->y,$self->z).">";
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;

1;

=head1 SYNOPSIS

    use SecondLife::DataTypes;
    
    my $vec = SecondLife::Vector->new( "<1,2,3>" );           # same
    my $vec = SecondLife::Vector->new( x=>$1, y=>$2, z=>$3 ); # same
    
    say "$vec"; # Print out <1, 2, 3>

=head1 DESCRIPTION

This represents a Second Life vector, a location with x, y and z components. 
These objects can be manipulated by methods in SecondLife::Rotation.

=constructor our method new($class: Str $vector_str) returns SecondLife::Vector

=constructor our method new($class: :$x, :$y, :$z) returns SecondLife::Vector

=attr our Num $x is rw

The X value of this vector.

=attr our Num $y is rw

The Y value of this vector.

=attr our Num $z is rw

The Z value of this vector.

=method our method stringify() returns Str

Returns the Second Life vector representation.

=cut
