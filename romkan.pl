#!/usr/bin/perl -CSDA

use warnings;
use strict;

package romkan;
#######################################################################
##
## romkan.pl: romaji-to-kana convertion subroutine for Perl
##
## Copyright (c) Kazumasa Utashiro
##
## Original: Jan 12 1993
;; my $rcsid = q$Id: romkan.pl,v 2.4 2014/10/17 02:17:52 utashiro Exp $;
##
#######################################################################
##
## SYNOPSIS
##
##	$kana = &romkan($romaji [, DUMMY [, KATAKANA]] );
##
## DESCRIPTION
##
##	Subroutine &romkan returns KANA string expressed by the first
##	argument.  It returns undef if entire string cannot be
##	converted to KANA.
##
##	Second argument is obsolete now.  It remains just for
##	compatibility.
##
##	If the third argument is supplied and its value is true,
##	return string is expressed by KATAKANA rather than HIRAGANA.
##
#######################################################################
##
## SAMPLE:
##
##	require 'romkan.pl';
##	while (<>) {
##	    s/([\w\-\']+)/&romkan($1)||$1/ge unless 1 .. /^$/;
##	    print;
##	}
##
#######################################################################

use utf8;

my @romkan = qw(
a	あ	i	い	u	う	e	え	o	お
		l	い
ka	か	ki	き	ku	く	ke	け	ko	こ
ga	が	gi	ぎ	gu	ぐ	ge	げ	go	ご
sa	さ	si	し	su	す	se	せ	so	そ
za	ざ	zi	じ	zu	ず	ze	ぜ	zo	ぞ
ta	た	ti	ち	tu	つ	te	て	to	と
tsa	つぁ	tsi	つぃ	tsu	つ	tse	つぇ	tso	つぉ
da	だ	di	ぢ	du	づ	de	で	do	ど
na	な	ni	に	nu	ぬ	ne	ね	no	の
ha	は	hi	ひ	hu	ふ	he	へ	ho	ほ
fa	ふぁ	fi	ふぃ	fu	ふ	fe	ふぇ	fo	ふぉ
pa	ぱ	pi	ぴ	pu	ぷ	pe	ぺ	po	ぽ
ba	ば	bi	び	bu	ぶ	be	べ	bo	ぼ
ma	ま	mi	み	mu	む	me	め	mo	も
ya	や	yi	い	yu	ゆ	ye	え	yo	よ
ra	ら	ri	り	ru	る	re	れ	ro	ろ
wa	わ	wi	ゐ	wu	う	we	ゑ	wo	を
kwa	か	kwi	き	kwu	く	kwe	け	kwo	こ
kya	きゃ	kyi	きぃ	kyu	きゅ	kye	きぇ	kyo	きょ
gya	ぎゃ	gyi	ぎぃ	gyu	ぎゅ	gye	ぎぇ	gyo	ぎょ
sha	しゃ	shi	し	shu	しゅ	she	しぇ	sho	しょ
sya	しゃ	syi	しぃ	syu	しゅ	sye	しぇ	syo	しょ
zya	じゃ	zyi	じぃ	zyu	じゅ	zye	じぇ	zyo	じょ
ja	じゃ	ji	じ	ju	じゅ	je	じぇ	jo	じょ
jya	じゃ	jyi	じぃ	jyu	じゅ	jye	じぇ	jyo	じょ
tya	ちゃ	tyi	ちぃ	tyu	ちゅ	tye	ちぇ	tyo	ちょ
cha	ちゃ	chi	ち	chu	ちゅ	che	ちぇ	cho	ちょ
tcha	っちゃ	tchi	っち	tchu	っちゅ	tche	っちぇ	tcho	っちょ
dya	ぢゃ	dyi	ぢぃ	dyu	ぢゅ	dye	ぢぇ	dyo	ぢょ
tha	てゃ	thi	てぃ	thu	てゅ	the	てぇ	tho	てょ
dha	でゃ	dhi	でぃ	dhu	でゅ	dhe	でぇ	dho	でょ
nya	にゃ	nyi	にぃ	nyu	にゅ	nye	にぇ	nyo	にょ
hya	ひゃ	hyi	ひぃ	hyu	ひゅ	hye	ひぇ	hyo	ひょ
pya	ぴゃ	pyi	ぴぃ	pyu	ぴゅ	pye	ぴぇ	pyo	ぴょ
bya	びゃ	byi	びぃ	byu	びゅ	bye	びぇ	byo	びょ
mya	みゃ	myi	みぃ	myu	みゅ	mye	みぇ	myo	みょ
rya	りゃ	ryi	りぃ	ryu	りゅ	rye	りぇ	ryo	りょ
va	ゔぁ	vi	ゔぃ	vu	ゔ	ve	ゔぇ	vo	ゔぉ
xa	ぁ	xi	ぃ	xu	ぅ	xe	ぇ	xo	ぉ
xwa	ゎ	xtsu	っ	xtu	っ
xya	ゃ			xyu	ゅ			xyo	ょ
n'	ん	n	ん	mb	ん	mm	ん	mp	ん
-	ー
);
my @rom = @romkan[ grep { !($_ % 2) } 0 .. $#romkan ];

my $vowels = 'aeiouâêîôûāēīōū';
my $consonants = 'ckgszjtdhfpbmyrw';

our %romkan = @romkan;
my %lv = qw(â a  ê e  î i  ô o  û u  ā a  ē e  ī i  ō o  ū u);
my %vl = qw(a âā e êē i îī o ôō u ûū);
for (@rom) {
    s/(.*)([aeiou])$/${1}[${2}$vl{$2}]/ or next;
}
map { $romkan{$_} //= $_ } 0..9, "'";
map { $romkan{"$_$_"} //= 'っ' } $consonants =~ /./g;
map { $romkan{"$_-$_"} //= 'っ' } $consonants =~ /./g;
for (qw(a e i o u)) {
    $romkan{'-'.$_} //= 'ー';
    $romkan{'='.$_} //= $romkan{$_};
    $romkan{'@'.$_} //= $romkan{"x$_"};
}

my $rom_pat = join '|', @rom, q/[\d\']/;
my $re_rom  = qr/$rom_pat/i;
my $re_consonants = qr/[$consonants]/i;

our %convert = (
    h  => "-", # h を変換 (@:「ぁ」, -:「ー」, =:「あ」)
    lv => "@", # â を変換 (@:「ぁ」, -:「ー」, =:「あ」)
    sq => 1,   # 末尾の ' を「っ」に変換
    );

sub main::romkan {
    local $_ = shift;
    my $dummy = shift;
    my $katakana = shift;

    my $kana = '';
    my $v = '';
    while (length) {
	s/^(?| m([bmp]) | ($re_consonants)-?\g{-1} | $re_rom() )/$1/xpi || last;
	my $match = lc ${^MATCH};
	my $lv = $match =~ s/([âêîôûāēīōū])$/$lv{$1}/;
	$match =~ /([aeiou])$/ and $v = $1;
	$kana .= $romkan{$match};
	$lv and $kana .= $romkan{$convert{lv}.$v};
	s/^h(?![haeiouâêîôûāēīōū])//i and $kana .= $romkan{$convert{h}.$v};
	s/^'$// and $kana .= 'っ' if $convert{sq};
    }
    return undef if length;

    $kana =~ tr/ぁ-んゔ/ァ-ンヴ/ if $katakana;

    $kana;
}

;######################################################################
if (__FILE__ eq $0) {	# test main
    package main;
    use strict;
    use warnings;
    use Getopt::Long;
    my $opt_echo  = 0;
    my $opt_mode  = "line";	# line, block, file
    my $opt_kana  = "hira";	# hira, kata
    my $opt_print = "always";	# always, any, all
    my $opt_style = "nl";	# nl, tab, diff, conflict
    my $opt_dash = 1;
    my $opt_lv = "x";
    my %start  = (conflict => "<<<<<<<\n");
    my %end    = (conflict => ">>>>>>>\n");
    my %middle = (conflict => "=======\n", diff => "---\n");
    my $command = $0 =~ /([^\/]+)$/ ? $1 : $0;
    my $usage = <<EOS;
Usage: $command --[no]echo --mode=line|block|file --kana=hira|kata --print=always|any|all --style=nl|tab|diff|conflict --[no]dash --convert h|lv|sq=[\@-=] --romkan=from=to
EOS
    Getopt::Long::Configure("bundling_override");
    GetOptions("echo!"     => \$opt_echo,
	       "mode=s"    => \$opt_mode,
	       "kana=s"    => \$opt_kana,
	       "print=s"   => \$opt_print,
	       "style=s"   => \$opt_style,
	       "dash!"     => \$opt_dash,
	       "convert=s" => \%romkan::convert,
	       "romkan=s"  => \%romkan::romkan,
	       "h|help"    => sub { print $usage; exit },
	       "dump"      => sub {
		   for (sort keys %romkan::romkan) {
		       printf "%-4s %s\n", $_, $romkan::romkan{$_};
		   }
		   exit;
	       },
    ) || die $usage;
    $opt_echo = 1 if {diff => 1, conflict => 1}->{$opt_style};
    $/ = {block => '', line => "\n", file => undef}->{$opt_mode};
    my $kana = $opt_kana =~ /^kata/i;
    my $symbol = "'" . ($opt_dash ? '-' : '');
    my $re_word = qr/\pL[\pL\Q${symbol}\E]*/;
    my $n = 1;
    while (<>) {
	my $orig = $_;
	my $line = tr/\n/\n/;
	my $f = 0;
	my $t = s/($re_word)/romkan($1,undef,$kana)||($f++,$1)/gie;
	if ($f == $t) {
	    print if $opt_print eq "always";
	}
	elsif ($f == 0 or $opt_print ne "all") {
	    if ($opt_style eq "diff") {
		my $range = $n;
		$range .= sprintf ",%d", $n + $line - 1 if $line > 1;
		print "${range}c${range}\n";
		$orig =~ s/^/< /mg;
		$_    =~ s/^/> /mg;
	    }
	    print $start{$opt_style} // '';
	    if ($opt_echo) {
		$orig =~ s/\n\z/\t/ if $opt_style eq "tab";
		print $orig;
		print $middle{$opt_style} // '';
	    }
	    print $_;
	    print $end{$opt_style} // '';
	}
	$n += $line;
    }
}
;######################################################################

1;
