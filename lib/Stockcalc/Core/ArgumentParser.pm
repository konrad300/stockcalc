package Stockcalc::Core::ArgumentParser;

use strict;
use warnings;

use Getopt::Long;

sub new {
    return bless {}, shift;
}

sub parse {
    my %arguments = ();
    my $parser = Getopt::Long::Parser->new();
    $parser->getoptions(\%arguments, "help",
        "quotes=s", "list", "charts=s") or exit 1;
    
    if (!%arguments) {
        exit;
    }
    
    if (exists($arguments{"help"})) {
        _display_usage_message();
        exit;
    }

    if (exists($arguments{"charts"}) && (!-d $arguments{"charts"})) {
        die "Output folder '$arguments{'charts'}' doesn't exist.\n";
    }

    return %arguments;
}

sub _display_usage_message {
    my $message = <<'END_MESSAGE';
usage: stockcalc [-h] [-l] [-q INSTRUMENT] [-c OUT_FOLDER]

The current usage of this script is limited to:
- printing quotes for selected instruments listed
  on Warsaw Stock Exchange
- generating charts in PNG format for selected
  instruments listed on Warsaw Stock Exchange

To see the list of available instruments use
--list option.

prerequisites:
- libgd library installed
- GD::Graph module installed

optional arguments:
  -h, --help        show this help message and exit
  -l, --list        list all available instruments
  -q INSTRUMENT, --quotes INSTRUMENT
                    show daily quotes for given
                    INSTRUMENT
  -c OUT_FOLDER, --charts OUT_FOLDER
                    generate charts in PNG format for
                    all instruments and save them to
                    OUT_FOLDER

examples:

$ stockcalc -l | grep "^D"
DREWEX
DSS
DTP
DUON
DROZAPOL
DGA
DELKO
DOMDEV

$ stockcalc -q "oponeo.pl" | grep "201612"
20161201 46.98
20161202 47.00
20161205 46.70
20161206 47.47
20161207 47.16
20161208 47.50
20161209 47.00

$ stockcalc -c "."
[Generates chars for all the available instruments and
saves them to the current folder]
END_MESSAGE

    die $message;
}

1;
