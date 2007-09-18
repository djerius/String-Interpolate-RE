use strict;
use warnings;
use inc::Module::Install;

name 'String-Interpolate-RE';

all_from 'lib/String/Interpolate/RE.pm';

build_requires 'Test::More';
build_requires 'Test::Exception';

auto_install;

WriteAll;
