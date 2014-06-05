use strict;
use warnings;
use inc::Module::Install;

name 'String-Interpolate-RE';

all_from 'lib/String/Interpolate/RE.pm';

author 'Diab Jerius';

author_tests( 'xt' );

auto_install;

cpanfile;

WriteAll;
