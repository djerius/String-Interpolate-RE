# NAME

String::Interpolate::RE - interpolate variables into strings using regular expressions

# VERSION

version 0.12

# SYNOPSIS

    # default formulation
    use String::Interpolate::RE qw( strinterp );

    $str = strinterp( "${Var1} $Var2", $vars, \%opts );

    # import with different default options.
    use String::Interpolate::RE strinterp => { opts => { useENV => 0 } };

# DESCRIPTION

This module interpolates variables into strings using regular
expression matching rather than Perl's built-in interpolation
mechanism and thus hopefully does not suffer from the security
problems inherent in using **eval** to interpolate into strings of
suspect ancestry.

## Changing the default option values

The default values for ["strinterp"](#strinterp)'s options were not all well
thought out.  **String::Interpolate::RE** uses [Exporter::Tiny](https://metacpan.org/pod/Exporter%3A%3ATiny),
allowing a version of ["strinterp"](#strinterp) with saner defaults to be
exported.  Simply specify them when importing:

    use String::Interpolate::RE strinterp => { opts => { useENV => 0 } };

The subroutine may be renamed using the `-as` option:

    use String::Interpolate::RE strinterp => { -as => strinterp_noenv,
                                               opts => { useENV => 0 } };

    strinterp_noenv( ... );

# INTERFACE

- strinterp

        $str = strinterp( $template );
        $str = strinterp( $template, $vars );
        $str = strinterp( $template, $vars, \%opts );

    Interpolate variables into a template string, returning the
    resultant string.  The template string is scanned for tokens of the
    form

        $VAR
        ${VAR}

    where `VAR` is composed of one or more word characters (as defined by
    the `\w` Perl regular expression pattern). `VAR` is resolved using
    the optional `$vars` argument, which may either by a hashref (in
    which case `VAR` must be a key), or a function reference (which is
    passed `VAR` as its only argument and must return the value).

    If the value returned for `VAR` is defined, it will be interpolated
    into the string at that point.  By default, variables which are not
    defined are by default left as is in the string.

    The `%opts` parameter may be used to modify the behavior of this
    function.  The following (case insensitive) keys are recognized:

    - format _boolean_

        If this flag is true, the template string may provide a `sprintf`
        compatible format which will be used to generate the interpolated
        value.  The format should be appended to the variable name with
        an intervening `:` character, e.g.

            ${VAR:fmt}

        For example,

            %var = ( foo => 3 );
            print strinterp( '${foo:%03d}', \%var, { format => 1 } );

        would result in

            003

    - raiseundef _boolean_

        If true, a variable which has not been defined will result in an
        exception being raised.  This defaults to false.

    - emptyundef _boolean_

        If true, a variable which has not been defined will be replaced with
        the empty string.  This defaults to false.

    - useENV _boolean_

        If true, the `%ENV` hash will be searched for variables which are not
        defined in the passed `%var` hash.  This defaults to true.

    - recurse _boolean_

        If true, derived values are themselves scanned for variables to
        interpolate.  To specify a limit to the number of levels of recursions
        to attempt, set the `recurse_limit` option.  Circular dependencies
        are caught, but just to be safe there's a limit of recursion levels
        specified by `recurse_fail_limit`, beyond which an exception is
        thrown.

        For example,

            my %var = ( a => '$b', b => '$c', c => 'd' );
            strinterp( '$a', \%var ) => '$b'
            strinterp( '$a', \%var, { recurse => 1 } ) => 'd'
            strinterp( '$a', \%var, { recurse => 1, recurse_limit => 1 } ) => '$c'

            strinterp( '$a', { a => '$b', b => '$a' } , { recurse => 1 }
                  recursive interpolation loop detected with repeated
                  interpolation of $a

    - recurse\_limit _integer_

        The number of recursion levels to descend when recursing into a
        variable's value before stopping.  The default is `0`, which means no
        limit.

    - recurse\_fail\_limit _integer_

        The number of recursion levels to descend when recursing into a
        variable's value before giving up and croaking.  The default is `100`.
        Setting this to `0` means no limit.

    - variable\_re _regular expression_

        This specifies the regular expression (created with the `qr`
        operator) which will match a variable name.  It defaults to
        `qr/\w+/`. Don't use `:`, `{`, or `}` in the regex, or things may
        break.

# DIAGNOSTICS

- `undefined variable: %s`

    This string is thrown if the `RaiseUndef` option is set and the
    variable `%s` is not defined.

- `recursive interpolation loop detected with repeated interpolation of <%s>`

    When resolving nested interpolated values (with the `recurse` option
    true ) a circular loop was found.

- `recursion fail-safe limit (%d) reached at interpolation of <%s>`

    The recursion fail safe limit (`recurse_fail_limit`) was reached while
    interpolating nested variable values (with the `recurse` option true ).

# SUPPORT

## Bugs

Please report any bugs or feature requests to bug-string-interpolate-re@rt.cpan.org  or through the web interface at: https://rt.cpan.org/Public/Dist/Display.html?Name=String-Interpolate-RE

## Source

Source is available at

    https://gitlab.com/djerius/string-interpolate-re

and may be cloned from

    https://gitlab.com/djerius/string-interpolate-re.git

# AUTHOR

Diab Jerius <djerius@cpan.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2017 by Smithsonian Astrophysical Observatory.

This is free software, licensed under:

    The GNU General Public License, Version 3, June 2007
