#!/usr/bin/perl -s -Cio

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
;; my $rcsid = q$Id: romkan.pl,v 2.2 2011/12/23 01:13:17 utashiro Exp $;
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
;#	argument.  It returns undef when translation was failed.
;#
;#	Second argument is obsolete now.  It remains for backward
;#	compatibility.  Put undef here when using third argument.
;#
;#	If the third argument is supplied and its value is
;#	true, return string is expressed by KATAKANA rather
;#	than HIRAGANA which is default.  Use undef for
;#	second argument if you don't want to specify the code.
;#
;######################################################################
;#
;# SAMPLE:
;#
;#	require('romkan.pl');
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
xa	ぁ	xi	ぃ	xu	ぅ	xe	ぇ	xo	ぉ
xwa	ゎ	xtsu	っ	xtu	っ
xya	ゃ			xyu	ゅ			xyo	ょ
n'	ん	n	ん
-	ー
);

my $consonants = 'ckgszjtdhfpbmyrw';
for ($consonants =~ /./g) { $romkan{"$_$_"} = $romkan{'xtsu'}; }
for (0..9, "'") { $romkan{$_} = $_; }

our $sub_romkan;
my $i = 0;
my @rom = grep(++$i % 2, @romkan);

;;; eval($sub_romkan = q%
sub main::romkan {
    local($_) = shift;
    my($code, $katakana) = @_;
    my $kana = '';
    while (length($_)) {
	if (0
% .	    join('', map("\t    || s/^($_)//i\n", @rom)) . q%
	    || s/^([\d\'])//
	    || s/^(([%.$consonants.q%])\2)/$2/i
	) {
	    $kana .= $romkan{lc($1)};
	} else {
	    last;
	}
    }
    return undef if length($_);
    $kana =~ tr/ぁ-んゔ/ァ-ンヴ/ if $katakana;
    $kana;
}
%);

use Carp;
croak $@ if $@;

;######################################################################
if (__FILE__ eq $0) {	# test main
    package main;
    our($debug, $katakana);
    binmode STDOUT, ':utf8';
    print $romkan::sub_romkan if $debug;
    $/ = '' unless -t STDIN;
    while (<>) {
	print unless -t STDIN;
	s/([\w\-\']+)/&romkan($1,undef,$katakana)||$1/ge;
	print;
    }
}
;######################################################################

1;
