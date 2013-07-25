; ---------------------------------
; Services IRC
; ---------------------------------

#features on
ON *:START:{
  if ($hget(groups,serv) == $null) { hadd -m groups serv 1 }
  if ($hget(groups,serv) == 1) { 
    splash_text 3 Chargement du script $nopath($script) ...
    .enable #features.serv
  }
  else { .disable #features.serv }
}


ON *:UNLOAD:{
  if ($hget(groups,serv)) { hadd groups serv 0 }
}
#features end

#features.serv on

; Vous identifie sur le réseau
; $1: pseudo, si absent, pseudo actuel
alias ident {
  var %serv = $network
  var %nick = $iif($1,$1,$me)

  if ($ri(services,nick. $+ %serv $+ . $+ %nick)) {
    var %ns = $v1
    tokenize 1 %ns
    var %ident = $iif($2 == 1,ns identify $decode($1),msg nickserv identify $decode($1))
    var %greet = $iif($4 == 1,ns set greet $5-)

    %ident | %greet
  }
}

; Ghost un pseudo selon les informations remplies dans les options
; $1: pseudo a ghoster
alias ghost {
  var %serv = $network
  var %nick = $1
  var %value = $ri(services,nick. $+ %serv $+ . $+ %nick)

  if (%value) {
    tokenize 1 %value
    if ($3 == 1) { 
      ns ghost %nick $decode($1) 
      set -u5 %gnick 1
      nick %nick
    }
  }
}

; Identifie le canal actif
; $1: canal a identifier, sinon canal actif
alias channelIdent {
  var %serv = $network
  var %chan = $iif($1,$1,$chan($active))
  if ($ri(services,chan. $+ %serv $+ . $+ %chan)) {
    var %cs = $v1
    tokenize 1 %cs
    var %ident = $iif($2 == 1,cs identify %chan $decode($1),msg chanserv identify %chan $decode($1))
    var %greet = $iif($4 == 1,cs set %chan entrymsg $5-)

    %ident | %greet
  }
}

; Se debannit du canal spécifié
; $1: canal auquel se débannir
alias chanunban {
  var %serv = $network
  var %chan = $1
  var %value = $ri(services,chan. $+ %serv $+ . $+ %chan)
  if (%value) {
    tokenize 1 %value
    if ($3 == 1) { 
      cs unban %chan
      set -u5 %dchan 1
      join %chan
    }
  }
}

;Auto-identification de nicks lors du changement de nick
; Si l'autoghostage est effectif, déconnecte automatiquement le ghost
ON ^&*:NICK:{
  if ($status != connected) { return }
  if ($nick == $me) { 
    ident $newnick
  }
}

;Auto-identification de canaux
ON ^&*:JOIN:*:{
  if ($status != connected) { return }
  if ($nick == $me) && ($me isop $chan) {
    channelIdent $chan
  }
}

; Lorsque je me connecte, autoidentification
; Pour eviter les boucles infinies de ghost, l'autoghostage ne fonctionnera pas à la connexion. Il faudra taper /nick <pseudo à ghoster> une fois connecté.
ON *:CONNECT:{
  ident
}

;Autoghost
RAW 433:*:{
  if ($status == connected) { 
    if (%gnick) { unset %gnick | halt }
    ghost $2
  }
}

; Autodeban
RAW 474:*:{
  if ($status == connected) {
    if (%dchan) { unset %dchan | halt } 
    chanunban $2
  }
}
#features.serv end

; Configurer bot protections
dialog serv.protections {
  title "Config. protections"
  icon "images/masterIRC2.ico"
  size -1 -1 301 199
  option pixels

  button "&Fermer", 1, 220 170 75 25, cancel
  box "Protections", 10, 4 2 292 166
  check "Kicker messages en gras", 11, 10 18 148 20, flat
  check "Kicker messages couleur", 12, 10 36 148 20, flat
  check "Kicker majuscules", 13, 10 54 148 20, flat
  check "Kicker flood", 14, 10 72 148 20, flat
  check "Kicker répétitions", 15, 10 90 148 20, flat
  check "Kicker couleurs inversées", 16, 10 108 148 20, flat
  check "Kicker messages soulignés", 17, 10 126 148 20, flat
  check "Kicker badwords", 18, 10 144 148 20, flat

  text "Kicks avant le ban", 21, 160 20 92 16
  edit "", 22, 258 17 24 21, right
  text "Kicks avant le ban", 23, 160 38 92 16
  edit "", 24, 258 35 24 21, right
  text "Kicks avant le ban", 25, 160 56 92 16
  edit "", 26, 258 53 24 21, right
  text "Kicks avant le ban", 27, 160 74 92 16
  edit "", 28, 258 71 24 21, right
  text "Kicks avant le ban", 29, 160 92 92 16
  edit "", 30, 258 89 24 21, right
  text "Kicks avant le ban", 31, 160 110 92 16
  edit "", 32, 258 107 24 21, right
  text "Kicks avant le ban", 33, 160 128 92 16
  edit "", 34, 258 125 24 21, right
  text "Kicks avant le ban", 35, 160 146 92 16
  edit "", 36, 258 143 24 21, right
}

ON *:DIALOG:serv.protections:*:*:{
  if ($devent == sclick) {
    if ($did == 11) { netcmd %serv.serv 1 bs kick %serv.chan bolds $iif($did($did).state,on,off) $iif($did(22),$v1,0) }
    elseif ($did == 12) { netcmd %serv.serv 1 bs kick %serv.chan colors $iif($did($did).state,on,off) $iif($did(24),$v1,0) }
    elseif ($did == 13) { netcmd %serv.serv 1 bs kick %serv.chan caps $iif($did($did).state,on,off) $iif($did(26),$v1,0) }
    elseif ($did == 14) { netcmd %serv.serv 1 bs kick %serv.chan flood $iif($did($did).state,on,off) $iif($did(28),$v1,0) }
    elseif ($did == 15) { netcmd %serv.serv 1 bs kick %serv.chan repeat $iif($did($did).state,on,off) $iif($did(30),$v1,0) }
    elseif ($did == 16) { netcmd %serv.serv 1 bs kick %serv.chan reverses $iif($did($did).state,on,off) $iif($did(32),$v1,0) }
    elseif ($did == 17) { netcmd %serv.serv 1 bs kick %serv.chan underlines $iif($did($did).state,on,off) $iif($did(34),$v1,0) }
    elseif ($did == 18) { netcmd %serv.serv 1 bs kick %serv.chan badwords $iif($did($did).state,on,off) $iif($did(36),$v1,0) }
  }
  elseif ($devent == close) {
    unset %serv.*
  }
}

; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
