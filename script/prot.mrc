; --------------------------
; Protections
; --------------------------

#features on
ON *:START:{
  if ($hget(groups,prots) == $null) { hadd -m groups prots 1 }
  if ($hget(groups,prots) == 1) { 
    splash_text 3 Chargement du script $nopath($script) ...
    .enable #features.prots 
    excludes.load
    bwlist.load w
    bwlist.load b
  }
  else { .disable #features.prots }
}


ON *:UNLOAD:{
  if ($hget(groups,prots)) { hadd groups prots 0 }
}


#features end

; Récupère le nom de l'action selon le code
; $1: action codée (ex: 1:bp-fl)
alias parseaction {
  tokenize 32 $1
  var %i = 1
  while (%i <= $0) {
    var %act = $gettok($ [ $+ [ %i ] ],2-,58)
    var %tok = 1
    var %res = %res —›
    while (%tok <= $numtok(%act,43)) {
      %res = %res $iif(%tok != 1,+) $getactionname($gettok(%act,%tok,43))
      inc %tok
    }
    inc %i
  }
  if (!%res) { return Aucune }
  else { return $mid(%res,4) }
}

; Recupère le nom de l'action selon le code
alias -l getActionName {
  if ($1 == bl) { return Blacklister user }
  elseif ($1 == do) { return Deop/Dehalfop/Devoice user }
  elseif ($1 == bp) { return Emettre Bip }
  elseif ($1 == fl) { return Flasher mIRC }
  elseif (nt-* iswm $1) { return Notifier sur canal actif }
  elseif (ib-* iswm $1) { return Afficher Infobulle }
  elseif (au-* iswm $1) { return Avertir user }
  elseif ($regex(cp2,$1,/^b-(\d+)-.+$/)) { return Bannir $iif($regml(cp2,1),$v1 mins) }
  elseif (k-* iswm $1) { return Kicker user }
  elseif (kl-* iswm $1) { return Kill user }
  elseif ($regex(cp1,$1,/^i-.+-(\d+)-.+$/)) { return Ignorer user $iif($regml(cp1,1),$v1 mins) }
  elseif (ps-* iswm $1) { return Commande perso. }
  elseif (cm-* iswm $1) { return Changer les modes du canal }
  elseif (s-* iswm $1) { return Jouer son }
  ; Seulement pour les protections personnelles
  elseif ($1 == ad) { return Auto-deban }
  elseif ($regex(cp3,$1,/^bq-(\d+)$/)) { return Bloquer queries $iif($regml(cp3,1),$v1 mins) }
  elseif ($1 == fq) { return Fermer query }
}

; Charge la liste des exclusions
alias excludes.load {
  if ($hget(excl)) { hfree excl }
  var %f = $qt($iif($ri(paths,excludes),$v1,data/excludes.txt))
  if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas!) | halt }

  hmake excl 100
  hload -i excl %f
}

; Blacklist/.Whitelist
alias bwlist.load {
  var %type = $iif($1 == w,wlist,blist)
  if ($hget(%type)) { hfree %type }
  var %f = $qt($iif($ri(paths,%type),$v1,data/ $+ %type $+ .txt))
  if (!$isfile(%f)) { write -c %f }

  hmake %type 100
  hload -i %type %f
}

;---------------------------------------------
; Dialogs principaux
;---------------------------------------------
;sec dialogs 

; Dialog pour la pub
dialog cprot.pub,pprot.spam {
  title "Edition d'une protection"
  size -1 -1 248 364
  option pixels
  icon images/masterIRC2.ico
  button "&Ok", 1, 80 336 80 24, ok
  button "&Annuler", 2, 164 336 80 24, cancel
  box "", 10, 4 2 240 86
  check "A&ctiver", 11, 12 20 108 18
  text "Au bout de :", 12, 32 42 64 16
  edit "3", 13, 100 38 38 22, limit 3
  text "récidives", 14, 148 42 44 16
  text "Intervalle :", 15, 32 64 64 16
  edit "30", 16, 100 60 38 22, limit 3
  text "secondes", 17, 148 64 44 16
  text "", 18, -1 -1 0 0, hide
  text "", 19, -1 -1 0 0, hide
  text "", 20, -1 -1 0 0, hide

  box "Protection", 21, 4 94 240 94
  list 22, 16 108 32 72, size
  text "", 23, 62 110 179 16
  text "", 24, 62 126 179 52

  box "Actions à effectuer", 30, 4 194 240 140
  list 32, 12 210 142 112, size
  button "Aj. &niveau", 33, 158 212 76 24
  button "Aj. &actions", 34, 158 236 76 24, disable
  button "&Supprimer", 35, 158 266 76 24, disable
  list 100, 12 210 142 112, hide disable
}

; Dialog pour les badwords
dialog cprot.badwords {
  title "Edition d'une protection"
  size -1 -1 248 364
  option pixels
  icon images/masterIRC2.ico
  button "&Ok", 1, 80 336 80 24, ok
  button "&Annuler", 2, 164 336 80 24, cancel
  box "", 10, 4 2 240 86
  check "A&ctiver", 11, 12 20 108 18
  text "Au bout de :", 12, 32 42 64 16
  edit "3", 13, 100 38 38 22, limit 3
  text "récidives", 14, 148 42 44 16
  text "Intervalle :", 15, 32 64 64 16
  edit "30", 16, 100 60 38 22, limit 3
  text "secondes", 17, 148 64 44 16
  text "", 18, -1 -1 0 0, hide
  text "", 19, -1 -1 0 0, hide
  text "", 20, -1 -1 0 0, hide

  box "Badwords", 21, 4 94 240 94
  list 22, 12 110 142 68, sort size extsel vsbar
  button "Aj&outer", 23, 158 112 76 24
  button "&Supprimer", 24, 158 136 76 24

  box "Actions à effectuer", 30, 4 194 240 140
  list 32, 12 210 142 112, size
  button "Aj. &niveau", 33, 158 212 76 24
  button "Aj. &actions", 34, 158 236 76 24, disable
  button "&Supprimer", 35, 158 266 76 24, disable
  list 100, 12 210 142 112, hide disable
}

; Dialog pour les majs
dialog cprot.majs {
  title "Edition d'une protection"
  size -1 -1 248 308
  option pixels
  icon images/masterIRC2.ico
  button "&Ok", 1, 80 276 80 24, ok
  button "&Annuler", 2, 164 276 80 24, cancel
  box "", 10, 4 2 240 106
  check "A&ctiver", 11, 12 20 108 18
  text "Au bout de :", 12, 32 42 64 16
  edit "3", 13, 100 38 38 22, limit 3
  text "récidives", 14, 148 42 44 16
  text "Intervalle :", 15, 32 64 64 16
  edit "30", 16, 100 60 38 22, limit 3
  text "secondes", 17, 148 64 44 16
  text "% de majs :", 18, 32 86 64 16
  edit "80", 19, 100 82 38 22, limit 3
  text "% du message", 20, 148 86 84 16

  box "", 21, -1 -1 0 0, hide
  list 22, -1 -1 0 0, hide
  button "", 23, -1 -1 0 0, hide
  button "", 24, -1 -1 0 0, hide

  box "Actions à effectuer", 30, 4 110 240 160
  list 32, 12 128 142 132, size
  button "Aj. &niveau", 33, 158 126 76 24
  button "Aj. &actions", 34, 158 150 76 24, disable
  button "&Supprimer", 35, 158 180 76 24, disable
  list 100, 12 210 142 112, hide disable
}

; Dialog pour les codes
dialog cprot.codes {
  title "Edition d'une protection"
  size -1 -1 248 366
  option pixels
  icon images/masterIRC2.ico
  button "&Ok", 1, 80 338 80 24, ok
  button "&Annuler", 2, 164 338 80 24, cancel
  box "", 10, 4 2 240 86
  check "A&ctiver", 11, 12 20 108 18
  text "Au bout de :", 12, 32 42 64 16
  edit "3", 13, 100 38 38 22, limit 3
  text "récidives", 14, 148 42 44 16
  text "Intervalle :", 15, 32 64 64 16
  edit "30", 16, 100 60 38 22, limit 3
  text "secondes", 17, 148 64 44 16
  text "", 18, -1 -1 0 0, hide
  text "", 19, -1 -1 0 0, hide
  text "", 20, -1 -1 0 0, hide

  box "", 21, -1 -1 0 0, hide
  list 22, -1 -1 0 0, hide
  button "", 23, -1 -1 0 0, hide
  button "", 24, -1 -1 0 0, hide

  box "Codes interdits", 40, 4 94 240 96
  check "&Tous", 41, 12 112 40 18
  check "&Couleurs", 42, 70 112 64 18
  check "&Reverse", 43, 146 112 64 18
  check "&Gras", 44, 70 128 46 18
  check "&Italique", 45, 146 128 56 18
  check "&Souligné", 46, 70 144 70 18
  text "Maximum de codes autorisés", 47, 14 164 140 16
  edit "3", 48, 162 160 74 22, limit 3

  box "Actions à effectuer", 30, 4 196 240 136
  list 32, 12 212 142 112, size
  button "Aj. &niveau", 33, 158 210 76 24
  button "Aj. &actions", 34, 158 234 76 24, disable
  button "&Supprimer", 35, 158 264 76 24, disable
  list 100, 12 210 142 112, hide disable
}

