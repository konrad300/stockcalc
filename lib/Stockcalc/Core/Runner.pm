package Stockcalc::Core::Runner;

use strict;
use warnings;

use Stockcalc::Core::ArgumentParser;
use Stockcalc::Repository::InstrumentRepository;
use Stockcalc::Chart::ChartGenerator;

sub new {
    return bless {}, shift;
}

sub run {
    my $parser = Stockcalc::Core::ArgumentParser->new();
    my %arguments = $parser->parse();

    _display_list_of_instruments() if exists($arguments{'list'});
    _display_instrument_data($arguments{'quotes'}) if exists($arguments{'quotes'});
    _generate_charts($arguments{'charts'}) if exists($arguments{'charts'});
}

sub _display_list_of_instruments {
     my $repository = Stockcalc::Repository::InstrumentRepository->new();
     my $all_instruments = $repository->get_all_instruments();
     foreach my $item (@$all_instruments) {
         print "$item\n"
     }
     exit;
}

sub _display_instrument_data {
    my $instrument = shift;
    my $repository = Stockcalc::Repository::InstrumentRepository->new();

    my $exists = $repository->does_instrument_exist($instrument);
    if (!$exists) {
        die "Instrument '$instrument' does not exist in the database.\n";
    }

    my $instrument_data = $repository->get_instrument_data($instrument, "", "");
    foreach my $item (@$instrument_data) {
        print "$item->{'date'} $item->{'value'}\n"
    }
    exit;
}

sub _generate_charts {
    my $output_folder = shift;
    my $repository = Stockcalc::Repository::InstrumentRepository->new();
    my $chartGenerator = Stockcalc::Chart::ChartGenerator->new();

    my $all_instruments = $repository->get_all_instruments();
    
    STDOUT->printflush("Generating charts... ");
    foreach my $instrument_name (@$all_instruments) {
        my $instrument_data = $repository->get_instrument_data($instrument_name, "", "");
        $chartGenerator->_generate_and_save_chart($instrument_name, $output_folder, $instrument_data);
    }
    print "all done\n";
    exit;
}

1;
