; ------------------------------------
; Gestion de serveurs favoris
; ------------------------------------

#features on
ON *:START:{
  if ($hget(groups,servers) == $null) { hadd -m groups servers 1 }
  if ($hget(groups,servers) == 1) { 
    .enable #features.servers
    splash_text 3 Chargement du script $nopath($script) ...
    autoconnect
  }
  else { .disable #features.servers }  
}

ON *:UNLOAD:{
  if ($hget(groups,servers)) { hadd groups servers 0 }
}
#features end

;;; <Doc>
;; Retourne les informations de connexion d'un serveur favori
;; Si l'une des propriétés suivantes est fournie, retourne l'info demandée, sinon retourne toute la ligne
;; $1: serveur, $prop : realname, email, nick, anick, port, identd, aconnect, invisible, ssl, reconnect, perform
alias serverInfos {
  if (!$enabled(servers)) { return }
  var %server = $$1, %Servers = $ri(servers,favorites)
  if ($istok(%servers,%server,59)) {
    var %info = $ri(servers,servers. $+ %Server)
    if (%info) {
      tokenize 1 %info
      if ($prop == realname) { return $1 }
      elseif ($prop == email) { return $2 }
      elseif ($prop == nick) { return $3 }
      elseif ($prop == anick) { return $4 }
      elseif ($prop == port) { return $5 }
      elseif ($prop == identd) { return $6 }
      elseif ($prop == aconnect) { return $7 }
      elseif ($prop == invisible) { return $8 }
      elseif ($prop == ssl) { return $9 }
      elseif ($prop == reconnect) { return $10 }
      elseif ($prop == perform) { return $11 }
      else { return %info }
    }
  }
}

; Autoconnexion aux serveurs favoris
alias -l autoconnect {
  var %i = 1, %servers = $ri(servers,favorites), %n = 0
  while (%i <= $numtok(%Servers,59)) {
    var %tok = $gettok(%servers,%i,59)
    var %servinfo = $ri(servers,servers. $+ %tok)
    if (%servinfo) && ($gettok(%servinfo,7,1) == 1) { 
      if (%n == 0) { theme.echo Connexion automatique vers les serveurs favoris ... Tapez /astop pour annuler. }
      set -u5 %timer 1
      .timerconn $+ %i -d 1 5 theme.echo Connexion au serveur %tok ... 
      .timerconne $+ %i -d 1 5 server $iif(%n > 0,-m) %tok
      %n = 1
    }
    inc %i
  }
}

; Stoppe l'autojoin
alias astop {
  .signal -n autostop
}

ON *:SIGNAL:autostop:{
  if (%timer) { .timerconn* off }
}

;;; <Doc>
;; Réécriture de la commande server pour prendre en compte les infos de connexion
;; Si le serveur est dans les serveurs favoris, se connecte avec les infos entrées dans les options: nick, anick, etc...
;; /params $1- : parametres de la commande /server
alias favServer {
  if (!$enabled(servers)) { !server $1- | return }
  ; Parsing de la commande: 1e etape
  if (-* iswm $1) { var %options = $remove($1,-), %serv = $2, %rem = $3- }
  elseif ($0 > 0) { var %serv = $1, %rem = $2- }
  else { var %serv = $network }

  ; Deuxieme utilisation de la commande server: n'a rien a voir ici
  if (%options) && ($regex(%options,/^-[sar]+/)) { !server $1- | return }

  ; Parsing de la commande: 2e étape: -i
  if ($regex(rem,%rem,/-i ([^ -][^ ]*)( [^ -][^ ]*)?( [^ -][^ ]*)?( [^ -][^ ]*)?/)) { 
    var %nick = $regml(rem,1), %anick = $regml(rem,2), %email = $regml(rem,3), %rname = $regml(rem, 4)
  }
  ; Parsing de la commande: 3e etape: -j
  if ($regex(rem,%rem,/-jn? ([^ -][^ ]*)( [^ -][^ ]*)?/)) {
    var %chan = $regml(rem,1), %passchan = $regml(rem,2)
  }
  ; Parsing de la commande: port and passowrd
  var %param = $gettok(%rem,1,32)
  if (%param isnum) { 
    var %port = %param 
    if ($gettok(%rem,2,32) !isin -i/-j) { var %pass = $gettok(%rem,2,32) }
  }
  elseif ($gettok(%rem,1,32) !isin -i/-j) { var %pass = $gettok(%rem,1,32) }
  ; FIN DU PARSING

  ;Deuxieme partie: parsing serveurs favoris
  if ($istok($ri(servers,favorites),%serv,59)) {
    var %servinfo = $ri(servers,servers. $+ %serv)
    if (!%servinfo) { !server $1- | return }
    tokenize 1 %servinfo

    ; Nick, anick, rname & email
    if (!%rname) { var %rname = $1 }
    if (!%email) { var %email = $2 }
    if (!%nick) { var %nick = $3 }
    if (!%anick) { var %anick = $4 }
    ; Port et identd
    if (!%port) { var %port = $5 }
    var %identd = $6
    ; Mode invisible 
    var %inv = $8
    ; SSL
    if ($9 == 1) && ($sslready) { var %options = $remove(%options,e) $+ e }
    ; Reconnexion auto
    var %reco = $10
    ; Perform
    if ($11 == 0) { var %options = $remove(%options,p,o) $+ po }

    ; Si l'option "preserve nicknames" est cochée
    if ($gettok($rmi(options,n8),10,44) == 1) { var %nick = $me, %anick = $anick }
    ;Away mode preservation
    if ($ri(awaymisc,awayconnect) == 1) && ($ri(awaymisc,wasaway. $+ %serv)) { var %nick = $me, %anick = $anick }
    ; Troisieme partie: création de la commande
    .identd on %identd

    !server $iif(%options,- $+ %options) %serv $iif(%port,$v1) $iif(%pass,$v1) -i %nick %anick %email %rname $iif(%chan,-j %chan %passchan)

    if (%inv == 1) && ($server) { .mode $me +i }

  }
  else { !server $1- | return }
  ; That was TOUGH!
}

; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
