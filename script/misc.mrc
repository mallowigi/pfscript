; ----------------------------------------
; Autres fonctionnalités
; ----------------------------------------

#features on

;;; <Doc>
;; Démarrage du script misc.mrc :
;; - Affichage du splash screen
;; - Affichage du tip of the day
;; - Chargement des clés des canaux
;; - Création du timer d'anti-idle
ON *:START:{
  if ($hget(groups,misc) == $null) { hadd -m groups misc 1 }
  if ($hget(groups,misc) == 1) { 
    .enable #features.misc

    ; Show splash screen
    if ($ri(misc,splash) == 1) { splash }
    splash_text 3 Chargement du script $nopath($script) ...

    ; Affiche le tip of the day
    if ($ri(misc,tips) == 1) { .timertip 1 5 showTip }

    ; Commande pour choper numero de la derniere version du pfscript sur le site
    if ($ri(misc,lookupdates) == 1) { lookUpdate }

    ; Chankeys
    var %f = $qt(data/chankeys.txt)
    if ($exists(%f)) { hmake chankeys 10 | hload chankeys %f }

    ; Anti-idle
    if ($ri(misc,antiidleuse) == 1) {
      var %time = $ri(misc,antiidle)
      if (%time > 0) { .timerantiidle -i 0 %time resetidle }
    }
  }
  else { .disable #features.misc }
}


ON *:UNLOAD:{
  if ($hget(groups,misc)) { hadd groups misc 0 }
  .timerantiidle off
  .timertip off
}
#features end

;----------------------------------------------
; Sauvegarde des clés des canaux
;----------------------------------------------

;;; <Doc>
;; Réécriture de join: join un canal et si il necessite une clé, l'insere automatiquement (requiert l'option keep-key)
;; /params $1: canal, $2 (optionnel): clé du canal
alias keyjoin {
  if (!$enabled(misc)) { !join $1- | return }

  var %target = $iif($left($1,1) != $chr(35),$chr(35) $+ $1,$1)
  if ($ri(misc,keepkey) == 0) { !join %target }
  else {
    var %key = $getChanKey(%target)
    if (%key) && (!$2) { !join %target %key }
    else { !join %target $2 }
  }
}

