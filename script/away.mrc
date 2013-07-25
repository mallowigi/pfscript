; -----------------------------
; Away Mode Script
; -----------------------------

#features on
ON *:START:{
  if ($hget(groups,away) == $null) { hadd -m groups away 1 }
  if ($hget(groups,away) == 1) { 
    splash_text 3 Chargement du script $nopath($script) ...
    .enable #features.away 
  }
  else { .disable #features.away }
}

ON *:LOAD:{
  if ($status == connected) { .timeraway.autoidle -i $iif($ri(awaymisc,autoawayuse) == 1,0 30 checkidle,off) }
}

ON *:UNLOAD:{
  if ($hget(groups,away)) { hadd groups away 0 }
  .timeraway.autoidle off
}
#features end

; Dialog d'information d'autoaway
dialog idleaway {
  title "Auto-away"
  size -1 -1 240 120
  option pixels
  icon images/masterIRC2.ico
  text "Attention:", 1, 6 6 46 16
  text "", 2, 54 6 180 54
  text "", 3, 54 64 126 16
  button "&Annuler", 5, 156 92 80 24, ok
  button "Activer &maintenant", 4, 50 92 100 24
  box "", 6, -2 78 244 8
}
on *:dialog:idleaway:*:*:{
  if ($devent == init) {
    did -a $dname 2 Vous avez choisi d'activer le mode auto-away après $ri(awaymisc,autoaway) minutes d'idle. Cliquez sur annuler si vous souhaitez annuler cette décision.
    did -a $dname 3 20 secondes restantes...
    .timeraway.idleaway -i 20 1 away.idlinc
  }
  elseif ($devent == sclick) {
    if ($did == 4) { away -i }
    elseif ($did == 5) { scon -at1 resetidle }
  }
  elseif ($devent == close) { .timeraway.idleaway off }
}

; Decremente le compteur de secondes, puis met away
alias away.idlinc {
  if (!$enabled(away)) { return }
  if ($dialog(idleaway)) {
    var %x = $calc($gettok($did(idleaway,3),1,32) -1)
    if (!%x) {
      dialog -x idleaway
      away -i
    }
    else { did -ra idleaway 3 %x seconds remaining... }
  }
  else { .timeraway.idleaway off }
}

; Verifie si le temps d'idle depasse le temps max
alias checkidle {
  if (!$enabled(away)) { return }
  if ($dialog(idleaway)) || ($away) { return }
  if ($ri(awaymisc,autoawayuse) == 0) { return }
  var %awaytime = $ri(awaymisc,autoaway)
  var %z = 1
  while ($scon(%z)) {
    scon %z
    if ($status == connected) {
      if ($idle < $calc(%awaytime * 60)) { return }
      else {
        if ($ri(awaymisc,notify) == 1) { opendialog -mo idleaway }
        else { away -i }
      }
    }
    inc %z
  }
  scon -r
}

; Activation du mode away. Si $1 = -i signifie autoaway, si $1 = -s ouvre les options, -u : serveur courant only
; $1- : [-n <Away Nick>] Message d'absence
alias away {
  if (!$enabled(away)) { !away $1- | return }
  if ($1- != $null) {
    if ($1 == -s) { setup -c Away Mode|Autres }
    var %i = $scid(0)
    var %awaytime = $ri(awaymisc,autoaway)

    while (%i) {
      if (-*u* iswm $1) {  }
      else { scid $scon(%i) }
      if ($status == connected) {
        if (-*n* iswm $1) { var %nick = $2, %aw = $3- }
        else { var %nick = $awayNick, %aw = $1- }

        if (-*i* iswm $1) { var %aw = $2- (auto-absent après $calc(%awaytime * 60) secondes d'idle) }

        var %backnick = $ri(awaymisc,backnick)
        if (%backnick == old) { %backnick = $me }
        else { %backnick = $defaultNick }

        wi awaymisc backnick. $+ $network %backnick

        !away %aw
        wi awaymisc wasaway. $+ $network %aw
        .timeraway.autoidle off
        if ($show) {
          %nick = $replace(%nick,<me>,$me,<back>,%backnick,<away>,$awayNick)
          if (-*i* iswm $1) || ($ri(awaymisc,nomessage) == 0) { away.showmessage %aw }
        }
        if (%nick) && (%nick !=== $me) { nick %nick }
      }
      dec %i
    }
  }
  else {
    aw_ Absent
  }
  .signal away
}

; Subalias pour récursion
alias -l aw_ { away $1- }

; Desactivation du mode away
alias back {
  if (!$enabled(away)) { !away }
  scon -at1 resetidle
  var %i = $scid(0)
  var %time = $awaytime
  var %aw = $awaymsg
  var %autoaway = $iif(auto-absent isin $awaymsg,-i,-)

  while (%i) {
    scid $scon(%i)
    if (!$server) { dec %i | continue }
    if (!$away) { theme.error Vous n'etes pas absent! | halt }

    if ($away) {
      !away
      wi awaymisc wasaway. $+ $network 
      .timeraway.autoidle -i 0 30 checkidle
      if ($show) {
        if (-*i* iswm %autoaway) || ($ri(awaymisc,nomessage) == 0) { away.showmessage %aw }
      }
      if ($ri(awaymisc,backnick. $+ $network)) { var %nick = $ifmatch }
      else { %nick = $defaultNick }
      if (%nick) && (%nick !=== $me) { nick %nick }
      wi awaymisc backnick. $+ $network
    }
    dec %i
  }

  .signal back
}

; Affiche le message d'away
; $1-: Message a afficher, ou message d'away si aucun message
alias away.showmessage {
  .timeraway.awmsg.*.* off
  var %exclude = $ri(awaymess,exclude)
  var %excludes = $ri(awaymess,channels)
  var %queryactive = $ri(awaymess,query)
  var %message = $iif($1-,$1-,$iif($away,$awaymsg))
  if ($ri(awaymess,use) == 1) {
    ; Si option "canal actif seulement" cochée
    if ($ri(awaymess,channel) == active) { 
      if ($active != Status Window) && (@* !iswm $active) {
        if (%exclude == 0) || !$istok(%excludes,$active,59) { describe $active est absent: %message } 
      }
    }
    else {
      ; Si excludes
      if (%exclude) && (%excludes) {
        var %chan = $chan(0),%query = $query(0),%f = 0
        while (%chan) {
          ; Si le canal n'est pas dans les exclusions
          if (!$istok(%excludes,$chan(%chan),59)) && ($me ison $chan(%chan)) {
            if ($chan(%chan)) {
              .timeraway.awmsg. $+ $ifmatch 1 %f describe $ifmatch est absent: %message
            }
            inc %f 1
          }
          dec %chan
        }
        if (%queryactive == 1) {
          while (%query) {
            if (!$istok(%excludes,$query(%query),59)) {
              if ($query(%query)) {
                .timeraway.awmsg. $+ $ifmatch 1 %f describe $ifmatch est absent: %message
              }
              inc %f 1
            }
            dec %query
          }
        }
      }
      else {
        if ($chan(0)) { ame est absent: %message }
        if (%queryactive) && ($query(0)) { qme $me est absent: %message }
      }
    }
  }
}

; Répondeur: envoie un message perso a un user tentant de vous contacter etant away
alias away.remind {
  ; Si repondeur activé et away actif
  if ($ri(awaymess,use) == 1) && ($away) { 
    ; Antiflood: eviter l'abus de demandes
    if (!%away.reminded. $+ $nick) && (!%away.antiflood) {
      set -u400 %away.reminded. $+ $nick 1
      set -u5 %away.antiflood 1
      notice $nick Absent depuis $duration($awaytime) $basecolor(1) $+ (Raison: $basecolor(2) $+ $awaymsg ) (Auto-réponse à un highlight/notice/chat)
    }
  }
}

menu @Awaylog {
  $style(2) $+([,$shorten(15,$active),]):return
  -
  Effacer tout:clear $active
  Fermer:close -@ $active
}

; Afficher les highlights recus etant absent
alias away.checklog {
  if ($away) && ($ri(awaylog,use) == 1) {
    var %show = 0
    ; Si propriete ok, affiche le message dans le log
    if ($prop == ok) { %show = 1 }

    if (%show != 0) {
      if (!$window(@Awaylog)) {
        window -nk0 @Awaylog
        theme.echo @Awaylog Ouverture du log "away"...
        theme.echo @Awaylog Message d'absence: $awaymsg
        echo @Awaylog 
      }
    }
    return %show
  }
}

#features.away on

raw 305:*:{
  var %t = $iif($awaytime,Temps d'absence sur le serveur $basecolor(4) $+ $network : $basecolor(2) $+ $duration($awaytime) $iif($awaymsg,$basecolor(1) $+ (Raison:  $+ $awaymsg $+ )))
  theme.away %t
  if ($window(@Awaylog)) { theme.away $ifmatch %t }
  haltdef
}
raw 306:*:{
  var %t = Serveur $basecolor(4) $+ $network : Raison d'absence:  $+ $basecolor(1) $+ $awaymsg $+ 
  theme.away %t
  if ($window(@Awaylog)) { theme.away $ifmatch %t }
  haltdef
}


ON *:CONNECT:{
  ; Activation de l'autoidle
  if ($ri(awaymisc,autoawayuse) == 1) { 
    .timeraway.autoidle -i 0 30 checkidle
  }
  ; Mise en away a la connexion
  if ($ri(awaymisc,awayconnect) == 1) && ($ri(awaymisc,wasaway. $+ $network)) {
    away -nu $me $ri(awaymisc,wasaway. $+ $network)
  }
}

ON *:DISCONNECT:{
  if ($ri(awaymisc,awayconnect) != 1) && ($ri(awaymisc,wasaway. $+ $network)) { 
    .nick $ri(awaymisc,backnick. $+ $network)
  }
  .timeraway.autoidle off
}

; Events pour l'awaylogging
ON *:TOPIC:#:{
  saveEvents $1-
}
ON *:KICK:#:{
  saveEvents $1-
}
ON *:BAN:#:{
  saveEvents $1-
}
ON *:JOIN:#:{
  saveEvents $1-
}
ON *:PART:#:{
  saveEvents $1-
}
ON *:NICK:{
  saveEvents $1-
}
ON *:MODE:#:{
  saveEvents $1-
}
ON *:INVITE:#:{
  saveEvents $1-
}
ON *:QUIT:{
  saveEvents $1-
}
ON *:NOTIFY:{
  saveEvents $1-
}
ON *:UNOTIFY:{
  saveEvents $1-
}
ON *:UNBAN:#:{
  saveEvents $1-
}
ON *:FILESENT:*:{
  saveEvents $1-
}
ON *:FILERCVD:*:{
  saveEvents $1-
}
ON *:GETFAIL:*:{
  saveEvents $1-
}
ON *:SENDFAIL:*:{
  saveEvents $1-
}

