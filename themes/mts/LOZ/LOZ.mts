;------------------------------------
; Pokemon Theme par Blaster
; Ne pas copier sans permission
;------------------------------------

[mts]
Name LOZ Version C
Author Blaster
Email zeldairc@free.fr
Description Thème Legend Of Zelda repris par Ocarina Script Version C
Website http://zeldairc.free.fr
Version 1.0
MTSVersion 1.3

Colors 0,2,4,3,1,6,1,1,1,2,1,1,4,7,13,1,1,1,1,1,1,3,0,3,0,6,1,9,15,1
RGBColors 16777215 0 4210816 2520915 255 4096149 16711808 33023 3523311 5494680 13399552 14142811 16515072 15295411 8355711 10735554
BaseColors 01,06,03,02,10

CLineOwner 06
CLineOP 08
CLineHOP 09
CLineVoice 15
CLineMe 07
CLineFriend 10
CLineEnemy 04

FontDefault Verdana,11
FontChan Verdana,11
FontQuery Verdana,11

ImageStatus stretch images/backgroundst.jpg
ImageChan fill images/background.jpg
ImageQuery fill images/background2.jpg
ImageSwitchbar fill images/banbottom.jpg
ImageToolbar fill images/bantop.jpg

Prefix 8▲
ParenText (<text>)
TimeStamp ON
TimeStampFormat <c4>[01HH:nn:ss<c4>]
Script loz.mrc
Load !script loz.load
Unload !script loz.unload
Scheme1 LOZ Version A
Scheme2 LOZ Version B

TextChan <c4><lt> $+ $loz.colorcmode(<cmode>) $+ <nick><c4><gt> <text>
TextChanSelf <c2><lt> $+ $loz.colorcmode(<cmode>) $+ <me><c2><gt> $loz.smileycolor(<text>)
ActionChan 4*2*6* <nick> <text>
ActionChanSelf 4*2*6* <me> $loz.smileycolor(<text>)
Notice 4›2› <c5>[<nick><c5>] <text>
NoticeSelf 4‹2‹ <c5>[<nick><c5>]<c1> $loz.smileycolor(<text>)
NoticeChan 4›2› <c4>(<c3><chan><c4>) <c5>[<nick><c5>] <text>
NoticeChanSelf 4‹2‹ <c4>(<c3><chan><c4>)<c1> $loz.smileycolor(<text>)
NoticeServer 4›2›  <server>: <text>

TextQuery <c4><lt><nick><c4><gt> <text>
TextQuerySelf <c2><lt><me><c2><gt> $loz.smileycolor(<text>)
ActionQuery 4*2*6* <nick> <text>
ActionQuerySelf 4*2*6* <me> $loz.smileycolor(<text>)
TextMsg 4›2› <c5>[<nick><c5>] <text>
TextMsgSelf 4‹2‹ <c5>[<nick><c5>]<c1> $loz.smileycolor(<text>)
ActionMsg 4›2› <c5>[<nick><c5>] <text>
ActionMsgSelf 4‹2‹ <c5>[<nick><c5>]<c1> $loz.smileycolor(<text>)

Mode !script loz.mode
ModeUser !script loz.usermode

Join 4¤ <c1><nick> (<address>) est entré(e) sur <chan> !
JoinSelf 4°2°6° <c1>Vous arrivez sur le canal <chan> !
Part 4¤ <c1><nick> (<address>) est sorti(e) de <chan> ! <parentext>.
Quit 6¤ <c1><nick> s'est déconnecté(e) de IRC <c1><parentext>.
QuitSelf 8¤ Vous vous êtes déconnecté(e) de IRC <c1><parentext>.
Kick 4°2°6° 4Kick - <c1><knick> a été éjecté(e) de <chan> par <nick> (<text>) !
KickSelf 4°2°6° 4Kick - <c1>Vous avez été éjecté(e) de <chan> par <nick> (<text>) !
Nick 4°2°6° <c2>Nick - <c1><nick> s'appelle maintenant <newnick> !
NickSelf 4°2°6° <c2>Nick - <c1>Vous vous appelez maintenant <newnick> !

Topic 4*2*6* <c1><nick> a changé le topic de <chan> : <text>
Invite 6¤ 10Invite - <c1><nick> vous invite à rejoindre <chan>...

