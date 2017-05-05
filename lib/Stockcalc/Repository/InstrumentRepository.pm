package Stockcalc::Repository::InstrumentRepository;

use strict;
use warnings;
use autodie;

use FindBin;
use File::Spec;

use constant DATA_FOLDER => File::Spec->catfile($FindBin::Bin, '../data');

sub new {
    return bless {}, shift;
}

sub get_all_instruments {
    my @instruments = ();

    opendir(my $dir_handle, DATA_FOLDER);
    while (my $filename = readdir($dir_handle)) {
        my ($name) = ($filename =~ /^(.*?)\.mst$/);
        if ($name) {
            push(@instruments, $name);
        }
    }

    closedir($dir_handle);
    return \@instruments;
}

sub does_instrument_exist {
    my $self = shift;
    my $name = uc(shift);

    opendir(my $dir_handle, DATA_FOLDER);
    while (my $filename = readdir($dir_handle)) {
        if ($filename =~ /^${name}\.mst$/) {
            closedir($dir_handle);
            return 1;
        }
    }

    closedir($dir_handle);
    return 0;
}

sub get_instrument_data {
    my $self = shift;
    my $name = uc(shift);
    my ($from, $to) = @_;

    my $filename = File::Spec->catfile(DATA_FOLDER, "${name}.mst");
    open(my $file_handle, "<", $filename);

    my @points = ();
    <$file_handle>;
    while (my $line = <$file_handle>) {
        chomp $line;
        my @fields = split(/,/, $line);
        my %point = ('date' => $fields[1], 'value' => $fields[5]);
        push(@points, \%point)
    }

    close($file_handle);
    return \@points;
}

1;
