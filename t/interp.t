use Test::More tests => 7;

use String::Interpolate::RE qw( strinterp );

my %vars = ( a => '1', b => '2' );
$ENV{a} = '11';
$ENV{b} = '22';
delete $ENV{c};  # just in case

is( strinterp( '$a', \%vars ), '1', 'defined in %vars' );
is( strinterp( '$a' ), '11', 'defined in %ENV' );

# undefined
is( strinterp( '$c' ), '$c', 'not defined' );
is( strinterp( '$c', {}, { EmptyUndef => 1 } ), '', 'not defined; EmptyUndef' );

eval { 
     strinterp( '$c', {}, {RaiseUndef=>1} ); 
};

ok( $@, 'not defined; RaiseUndef');

# don't use %ENV

$ENV{c} = '33';
is( strinterp( '$a', \%vars, {UseEnv => 0} ), '1', 'defined; UseENV => 0' );
is( strinterp( '$c', {}, {UseEnv => 0} ), '$c', 'not defined; UseENV => 0' );