; Dialog box pour les floods/personal protections
dialog cprot.ctcpflood,cprot.hopflood,cprot.noticeflood,cprot.répétitions,cprot.flood,pprot.ban,pprot.ctcpflood,pprot.dccflood,pprot.highlightflood,pprot.inviteflood,pprot.noticeflood,pprot.queryflood {
  title "Edition d'une protection"
  size -1 -1 248 266
  option pixels
  icon images/masterIRC2.ico
  button "&Ok", 1, 80 238 80 24, ok
  button "&Annuler", 2, 164 238 80 24, cancel
  box "", 10, 4 2 240 86
  check "A&ctiver", 11, 12 20 108 18
  text "Au bout de :", 12, 32 42 64 16
  edit "3", 13, 100 38 38 22, limit 3
  text "récidives", 14, 148 42 44 16
  text "Intervalle :", 15, 32 64 64 16
  edit "30", 16, 100 60 38 22, limit 3
  text "secondes", 17, 148 64 44 16
  text "", 18, -1 -1 0 0, hide
  text "", 19, -1 -1 0 0, hide
  text "", 20, -1 -1 0 0, hide

  box "", 21, -1 -1 0 0, hide
  list 22, -1 -1 0 0, hide
  button "", 23, -1 -1 0 0, hide
  button "", 24, -1 -1 0 0, hide

  box "Actions à effectuer", 30, 4 96 240 136
  list 32, 12 112 142 112, size
  button "Aj. &niveau", 33, 158 114 76 24
  button "Aj. &actions", 34, 158 138 76 24, disable
  button "&Supprimer", 35, 158 168 76 24, disable
  list 100, 12 210 142 112, hide disable
}

; Sous-dialog d'ajout d'actions
dialog addActions {
  title "Ajout d'actions"
  size -1 -1 401 272
  option pixels
  icon images/masterIRC2.ico
  button "&Ok", 1, 213 244 80 24, ok
  button "&Annuler", 2, 307 244 80 24, cancel
  text "", 3, -1 -1 0 0, result hide

  tab "Avertissements", 100, 4 6 392 236
  check "Emettre un &Bip", 101, 14 34 162 18, tab 100
  check "&Highlight mIRC", 102, 14 50 142 18, tab 100
  check "&Echo canal actif:", 103, 14 66 158 18, tab 100
  edit "<nick> a activé une protection de type <type> sur le canal <chan>!", 104, 30 84 356 22, disable tab 100 autohs limit 200
  check "&Infobulle (si activées), message:", 105, 14 108 214 18, tab 100
  edit "<nick> a activé une protection de type <type> sur le canal <chan>!", 106, 30 126 356 22, disable tab 100 autohs limit 200
  check "&Avertir user, message:", 107, 14 152 128 18, tab 100
  edit "Les <flood> sont interdits sur <chan>!", 108, 30 170 356 22, disable tab 100 autohs limit 200
  text "Envoyer comme", 109, 32 196 44 16, disable tab 100
  radio "&Notice", 110, 82 194 54 18, disable tab 100
  radio "&Query", 111, 82 212 104 18, disable tab 100

  tab "Punitions", 200
  check "&Bannir", 201, 14 34 68 18, tab 200
  check "&Debannir après", 202, 32 50 104 18, disable tab 200
  combo 203, 144 48 56 134, disable tab 200 size edit limit 3 drop
  text "minutes", 204, 212 52 42 16, disable tab 200
  text "Masque de ban:", 205, 50 76 118 16, disable tab 200
  combo 206, 144 72 242 170, disable tab 200 size drop
  check "De&op/dehalfop/devoice", 207, 14 98 146 18, tab 200
  check "&Kicker user, raison:", 208, 14 114 110 18, tab 200
  edit "Les <flood> sont interdits sur <chan>!", 209, 30 132 356 22, disable tab 200 autohs limit 200
  check "K&ill user (IRCop), raison:", 210, 14 158 168 18, tab 200
  edit "Respectez la netiquette!", 211, 30 176 356 22, disable tab 200 autohs limit 200
  check "S'auto-&débannir du canal", 212, 14 200 168 18, hide tab 200

  tab "Ignorer", 300
  check "&Ignorer", 301, 14 34 56 18, tab 300
  check "&Complètement", 302, 32 50 88 18, disable tab 300
  check "&Queries", 303, 32 66 60 18, disable tab 300
  check "&DCC", 304, 122 66 48 18, disable tab 300
  check "&Messages", 305, 32 82 64 18, disable tab 300
  check "I&nvites", 306, 122 82 54 18, disable tab 300
  check "&Notices", 307, 32 98 54 18, disable tab 300
  check "Co&des", 308, 122 98 54 18, disable tab 300
  check "C&TCPs", 309, 32 114 52 18, disable tab 300
  check "&Enlever après", 310, 32 130 88 18, disable tab 300
  combo 311, 144 128 56 134, disable tab 300 size edit limit 3 drop
  text "minutes", 312, 212 132 42 16, disable tab 300
  text "", 313, -1 -1 0 0, disable hide tab 300
  text "Masque d'ignore", 314, 50 156 86 16, disable tab 300
  combo 315, 144 152 242 170, disable tab 300 size drop

  tab "Autres", 400
  check "&Blacklister", 401, 14 34 86 18, tab 400
  check "&Commande perso:", 402, 14 50 110 18, tab 400
  edit "", 403, 30 68 356 22, disable tab 400 autohs limit 200
  check "&Mettre les modes:", 404, 14 94 124 18, tab 400
  edit "+", 405, 30 112 356 22, disable tab 400 autohs limit 50
  check "&Jouer son:", 406, 14 136 80 18, tab 400
  edit "", 407, 30 154 320 22, disable tab 400 autohs limit 400
  button "&...", 408, 352 154 34 22, disable tab 400
  check "&Fermer query", 409, 14 180 86 18, hide tab 400
  check "Bloquer &queries pour", 410, 14 197 118 18, hide tab 400
  edit "60", 411, 146 197 58 22, hide tab 400 limit 4 disabled center
  text "secondes", 412, 213 199 46 16, hide tab 400

  tab "Aide", 500
  text "Liste des identifieurs que vous pouvez utiliser dans vos messages:", 501, 14 36 262 26, tab 500
  list 502, 12 80 164 150, tab 500 sort size vsbar
  text "Description:", 503, 186 66 60 14, tab 500
  text "Pas de sélection", 504, 186 80 192 148, tab 500
  text "Identifieurs:", 505, 14 66 56 14, tab 500

}

;ces

; --------------------------------------------------
; ALIAS UTILISES DANS LES DIALOGS
; --------------------------------------------------
;sec aliases

; Affiche un texte d'explication sur le niveau de sévérité sélectionné
; $1: niveau de sévérité
alias -l showStrictness {
  if ($1 == 1) {
    did -ra $dname 23 Haute
    did -ra $dname 24 Tout message comportant un #canal ou une URL déclenchera la protection.
  }
  elseif ($1 == 2) {
    did -ra $dname 23 Moyenne
    did -ra $dname 24 La protection n'est déclenchée que lorsque les mots-clés "venez", "visitez"... accompagnent le #canal ou l'URL.
  }
  else {
    did -ra $dname 23 Basse
    did -ra $dname 24 La protection n'est déclenchée que lorsque les mots-clés "venez", "visitez"... accompagnent le #canal ou l'URL et lorsqu'il n'y a rien d'autre.
  }
}


; Charge les paramètres du dialog selon le fichier prot.ini
alias -l loadParams {
  did $iif($getProtParam(%prot.chan,%prot.prot,use) == 1,-c,-u) $dname 11
  set -e %prot.use $did(11).state

  if ($getProtParam(%prot.chan,%prot.prot,times)) { did -ra $dname 13 $v1 }
  if ($did(13) == 1) { did -ra $dname 14 récidive }
  set -e %prot.times $did(13)

  if ($getProtParam(%prot.chan,%prot.prot,interval)) { did -ra $dname 16 $v1 }
  if ($did(16) == 1) { did -ra $dname 17 seconde }
  set -e %prot.interval $did(16)

  decodeAction $getProtParam(%prot.chan,%prot.prot,action)
  set -e %prot.action $encodeAction

  if (Pub isin $dname) || (Spam isin $dname)  { 
    var %str = $iif($getProtParam(%prot.chan,%prot.prot,strictness),$v1,1)
    did -i $dname 22 1 params %str * * * * * * * 
    set -e %prot.strictness %str
    showStrictness %prot.strictness
  }
  elseif (Badwords isin $dname) {
    var %bws = $getProtParam(%prot.chan,%prot.prot,badwords)
    set -e %prot.badwords %bws
    didtok $dname 22 59 %prot.badwords
  }
  elseif (Majs isin $dname) {
    var %rate = $iif($getProtParam(%prot.chan,%prot.prot,rate),$v1,0.8)
    did -ra $dname 19 $calc(%rate * 100)
    set -e %prot.rate %rate
  }
  elseif (Codes isin $dname) {
    var %codes = $getProtParam(%prot.chan,%prot.prot,codes)
    set -e %prot.codes %codes
    if (%codes == krbiu) { did -c $dname 41 }
    else { 
      if (k isin %codes) { did -c $dname 42 } 
      if (r isin %codes) { did -c $dname 43 } 
      if (b isin %codes) { did -c $dname 44 } 
      if (i isin %codes) { did -c $dname 45 } 
      if (u isin %codes) { did -c $dname 46 } 
    }
    did -ra $dname 48 $iif($getProtParam(%prot.chan,%prot.prot,mincodes),$v1,3)
    set -e %prot.mincodes $did(48)
  }
}


