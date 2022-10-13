package Rarmani::Driver::SQLite;
use strict;
use warnings;
use Rarmani::Driver::Declare;
use Types::Common -types;
use Types::DateTime -all;

type_match Int,      qr/^(INTEGER)$/;
type_match Num,      qr/^(NUMERIC)$/;
type_match Bool,     qr/^(BOOL)$/;
type_match Str,      qr/^(TEXT|REAL)$/;
type_match DateTime, qr/^(DATETIME)$/;
type_match Any,      qr/^.*$/;   

1;