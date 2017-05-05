package Stockcalc::Chart::ChartGenerator;

use strict;
use warnings;

use File::Spec;
use GD::Graph::lines;

sub new {
    return bless {}, shift;
}

sub _generate_and_save_chart {
    my $self = shift;
    my $instrument_name = shift;
    my $output_folder = shift;
    my $instrument_data = shift;

    my @labels = ();
    my @values = ();

    foreach my $item (@$instrument_data) {
        push(@labels, $item->{'date'});
        push(@values, $item->{'value'});
    }

    my $gd = GD::Graph::lines->new(1400, 1000);
    $gd->set(
        title             => "Stockcalc - index chart",
        line_width        => 1,
        x_label           => "Date",
        y_label           => "Value",
        x_label_skip      => $#labels / 50.0,
        x_labels_vertical => 1,
    );
    $gd->set_legend($instrument_name);

    my $chart = $gd->plot([\@labels, \@values])->png();
    _save_chart_to_disk($instrument_name, $output_folder, $chart);
}

sub _save_chart_to_disk {
    my $file_name = shift;
    my $output_folder = shift;
    my $chart = shift;
    
    my $file_path = File::Spec->catfile($output_folder, $file_name);

    open(OUT, ">", "${file_path}.png") or die "Couldn't open ${file_path}.png for output: $!\n";
    binmode(OUT);
    print OUT $chart;
    close(OUT);
}

1;
