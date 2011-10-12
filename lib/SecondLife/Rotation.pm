package SecondLife::Rotation;
# ABSTRACT: Second Life's rotations (quarterions with a non-standard representation)
use strict;
use warnings;
use overload
	'""' => "stringify";
use Regexp::Common qw/ RE_num_real /;
use Scalar::Util qw( blessed );

use parent qw/Math::Quaternion/;

use constant X_SLOT => 1;
use constant Y_SLOT => 2;
use constant Z_SLOT => 3;
use constant S_SLOT => 0;

=attr our Num $x is rw

The X value of this rotation.

=cut
sub x {
    my $self = shift;
    if ( @_ ) {
        $self->[X_SLOT] = $_[0];
        return $self;
    }
    else {
        return $self->[X_SLOT];
    }
}

=attr our Num $y is rw

The Y value of this rotation.

=cut
sub y {
    my $self = shift;
    if ( @_ ) {
        $self->[Y_SLOT] = $_[0];
        return $self;
    }
    else {
        return $self->[Y_SLOT];
    }
}

=attr our Num $z is rw

The Z value of this rotation.

=cut
sub z {
    my $self = shift;
    if ( @_ ) {
        $self->[Z_SLOT] = $_[0];
        return $self;
    }
    else {
        return $self->[Z_SLOT];
    }
}

=attr our Num $s is rw

The S value of this rotation.

=cut
sub s {
    my $self = shift;
    if ( @_ ) {
        $self->[S_SLOT] = $_[0];
        return $self;
    }
    else {
        return $self->[S_SLOT];
    }
}

=constructor new( Str $slrotation ) returns SecondLife::Rotation

=constructor new( :$x, :$y, :$z, :$s ) returns SecondLife::Rotation

=constructor new( Math::Quaternion $quaternion ) returns SecondLife::Rotation

=constructor new( HashRef $args ) returns SecondLife::Rotation

Construct a SecondLife::Rotation object from either the SL string
representation, or a hash with keys for the individual elements, or a
Math::Quaternion object, or a hashref to pass to Math::Quaternion's constructor.

=cut
sub new {
    my $class = shift;
    if ( @_ == 1 ) {
        my ($rot) = @_;
        if ( blessed $rot ) {
            unless ( $rot->isa("Math::Quaternion") ) {
                require Carp;
                Carp::croak("We only understand quaternion's as provided by Math::Quaternion");
            }
            return $class->new( x=> $rot->[X_SLOT], y=>$rot->[Y_SLOT], z=>$rot->[Z_SLOT], s=>$rot->[S_SLOT] );
        }
        elsif (ref $rot eq 'HASH') {
            return $class->new( Math::Quaternion->new($rot) );
        }
        else {
            my $num = RE_num_real();
            if ( $rot =~ /^ [(<] \s* ($num), \s* ($num), \s* ($num), \s* ($num) \s* [)>] $/xo ) {
                return $class->SUPER::new( $4, $1, $2, $3 );
            }
            else {
                require Carp;
                Carp::croak( "Could not parse a rotation from $rot" );
            }
        }
    }
    else {
        my %args = @_;
        my $self = $class->SUPER::new();
        foreach (keys %args) {
            $self->$_( $args{$_} );
        }
        return bless $self, $class;
    }
}

=method stringify() returns Str

Returns the Second Life string representation of this rotation

=cut
sub stringify {
    my $self = shift;
    return "<".join(", ",$self->x,$self->y,$self->z,$self->s).">";
}

=method rotate_vector( SecondLife::Vector $vector ) returns SecondLife::Vector

Rotates $vector by this rotation and returns the resulting vector.  This does not mutate.

=cut
sub rotate_vector {
    my $self = shift;
    my( $vector ) = @_;
    my( $x, $y, $z) = $self->SUPER::rotate_vector( $vector->x, $vector->y, $vector->z );
    return SecondLife::Vector->new( x=>$x, y=>$y, z=>$z );
}


sub rotation { bless Math::Quaternion::rotation(@_); }

## Wrap methods:
foreach (qw( unit conjugate inverse normalize multiply dot plus minus power negate scale slerp )) {
    my $super = "SUPER::conjugate";
    no strict 'refs';
    *$_ = sub {
        my $self = shift;
        my $class = ref($self) ? ref($self) : $self;
        return bless $self->$super(@_), $class;
    };
}

1;

=head1 SYNOPSIS

    use SecondLife::DataTypes qw( slrot slvec );

    my $rot = SecondLife::Rotation->new( "<0,0,0,1>" ); # create a null rotation
    my $rot = slrot "<0,0,0,1>";                                   # the same
    my $rot = SecondLife::Rotation->new( x=>0, y=>0, z=>0, s=>1 ); # the same
    my $rot = SecondLife::Rotation->new( Math::Quaternion->new( 1, 0, 0, 0 ) ); # The same

    # Rotate the specified vector by the rotation and return the new vector
    my $vec = $rot->rotate_vector( slvec "<1,2,3>" ); 

    print "$rot\n"; # Prints <0, 0, 0, 1>

=head1 DESCRIPTION

This is a subclass of L<Math::Quaternion>.  The constructor can accept the
Second Life string representation of a rotation, x, y, z, s key/value pairs,
a hashref to be passed to Math::Quaternion->new, or a Math::Quaternion
object.

Stringifying produces the SecondLife form, not the Math::Quaternion
form.  

Rotate_vector expects and returns a SecondLife::Vector object.

There are x, y, z, and s accessors.

Otherwise, this is the same as a Math::Quaternion object.  If you want to
know more about the operations available to, please see its documentation.

=head1 SEE ALSO

Math::Quaternion
