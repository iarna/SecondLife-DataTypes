#!perl -T

use Test::More tests => 6;

BEGIN {
    use_ok( 'SecondLife::Vector' ) || print "Bail out!
";
}

diag( "Testing SecondLife::Vector $SecondLife::DataTypes::Vector::VERSION, Perl $], $^X" );

my $rot = SecondLife::Vector->from_string("<1.3,1.5,-3,1>");
is( "$rot", "<1.3, 1.5, -3, 1>", "stringify");
is( $rot->x, 1.3, "x");
is( $rot->y, 1.5, "y");
is( $rot->z, -3, "z");
is( $rot->s, 1, "s");

