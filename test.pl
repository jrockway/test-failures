#!/usr/bin/env perl

use strict;
use warnings;
use feature ':5.10';

use Path::Class;

`emacsclient --eval '(test-failure-start)'`;

sub report {
    my ($what) = @_;
    my ($package, $file, $line) = caller 1;
    $file = file(__FILE__)->parent->file($file)->absolute;
    `emacsclient --eval '(report-test-$what "\Q$file\E" $line)'`;
    say "$what $file:$line";
}

sub ok {
    my ($test) = @_;
    if($test) {
        report 'pass';
    }
    else {
        report 'fail';
    }
}

ok 2 + 2 == 5, '2 + 2 is 5';

sleep 2;

ok 2 - 2 == 0, '2 from 2 is zero';

