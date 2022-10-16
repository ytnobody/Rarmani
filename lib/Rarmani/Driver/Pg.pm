package Rarmani::Driver::Pg;
use strict;
use warnings;
use Rarmani::Driver::Declare;
use Types::Common -types;
use Types::DateTime -all;

type_match Int,           qr/^(INTEGER|SMALLINT|BIGINT|SERIAL|BIGSERIAL)([\(\)0-9]+)?$/;
type_match Num,           qr/^(DECIMAL|NUMERIC|REAL|DOUBLE|INTERVAL)([\(\)0-9]+)?/;
type_match Str,           qr/^(BYTEA|TEXT)/;
type_match StrLength,     qr/^(CHARACTER|CHAR|VARCHAR)([\(\)0-9]+)?/;
type_match DateTime,      qr/^(DATE|TIME|DATETIME|TIMESTAMP|YEAR)/;
type_match Enum,          qr/^(ENUM([\(\).+]+)$)/;
type_match ArrayRef[Str], qr/^(SET([\(\).+]+))/;
type_match Bool,          qr/^(BOOLEAN)/;

1;