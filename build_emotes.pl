#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use JSON qw( decode_json );

my $emote_list_url = 'https://api.twitch.tv/kraken/chat/emoticons';
my $subfile = "emotes.sub";
my %submap = ();

open (FH, "< $subfile") or die "Can't open substitution file.";
my @sublines = <FH>;
close FH or die "Can't close substitution file.";

foreach my $g ( @sublines ) {
	my @values = split(' ', $g);
	if(@values <= 2) {
		$submap{ $values[0] } = $values[1];
	}
}

my $emote_list_json = get $emote_list_url;
die "Couldn't get $emote_list_url" unless defined $emote_list_json;

my $emote_list = decode_json($emote_list_json);

my @emotes = @{ $emote_list->{'emoticons'} };
foreach my $f ( @emotes ) {
	my $global = 0;
	my $normal = 0;
	my @images = @{ $f->{'images'} };
	foreach my $g ( @images ) {
		if(!defined $g->{'emoticon_set'}) {
			$global = 1;
		} elsif($g->{'emoticon_set'} == "33") {
			$normal = 1;
		}
	}

	if($global == 1 and $normal == 0) {
		my $url = $images[0]->{'url'};
		my $code = $f->{"regex"};

		if(exists($submap{ $code })) {
			$code = $submap{ $code };
		}

		print "\<div class=\"emoticon\"\> \<div class=\"emoticon-box\"\> \<img src=\"$url\" alt=\"\" /\> \</div\> $code \</div\>\n";
	}

}