Echo <timestamp> <pre> <c1><text>
EchoTarget <timestamp> <pre> <c1><text>
Error <timestamp> 4!!! Erreur: <c1><text>
Away <timestamp> <c3>[ <c5>Absence <c3>] [ <c5>Raison :  <c1><text> <c3> ] [ <c5>Heure : <c1> $+ $time $+ <c3>] [ <c5>Répondeur activé <c3>]


Raw.311 !script loz.whoisstart 
Raw.307 0 6~ Pseudonyme enregistré
Raw.378 0 6~ Connexion : <text>
Raw.335 0 6~ <text>
Raw.313 0 6~ <nick> est un(e) IRCop
Raw.317 0 6~ Idle: $duration(<idletime>,<signontimeraw>)
Raw.301 0 6~ <nick> est absent(e) : <away>
Raw.319 0 6~ Canaux : <chan>
Raw.312 0 6~ Utilise : <wserver> <serverinfo>
Raw.310 0 6~ <nick> est disponible pour toute aide
Raw.318 !script loz.whoisstop
Raw.671 0 6~ Utilise une connexion sécurisée

Raw.314 !script loz.whoisstart
Raw.369 !script loz.whoisstop

Connect !script loz.load
Raw.Other <text>
RAW.324 4›2›6› Mode(s) du canal : <modes>
RAW.329 4›2›6› Canal créé le $asctime(<text>)
RAW.332 4›2›6› Topic : <text>
RAW.333 4›2›6› Rédigé par : <nick>
RAW.353 4›2›6› Utilisateurs : <text>
RAW.366 4›2›6› 3----------------------
RAW.401 0 6~ <nick> non trouvé(e) !
Raw.421 0 6~ <value> : Commande invalide !

SndStart sounds/Connexion.mp3
SndHighLight sounds/HL.wav
SndOpen sounds/PV.wav
SndQuitSelf sounds/Deconnexion.mp3
SndDisconnect sounds/Deconnexion.mp3
SndAway sounds/Midona.wav
SndBack sounds/Link.wav

[scheme1]
Colors 0,10,12,5,2,1,6,1,1,6,1,1,4,7,1,1,1,10,1,1,1,7,1,15,1,2,6,15
RGBColors 16777215 0 8388608 37632 255 127 8388736 38655 65535 6610115 9671424 16776960 16515072 16711935 8355711 6606044
BaseColors 01,06,03,04,12
CLineOp 06
CLineHOP 12
CLineVoice 03
CLineMe 10
CLineFriend 15
CLineEnemy 05
FontDefault Tahoma,11
FontChan Tahoma,11
FontQuery Tahoma,11
ImageStatus tile images/scheme1/backgroundst.jpg
ImageChan tile images/scheme1/background.jpg
ImageQuery tile images/scheme1/background2.jpg
ImageSwitchbar fill images/scheme1/banbottom.jpg
ImageToolbar fill images/scheme1/bantop.jpg
TimestampFormat 14-HH:nn:ss-
SndHighLight sounds/scheme1/Hey.mp3
SndOpen sounds/scheme1/Listen.mp3
SndAway sounds/scheme1/Baille.mp3

[scheme2]
Colors 0,6,12,5,2,1,1,1,1,2,1,1,4,7,1,1,1,10,1,1,1,6,0,10,0,2,14,11
RGBColors 16777215 0 8388608 37632 255 127 8388736 4227327 65535 6610115 8406888 16564124 16515072 16711935 8421504 6606044
BaseColors 01,06,03,04,12
CLineOp 07
CLineHOP 09
CLineVoice 11
CLineMe 14
CLineFriend 08
CLineEnemy 05
FontDefault Tahoma,11
FontChan Tahoma,11
FontQuery Tahoma,11
ImageStatus tile images/scheme2/backgroundst.jpg
ImageChan stretch images/scheme2/background.jpg
ImageQuery fill images/scheme2/background2.jpg
ImageSwitchbar fill images/scheme2/banbottom.jpg
ImageToolbar fill images/scheme2/bantop.jpg
TimestampFormat 10[14HH:nn:ss10]
SndHighLight sounds/scheme1/Hey.mp3
SndOpen sounds/scheme1/Listen.mp3
SndAway sounds/scheme1/Baille.mp3