; Active/désactive les items
alias -l enableDisableItems {
  did $iif($did(11).state == 1,-e,-b) $dname 12-20,21-24,30,32-35
  did -u $dname 32 
  did -b $dname 34-35

  if ($did(13) <= 1) { did -b $dname 15-17 }

  if (Badwords isin $dname) {
    did -b $dname 24
  }
  if (Codes isin $dname) { 
    did $iif($did(11).state == 1,-e,-b) $dname 40-48
    if ($did(41).state == 1) { did -b $dname 42-46 }
  }
}


; Lors du clic sur le bouton ok, enregistre les changements dans le fichier ini
alias -l writeChanges {
  setProtParam %prot.chan %prot.prot use %prot.use
  setProtParam %prot.chan %prot.prot times %prot.times
  setProtParam %prot.chan %prot.prot interval %prot.interval
  setProtParam %prot.chan %prot.prot action %prot.action
  setProtParam %prot.chan %prot.prot strictness %prot.strictness
  setProtParam %prot.chan %prot.prot badwords %prot.badwords
  setProtParam %prot.chan %prot.prot codes %prot.codes
  setProtParam %prot.chan %prot.prot mincodes %prot.mincodes
  setProtParam %prot.chan %prot.prot rate %prot.rate
}


; Decode une liste d'actions et les affiche dans la liste d'actions
; $1: liste d'actions codée
alias -l decodeAction {
  var %action = $1-
  did -r $dname 32,100
  did -a $dname 32 Actions
  did -a $dname 100 Actions
  var %i = 1

  while (%i <= $0) {
    did -a $dname 32 $chr(160) - $chr(160) %i $+ e fois
    did -a $dname 100 $chr(183) $+ %i
    var %a = 1
    var %act = $gettok($gettok(%action,%i,32),2-,58)
    var %z = $numtok(%act,43)
    while (%a <= %z) {
      var %subact = $gettok(%act,%a,43)
      did -a $dname 32 $chr(160) $chr(160) $chr(183) $chr(160) $getActionName(%subact)
      did -a $dname 100 %subact
      inc %a
    }
    inc %i
  }
}

; Opération inverse: convertit la liste d'actions en un code la représentant
alias -l encodeAction {
  var %i = 2, %n = $did(100).lines
  var %res
  while (%i <= %n) {
    var %line = $did(100,%i)
    if ($left(%line,1) == $chr(183)) {
      %res = $+(%res,$chr(32),$remove(%line,$chr(183)),:)
    }
    else {  
      %res = $+(%res,%line,+)
    }
    inc %i
  }
  return %res
}


; Ajoute un niveau d'actions à la liste d'actions
alias -l addLevel {
  var %action = $encodeAction 
  var %nact = $calc($numtok(%action,32) + 1)
  set -e %prot.subact
  var %newsubact = $$dialog(addActions,addActions,-4)

  %action = $+(%action,$chr(32),%nact,:,%newsubact)
  decodeAction %action
  set -e %prot.action $encodeAction

}

; Editer les actions pour le niveau sélectionné
alias -l editActions {
  var %action = $encodeAction, %sel = $did(32).sel
  if ($chr(183) $+ * iswm $did(100,%sel)) { 
    var %lvl = $remove($did(100,%sel),$chr(183)) 
  }
  else {
    var %lvlline = $didwm($dname,100,$chr(183) $+ *,%sel)
    if (%lvlline) { 
      var %lvl = $remove($did(100,%lvlline),$chr(183)) | %lvl = $calc(%lvl - 1) 
    }
    else { var %lvl = $numtok(%action,32) }
  }
  if (%lvl) { set -e %prot.subact $gettok($gettok(%action,%lvl,32),2-,58) }

  var %newsubact = $$dialog(addActions,addActions,-4)

  if (%newsubact == na) { %action = $remove(%action,%prot.subact) }
  elseif (%prot.subact) { %action = $replace(%action,%prot.subact,%newsubact) }
  else { %action = $replace(%action,%lvl $+ $chr(58),%lvl $+ $chr(58) $+ %newsubact) }

  decodeAction %action
  set -e %prot.action $encodeAction

}


