#!perl -T

use Test::More tests => 6;

BEGIN {
    use_ok( 'SecondLife::Rotation' ) || print "Bail out!
";
}

diag( "Testing SecondLife::Rotation $SecondLife::DataTypes::Rotation::VERSION, Perl $], $^X" );

my $rot = SecondLife::Rotation->new("<1.3,1.5,-3,1>");
is( "$rot", "<1.3, 1.5, -3, 1>", "stringify");
is( $rot->x, 1.3, "x");
is( $rot->y, 1.5, "y");
is( $rot->z, -3, "z");
is( $rot->s, 1, "s");