ON *:TEXT:*:#:{
  saveEvents $1-
}
ON *:TEXT:*:?:{
  away.remind
}
ON ^*:ACTION:*:#:{
  saveEvents $1-
  ; Ne pas afficher les messages des autres users
  if ($ri(awaymisc,noothers) == 1) && (absent isin $1-) { haltdef }
}
ON *:NOTICE:*:*:{
  saveEvents $1-
}
ON *:SNOTICE:*:{
  saveEvents $1-
}
ON *:WALLOPS:*:{
  saveEvents $1-
}
ON *:CTCP:*:*:{
  saveEvents $1-
}
ON *:ERROR:*:{
  saveEvents $1-
}
ON *:RAWMODE:*:{
  saveEvents $1-
}
#features.away end

; Verifie si un texte est highlighté (pour l'awaylog)
alias -l aw.ishl {
  var %ishl = $ishl($1-)
  var %hls = $ri(awaylog,triggers)
  if (!%hls) { return %ishl }
  if (%ishl == $true) { return %ishl }
  else { return $isinphrase($1-,%hls,59) }
}


; Inscrit les evenements dans le log "Awaylog". Contient les highlights perso, les highlights indiqués dans les options et les events si spécifiés dans les options. S'occupe aussi de la fonction répondeur)
; Nécessite que le logging soit activé (sauf pour répondeur)
alias -l saveEvents {
  var %isop = $comchan($me,1).op
  var %print = 0

  if ($away) && ($ri(awaylog,use) == 1) {
    ; Si op option, enregistre les kick/topic/ban/mode anyway
    if ($ri(awaylog,op) == 1) && (%isop) && ($event isin kick/topic/ban/mode) { %print = 1 }
    ; Si events option, enregistre en plus les events (join/part...)
    if ($ri(awaylog,events) == 1) && ($event isin join/part/nick/mode/invite/quit/kick/topic/ban/unban/rawmode) { %print = 2 }
    ; Sinon n'enregistre que les events de base
    if ($event isin notice/error/notify/unotify/snotice/wallops/filesent/filercvd/getfail/sendfail/ctcp) { %print = 3 }
    ; Enfin n'enregistre le texte que si il est un highlight
    if ($event isin text/action) && ($aw.ishl($1-)) { %print = 4 }

    if (%print == 4) || (%print == 3) || (%print == 2) || (%print == 1) {
      noop $away.checklog($1-).ok
      if ($theme.current) {
        theme.vars echo $color($event) -t @Awaylog
        set -u %::nick $nick
        set -nu %::cnick $cnick($nick).color
        set -u %::address $address
        set -u %::chan $chan
        set -u %::knick $knick
        set -nu %::newnick $newnick
        set -u %::kaddress $address($knick,5)
        set -nu %::modes $1-
        set -u %::text $1-
        set -u %:raw $1-
        if ($event isin text/action) { theme.text $event $+ chan $upper($event) %::text }
        elseif ($event isin op/deop/help/dehelp/voice/devoice/rawmode) { theme.text mode RAWMODE %::modes }
        elseif ($event == error) { theme.text servererror ERROR %::text }
        elseif ($event == snotice) { theme.text noticeserver SNOTICE %::text }
        elseif ($event == ctcp) { theme.text ctcpchan CTCP $1- }
        else { theme.text $event $upper($event) %::text }
      }
      else { 
        ;FIXME pour voir si tout marche...
        if ($event == kick) { echo -ti4c kick @Awaylog $nick a kické $knick ( $+ $address($knick,5) $+ ) de $chan (Raison: $1- $+ ) }
        elseif ($event == topic) { echo -ti4c topic @Awaylog $nick a changé le topic de $chan en $qt($1-) }
        elseif ($event == rawmode) || ($event == mode) { echo -ti4c mode @Awaylog $nick a mis les modes $1- sur $chan }
        elseif ($event == join) { echo -ti4c join @Awaylog $nick ( $+ $address $+ ) a rejoint le canal $chan } 
        elseif ($event == part) { echo -ti4c part @Awaylog $nick ( $+ $address $+ ) est sorti de $chan } 
        elseif ($event == nick) { echo -ti4c nick @Awaylog $nick a changé son pseudo en $newnick } 
        elseif ($event == invite) { echo -ti4c info @Awaylog $nick a invité $1- sur $chan } 
        elseif ($event == quit) { echo -ti4c quit @Awaylog $nick a quitté IRC (Raison: $1- $+ ) } 
        elseif ($event == notice) { echo -ti4c notice @Awaylog Notice: $nick --> $1- } 
        elseif ($event == error) { echo -ti4c info @Awaylog Erreur: $1- } 
        elseif ($event == notify) { echo -ti4c notify @Awaylog $nick vient de se connecter. }
        elseif ($event == unotify) { echo -ti4c notify @Awaylog $nick vient de se déconnecter. }
        elseif ($event == snotice) { echo -ti4c notice @Awaylog Server Notice: $1- } /
        elseif ($event == wallops) { echo -ti4c wallops @Awaylog Wallops: $1- } 
        elseif ($event == filesent) { echo -ti4c normal @Awaylog DCC File sent: $1- } 
        elseif ($event == filercvd) { echo -ti4c normal @Awaylog DCC File received: $1- } 
        elseif ($event == getfail) { echo -ti4c normal @Awaylog DCC File Get Fail: $1- } 
        elseif ($event == sendfail) { echo -ti4c normal @Awaylog DCC File Send Fail: $1- } 
        elseif ($event == ctcp) { echo -ti4c ctcp @Awaylog CTCP: $1- }
        elseif ($event == action) { echo -ti4c action @Awaylog *** $nick $1- *** }
        elseif ($event == text) { echo -ti4c normal @Awaylog ( $+ $nick $+ ) $1- }
      }
    }
  }

  ; Répondeureuh: Si highlight/notice/query/chat
  if ($me isin $1-) || ($event isin notice/chat/filesent/filercvd/getfail/sendfail) { away.remind }
}

;---------------------------------
; Fin du fichier
;---------------------------------
