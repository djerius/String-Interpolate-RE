use Test::More tests => 7;
use Test::Exception;

use String::Interpolate::RE qw( interpolate );

my %vars = ( a => '1', b => '2' );
$ENV{a} = '11';
$ENV{b} = '22';
delete $ENV{c};  # just in case

is( interpolate( '$a', \%vars ), '1', 'defined in %vars' );
is( interpolate( '$a' ), '11', 'defined in %ENV' );

# undefined
is( interpolate( '$c' ), '$c', 'not defined' );
is( interpolate( '$c', {}, { EmptyUndef => 1 } ), '', 'not defined; EmptyUndef' );
dies_ok { interpolate( '$c', {}, {RaiseUndef=>1} ) } 'not defined; RaiseUndef';

# don't use %ENV

$ENV{c} = '33';
is( interpolate( '$a', \%vars, {UseEnv => 0} ), '1', 'defined; UseENV => 0' );
is( interpolate( '$c', {}, {UseEnv => 0} ), '$c', 'not defined; UseENV => 0' );
