;------------------------------------
; Pokemon Theme by Klarth
; Do not copy without permission
;------------------------------------

[mts]
Name PFScript Theme
Author Klarth
Email mariosmilax@free.fr
Description PF Script Theme By Klarth
Website http://www.pokemon-france.com
Version 1.0
MTSVersion 1.3

;------------------------- Color Section -------------------------
;New IRC Color Scheme (default)
Colors 0,10,4,5,3,2,9,11,13,10,9,1,6,7,6,10,4,2,3,5,1,1,0,1,0,15,6,5,0,1
RGBColors 16777215 0 8388608 25600 3937500 930403 9109643 30444 55295 2330219 8421376 11829830 16744448 6881490 5197613 8026746

;Base Colors for the script: text color : Black, nick color: Green, hl color: Red, bracket color: Teal, parenthesis color: Darkblue
BaseColors 01,03,04,10,02

;Nick Colors and prefixes
;Owner Purple (*)
CLineOwner 06
CLineCharOwner *

;OP Red (@)
CLineOP 04
CLineCharOP @

;Halfop Orange (%)
CLineHOP 07
CLineCharHOP %

;Voice Yellow (+)
CLineVoice 08
CLineCharVoice +

;Me Gray
CLineMe 14

;Notify List nicks (default blue)
CLineFriend 12

;Ignored nicks (default Brown)
CLineEnemy 05

;--------------------- Font section ------------------------
FontDefault Calibri,13,B; Verdana,12; Arial,12,B
FontChan Calibri,13,B; Verdana,12; Arial,12,B
FontQuery Calibri,13,B; Verdana,12; Arial,12,B

;--------------------- Images section ----------------------
ImageStatus stretch images/fonds/afond $+ $rand(1,18) $+ .png
ImageChan stretch images/fonds/afond $+ $rand(1,18) $+ .png
ImageQuery stretch images/fonds/afond $+ $rand(1,18) $+ .png
ImageMirc tile images/bgmirc.jpg
ImageSwitchbar fill images/sidebar.png
ImageToolbar fill images/bantop.png

;--------------------- Misc ------------------------------------
Prefix <c4>~·-<gt>
ParenText <c5>(<c1><text><c5>)
TimeStamp ON
TimeStampFormat <c5>(15HH:nn:ss<c5>)
Script pftheme.mrc
Indent 4

;--------------------- Schemes ---------------------------------
Scheme1 Black Theme

;--------------------- Events ----------------------------------
;Common
TextChan <c4>[14<cmode><cnick><nick><c4>] <text>
TextChanSelf <c4>[<cnick><me><c4>] <text>
ActionChan <pre> <c1>*** 14<cnick><nick> <text> <c1>***
ActionChanSelf <pre> <c1>*** <cnick><me> <text> <c1>***
Notice <c2><lt>--- (Notice) <cnick><nick>: <text>
NoticeSelf <c2>---<gt> (Notice) <cnick><nick>: <text>
NoticeChan <c2><lt>--- <c4>[<c3>Channel Notice (<chan>)<c4>] 14<cmode><cnick><nick>: <text>
NoticeChanSelf <c2>---<gt> <c4>[<c3>Channel Notice (<chan>)<c4>] <text>
TextQuery <c5>(<cnick><nick><c5>) : <text>
TextQuerySelf <c5>(<cnick><me><c5>) : <text>
ActionQuery <pre> <c1>*** 14<cnick><nick> <text> <c1>***
ActionQuerySelf <pre> <c1>*** 14<cnick><me> <text> <c1>***
TextMsg <c5>(<cnick><nick><c5>) : <text>
TextMsgSelf <c5>(<cnick><me><c5>) : <text>
ActionMsg <pre> <c1>*** 14<cnick><nick> <text> <c1>***
ActionMsgSelf <pre> <c1>*** 14<cnick><me> <text> <c1>***

;Mode
Mode !script pftheme.mode
ModeUser !script pftheme.usermode

