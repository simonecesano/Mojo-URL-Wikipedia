use strict;
use warnings;
use v5.10;

package Mojo::URL::Wikipedia;

# ABSTRACT: generate wikipedia/wikidata/wikimedia URL

use Mojo::Base qw/Mojo::URL/;

use Mojo::Loader qw(find_modules load_class);
use Mojo::Util qw/dumper md5_sum url_escape encode/;

my @import;

has 'language' => 'en';

sub import {
    @import = @_;
    # say STDERR 'package: ' .__PACKAGE__;
    # say join ', ', @import;

    for my $module (find_modules __PACKAGE__) {
	my $e = load_class $module;
	warn qq{Loading "$module" failed: $e} and next if ref $e;
	# if ($module->can('foo')) { $module->foo }
    }
}

sub pageprops {
    my $self = shift;
    my $opts = ref $_[-1] eq 'HASH' ? pop : {};

    my @titles = @_;

    my $lang = $opts->{lang} || $self->language;

    $self->parse(sprintf('https://%s.wikipedia.org/w/api.php?action=query&format=json&prop=pageprops&titles=Albert Einstein', $lang));
    $self->query({ titles => join '|', @titles });
    return $self;
}

sub extracts {
    my $self = shift;
    my $opts = ref $_[-1] eq 'HASH' ? pop : {};

    my @titles = @_;

    my $lang = $opts->{lang} || $self->language;

    $self->parse(sprintf('https://%s.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&exintro&explaintext&redirects=1&titles', $lang));
    $self->query({ titles => join '|', @titles });
    return $self;
}

sub file {
    my $self= shift;
    my ($file, $size) = @_;

    $file =~ s/^\w+://;
    $file =~ s/ /_/g;

    $file = encode('UTF-8', $file);
    my $md5 = md5_sum($file);
    $file = url_escape($file);

    if ($size) {
	$size =~ s/px$//;
	my $template = 'https://upload.wikimedia.org/wikipedia/commons/thumb/%s/%s/%s/%dpx-%s';
	return sprintf $template, substr($md5, 0, 1), substr($md5, 0, 2), $file, $size, $file;
    } else {
	my $template = 'https://upload.wikimedia.org/wikipedia/commons/%s/%s/%s';
	return sprintf $template, substr($md5, 0, 1), substr($md5, 0, 2), $file;
    }
}

sub geosearch_bbox {
    my $self = shift;

    my $opts = ref $_[-1] eq 'HASH' ? pop : {};

    my @coords = @_;

    if (@coords == 2) {
	my $deg = delete $opts->{degrees} || 0.1;
	$coords[2] = $coords[0] - $deg;
	$coords[3] = $coords[1] + $deg;
    } elsif (@coords == 3) {
	my $deg = pop @coords;
	$coords[2] = $coords[0] - $deg;
	$coords[3] = $coords[1] + $deg;
    } elsif (@coords >= 4) {
	@coords = @coords[0..3];
    } else {

    }

    my $lang = $opts->{lang} || $self->language;
    my $coords = join '|', @coords;

    $self->parse(sprintf('https://%s.wikipedia.org/w/api.php?action=query&list=geosearch&gsbbox=40.7|-74.0|40.6|-73.9&format=json&gslimit=500', $lang));
    $self->query({ gsbbox => $coords });
}

sub entity {
    my $self = shift;
    my $entity = shift;

    $self->parse(sprintf('https://www.wikidata.org/wiki/Special:EntityData/%s.json', $entity));
    return $self;
}

1;
