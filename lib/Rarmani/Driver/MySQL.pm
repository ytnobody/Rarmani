package Rarmani::Driver::MySQL;
use strict;
use warnings;
use Rarmani::Driver::Declare;
use Types::Common -types;
use Types::DateTime -all;

type_match Int,           qr/^(INTEGER|INT|SMALLINT|TINYINT|MEDIUMINT|BIGINT)([\(\)0-9]+)?$/;
type_match Num,           qr/^(DECIMAL|NUMERIC|FLOAT|DOUBLE)([\(\)0-9]+)?/;
type_match Str,           qr/^(BINARY|VARBINARY|BLOB|TEXT)/;
type_match StrLength,     qr/^(BIT|CHAR|VARCHAR)([\(\)0-9]+)?/;
type_match DateTime,      qr/^(DATE|DATETIME|TIMESTAMP|YEAR)/;
type_match Enum,          qr/^(ENUM([\(\).+]+)$)/;
type_match ArrayRef[Str], qr/^(SET([\(\).+]+))/;

1;