;Join, Part, Quit, Kick, Nick
Join <pre> ``` <cnick><nick> <c4>(14<address><c4>) a rejoint le canal <c5><chan> <parentext> ´´´
JoinSelf <pre> ``` Vous <c4>(12<me> - 14<address><c4>) parlez maintenant sur <c5><chan> ´´´
Part <pre> ``` <cnick><nick> <c4>(14<address><c4>) est sorti de <c5><chan> <parentext> ´´´
Quit <pre> ``` <cnick><nick> <c4>(14<address><c4>) a quitté IRC <parentext> ***
QuitSelf <pre> ``` Vous <c4>(<me><c4>) avez quitté IRC <parentext> ***
Kick <pre> ``` <cnick><nick> a kické <cnick><knick> <c4>(14<kaddress><c4>) de <c5><chan> <c5>(Raison : <c1><text><c5>) ´´´
KickSelf <pre> ``` Vous avez été kické de <c5><chan> par <cnick><nick> <c5>(Raison  : <c1><text><c5>) ´´´
Nick <pre> ``` <cnick><nick> s'appelle maintenant <c3><newnick> ´´´
NickSelf <pre> ``` Vous vous appelez maintenant <c3><newnick> ´´´

;Misc
Topic <pre> ~~~ <cnick><nick> a changé le topic en : <c1><text> ~~~
Invite <pre> ~~~ <cnick><nick> vous invite à rejoindre <c5><chan> ~~~
Rejoin <pre> ~~~ Tentative de hop sur le canal <c5><chan>... ~~~

;Server Messages
ServerError !script pftheme.servererror
Wallop <pre> ### <c4>(Wallop<c4>) <text> ###
NoticeServer <pre> ### <c4>(Notice Server<c4>) <text> ###

;Ctcps
Ctcp ~#* <c5>(<nick> CTCP <ctcp><c5>) <c1><text> *#~
CtcpSelf <c3>~#* -<gt> <c5>(<nick> CTCP <ctcp><c5>) <c1><text> <c3>*#~
CtcpChan ~#* <c5>(<chan> CTCP <ctcp><c5>) <c1><text> *#~
CtcpChanSelf <c3>~#* -<gt> <c5>(<chan> CTCP <ctcp><c5>) <c1><text> <c3>*#~
CtcpReply !script pftheme.ctcpreply 
CtcpReplySelf <c3>~#* -<gt> <c5>(<nick> CTCP <ctcp><c5>) Réponse : <c1><text>  <c3>*#~

;Notify
Notify <pre> ---<gt> <c5>(7Notif<c5>) : <cnick><nick> est connecté! <c5>(<text><c5>) <lt>---
UNotify <pre> ---<gt> <c5>(7Notif<c5>) : <cnick><nick> s'est déconnecté. <c5>(<text><c5>) <lt>---

HighLight <c3>{{<cnick><nick><c3>}} <text>
;HighLight !!Highlight!! <cnick><nick> a prononcé <c1>"<text>" sur le canal <c2><chan>

;Dns
DNS <pre> 12DNS: Résolution de <c2><address>...
DNSError <pre> 12DNS: Echec de résolution de <c2><address>.
DNSResolve <pre> 12DNS: Adresse résolue: <c2><raddress> (14<naddress> - 14<iaddress>)

;DCC
Send <pre> [|DCC: <c2><nick> tente de vous envoyer le fichier "<c4><file>". Accepter? |]
Fserve <pre> [|FSERVE: <c2><nick> tente de vous envoyer le fichier "<c4><file>". Accepter? |]
FileSent <pre> [|4DCC: Vous avez bien envoyé le fichier "<c4><file>" <c5>(<size><c5>) à <c2><nick>. (Envoyé en <c4><secs>) |]
FileRcvd <pre> [|4DCC: Vous avez bien reçu le fichier "<c4><file>" <c5>(<size><c5>) de <c2><nick>. (Reçu en <c4><secs>) |]
GetFail <pre> [|4DCC: Echec de la réception du fichier "<c4><file>" <c5>(<size><c5>) par <c2><nick>. (Téléchargé <c4><rcvd> <c5>(<percent>%<c5>) en <c4><secs>s) |]
SendFail <pre> [|4DCC: Echec de l'envoi du fichier "<c4><file>" <c5>(<size><c5>) à <c2><nick>. (Envoyé <c4><sent> <c5>(<percent>%<c5>) en <c4><secs>s) |]

;Format for theme.echo and theme.error aliases
Echo <timestamp> <pre> <c1><text>
EchoTarget <timestamp> <pre> <c1><text>
Error <timestamp> 4!!! Erreur: <c1><text>
Away <timestamp> <pre> <c5>^^^ <text> <c5>^^^

;Whois
Raw.311 !script pftheme.whoisstart
Raw.307 !script pftheme.registered
Raw.313 !script pftheme.isircop
Raw.317 !script pftheme.idle
Raw.301 !script pftheme.awaymode
Raw.319 !script pftheme.channels
Raw.312 !script pftheme.server
Raw.318 !script pftheme.whoisstop
Raw.671 7~~~~ 12Utilise une connexion sécurisée 7~~~~ 

;Whowas
Raw.314 !script pftheme.whowasstart
Raw.369 !script pftheme.whowasstop

;Other Raws
Connect <c1>Vous êtes maintenant <c2>connecté au serveur <c5><server>!
Disconnect <c1>Déconnexion du serveur!
Raw.Other <c1><text>
Raw.001 <c1>Bienvenue sur IRC l'ami!!!
Raw.002 <c1>Vous êtes sur le serveur <c5><server>, 14<value>
Raw.003 <c1>Serveur créé le: <c5><value>
Raw.004 <c1>Serveur <c5><server>, Usermode : <c4><value>
Raw.005 <c1>Protocoles supportés: <c5><text>

Raw.219 13----------------------------------------------------------
RAW.221 <pre> <c1>Modes: <c5><modes>
RAW.250 <pre> <c1>Nombre total de connexions : <c5><value>
RAW.251 <pre> <c1>Il y'a <c4><users><c1> users connectés dont <c4><text><c1> invisibles sur <c5><value><c1> serveurs
RAW.252 <pre> <c1>IRCOpérateurs connectés: <c5><value>
RAW.253 <pre> <c1>Connexions inconnues: <c5><value>
RAW.254 <pre> <c1>Canaux enregistrés: <c5><value>
RAW.255 <pre> <c1>Clients locaux: <c5><users>
Raw.263 <pre> <c3> ### Erreur: Le serveur est temporairement surchargé. Veuillez réessayer ultérieurement. ###
RAW.265 <pre> <c1>Utilisateurs locaux: <c5><users> sur un max de <c5><value>
RAW.266 <pre> <c1>Utilisateurs globaux: <c5><users> sur un max de <c5><value>
Raw.271 <pre> <c1>Liste des utilisateurs shun: <c2><nick> 
Raw.272 <pre> 
Raw.280 <pre> <c1>Liste des utilisateurs gline: <c2><text>
Raw.281 <pre>

RAW.302 <pre> <c1>Userhost <c2><nick>!<address>
Raw.305 <pre> <c5>^^^ Vous n'êtes plus absent ^^^ 
Raw.306 <pre> <c5>^^^ Vous êtes à présent absent ^^^

Raw.315 !script pftheme.whoisstop
Raw.321 !script pftheme.chanlist
Raw.322 !script pftheme.chanlistadd
Raw.323 !script aline @chans %::c1 $+ Fin de la liste

RAW.324 <pre> <c1>Modes du canal: <c4>(<c5><modes><c4>)<c1>
RAW.329 !Script %:echo %::pre %::c1 $+ Canal créé le : %::c4 $+ $signontimefr(%::text)
RAW.332 <pre> <c1>Topic: "<c2><text>"<c1>
RAW.333 !script pftheme.topicsetby
RAW.341 <pre> <c1>Invitation de <c2><nick> à rejoindre <c5><chan>

RAW.353 !script pftheme.listusers
RAW.366 <c4>~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
RAW.372 !script pftheme.motd
RAW.375 !script pftheme.motdbegin
RAW.376 !script pftheme.motdend
RAW.391 <pre> <c1>Heure du serveur : <c5><text>


RAW.401 <pre><c3> ### Erreur: Pseudo <c4><nick><c3> inexistant! ###
RAW.403 <pre><c3> ### Erreur: Canal <c4><chan><c3> inexistant! ###
RAW.404 <pre><c3> ### Erreur: Vous ne pouvez pas envoyer de message sur <c4><chan><c3>. ### 
RAW.421 <pre><c5> @@@ <c4><value><c5>: Commande invalide 
RAW.432 <pre><c3> @@@ Erreur: Le pseudo <c4><nick><c3> ne peut pas être utilisé. @@@
RAW.433 <pre><c3> @@@ Erreur: Le pseudo <c4><nick><c3> est déjà utilisé. @@@
RAW.437 <pre><c3> @@@ Erreur: Vous ne pouvez pas changer de pseudo tant que vous êtes banni sur <c4><chan> @@@
RAW.471 <pre><c3> ^^^ Erreur: Impossible de rejoindre <c4><chan><c3> : Le canal est plein (mode +l). ^^^
RAW.473 <pre><c3> ^^^ Erreur: Impossible de rejoindre <c4><chan><c3> : Le canal ne peut être rejoint que par invite (mode +i). Vous pouvez demander à quelqu'un de vous ouvrir en tapant /knock <chan> ^^^
RAW.474 <pre><c3> ^^^ Erreur: Impossible de rejoindre <c4><chan><c3> : Vous êtes banni de ce canal. ^^^
RAW.475 <pre><c3> ^^^ Erreur: Impossible de rejoindre <c4><chan><c3> : Le canal est protégé par une clé (mode +k). Tapez /join <chan> [key] si vous avez la clé pour rejoindre le canal. ^^^
RAW.482 <pre><c3> ^^^ Erreur: Action refusée: Vous n'êtes pas opérateur sur <c4><chan><c3> ! ^^^
Raw.408 <pre><c5> ~~~ Erreur: Vous ne pouvez pas utiliser de couleurs sur ce canal! ~~~

Raw.600 <pre> Notification: <c2><nick> 2(14<address>2) s'est connecté à 10[<c5><value>10]
Raw.601 <pre> Notification: <c2><nick> 2(14<address>2) s'est déconnecté 10[<c5><value>10]

;---------------- Sounds ------------------

SndStart sounds/start.mp3
SndHighLight sounds/highlight.mp3
SndTextQuery sounds/query.mp3

SndNotice sounds/notice.mp3
SndNoticeSelf sounds/notice.mp3
SndSNotice sounds/snotice.mp3
SndSNoticeSelf sounds/snotice.mp3
SndJoin sounds/join.mp3
SndJoinSelf sounds/join.mp3
SndPart sounds/part.mp3
SndPartSelf sounds/part.mp3
SndKick sounds/kick.mp3
SndKickSelf sounds/kick.mp3

SndMode sounds/protect.mp3
SndModeSelf sounds/protect.mp3
SndOp sounds/op.mp3
SndOpSelf sounds/op.mp3
SndDeop sounds/deop.mp3
SndDeopSelf sounds/deop.mp3
SndBan sounds/ban.mp3
SndBanSelf sounds/ban.mp3
SndHop sounds/halfop.mp3
SndHopSelf sounds/halfop.mp3
SndDeHop sounds/dehalfop.mp3
SndDeHopSelf sounds/dehalfop.mp3
SndVoice sounds/voice.mp3
SndVoiceSelf sounds/voice.mp3
SndDeVoice sounds/devoice.mp3
SndDeVoiceSelf sounds/devoice.mp3

SndCtcp sounds/ctcp.mp3
SndCtcpSelf sounds/ctcp.mp3

SndQuit sounds/part.mp3
SndQuitSelf sounds/disconnect.mp3

SndNotify sounds/notify.mp3
SndUNotify sounds/disconnect.mp3

SndInvite sounds/notify.mp3
SndWallops sounds/notify.mp3

SndConnect sounds/connect.mp3
SndDisconnect sounds/disconnect.mp3

SndSend sounds/dccsend.mp3
SndFileSent sounds/dccsent.mp3
SndFileRcvd sounds/dccsent.mp3
SndSendFail sounds/deop.mp3
SndGetFail sounds/deop.mp3

; Un peu chiants ces deux la
;SndOpen sounds/ctcp.mp3
;SndDialog sounds/ctcp.mp3
SndAway sounds/notify.mp3
SndBack sounds/voice.mp3

;---------------------- Schemes ------------------------------
[scheme1]
Colors 1,12,4,5,3,4,12,8,4,13,9,0,4,7,6,7,11,3,3,2,14,1,0,1,0,15,6,14,0,1
BaseColors 0,12,8,3,6
RGBColors 16777215 0 13825351 2865963 255 2970272 13762770 3127039 6025215 9109386 12303104 11454975 16744448 16749055 9470064 14474460
ImageStatus stretch images/fonds/bfond $+ $rand(1,18) $+ .png
ImageChan stretch images/fonds/bfond $+ $rand(1,18) $+ .png
ImageQuery stretch images/fonds/bfond $+ $rand(1,18) $+ .png
TimeStampFormat <c4>(15HH:nn:ss<c4>)