package SecondLife::Region;
# ABSTRACT: Second Life's region identifiers (a name, plus a location in the 2d grid of sims)
use Any::Moose;
use overload q{""} => \&stringify;
use Regexp::Common qw/ RE_num_int /;

has 'name' => ( is=>'rw', isa=>'Str' );
has [qw( x y )] => ( is=> 'rw', isa=>'Int' );

sub BUILDARGS {
    my $self = shift;
    my( $region ) = @_;
    my $num = RE_num_int();
    if ( @_==1 ) {
        if ( $region =~ /^ (.*?) \s* \( ($num), \s* ($num) \) $/xo ) {
            return { name=> $1, x=> $2, y=> $3 };
        }
        else {
            require Carp;
            Carp::croak( "Could not parse a region from $region" );
        }
    }
    elsif ( ! (@_ % 2) ) {
        return { @_ };
    }
    else {
        require Carp;
        Carp::croak( "Invalid region constructor" );
    }
}

sub stringify {
    my $self = shift;
    return $self->name . " (" . $self->x . ", " . $self->y .")";
}


no Any::Moose;
__PACKAGE__->meta->make_immutable;

1;

=head1 SYNOPSIS

    use SecondLife::DataTypes;
    my $region = SecondLife::Region->new( name=>"Dew Drop", x=>236544, y=>242944 );

    # Or from a string, for instance, in a PSGI handler:

    use Plack::Request;
    
    sub psgi_handler {
        my $req = Plack::Request->new( shift );
        my $region = SecondLife::Region->new( $req->header('X-SecondLife-Region') );
        my $res = $req->new_response( 200 );
        $res->content_type('text/plain');
        $res->body(
            "This request was made from the ".$region->name." region of SecondLife\n".
            "Which is located at the global coordinates ".$region->x.", ".$region->y."\n".
            "This would be expressed as $region normally."
        );
        return $res->finalize;
    }

=head1 DESCRIPTION

This parses and emits Second Life region identifiers, which are made up of a
name and coordinates of the region on the grid.  These can be turned into
the global coordinates for the top left of the region by multiplying by 256.

=constructor our method new($class: Str :$name, Int :$x, Int :$y)

=constructor our method new($class: Str $region_str ) returns SecondLife::Region

The constructor either takes a single argument, a region string you want to
parse in the format: Region Name (X, Y)
Or a hash with the attributes you want to have started initialized.

=attr has Str $.name is rw

The name of the region

=attr has Int $.x is rw

=attr has Int $.y is rw

The X and Y coordinates of the region on the grid.

=method our method stringify() returns Str

Returns the region and coordinates as a string in the same form that Second
Life does.  Evalauting the object as a string will also produce this result.

