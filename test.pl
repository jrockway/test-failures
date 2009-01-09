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

ok 2 - 3 > 0, "you can't take three from two";

ok 2 < 3, "two is less than three";

ok 40 =~ /4.$/, "so you look at the four in the tens place";