; Supprime l'action/le niveau sélectionné
alias -l delAction {
  var %action = $encodeAction, %sel = $did(32).sel

  if ($chr(183) $+ * iswm $did(100,%sel)) { 
    if ($$yndialog(Êtes-vous sûr(e) de vouloir effacer le niveau sélectionné?)) {
      var %lvl = $remove($did(100,%sel),$chr(183))
      %action = $deltok(%action,%lvl,32)
      ; Decrement des niveaux
      var %i = %lvl, %n = $numtok(%action,32)
      while (%i <= %n) {
        %action = $replace(%action,$calc(%i + 1) $+ :,%i $+ :)
        inc %i
      }
      decodeAction %action
      set -e %prot.action $encodeAction
    }
  }
  else {
    if ($$yndialog(Êtes-vous sûr(e) de vouloir effacer l'action sélectionnée?)) {
      did -d $dname 32,100 %sel
      set -e %prot.action $encodeAction
    }
  }
}

; Remplit les cases du dialog Addparams lors du clic sur "Modifier actions"
alias -l loadActionParams {
  var %numactions = $numtok(%prot.subact,43)
  var %i = 1
  while (%i <= %numactions) {
    var %action = $gettok(%prot.subact,%i,43)
    unparseAction %action
    inc %i
  }
}

; Coche les cases du dialog selon l'action
alias -l unparseAction {
  tokenize 45 $1-
  ;Blacklist
  if ($1 == bl) { did -c $dname 401 }
  ; Deop
  elseif ($1 == do) { did -c $dname 207 }
  ; Beep
  elseif ($1 == bp) { did -c $dname 101 }
  ; Flash
  elseif ($1 == fl) { did -c $dname 102 }
  ; Notif
  elseif ($1 == nt) {
    did -c $dname 103
    did -e $dname 104
    if ($2 != d) { did -ra $dname 104 $getProtParam(%prot.chan,%prot.prot $+ . $+ echo,$2) }
  }
  ; Infobulle
  elseif ($1 == ib) {
    did -c $dname 105
    did -e $dname 106
    if ($2 != d) { did -ra $dname 106 $getProtParam(%prot.chan,%prot.prot $+ . $+ info,$2) }
  }
  ; Avertir
  elseif ($1 == au) {
    did -c $dname 107
    did -e $dname 108-111
    if ($2 == 0) { did -u $dname 110 | did -c $dname 111 }
    else { did -c $dname 110 | did -u $dname 111 }
    if ($3 != d) { did -ra $dname 108 $getProtParam(%prot.chan,%prot.prot $+ . $+ warn,$3) }
  }
  ; Bannir
  elseif ($1 == b) {
    did -c $dname 201
    did -e $dname 202-206
    if ($2) {
      did -c $dname 202
      if ($didwm(203,$2)) { did -c $dname 203 $v1 }
      else { did -ac $dname 203 $2 }
    }
    did -c $dname 206 $calc($3 + 1)
  }
  ; Kicker
  elseif ($1 == k) {
    did -c $dname 208
    did -e $dname 209
    if ($2 != d) { did -ra $dname 209 $getProtParam(%prot.chan,%prot.prot $+ . $+ kick,$2) }
  }
  ; Kill
  elseif ($1 == kl) {
    did -c $dname 210
    did -e $dname 211
    if ($2 != d) { did -ra $dname 211 $getProtParam(%prot.chan,%prot.prot $+ . $+ kill,$2) }
  }
  ; Ignore
  elseif ($1 == i) {
    did -c $dname 301
    did -e $dname 302-309
    if ($2 == a) { did -c $dname 302 | did -b $dname 303-309 }
    else {
      if (q isin $2) { did -c $dname 303 }
      if (d isin $2) { did -c $dname 304 }
      if (m isin $2) { did -c $dname 305 }
      if (i isin $2) { did -c $dname 306 }
      if (n isin $2) { did -c $dname 307 }
      if (k isin $2) { did -c $dname 308 }
      if (c isin $2) { did -c $dname 309 }
    }
    if ($3) {
      did -c $dname 310
      did -e $dname 310-312
      if ($didwm(311,$3)) { did -c $dname 311 $v1 }
      else { did -ac $dname 311 $3 }
    }
    if ($4) { did -ec $dname 314,315 $calc($4 + 1) }
  }
  ; Commande perso
  elseif ($1 == ps) {
    did -c $dname 402
    did -e $dname 403
    if ($2 != d) { did -ra $dname 403 $getProtParam(%prot.chan,%prot.prot $+ . $+ perso,$2) }
  }
  ;Changer modes
  elseif ($1 == cm) {
    did -c $dname 404
    did -e $dname 405
    if ($2 != d) { did -ra $dname 405 $getProtParam(%prot.chan,%prot.prot $+ . $+ modes,$2) }
  }
  ; Jouer son
  elseif ($1 == s) {
    did -c $dname 406
    did -e $dname 407-408
    if ($2 != d) { did -ra $dname 407 $getProtParam(%prot.chan,%prot.prot $+ . $+ sound,$2) }
  }
  ;Auto deban
  elseif ($1 == ad) { did -c $dname 212 }
  elseif ($1 == fq) { did -c $dname 409 }
  elseif ($1 == bq) { 
    did -c $dname 410
    did -e $dname 411-412
    if ($2) { did -ra $dname 411 $2 }
  }
}


; Supprime les messages perso
alias -l removeMsgs {
  if ($regex(val,%prot.subact,/nt-([A-Z0-9]+)/)) { 
    setProtParam %prot.chan %prot.prot $+ . $+ echo $regml(val,1)
  }
  if ($regex(val,%prot.subact,/ib-([A-Z0-9]+)/)) { 
    setProtParam %prot.chan %prot.prot $+ . $+ info $regml(val,1)
  }
  if ($regex(val,%prot.subact,/au-[^-]+-([A-Z0-9]+)/)) { 
    setProtParam %prot.chan %prot.prot $+ . $+ warn $regml(val,1)
  }
  if ($regex(val,%prot.subact,/k-([A-Z0-9]+)/)) { 
    setProtParam %prot.chan %prot.prot $+ . $+ kick $regml(val,1)
  }
  if ($regex(val,%prot.subact,/kl-([A-Z0-9]+)/)) { 
    setProtParam %prot.chan %prot.prot $+ . $+ kill $regml(val,1)
  }
  if ($regex(val,%prot.subact,/ps-([A-Z0-9]+)/)) { 
    setProtParam %prot.chan %prot.prot $+ . $+ perso $regml(val,1)
  }
  if ($regex(val,%prot.subact,/cm-([A-Z0-9]+)/)) { 
    setProtParam %prot.chan %prot.prot $+ . $+ modes $regml(val,1)
  }
  if ($regex(val,%prot.subact,/s-([A-Z0-9]+)/)) { 
    setProtParam %prot.chan %prot.prot $+ . $+ sound $regml(val,1)
  }
}


;ces

; ------------------------------------------------
; GESTION DES EVENEMENTS DES DIALOGS
; ------------------------------------------------
;sec dialogevents

ON *:dialog:?prot.*:*:*:{
  if ($devent == init) {
    mdxload
    mdx SetFont $dname 10,21,30 13 700 Tahoma
    did -a $dname 10 Protection %prot.prot

    ; Track bar
    if (Pub isin $dname) || (Spam isin $dname) { 
      mdx SetControlMDX $dname 22 TrackBar vertical > $mdxfile(bars)
      mdx SetBorderStyle $dname 22
      mdx SetFont $dname 23 12 700 Tahoma
      did -i $dname 22 1 params 1 1 3 * * * * 20
      did -i $dname 22 1 ticfreq 1 
    }
    elseif (Codes isin $dname) {
      mdx SetFont $dname 40 13 700 Tahoma
    }

    loadParams
    enableDisableItems
  }
  elseif ($devent == sclick) {
    ; Checkbox Activer
    if ($did == 11) { 
      set -e %prot.use $did($did).state
      enableDisableItems
    }
    ; Strictness pour la protection Pub
    elseif ($did == 22) && ((Pub isin $dname) || (Spam isin $dname)) {
      var %select = $gettok($did($did,1),1,32)
      set -e %prot.strictness %select
      showStrictness %prot.strictness
    }
    ; Liste des badwords pour la protection Badwords
    elseif ($did == 22) && (Badwords isin $dname) {
      did $iif($did($did).sel,-e,-b) $dname 24
    }
    ; Ajout d'un badword
    elseif ($did == 23) && (Badwords isin $dname) {
      var %newbw = $$inputdialog(Entrez un nouveau badword)
      set -e %prot.badwords $addtok(%prot.badwords,%newbw,59)
      did -r $dname 22
      didtok $dname 22 59 %prot.badwords
      did -b $dname 24
    }
    ; Suppr d'un badword
    elseif ($did == 24) && (Badwords isin $dname) {
      if ($$yndialog(Supprimer le ou les badwords sélectionnés?)) {
        while ($did(22).sel) { 
          did -d $dname 22 $did(22).sel
        }
        set -e %prot.badwords $didtok($dname,22,59)
        did -b $dname 24
      }
    }
    elseif ($did == 41) { 
      did $iif($did($did).state == 1,-b,-e) $dname 42-46
      set -e %prot.codes $iif($did($did).state == 1,krbiu)
    }
    elseif ($did >= 42) && ($did <= 46) {
      set -e %prot.codes $+($iif($did(42).state,k),$iif($did(43).state,r),$iif($did(44).state,b),$iif($did(45).state,i),$iif($did(46).state,u))
    }
    ;clic sur la liste d'actions
    elseif ($did == 32) {
      if (* $+ $chr(160) -* iswm $did($did).seltext) { 
        did -ra $dname 34 Aj. &actions | did -e $dname 34,35 
      }
      elseif (* $+ $chr(183) * iswm $did($did).seltext) { 
        did -ra $dname 34 Mod. &action | did -e $dname 34,35
      }
      else { did -ra $dname 34 Aj. &actions | did -b $dname 34,35 }
    }
    ; Bouton ajouter niveau
    elseif ($did == 33) {
      addLevel
      did -b $dname 34-35
    }
    ; Bouton modifier actions
    elseif ($did == 34) {
      editActions
      did -b $dname 34-35
    }
    ; Bouton suppr action
    elseif ($did == 35) {
      delAction
      did -b $dname 34-35
    }
    ; Bouton ok
    elseif ($did == 1) {
      if ($did(13) !isnum) || ($did(16) !isnum) { $errdialog(Certains champs n'ont pas été remplis correctement!) | halt }
      writeChanges
      if ($dialog(settings)) { 
        if ($dialog(settings).tab == 800) {
          cprot.reflist %prot.chan
          did -c settings 830 %prot.line 
        }
        elseif ($dialog(settings).tab == 900) {
          pprot.reflist
          did -c settings 920 %prot.line
        }
      }
      dialog -c $dname
    }
    ; Bouton cancel
    elseif ($did == 2) {
      dialog -c $dname
    }
  }
  elseif ($devent == edit) {
    ; Récidives
    if ($did == 13) {
      if ($colorBadNumber($dname,$did)) { set -e %prot.times $did($did) } 
      if ($did($did) > 1) { did -ra $dname 14 récidives | did -e $dname 15-17 }
      else { did -ra $dname 14 récidive | did -b $dname 15-17 }
    }
    ; Intervalle
    elseif ($did == 16) {
      if ($colorBadNumber($dname,$did)) { set -e %prot.interval $did($did) } 
      if ($did($did) > 1) { did -ra $dname 17 secondes }
      else { did -ra $dname 17 seconde }
    }
    elseif (Majs isin $dname) && ($did == 19) {
      if ($colorBadNumber($dname,$did)) { set -e %prot.rate $calc($did($did) / 100) }
    }
    elseif (Codes isin $dname) && ($did == 48) {
      if ($colorBadNumber($dname,$did)) { set -e %prot.mincodes $did($did) }
    }
  }
  elseif ($devent == close) { 
    unset %prot.*
  }
}

on *:dialog:addActions:*:*:{
  if ($devent == init) {
    ; Temps de punition/ignore
    didtok $dname 203,311 44 1,2,5,10,30,60,120,300
    did -c $dname 203,311 3

    ; Masques ban/ignore
    var %i = 0
    while (%i < 10) {
      did -a $dname 206,315 $+([,%i,]) $mask(nick!ident@some.host.com,%i)
      inc %i
    }
    did -c $dname 206 $calc($ri(masks,banmask) + 1)
    did -c $dname 315 $calc($ri(masks,ignoremask) + 1)

    ; Identifieurs
    didtok $dname 502 44 <action>,<chan>,<type>,<flood>,<next>,<nick>,<level>,<interval>,<times>,<rate>,<badword>,<mincodes>,<url>

    did -c $dname 111

    ; Protections personnelles
    if (%prot.chan == pprot) { 
      did -v $dname 212,409-412 
      if (%prot.prot != ban) { did -h $dname 212 }
      else { did -h $dname 409-412 }
    }

    ; Remplit le dialog
    if (%prot.subact) { loadActionParams }
    did -ra $dname 3 %prot.subact
  }
  elseif ($devent == sclick) {
    if ($did == 103) { did $iif($did($did).state,-e,-b) $dname 104 }
    elseif ($did == 105) { did $iif($did($did).state,-e,-b) $dname 106 }
    elseif ($did == 107) { did $iif($did($did).state,-e,-b) $dname 108-111 }
    elseif ($did == 201) {
      did $iif($did($did).state,-e,-b) $dname 202-206
      if ($did($did).state) && ($did(202).state) { did -e $dname 203 }
      else { did -b $dname 203 }
    }
    elseif ($did == 202) { did $iif($did($did).state,-e,-b) $dname 203 }
    elseif ($did == 205) { did $iif($did($did).state,-e,-b) $dname 206 }
    elseif ($did == 208) { did $iif($did($did).state,-e,-b) $dname 209 }
    elseif ($did == 210) { did $iif($did($did).state,-e,-b) $dname 211 }
    elseif ($did == 301) {
      did $iif($did($did).state,-e,-b) $dname 302-315
      if (!$did(302).state) || (!$did($did).state) { did $iif($did($did).state,-e,-b) $dname 303-309 }
      if ($did($did).state) && ($did(310).state) { did -e $dname 311 }
      else { did -b $dname 311 }
    }
    elseif ($did == 302) { did $iif($did($did).state,-b,-e) $dname 303-309 }
    elseif ($did == 310) { did $iif($did($did).state,-e,-b) $dname 311 }
    elseif ($did == 314) { did $iif($did($did).state,-e,-b) $dname 315 }
    elseif ($did == 402) { did $iif($did($did).state,-e,-b) $dname 403 }
    elseif ($did == 404) { did $iif($did($did).state,-e,-b) $dname 405 }
    elseif ($did == 406) { did $iif($did($did).state,-e,-b) $dname 407,408 }
    elseif ($did == 408) { did -ra $dname 407 $$sfile(*.wav;*.mid;*.mp3;*.wma,Choisir un son à jouer) }
    elseif ($did == 410) { did $iif($did($did).state,-e,-b) $dname 411-412 }
    elseif ($did == 502) {
      var %s = $did($did).seltext
      if (%s == <action>) { did -ra $dname 504 La liste d'actions effectuées lorsque la protection se déclenche. }
      elseif (%s == <chan>) { did -ra $dname 504 Le canal où la protection a été déclenchée. }
      elseif (%s == <type>) { did -ra $dname 504 Le type de protection. }
      elseif (%s == <flood>) { did -ra $dname 504 Court descriptif de l'action ayant causé le déclenchement de la protection (ex: trop de majs). }
      elseif (%s == <next>) { did -ra $dname 504 La prochaine action déclenchée si l'utilisateur récidive. }
      elseif (%s == <nick>) { did -ra $dname 504 Le pseudo de l'utilisateur ayant déclenché la protection. }
      elseif (%s == <level>) { did -ra $dname 504 Numéro du niveau d'actions. }
      elseif (%s == <times>) { did -ra $dname 504 Nombre maximum de messages satisfaisant les conditions de la protection dans l'intervalle donné pour que la protection se déclenche. }
      elseif (%s == <interval>) { did -ra $dname 504 Intervalle maximum en secondes durant lequel le nombre de messages satisfaisant les conditions de la protection dépasse la limite spécifiée déclenche la protection. }
      elseif (%s == <rate>) { did -ra $dname 504 Dans le cas de la protection "Majs", le pourcentage de majuscules maximum pour que la protection se déclenche. }
      elseif (%s == <badword>) { did -ra $dname 504 Dans le cas de la protection "Badwords", le badword ayant déclenché la protection. }
      elseif (%s == <mincodes>) { did -ra $dname 504 Dans le cas de la protection "Codes", le maximum de codes contenus dans un message pour que la protection se déclenche. }
      elseif (%s == <url>) { did -ra $dname 504 Dans le cas de la protection "Pub", la publicité déclenchant la protection. }
    }
    ; Bouton ok
    elseif ($did == 1) {
      var %r
      removeMsgs
      if ($did(101).state) { %r = %r bp }
      if ($did(102).state) { %r = %r fl }
      if ($did(103).state) {
        if ($did(104)) {
          var %val = $trnum
          %r = %r nt- $+ %val
          setProtParam %prot.chan %prot.prot $+ . $+ echo %val $v1
        }
        else { %r = %r nt-d }
      }
      if ($did(105).state) {
        if ($did(106)) {
          var %val = $trnum
          %r = %r ib- $+ %val
          setProtParam %prot.chan %prot.prot $+ . $+ info %val $v1
        }
        else { %r = %r ib-d }
      }
      if ($did(107).state) {
        if ($did(108)) {
          var %val = $trnum
          %r = %r au- $+ $did(110).state $+ - $+ %val
          setProtParam %prot.chan %prot.prot $+ . $+ warn %val $v1
        }
        else { %r = %r au- $+ $did(110).state $+ -d }
      }
      if ($did(201).state) { 
        var %deban = $iif($did(203) isnum,$abs($v1),0)
        if ($did(202).state == 0) { %deban = 0 }
        var %mban = $calc($did(206).sel - 1)

        %r = %r b- $+ %deban $+ - $+ %mban
      }
      if ($did(207).state) { %r = %r do }
      if ($did(208).state) {
        if ($did(209)) {
          var %val = $trnum
          %r = %r k- $+ %val
          setProtParam %prot.chan %prot.prot $+ . $+ kick %val $v1
        }
        else { %r = %r k-d }
      }
      if ($did(210).state) {
        if ($did(211)) {
          var %val = $trnum
          %r = %r kl- $+ %val
          setProtParam %prot.chan %prot.prot $+ . $+ kill %val $v1
        }
        else { %r = %r kl-d }
      }
      if ($did(212).visible) && ($did(212).state) {
        %r = %r ad
      }
      if ($did(301).state) {
        var %ign
        if ($did(302).state) { %ign = a }
        else {
          if ($did(303).state) { %ign = %ign $+ q }
          if ($did(304).state) { %ign = %ign $+ d }
          if ($did(305).state) { %ign = %ign $+ m }
          if ($did(306).state) { %ign = %ign $+ i }
          if ($did(307).state) { %ign = %ign $+ n }
          if ($did(308).state) { %ign = %ign $+ k }
          if ($did(309).state) { %ign = %ign $+ c }
          if (!%ign) { %ign = a }
        }
        var %unignore = $iif($did(311) isnum,$abs($v1),0)
        if ($did(310).state == 0) { %unignore = 0 }
        var %mign = $calc($did(315).sel - 1)

        %r = %r $+(i-,%ign,-,%unignore,-,%mign)
      }
      if ($did(401).state) { %r = %r bl }
      if ($did(402).state) {
        if ($did(403)) {
          var %val = $trnum
          %r = %r ps- $+ %val
          setProtParam %prot.chan %prot.prot $+ . $+ perso %val $v1
        }
        else { %r = %r ps-d }
      }
      if ($did(404).state) {
        if ($did(405)) {
          var %val = $trnum
          %r = %r cm- $+ %val
          setProtParam %prot.chan %prot.prot $+ . $+ modes %val $v1
        }
        else { %r = %r cm-d }
      }
      if ($did(406).state) {
        if ($did(407)) {
          var %val = $trnum
          %r = %r s- $+ %val
          setProtParam %prot.chan %prot.prot $+ . $+ sound %val $v1
        }
        else { %r = %r s-d }
      }
      if ($did(409).visible) && ($did(409).state) { %r = %r fq }
      if ($did(410).visible) && ($did(410).state) {
        var %unign = $iif($did(411) isnum,$abs($v1),0)

        %r = %r bq- $+ %unign
      }
      if (!%r) { %r = na }
      did -ra $dname 3 $replace(%r,$chr(32),$chr(43))
    }
  }
}
;ces

; ------------------------------------------------
; PROTECTIONS DES CANAUX/PERSONNELLES: Alias
; ------------------------------------------------
;sec aliasevents


; Verifie si un user est exclu des protections
alias isExcluded {
  if ($hfind(excl,$1,0,W)) { return 1 } 

  ; Verifie si user de la protectlist
  var %plist = $rci(excludes,others)
  if ((%plist) && ($1 isprotect)) { return 1 }
  elseif ((%plist) && ($chan) && ($1 isprotect $chan)) { return 1 }
  return 0
}


; Récupère les messages persos des actions (kick, info...) en remplaçant les identifieurs spéciaux
; $1: message
alias -l getActionMsg { 
  var %message = $1-
  var %replacements = %prot.reps
  if (!%replacements) { return %message }
  return $replacex(%message, [ %replacements ] ) 
}

; Ajoute le pseudo a la blacklist
; $1: pseudo; $2- (commentaire (facultatif))
; FIXME: Ajouter ca a la réelle blacklist
alias -l addBlacklist {
  if ($1 !iswm $address($me,5)) {
    hadd blist $+(*,.,$1l) 1
  }
}

; Affiche une description de la protection déclenchée
; $1: protection
alias -l getDescFlood { 
  if ($1 == pub) { return Publicité interdite }
  elseif ($1 == spam) { return Publicité en privé interdite }
  elseif ($1 == badwords) { return Emploi d'un mot interdit }
  elseif ($1 == majs) { return Trop de majuscules }
  elseif ($1 == codes) { return Trop de codes de style }
  elseif ($1 == ctcpflood) { return Flood de CTCP }
  elseif ($1 == dccflood) { return Flood de DCC Requests }
  elseif ($1 == hopflood) { return Flood de join/part }
  elseif ($1 == noticeflood) { return Flood de notices }
  elseif ($1 == queryflood) { return Flood de query }
  elseif ($1 == répétitions) { return Répétitions de messages }
  elseif ($1 == flood) { return Flood de messages inutiles }
  elseif ($1 == ban) { return Ban intempestif }
  elseif ($1 == highlightflood) { return Flood de Highlights }
  elseif ($1 == inviteflood) { return Flood d'invites }
}


; Verifie si la protection doit s'activer
; $1: nick déclencheant la protection; $2: canal
alias -l cprot.triggerProt {
  ; Verifie d'abord si on a les droits necessaires pour controler le chan
  if (!$canControl($2)) { return $false }
  ; Verifie ensuite que le pseudo n'est pas dans les exclusions
  if ($isExcluded($address($1,5))) { return $false }

  ; Verifie si l'on utilise les protections par défaut pour ce canal
  if ($rci(cprot,allpreset) == 1) || ($rci(cprot. $+ $2,usepreset) == 1) { var %preset = 1 }

  if ($2 isin $rci(cprot,channels)) { var %cprot = cprot. $+ $2 }
  else { var %cprot = cprot }

  ; Verifie si l'on punit les ops/voices
  if (($1 isop $2) || ($1 ishop $2)) { 
    if (%preset) || ($rci(%cprot,punishops) == 1) { return $true } 
  }
  elseif ($1 isvoice $2) { 
    if (%preset) || ($rci(%cprot,punishops) == 1) { return $true } 
  }
  else { return $true }
}

; Meme chose mais pour les personal protections
alias -l pprot.triggerProt {
  ; Verifie d'abord que ce n'est pas moi même
  if ($1 == $me) { return $false }
  ; Verifie ensuite que le pseudo n'est pas dans les exclusions
  if ($isExcluded($fulladdress)) { return $false }
  return $true
}

; Sauve dans une table de hachage la protection déclenchée, le canal et l'user la déclenchant.
; $1: protection
alias -l cprot.register {
  var %chan = $iif($chan isin $rci(cprot,channels),$chan,default)
  var %use = $getProtParam(%chan,$1,use)
  var %times = $getProtParam(%chan,$1,times)
  var %interval = $getProtParam(%chan,$1,interval)
  var %item = $+($1,.,$chan,.,,$fulladdress,.,t-)

  if (!%use) { return }
  ; Cas des répétitions
  if ($1 == répétitions) { %item = %item $+ $2 }

  hadd -mu $+ %interval cprot %item $+ $trnum 1
  if ($hfind(cprot,%item $+ *,0,w) >= %times) { cprot.doTrigger $1- }
}

; Même chose mais pour les personal protections
alias -l pprot.register {
  var %chan = pprot
  var %use = $getProtParam(%chan,$1,use)
  var %times = $getProtParam(%chan,$1,times)
  var %interval = $getProtParam(%chan,$1,interval)
  var %item = $+($1,.,pprot,.,,$fulladdress,.,t-)

  if (!%use) { return }

  hadd -mu $+ %interval pprot %item $+ $trnum 1
  if ($hfind(pprot,%item $+ *,0,w) >= %times) { pprot.doTrigger $1- }
}


; Verifie un texte d'un canal si il y'a pub/flood/majs/etc...
; $1-: texte
alias -l cprot.checkText {
  var %chan = $iif($chan isin $rci(cprot,channels),$chan,default)

  ; Test pub
  var %strictness = $getProtParam(%chan,pub,strictness)

  var %text = $strip($1-)
  if ($regex(pub,%text,/(#[^\s]+|http://[^\s]+\.[^\s]+|www\.[^\s]+\.[^\s]+)/)) {
    var %url = $regml(pub,1)
    var %bws = /(join|visit|visitez|visite|allez|va|venez|viens|go|votez|brauch|besuch|komm|verlos|plz|please|svp|come|rejoignez|vienes|veneis|vienen|visita|visitas|visitais|vota|votas|votais|cam|live|porn|pron|sex)/i

    ; Protection haute
    if (%strictness == 1) { cprot.register pub %url }
    ; Protection moyenne
    elseif ($regex(pub2,%text, [ %bws ] )) {
      if (%strictness == 2) { cprot.register pub %url }
      ; Protection basse
      else {
        var %bw = $regml(pub2,1)
        if ($regex($1-,/^ $+ %bw $+ .* $+ %url $+ $ $+ /i)) { cprot.register pub %url }
      }
    }
  }

  ; Test badwords
  var %badwords = $getProtParam(%chan,badwords,badwords)

  if (%badwords) {
    ; Construction de la regex des bws
    var %regex = /(, %i = 1
    while (%i < $numtok(%badwords,59)) {
      %regex = %regex $+ $gettok(%badwords,%i,59) $+ [s]? $+ $chr(124)
      inc %i
    }

    if ($gettok(%badwords,%i,59)) { %regex = %regex $+ $v1 $+ [s]? }
    %regex = %regex $+ )/i

    if ($regex(bw,%text,%regex)) { cprot.register badwords $regml(bw,1) }
  }

  ; Test Majs
  var %rate = $getProtParam(%chan,majs,rate)

  if (%rate > 0) && ($len(%text) > 3) {

    if ($calc($regex(%text,/[A-ZÀ-Ý]/g) / $len(%text)) >= %rate) { cprot.register majs }
  }

  ; Test codes
  var %mincodes = $getProtParam(%chan,codes,mincodes)
  var %codes = $getProtParam(%chan,codes,codes)

  if (%mincodes > 0) {
    var %codes = / $+ $chr(91) $+ $replace(%codes,k,$chr(3),r,$chr(22),b,$chr(2),i,$chr(29),u,$chr(31)) $+ $chr(93) $+ /g
    if ($regex($1-,[ %codes ]) >= %mincodes) { cprot.register codes }
  }

  ; Répétitions
  cprot.register répétitions $sha1(%text)

  ; Flood basique
  cprot.register flood
}

; Verifie le messages envoyés en privé pour flood/spam/etc...
; $1: message
alias -l pprot.checkMP {
  ; QueryFlood
  pprot.register queryflood

  ; Spam
  var %strictness = $getProtParam(pprot,spam,strictness)

  var %text = $strip($1-)
  if ($regex(pub,%text,/(#[^\s]+|http://[^\s]+\.[^\s]+|www\.[^\s]+\.[^\s]+)/)) {
    var %url = $regml(pub,1)
    var %bws = /(join|visit|visitez|visite|allez|va|venez|viens|go|votez|brauch|besuch|komm|verlos|plz|please|svp|come|rejoignez|vienes|veneis|vienen|visita|visitas|visitais|vota|votas|votais|cam|live|porn|pron|sex)/i

    ; Protection haute
    if (%strictness == 1) { pprot.register spam %url }
    ; Protection moyenne
    elseif ($regex(pub2,%text, [ %bws ] )) {
      if (%strictness == 2) { pprot.register spam %url }
      ; Protection basse
      else {
        var %bw = $regml(pub2,1)
        if ($regex($1-,/^ $+ %bw $+ .* $+ %url $+ $ $+ /i)) { pprot.register spam %url }
      }
    }
  }
}

; Déclenche les actions de la protection
; $1: protection, $2: badword/url (optionnel) $chan: canal, $fulladdress: user@host déclencheant la protection
alias -l cprot.doTrigger {
  var %chan = $iif($chan isin $rci(cprot,channels),$chan,default)
  var %times = $getProtParam(%chan,$1,times)
  var %interval = $getProtParam(%chan,$1,interval)
  var %rate = $getProtParam(%chan,$1,rate)
  var %codes = $getProtParam(%chan,$1,codes)
  var %mincodes = $getProtParam(%chan,$1,mincodes)
  var %badwords = $getProtParam(%chan,$1,badwords)

  var %action = $getProtParam(%chan,$1,action)
  var %item = $+($1,.,$chan,.,$fulladdress,.t-)

  ; cas des répétitions
  if ($1 == répétitions) { %item = %item $+ $2 }
  ; Tout d'abord reset le compteur dans la table
  if ($hget(cprot)) { hdel -w cprot %item $+ * }

  ; Incremente le compteur de niveaux de protection
  var %lvl = $+($1,.,$chan,.,$fulladdress,.lvl)
  hinc -mu3600 cprot %lvl
  var %curlvl = $hget(cprot,%lvl)
  ; Si on a atteint le niveau maximum, reset le compteur de levels
  if (%curlvl >= $numtok(%action,32)) { hdel cprot %lvl }  

  var %subact = $gettok($gettok(%action,%curlvl,32),2-,58)

  ; Sera utilisé pour le remplacement des identifieurs
  set -e %prot.reps <chan>, $+ $chan $+ ,<type>, $+ $1 $+ ,<flood>, $+ $getDescFlood($1) $+ ,<nick>, $+ $nick $+ ,<times>, %times $+ ,<interval>, %interval $+ ,<level>, $+ %curlvl $+ ,<action>, $+ $parseAction(1: $+ %subact) $+ ,<next>, $+ $iif($gettok(%action,$calc(%curlvl +1),32),$parseaction($v1),Aucune) $+ ,<rate>, $+ $calc(%rate * 100) $+ ,<mincodes>, $+ %mincodes $+ ,<badword>, $+ $2 $+ ,<url>, $+ $qt($2)

  ; Effectue l'action spécifiée
  var %i = 1
  while ($gettok(%subact,%i,43)) {
    var %tok = $v1
    if (%tok == bp) { beep }
    elseif (%tok == fl) { flash }
    elseif (%tok == do) { mode $chan -ovh $nick $nick $nick }
    elseif (%tok == bl) { addBlackList $iif($address($nick,$ri(masks,banmask)),$v1,$nick $+ !*@*) $getDescFlood($1) }
    elseif ($regex(cpt,%tok,/^k-([0-9A-Z]+|d)$/)) { 
      var %kmess = $regml(cpt,1)
      if (!%kmess) || (%kmess == d) { %kmess = $getDescFlood($1) }
      else { 
        %kmess = $getActionMsg($getProtParam(%chan,$1 $+ . $+ kick,%kmess))
        if (!%kmess) { %kmess = $getDescFlood($1) }
      }

      kick $chan $nick %kmess
    }
    elseif ($regex(cpt,%tok,/^kl-([0-9A-Z]+|d)$/)) { 
      var %kmess = $regml(cpt,1)
      if (!%kmess) || (%kmess == d) { %kmess = $getDescFlood($1) }
      else { 
        %kmess = $getActionMsg($getProtParam(%chan,$1 $+ . $+ kill,%kmess)) 
        if (!%kmess) { %kmess = $getDescFlood($1) }
      }

      kill $nick %kmess
    }
    elseif ($regex(cpt,%tok,/^nt-([0-9A-Z]+|d)$/)) {
      var %echomsg = $regml(cpt,1)
      if (!%echomsg) || (%echomsg == d) { %echomsg = $nick a déclenché une protection sur $chan : $getDescFlood($1) }
      else { 
        %echomsg = $getActionMsg($getProtParam(%chan,$1 $+ . $+ echo,%echomsg)) 
        if (!%echomsg) { %echomsg = $nick a déclenché une protection sur $chan : $getDescFlood($1) }
      }

      theme.echo %echomsg
    }
    elseif ($regex(cpt,%tok,/^ib-([0-9A-Z]+|d)$/)) {
      var %echomsg = $regml(cpt,1)
      if (!%echomsg) || (%echomsg == d) { %echomsg = $nick a déclenché une protection sur $chan : $getDescFlood($1) }
      else { 
        %echomsg = $getActionMsg($getProtParam(%chan,$1 $+ . $+ info,%echomsg)) 
        if (!%echomsg) { %echomsg = $nick a déclenché une protection sur $chan : $getDescFlood($1) }
      }

      noop $pftip(protection,%echomsg)
    }
    elseif ($regex(cpt,%tok,/^au-(1|0)-([0-9A-Z]+|d)$/)) {
      var %notice = $regml(cpt,1)
      var %mess = $regml(cpt,2)
      if (!%mess) || (%mess == d) { %mess = $getDescFlood($1) }
      else { 
        %mess = $getActionMsg($getProtParam(%chan,$1 $+ . $+ warn,%mess)) 
        if (!%mess) { %mess = $getDescFlood($1) }
      }

      if (%notice) { .notice $nick %mess }
      else { .query $nick %mess }
    }
    elseif ($regex(cpt,%tok,/^b-(\d+)-([0-9])$/)) { 
      var %deban = $calc($regml(cpt,1) * 60)
      var %mask = $regml(cpt,2)

      ban $iif(%deban,-u $+ %deban) $chan $address($nick,%mask) %mask

    }
    elseif ($regex(cpt,%tok,/^i-([qdminkc]+|a)-(\d+)-([0-9])$/)) { 
      var %ign = $regml(cpt,1)
      if (!%ign) || (%ign == a) { %ign = qdminkc }
      %ign = $replacex(%ign,q,p,c,t,m,c)

      var %deban = $calc($regml(cpt,2) * 60)
      var %mask = $regml(cpt,3)

      ignore - $+ %ign $+ $iif(%deban,u $+ %deban) $nick %mask
    }
    elseif ($regex(cpt,%tok,/^ps-([0-9A-Z]+|d)$/)) {
      var %echomsg = $regml(cpt,1)
      if (!%echomsg) || (%echomsg == d) { %echomsg = theme.echo $nick a déclenché une protection sur $chan : $getDescFlood($1) }
      else { 
        %echomsg = $getActionMsg($getProtParam(%chan,$1 $+ . $+ perso,%echomsg)) 
        if (!%echomsg) { %echomsg = theme.echo $nick a déclenché une protection sur $chan : $getDescFlood($1) }
      }

      %echomsg
    }
    elseif ($regex(cpt,%tok,/^cm-([0-9A-Z]+|d)$/)) {
      var %echomsg = $regml(cpt,1)
      if (!%echomsg) || (%echomsg == d) { %echomsg = + }
      else { 
        %echomsg = $getActionMsg($getProtParam(%chan,$1 $+ . $+ modes,%echomsg)) 
        if (!%echomsg) { %echomsg = + }
      }

      if (%echomsg != +) && ($left(%echomsg,1) isin +-) { 
        mode $chan %echomsg
      }
    }
    elseif ($regex(cpt,%tok,/^s-([0-9A-Z]+|d)$/)) {
      var %echomsg = $regml(cpt,1)
      if (!%echomsg) || (%echomsg == d) { %echomsg = beep }
      else { 
        %echomsg = $getActionMsg($getProtParam(%chan,$1 $+ . $+ sound,%echomsg)) 
        if (!%echomsg) { %echomsg = beep }
      }

      if (%echomsg != beep) { splay %echomsg }
      else { beep }
    }
    inc %i
  }
  unset %prot.reps
}

; Même chose mais pour les personal protections
; $1: protection, $2: badword/url (optionnel)
alias -l pprot.doTrigger {
  var %chan = pprot
  var %times = $getProtParam(%chan,$1,times)
  var %interval = $getProtParam(%chan,$1,interval)

  var %action = $getProtParam(%chan,$1,action)
  var %item = $+($1,.,pprot,.,$fulladdress,.t-)

  ; Tout d'abord reset le compteur dans la table
  if ($hget(pprot)) { hdel -w pprot %item $+ * }

  ; Incremente le compteur de niveaux de protection
  var %lvl = $+($1,.,pprot,.,$fulladdress,.lvl)
  hinc -mu3600 pprot %lvl
  var %curlvl = $hget(pprot,%lvl)
  ; Si on a atteint le niveau maximum, reset le compteur de levels
  if (%curlvl >= $numtok(%action,32)) { hdel pprot %lvl }  

  var %subact = $gettok($gettok(%action,%curlvl,32),2-,58)

  ; Sera utilisé pour le remplacement des identifieurs
  set -e %prot.reps <chan>, $+ $chan $+ ,<type>, $+ $1 $+ ,<flood>, $+ $getDescFlood($1) $+ ,<nick>, $+ $nick $+ ,<times>, %times $+ ,<interval>, %interval $+ ,<level>, $+ %curlvl $+ ,<action>, $+ $parseAction(1: $+ %subact) $+ ,<next>, $+ $iif($gettok(%action,$calc(%curlvl +1),32),$parseaction($v1),Aucune) $+ ,<rate>, $+ $calc(%rate * 100) $+ ,<mincodes>, $+ %mincodes $+ ,<badword>, $+ $2 $+ ,<url>, $+ $qt($2)

  ; Effectue l'action spécifiée
  var %i = 1
  while ($gettok(%subact,%i,43)) {
    var %tok = $v1
    if (%tok == bp) { beep }
    elseif (%tok == fl) { flash }
    elseif (%tok == do) { execAllChans -c mode <chan> -ovh $nick $nick $nick }
    elseif (%tok == bl) { addBlackList $iif($address($nick,$ri(masks,banmask)),$v1,$nick $+ !*@*) $getDescFlood($1) }
    elseif ($regex(cpt,%tok,/^k-([0-9A-Z]+|d)$/)) { 
      var %kmess = $regml(cpt,1)
      if (!%kmess) || (%kmess == d) { %kmess = $getDescFlood($1) }
      else { 
        %kmess = $getActionMsg($getProtParam(%chan,$1 $+ . $+ kick,%kmess))
        if (!%kmess) { %kmess = $getDescFlood($1) }
      }

      execAllChans -c kick <chan> $nick %kmess
    }
    elseif ($regex(cpt,%tok,/^kl-([0-9A-Z]+|d)$/)) { 
      var %kmess = $regml(cpt,1)
      if (!%kmess) || (%kmess == d) { %kmess = $getDescFlood($1) }
      else { 
        %kmess = $getActionMsg($getProtParam(%chan,$1 $+ . $+ kill,%kmess)) 
        if (!%kmess) { %kmess = $getDescFlood($1) }
      }

      kill $nick %kmess
    }
    elseif ($regex(cpt,%tok,/^nt-([0-9A-Z]+|d)$/)) {
      var %echomsg = $regml(cpt,1)
      if (!%echomsg) || (%echomsg == d) { %echomsg = $nick a déclenché une protection sur $chan : $getDescFlood($1) }
      else { 
        %echomsg = $getActionMsg($getProtParam(%chan,$1 $+ . $+ echo,%echomsg)) 
        if (!%echomsg) { %echomsg = $nick a déclenché une protection sur $chan : $getDescFlood($1) }
      }

      theme.echo %echomsg
    }
    elseif ($regex(cpt,%tok,/^ib-([0-9A-Z]+|d)$/)) {
      var %echomsg = $regml(cpt,1)
      if (!%echomsg) || (%echomsg == d) { %echomsg = $nick a déclenché une protection sur $chan : $getDescFlood($1) }
      else { 
        %echomsg = $getActionMsg($getProtParam(%chan,$1 $+ . $+ info,%echomsg)) 
        if (!%echomsg) { %echomsg = $nick a déclenché une protection sur $chan : $getDescFlood($1) }
      }

      noop $pftip(protection,%echomsg)
    }
    elseif ($regex(cpt,%tok,/^au-(1|0)-([0-9A-Z]+|d)$/)) {
      var %notice = $regml(cpt,1)
      var %mess = $regml(cpt,2)
      if (!%mess) || (%mess == d) { %mess = $getDescFlood($1) }
      else { 
        %mess = $getActionMsg($getProtParam(%chan,$1 $+ . $+ warn,%mess)) 
        if (!%mess) { %mess = $getDescFlood($1) }
      }

      if (%notice) { .notice $nick %mess }
      else { .query $nick %mess }
    }
    elseif ($regex(cpt,%tok,/^b-(\d+)-([0-9])$/)) { 
      var %deban = $calc($regml(cpt,1) * 60)
      var %mask = $regml(cpt,2)

      execAllChans -c ban $iif(%deban,-u $+ %deban) <chan> $address($nick,%mask) %mask
    }
    elseif ($regex(cpt,%tok,/^i-([qdminkc]+|a)-(\d+)-([0-9])$/)) { 
      var %ign = $regml(cpt,1)
      if (!%ign) || (%ign == a) { %ign = qdminkc }
      %ign = $replacex(%ign,q,p,c,t,m,c)

      var %deban = $calc($regml(cpt,2) * 60)
      var %mask = $regml(cpt,3)

      ignore - $+ %ign $+ $iif(%deban,u $+ %deban) $nick %mask
    }
    elseif ($regex(cpt,%tok,/^ps-([0-9A-Z]+|d)$/)) {
      var %echomsg = $regml(cpt,1)
      if (!%echomsg) || (%echomsg == d) { %echomsg = theme.echo $nick a déclenché une protection personnelle : $getDescFlood($1) }
      else { 
        %echomsg = $getActionMsg($getProtParam(%chan,$1 $+ . $+ perso,%echomsg)) 
        if (!%echomsg) { %echomsg = theme.echo $nick a déclenché une protection personnelle : $getDescFlood($1) }
      }

      %echomsg
    }
    elseif ($regex(cpt,%tok,/^cm-([0-9A-Z]+|d)$/)) {
      var %echomsg = $regml(cpt,1)
      if (!%echomsg) || (%echomsg == d) { %echomsg = + }
      else { 
        %echomsg = $getActionMsg($getProtParam(%chan,$1 $+ . $+ modes,%echomsg)) 
        if (!%echomsg) { %echomsg = + }
      }

      if (%echomsg != +) && ($left(%echomsg,1) isin +-) { 
        execAllChans -c mode <chan> %echomsg
      }
    }
    elseif ($regex(cpt,%tok,/^s-([0-9A-Z]+|d)$/)) {
      var %echomsg = $regml(cpt,1)
      if (!%echomsg) || (%echomsg == d) { %echomsg = beep }
      else { 
        %echomsg = $getActionMsg($getProtParam(%chan,$1 $+ . $+ sound,%echomsg)) 
        if (!%echomsg) { %echomsg = beep }
      }

      if (%echomsg != beep) { splay %echomsg }
      else { beep }
    }
    elseif ($regex(cpt,%tok,/^bq-(\d+)$/)) {
      var %dur = $regml(cpt,1)
      if (!%dur) || (%dur !isnum 0-9999) { %dur = 30 }

      set -u [ $+ [ %dur ] ] %blockquery 1
    }
    elseif (%tok == fq) { close -m $nick }
    elseif (%tok == ad) && ($canControl($chan)) { mode $chan -b $me | cs unban $chan }
    inc %i
  }
  unset %prot.reps
}
;ces

;--------------------------------------------
; EVENEMENTS
;--------------------------------------------
;sec events

#features.prots on

; Blacklist/Whitelist
ON *:JOIN:#:{
  if ($canControl($chan)) {
    var %tosearch = $+($chan,.,$nick,!,$address)
    if ($hfind(wlist,%tosearch,1,W)) { mode $chan +e $nick }
    elseif ($hfind(blist,%tosearch,1,W)) { kb $nick Vous n'êtes pas autorisé à entrer sur ce canal (Blacklist)! }
  }
}

ON *:EXIT:{
  if ($hget(excl)) { 
    var %f $qt($iif($ri(paths,excludes),$v1,data/excludes.txt))
    if (!$isfile(%f)) { errdialog Le fichier %f n'existe pas! | halt }
    write -c %f
    hsave -i excl %f
  }
  if ($hget(blist)) { 
    var %f $qt($iif($ri(paths,blist),$v1,data/blist.txt))
    write -c %f
    hsave -i blist %f
  }
  if ($hget(wlist)) { 
    var %f $qt($iif($ri(paths,wlist),$v1,data/wlist.txt))
    write -c %f
    hsave -i wlist %f
  }
}

; Hopflood
ON *:PART:#:{
  if ($cprot.triggerProt($nick,$chan)) { cprot.register hopflood }
}

; Pub/Badword/Majs/Codes/Répétitions/Flood/HLFlood
ON *:TEXT:*:#:{
  if ($cprot.triggerProt($nick,$chan)) { cprot.checkText $1- }
  if ($highlight($1-)) && ($pprot.triggerProt($nick)) { pprot.register highlightflood }
}

ON *:BAN:#:{
  if ($canControl($chan)) && ($pprot.triggerProt($nick)) { pprot.register ban }
}

;QueryFlood
ON *:TEXT:*:?:{
  if ($pprot.triggerProt($nick)) { pprot.checkMP $1- }
}

; Block query
ON ^*:OPEN:?:{
  if (%blockquery) { haltdef }
}

; CTCPFlood
CTCP *:*:#:{
  if ($cprot.triggerProt($nick,$chan)) { cprot.register ctcpflood }
}

; CTCPFlood perso
CTCP ^*:*:?:{
  if ($1 == DCC) && ($pprot.triggerProt($nick)) { pprot.register dccflood }
  elseif ($pprot.triggerProt($nick)) { pprot.register ctcpflood }
}


; NoticeFlood
ON *:NOTICE:*:#:{
  if ($cprot.triggerProt($nick,$chan)) { cprot.register noticeflood }
}

;Noticeflood perso
ON *:NOTICE:*:?:{
  if ($pprot.triggerProt($nick)) { pprot.register noticeflood }
}

; InviteFlood
ON *:INVITE:#:{
  if ($pprot.triggerProt($nick)) { pprot.register inviteflood }
}

; DCC Flood
ON *:DCCSERVER:*:{
  if ($pprot.triggerProt($nick)) { pprot.register dccflood }
}
#features.prots end
;ces

; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
