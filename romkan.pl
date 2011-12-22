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
a	��	i	��	u	��	e	��	o	��
ka	��	ki	��	ku	��	ke	��	ko	��
ga	��	gi	��	gu	��	ge	��	go	��
sa	��	si	��	su	��	se	��	so	��
za	��	zi	��	zu	��	ze	��	zo	��
ta	��	ti	��	tu	��	te	��	to	��
tsa	�Ĥ�	tsi	�Ĥ�	tsu	��	tse	�Ĥ�	tso	�Ĥ�
da	��	di	��	du	��	de	��	do	��
na	��	ni	��	nu	��	ne	��	no	��
ha	��	hi	��	hu	��	he	��	ho	��
fa	�դ�	fi	�դ�	fu	��	fe	�դ�	fo	�դ�
pa	��	pi	��	pu	��	pe	��	po	��
ba	��	bi	��	bu	��	be	��	bo	��
ma	��	mi	��	mu	��	me	��	mo	��
ya	��			yu	��			yo	��
ra	��	ri	��	ru	��	re	��	ro	��
wa	��	wi	��			we	��	wo	��
kya	����	kyi	����	kyu	����	kye	����	kyo	����
gya	����	gyi	����	gyu	����	gye	����	gyo	����
sha	����	shi	��	shu	����	she	����	sho	����
zya	����	zyi	����	zyu	����	zye	����	zyo	����
ja	����	ji	��	ju	����	je	����	jo	����
jya	����	jyi	����	jyu	����	jye	����	jyo	����
tya	����	tyi	����	tyu	����	tye	����	tyo	����
cha	����	chi	��	chu	����	che	����	cho	����
dya	�¤�	dyi	�¤�	dyu	�¤�	dye	�¤�	dyo	�¤�
tha	�Ƥ�	thi	�Ƥ�	thu	�Ƥ�	the	�Ƥ�	tho	�Ƥ�
dha	�Ǥ�	dhi	�Ǥ�	dhu	�Ǥ�	dhe	�Ǥ�	dho	�Ǥ�
nya	�ˤ�	nyi	�ˤ�	nyu	�ˤ�	nye	�ˤ�	nyo	�ˤ�
hya	�Ҥ�	hyi	�Ҥ�	hyu	�Ҥ�	hye	�Ҥ�	hyo	�Ҥ�
pya	�Ԥ�	pyi	�Ԥ�	pyu	�Ԥ�	pye	�Ԥ�	pyo	�Ԥ�
bya	�Ӥ�	byi	�Ӥ�	byu	�Ӥ�	bye	�Ӥ�	byo	�Ӥ�
mya	�ߤ�	myi	�ߤ�	myu	�ߤ�	mye	�ߤ�	myo	�ߤ�
rya	���	ryi	�ꤣ	ryu	���	rye	�ꤧ	ryo	���
xa	��	xi	��	xu	��	xe	��	xo	��
xwa	��	xtsu	��	xtu	��
xya	��			xyu	��			xyo	��
n'	��	n	��
-	��
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
