#!/usr/local/bin/perl -s
package romkan;
;######################################################################
;#
;# romkan.pl: romaji-to-kana convertion subroutine for Perl
;#
;# Copyright (c) 2001 Kazumasa Utashiro <utashiro@srekcah.org>
;# Copyright (c) 1995,1996,1998,1999 Kazumasa Utashiro
;# Internet Initiative Japan Inc.
;#
;# Copyright (c) 1993 Kazumasa Utashiro
;# Software Research Associates, Inc.
;#
;# Original: Jan 12 1993
;; $rcsid = q$Id: romkan.pl,v 1.9 2001/06/25 11:09:01 utashiro Exp $;
;#
;######################################################################
;#
;# SYNOPSIS
;#
;#	$kana = &romkan($roma [, CODE [, KATAKANA]] );
;#
;# DESCRIPTION
;#
;#	Subroutine &romkan returns KANA string expressed by the first
;#	argument.  It returns undef when translation was failed.
;#
;#	Second argument specifies the encoding of return string.  It
;#	is encoded in 'euc' by default.  Use 'euc', 'sjis' or 'jis'.
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

require('jcode.pl');

$pcode = 'euc';

$romkan_table = <<'__TABLE_END__' unless $romkan_table;
a	丐	i	中	u	丹	e	尹	o	云
ka	井	ki	五	ku	仁	ke	仃	ko	仇
ga	互	gi	亢	gu	什	ge	仆	go	仍
sa	今	si	仄	su	允	se	六	so	公
za	介	zi	元	zu	內	ze	兮	zo	冗
ta	凶	ti	切	tu	勾	te	化	to	午
tsa	勾丑	tsi	勾不	tsu	勾	tse	勾之	tso	勾予
da	分	di	刈	du	勿	de	匹	do	升
na	卅	ni	卞	nu	厄	ne	友	no	及
ha	反	hi	夫	hu	孔	he	尺	ho	幻
fa	孔丑	fi	孔不	fu	孔	fe	孔之	fo	孔予
pa	天	pi	夭	pu	尤	pe	巴	po	弔
ba	壬	bi	太	bu	少	be	屯	bo	廿
ma	引	mi	心	mu	戈	me	戶	mo	手
ya	支			yu	斗			yo	方
ra	日	ri	曰	ru	月	re	木	ro	欠
wa	歹	wi	毋			we	比	wo	毛
kya	五扎	kyi	五不	kyu	五文	kye	五之	kyo	五斤
gya	亢扎	gyi	亢不	gyu	亢文	gye	亢之	gyo	亢斤
sha	仄扎	shi	仄	shu	仄文	she	仄之	sho	仄斤
zya	元扎	zyi	元不	zyu	元文	zye	元之	zyo	元斤
ja	元扎	ji	元	ju	元文	je	元之	jo	元斤
jya	元扎	jyi	元不	jyu	元文	jye	元之	jyo	元斤
tya	切扎	tyi	切不	tyu	切文	tye	切之	tyo	切斤
cha	切扎	chi	切	chu	切文	che	切之	cho	切斤
dya	刈扎	dyi	刈不	dyu	刈文	dye	刈之	dyo	刈斤
tha	化扎	thi	化不	thu	化文	the	化之	tho	化斤
dha	匹扎	dhi	匹不	dhu	匹文	dhe	匹之	dho	匹斤
nya	卞扎	nyi	卞不	nyu	卞文	nye	卞之	nyo	卞斤
hya	夫扎	hyi	夫不	hyu	夫文	hye	夫之	hyo	夫斤
pya	夭扎	pyi	夭不	pyu	夭文	pye	夭之	pyo	夭斤
bya	太扎	byi	太不	byu	太文	bye	太之	byo	太斤
mya	心扎	myi	心不	myu	心文	mye	心之	myo	心斤
rya	曰扎	ryi	曰不	ryu	曰文	rye	曰之	ryo	曰斤
xa	丑	xi	不	xu	丰	xe	之	xo	予
xwa	止	xtsu	勻	xtu	勻
xya	扎			xyu	文			xyo	斤
n'	氏	n	氏
-	□
__TABLE_END__

&jcode'convert(*romkan_table, $pcode);
%romkan = @romkan = split(/\s+/, $romkan_table);
$consonants = 'ckgszjtdhfpbmyrw';
for ($consonants =~ /./g) { $romkan{"$_$_"} = $romkan{'xtsu'}; }
for (0..9, "'") { $romkan{$_} = $_; }

$i = 0;
;;; eval($sub_romkan = q%
sub main'romkan {
    local($_, $code, $katakana) = @_;
    local($kana) = '';
    while (length) {
	if (0
% .	join('', grep(++$i%2 && ($_ = "\t    || s/^($_)//i\n"), @romkan)) . q%
	    || s/^([\d\'])//
	    || s/^(([%.$consonants.q%])\2)/$2/i
	) {
	    $kana .= $romkan{"\L$1"};
	} else {
	    last;
	}
    }
    return undef if length;
    $kana =~ s/\244(.)/\245$1/g if $katakana;
    &jcode'convert(*kana, $code, $pcode) if $code && $code ne $pcode;
    $kana;
}
%);

;######################################################################
if (__FILE__ eq $0) {	# test main
    package main;

    print $romkan'sub_romkan if $debug;

    $/ = '' unless -t STDIN;
    $code = $jis ? 'jis' : $euc ? 'euc' : $sjis ? 'sjis' : undef;

    while (<>) {
	print unless -t STDIN;
	s/([\w\-\']+)/&romkan($1,$code,$katakana)||$1/ge;
	print;
    }
}
;######################################################################

1;
