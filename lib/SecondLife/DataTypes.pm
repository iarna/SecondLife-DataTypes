package SecondLife::DataTypes;
# ABSTRACT: Support for parsing, working with and printing Second Life's data types
use strict;
use warnings;
use SecondLife::Rotation;
use SecondLife::Vector;
use SecondLife::Region;
use Sub::Exporter -setup => { exports => [qw( slrot slvec slregion )] };

sub slrot($) { SecondLife::Rotation->new(@_); }

sub slvec($) { SecondLife::Vector->new(@_); }

sub slregion($) { SecondLife::Region->new(@_); }

1;

=pod

=head1 SYNOPSIS

    use SecondLife::Rotation;
    my $null_rot = SecondLife::Rotation->new("<0,0,0,1.0>");

    # or

    use SecondLife::DataTypes qw( slrot );
    my $null_rot2 = slrot "<0,0,0,1.0>";

    print $null_rot2->s,"\n"; # 1.0
    
    use SecondLife::DataTypes qw( slvec );
    my $cyan = SecondLife::Vector->new("<0,1,1>");
    my $rec = slvec '<1,0,0>';
    
    use SecondLife::DataTypes qw( slregion );
    my $region = SecondLife::Region->new("Dew Drop (236544, 242944)");
    my $region2 = slregion 'Dew Drop (236544, 242944)'; # same

=head1 DESCRIPTION

This module loads the other SecondLife data type modules and optionally
provides sugar for creating new instances of them from strings.

=func sub slrot(Str $rot_str) returns SecondLife::Rotation

Create a new L<SecondLife::Rotation> object from a string.

=func slvec(Str $vec_str) returns SecondLife::Vector

Create a new L<SecondLife::Vector> object from a string.

=func slregion(Str $region_str) returns SecondLife::Region

Create a new L<SecondLife::Region> object from a string

=head1 SEE ALSO

SecondLife::Rotation
SecondLife::Vector
SecondLife::Region
Math::Quaternion