;;; <Doc>
;; Recupere la clé d'un canal
;; $1: canal
alias getChanKey {
  if (!$enabled(misc)) { $errdialog(La fonctionnalité est désactivée. Veuillez la réactiver d'abord.) | halt }
  if ($ri(misc,keepkey) == 0) { return }
  return $decode($hget(chankeys,$+($network,.,$1)))
}

; Sauve la clé d'un canal
alias -l saveChanKey {
  hadd -m chankeys $1 $encode($2)
}

;-------------------------------------------
; Verification des mises a jour 
;-------------------------------------------

;;; <Doc>
;; Verifie si une mise à jour du script est disponible
alias lookUpdate {
  ; Tant que j'ai pas acces au FTP
  $infodialog(Cette fonctionnalité est désactivée pour le moment.) | return
  if (!$script(libhttp.mrc)) { echo -s Le fichier libhttp.mrc est absent | return }
  http_get PFVERSION http://www.pokemon-france.com/services/chat/download.htm
}

; Active le téléchargement de la new version
alias -l askDownload {
  if ($$yndialog(Une nouvelle version du PFScript est disponible $chr(40) $+ version %upd $+ $chr(41) $+ .Voulez-vous la télécharger maintenant?)) {
    run explorer.exe http://www.pokemon-france.com/script/download.php
  }
}


on *:sockread:PFVERSION {
  if ($sockerr) return
  var %sockinput
  sockread %sockinput
  if ($regex(%sockinput,/<em id="version">(\d+(\.\d+)?)/i)) {
    sockclose $sockname
    set -u5 %upd $regml(1)
    if (%upd > $pfversion) { 
      .timer 1 0 askDownload
    }
  }
}

;---------------------------------------
; SPLASH SCREEN
;---------------------------------------

;;; <Doc>
;; Ouvre la fenetre de splash pour 5 secondes
alias -l splash {
  if (!$enabled(misc)) { return }
  dialog -mhdro splash splash
  .timerclosesplash 1 5 splash_close
}

; Ferme la fenetre de splash
alias -l splash_close {
  xdialog -a splash +bh 200
  xdialog -x splash
  showmirc -sx
  .timerclosesplash off
  .timersplash* off
}

; Events en cas de clic
alias splash_cb {
  if ($2 == sclick) { splash_close }
}

dialog -l splash {
  title "Splash"
  size -1 -1 400 340
  option pixels
}

ON *:dialog:splash:*:*:{
  if ($devent == init) {
    ; Si pas d'image, seulement le texte
    var %image = images/splash.png
    if (!$isfile(%image)) { dialog -sr $dname -1 -1 400 40 }

    ; DCX Mark
    dcx Mark $dname splash_cb
    xdialog -a $dname +ab 200
    xdialog -b $dname +d
    xdialog -q $dname +r wait

    ; If no image, only print the text
    if ($isfile(%image)) { 
      xdialog -g $dname +i %image
      xdialog -c $dname 1 panel 0 300 400 70
    }
    else { xdialog -c $dname 1 panel 0 0 400 70 }
    xdid -x $dname 1 +b
    xdid -C $dname 1 +b 2960685

    ; Sets the texts
    xdid -c $dname 1 2 text 5 5 400 15 noformat transparent
    xdid -f $dname 2 + ansi 8 Century Gothic
    xdid -C $dname 2 +t 16777215
    xdid -c $dname 1 3 text 5 20 400 15 noformat transparent
    xdid -f $dname 3 + ansi 8 Century Gothic
    xdid -C $dname 3 +t 16777215
    xdid -c $dname 1 4 text 5 35 400 15 noformat transparent
    xdid -f $dname 4 + ansi 8 Century Gothic
    xdid -C $dname 4 +t 16777215 
  }
}

;--------------------------------------------
; Astuces du jour
;--------------------------------------------
;;; <Doc>
;; Affiche une astuce du jour
alias showTip {
  if (!$enabled(misc)) { $errdialog(L'affichage des astuces est désactivé.Réactivez-les d'abord via le gestionnaire des fonctionnalités.) | return }
  var %totd = $read(data/tips.txt,n)
  if (!%totd) { return }
  $infodialog(Conseil n° $+ $readn :  %totd)
}

;--------------------------------------------
; Masques
;--------------------------------------------

;;; <Doc>
;; Bannit l'utilisateur avec le masque fourni
;; /params: $1- Parametres de la commande /ban
;; Note: si le masque est fourni (dernier parametre: nombre) alors ce sera ce masque qui sera utilisé
alias maskban {
  var %maskban = $ri(masks,banmask)
  if ($ [ $+ [ $0 ] ] isnum) { !ban $1- }
  else { !ban $1- %maskban }
}

;;; <Doc>
;; Ignore l'utilisateur avec le masque fourni
;; /params: $1- Parametres de la commande /ignore
;; Note: si le masque est fourni (dernier parametre: nombre) alors ce sera ce masque qui sera utilisé
alias maskignore {
  var %maskign = $ri(masks,ignoremask)
  if ($ [ $+ [ $0 ] ] isnum) { !ignore $1- }
  else { !ignore $1- %maskign }
}


;--------------------------------------------
; Options des highlights
;--------------------------------------------

;;; <Doc>
;; Réécriture de la commande notice pour afficher dans la fenetre séparée
;; /params $1: nick, $2-: texte a envoyer
alias newnotice {
  if (!$enabled(misc)) { !notice $1- | return }
  theme.notice $1 $2-
  if ($ri(misc,noticeother) == 1) {
    openNoticeWin
    printNotice @Notices $timestamp Notice envoyée à $basecolor(2) $+ $1 : $basecolor(1) $+ $qt($2-) 
    set -e %lastnoticenick $1
  }
}

; Ouvre la fenetre des highlights
alias -l openHighlightWin {
  window -Ce3g2ik0vz @Highlights -1 -1 480 400 Calibri 14 $iif($isfile("images/masterIRC2.ico"),"images/mbico.ico")
}

; Ouvre la fenetre des notices speciales
alias -l openNoticeWin {
  window -Ce3g2ik0vz @Notices -1 -1 480 400 Calibri 14 $iif($isfile("images/masterIRC2.ico"),"images/mbico.ico")
}

; Ouvre la fenetre affichant les notices des services
alias -l openServWin {
  var %title = $1
  window -Clnvz +e %title -1 -1 480 400 Calibri 14 $iif($isfile("images/masterIRC2.ico"),"images/mbico.ico")
}

; Affiche la notice dans la fenetre correspondante
; $1: window, $2-: texte
alias -l printNotice {
  var %title = $1
  if (!$window(%title)) || (!$2) { return }
  aline -shp $color(listbox text) %title $2- 
  flash -r %title
}

;;; <Doc>
;; Réécriture de la commande ns pour afficher les notices dans la fenetre des services
alias ns {
  if (!$enabled(misc)) { !ns $1- | return }
  if ($ri(misc,serviceswin) == 1) {
    openServWin @NickServ. $+ $network
    titlebar @NickServ. $+ $network Réseau $network : /ns $1-
  }
  !ns $1-
}

;;; <Doc>
;; Réécriture de la commande cs pour afficher les notices dans la fenetre des services
alias cs {
  if (!$enabled(misc)) { !cs $1- | return }
  if ($ri(misc,serviceswin) == 1) {
    openServWin @ChanServ. $+ $network
    titlebar @ChanServ. $+ $network Réseau $network : /cs $1-
  }
  !cs $1-
}

;;; <Doc>
;; Réécriture de la commande bs pour afficher les notices dans la fenetre des services
alias bs {
  if (!$enabled(misc)) { !bs $1- | return }
  if ($ri(misc,serviceswin) == 1) {
    openServWin @BotServ. $+ $network
    titlebar @BotServ. $+ $network Réseau $network : /bs $1-
  }
  !bs $1-
}

;;; <Doc>
;; Fenêtres @NickServ*, @ChanServ* et @BotServ*
;; Copie le contenu de la ligne sélectionnée
menu @NickServ*,@ChanServ*,@BotServ* {
  lbclick:clipboard $sline($mouse.win,1)
}

;;; <Doc>
;; Fenêtres *Serv*: La touche entrée ferme la fenêtre
ON *:KEYDOWN:@:*:{
  if (*Serv* iswm $active) && ($keyval == 13) {
    close -@ $active
  }
}

;;; <Doc>
;; Entree du texte dans l'editbox renvoie une notice au dernier utilisateur
ON *:INPUT:@Notices:{
  if (%lastnoticenick) && (%lastnoticenick != $me) { notice %lastnoticenick $1- }
}

;--------------------------------------------------------


#features.misc on

;;; <Doc>
;; Entrée sur un canal protégé par une clé: ajoute la clé dans la base si l'option keepkey est cochée
RAW 324:*:{
  if ($ri(misc,keepkey) == 1) {
    var %mode = $3
    if (k isin %mode) {
      var %key = [ $ $+ [ $0 ] ]
      saveChanKey $+($network,.,$2) %key
    }
  }
}

;;; <Doc>
;; Changement de la clé du canal: change la clé associée dans la base si l'option keepkey est cochée
ON *:RAWMODE:*:{
  if ($ri(misc,keepkey) == 1) {
    var %mode = $1
    var %on = $left(%mode,1)
    if (k isin %mode) {
      if (%on == -) { saveChanKey $+($network,.,$chan) }
      else { 
        var %key = [ $ $+ [ $0 ] ]
        saveChanKey $+($network,.,$chan) %key
      }
    }
  }
}

;-------------------------------------
; Transfert DCC
;-------------------------------------

;;; <Doc>
;; Affiche les infos a la fin du transfert DCC si l'option dccinfo est cochée
ON *:FILESENT:*:{
  if ($ri(misc,dccinfo) == 1) {
    var %enddcc = Le fichier $basecolor(4) $+ $qt($send(-1).file) $basecolor(1) $+ a bien été reçu par $basecolor(2) $+ $send(-1) $iif($send(-1).ip != 255.255.255.255,15( $+ $ifmatch $+ )).
    var %enddcc2 = Fichier de $basecolor(4) $+ $bytes($send(-1).size,3).suf $basecolor(1) $+ , envoyé en $basecolor(4) $+ $durationfr($send(-1).secs) $basecolor(1) $+, à une vitesse moyenne de $basecolor(4) $+ $bytes($send(-1),3).suf $+ /s.
    theme.echo %enddcc
    theme.echo %enddcc2
  }
}

;;; <Doc>
;; Affiche les infos a la fin du transfert DCC si l'option dccinfo est cochée
ON *:FILERCVD:*:{
  if ($ri(misc,dccinfo) == 1) {
    var %enddcc = Le fichier $basecolor(4) $+ $qt($get(-1).file) $basecolor(1) $+ , envoyé par $basecolor(2) $+ $get(-1) $iif($get(-1).ip != 255.255.255.255,15( $+ $ifmatch $+ )) $basecolor(1) $+ a bien été téléchargé à l'adresse $basecolor(3) $+ $qt($get(-1).path).
    var %enddcc2 = Fichier de $basecolor(4) $+ $bytes($get(-1).size,3).suf $basecolor(1) $+ , téléchargé en $basecolor(4) $+ $durationfr($get(-1).secs) $basecolor(1) $+ , à une vitesse moyenne de $basecolor(4) $+ $bytes($get(-1),3).suf $+ /s.
    theme.echo %enddcc
    theme.echo %enddcc2
  }
}

;;; <Doc>
;; Affiche les infos a la fin du transfert DCC si l'option dccinfo est cochée
ON *:SENDFAIL:*:{
  if ($ri(misc,dccinfo) == 1) {
    var %enddcc = Echec de l'envoi du fichier $basecolor(4) $+ $qt($send(-1).file) $basecolor(1) $+ , envoyé à $basecolor(2) $+ $send(-1) $iif($send(-1).ip != 255.255.255.255,14( $+ $ifmatch $+ )).
    var %enddcc2 = Envoi de $basecolor(4) $+ $bytes($send(-1).sent,3).suf $+ $basecolor(1) $+ sur $basecolor(4) $+ $bytes($send(-1).size,3).suf $basecolor(1) $+ ( $+ $send(-1).pc $+ % $+ ), envoyés en $basecolor(4) $+ $durationfr($send(-1).secs) $basecolor(1) $+ , à une vitesse moyenne de $basecolor(4) $+ $bytes($send(-1),3).suf $+ /s.
    theme.echo %enddcc
    theme.echo %enddcc2
  }
}

;;; <Doc>
;; Affiche les infos a la fin du transfert DCC si l'option dccinfo est cochée
ON *:GETFAIL:*:{
  if ($ri(misc,dccinfo) == 1) {
    var %enddcc = Echec de la réception du fichier $basecolor(4) $+ $qt($get(-1).file) $basecolor(1) $+ , envoyé par $basecolor(2) $+ $get(-1) $iif($get(-1).ip != 255.255.255.255,14( $+ $ifmatch $+ )).
    var %enddcc2 = Réception de $basecolor(4) $+ $bytes($get(-1).rcvd,3).suf $basecolor(1) $+ sur $basecolor(4) $+ $bytes($get(-1).size,3).suf $basecolor(1) $+ ( $+ $get(-1).pc $+ % $+ $basecolor(1) $+ ), téléchargés en $basecolor(4) $+ $durationfr($get(-1).secs) $+ $basecolor(1) $+ , à une vitesse moyenne de $basecolor(4) $+ $bytes($get(-1),3).suf $+ /s.
    theme.echo %enddcc
    theme.echo %enddcc2
  }
}

;---------------------------------------
; Compteur de kicks 
;---------------------------------------

;;; <Doc>
;; Affiche les statistiques de kicks lors d'un kick si l'option kickcount est cochée
ON *:KICK:*:{
  if ($nick == $me) {
    if ($ri(misc,kickcount) == 1) {
      var %mess = Nombre de kicks sur le canal $basecolor(2) $+ $chan : $basecolor(4) $+ $getCStat($chan,kickCount) $basecolor(1) $+ sur un total de $basecolor(4) $+ $getStat(kickCount) kicks.
      theme.echo -ea %mess
    }
  }
}

;--------------------------------------
; Highlights fenetre active/séparée
;--------------------------------------

;;; <Doc>
;; Si le texte contient un highlight, affiche le highlight:
;; - dans la fenêtre active si l'option hlactive est cochée
;; - dans la fenêtre des highlights si l'option hlother est cochée
ON *:TEXT:*:*:{
  if ($highlight) && ($highlight($1-)) && (?1 !iswm $1) {
    set -un %weshmessage !!Highlight!! $basecolor(4) $+ $nick  $+ a prononcé le texte $basecolor(1) $+  $+ $qt($1-)  $+ sur $basecolor(2) $+ $chan !
    if ($ri(misc,hlactive) == 1) {
      if ($chan != $active) { echo -atlgc highlight %weshmessage }
    }
    if ($ri(misc,hlother) == 1) {
      openHighlightWin
      printNotice @Highlights highlight %weshmessage
    }
  }
}

;;; <Doc>
;; Lors de la réception d'une notice: 
;; - Si notice de services, la redirige vers la fenêtre des services si l'options serviceswin est cochée
;; - Sinon, la redirige vers la fenêtre des notices si l'options noticeother est cochée
ON ^*:NOTICE:*:*:{
  if ($ri(misc,serviceswin) == 1) {
    if ($nick == NickServ) || ($nick == Themis) {
      openServWin @NickServ. $+ $network
      printNotice @NickServ. $+ $network $1- | halt
    }
    elseif ($nick == ChanServ) || ($nick == Gaia) {
      openServWin @ChanServ. $+ $network
      printNotice @ChanServ. $+ $network $timestamp $1- | halt
    }
    elseif ($nick == BotServ) || ($nick == Poseidon) {
      openServWin @BotServ. $+ $network
      printNotice @BotServ. $+ $network $1- | halt
    }
  }
  if ($ri(misc,noticeother) == 1) {
    openNoticeWin
    printNotice @Notices $timestamp Notice de $basecolor(2) $+ $nick : $basecolor(1) $+ $qt($1-) 
    set -e %lastnoticenick $nick
    halt
  }
}

;--------------------------------------
; Vidage du presse-papiers
;--------------------------------------

;;; <Doc>
;; A la fermeture de mIRC:
;; - Sauvegarde des clés des canaux (option keepkey)
;; - Vidage du pressepapies (option clearcb)
ON *:EXIT:{
  ; Sauvegarde des clés
  if ($ri(misc,keepkey) == 1) {
    var %f = $qt(data/chankeys.txt)
    if (%f) && ($hget(chankeys)) { write -c %f | hsave chankeys %f }
  }

  ; Vidage du pressepapiers
  if ($ri(misc,clearcb) == 1) { clipboard }
}

;;; <Doc>
;; Menu Outils: Récupérer clé d'un canal, Afficher une astuce du jour, Vérifier les mises à jour
menu menubar {
  Outils
  .$iif($enabled(misc),Récupèrer la clé d'un canal):theme.echo -a $iif($getChanKey($$?="Quel canal?"),La clé du canal $! est : $v1,Pas de clé enregistrée pour ce canal)
  .$iif($enabled(misc),Afficher une astuce du jour):showTip
  .$iif($enabled(misc),Vérifier les mises à jour du script):lookUpdate
}


#features.misc end

;;; <Doc>
;; Envoi de la version du PFScript en cas de ctcp version
CTCP *:*:*:{
  if ($1 == VERSION) {
    .ctcpreply $nick VERSION $pfscript
  }
}

; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
