#!/usr/bin/env bash
set -e

# Load our library. Sourcing is not allowed
PATH="$PATH:$(dirname "$0")/lib/"

my-module list_all_records some_id
my-module get_record_count

# This should throw an error
my-module foobar || true
