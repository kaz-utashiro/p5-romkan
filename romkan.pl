#!/usr/bin/perl -CSDA

use warnings;
use strict;

package romkan;
;######################################################################
;#
;# romkan.pl: romaji-to-kana convertion subroutine for Perl
;#
;# Copyright (c) Kazumasa Utashiro
;#
;# Original: Jan 12 1993
;; my $rcsid = q$Id: romkan.pl,v 2.4 2014/10/17 02:17:52 utashiro Exp $;
;#
;######################################################################
;#
;# SYNOPSIS
;#
;#	$kana = &romkan($romaji [, DUMMY [, KATAKANA]] );
;#
;# DESCRIPTION
;#
;#	Subroutine &romkan returns KANA string expressed by the first
;#	argument.  It returns undef if entire string cannot be
;#	converted to KANA.
;#
;#	Second argument is obsolete now.  It remains just for backward
;#	compatibility.
;#
;#	If the third argument is supplied and its value is true,
;#	return string is expressed by KATAKANA rather than HIRAGANA.
;#
;######################################################################
;#
;# SAMPLE:
;#
;#	require 'romkan.pl';
;#	while (<>) {
;#	    s/([\w\-\']+)/&romkan($1)||$1/ge unless 1 .. /^$/;
;#	    print;
;#	}
;#
;######################################################################

use utf8;

my(%romkan, @romkan);
%romkan = @romkan = qw(
a	あ	i	い	u	う	e	え	o	お
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
ya	や			yu	ゆ			yo	よ
ra	ら	ri	り	ru	る	re	れ	ro	ろ
wa	わ	wi	ゐ			we	ゑ	wo	を
kya	きゃ	kyi	きぃ	kyu	きゅ	kye	きぇ	kyo	きょ
gya	ぎゃ	gyi	ぎぃ	gyu	ぎゅ	gye	ぎぇ	gyo	ぎょ
sha	しゃ	shi	し	shu	しゅ	she	しぇ	sho	しょ
sya	しゃ	syi	しぃ	syu	しゅ	sye	しぇ	syo	しょ
zya	じゃ	zyi	じぃ	zyu	じゅ	zye	じぇ	zyo	じょ
ja	じゃ	ji	じ	ju	じゅ	je	じぇ	jo	じょ
jya	じゃ	jyi	じぃ	jyu	じゅ	jye	じぇ	jyo	じょ
tya	ちゃ	tyi	ちぃ	tyu	ちゅ	tye	ちぇ	tyo	ちょ
cha	ちゃ	chi	ち	chu	ちゅ	che	ちぇ	cho	ちょ
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
n'	ん	n	ん
-	ー
);

my $consonants = 'ckgszjtdhfpbmyrw';
map { $romkan{"$_$_"} = $romkan{'xtsu'} } $consonants =~ /./g;
map { $romkan{$_} = $_ } 0..9, "'";

my @rom = @romkan[ map { $_*2 } 0 .. (@romkan/2)-1 ];
my $rom_pat = join '|', @rom, q/[\d\']/;

my $re_rom  = qr/$rom_pat/i;
my $re_consonants = qr/[$consonants]/i;

sub main::romkan {
    local $_ = shift;
    my $dummy = shift;
    my $katakana = shift;

    my $kana = '';
    while (length) {
	s/^($re_rom)// || s/^(($re_consonants)\2)/$2/ || last;
	$kana .= $romkan{ lc $1 };
    }

    return undef if length;

    $kana =~ tr/ぁ-んゔ/ァ-ンヴ/ if $katakana;

    $kana;
}

use Carp;
croak $@ if $@;

;######################################################################
if (__FILE__ eq $0) {	# test main
    package main;
    use Getopt::Long;
    Getopt::Long::Configure("bundling");
    my $opt_debug = 0;
    my $opt_echo  = 0;
    my $opt_mode  = "line";
    my $opt_kana  = "hira";
    my $opt_ocode = "utf8";
    my $command = $0 =~ /([^\/]+)$/ ? $1 : $0;
    GetOptions("debug"   => \$opt_debug,
	       "echo!"   => \$opt_echo,
	       "mode=s"  => \$opt_mode,
	       "kana=s"  => \$opt_kana,
	       "ocode=s" => \$opt_ocode,
	      )
	|| die <<EOS;
Usage: $command --[no]echo --mode=line|block --kana=hira|kata
EOS
    binmode STDOUT, ":$opt_ocode";
    print $romkan::sub_romkan if $opt_debug;
    $/ = '' if $opt_mode eq "block";
    my $kana = $opt_kana eq "kata";
    while (<>) {
	print if $opt_echo;
	s/(\w[\w\-\']*)/&romkan($1,undef,$kana)||$1/ge;
	print;
    }
}
;######################################################################

1;
