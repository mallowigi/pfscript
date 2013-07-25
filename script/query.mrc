;------------------------------------------
; Query options
;------------------------------------------

#features on
ON *:START:{
  if ($hget(groups,query) == $null) { hadd -m groups query 1 }
  if ($hget(groups,query) == 1) { 
    splash_text 3 Chargement du script $nopath($script) ...
    .enable #features.query 
  }
  else { .disable #features.query }
}

ON *:UNLOAD:{
  if ($hget(groups,query)) { hadd groups query 0 }
}
#features end

; Custom query command: when opening query window 
alias query {
  if (!$enabled(query)) { !query $1- | return }
  if ($1 == -n) {
    var %n = -n
    tokenize 32 $2-
  }
  if ($window($1,1).type != query) {
    incStat queriesCount
    incStat -c $1 queriesCount
    !query %n $1
    if ($window($1,1).type == query) && ($1 != $me) {
      theme.echo $1 Ouverture d'une query avec $basecolor(3) $+ $1 $+ ...
      theme.echo $1 Création: $basecolor(4) $+ $asctimefr($ctime)
      if ($ri(query,stats) == 1) {
        theme.echo $1 Total de queries ouvertes: $basecolor(4) $+ $getStat(queriesCount)
        theme.echo $1 De cet utilisateur: $basecolor(4) $+ $getCStat($1,queriesCount)
        theme.echo $1 Caractères: $basecolor(4) $+ $getCStat($1,writtenChars) $+ , Mots: $basecolor(4) $+ $getCStat($1,writtenWords) $+ , Lignes: $basecolor(4) $+ $getCStat($1,writtenLines)
      }
      echo $1 
      if ($2- != $null) { msg $1- }
    }
  }
  else { !query $1- }
}

; Verifie les fenetres de query et les ferme si leur temps d'idle est supérieur a la valeur renseignee dans les options
alias checkAutoclose {
  var %nbquery = $query(0)
  if ($ri(query,autocloseuse) == 1) && $ri(query,autoclose) > 0) {
    var %idletime = $calc($ri(query,autoclose) * 60)
    while (%nbquery) {
      var %qmsg = $query(%nbquery).idle
      ; Si le temps d'idle est supérieur a la valeur maximale autorisée
      if (%qmsg > %idletime) {
        ; Si la query est highlightee ou si la fenetre de query est la fenetre active, ne pas la fermer
        if (!$window($query(%nbquery)).sbcolor) && ($query(%nbquery) != $active) { 
          close -m $query(%nbquery)
        }
      }
      dec %nbquery
    }
  }
}

#features.query on


; Activation de l'autoclose au demarrage
ON *:CONNECT:{
  if ($ri(query,autocloseuse) == 1) { .timerautoclose -i 0 30 checkAutoclose }
}

; Statistiques: Lors de l'ouverture d'une query
ON *:OPEN:?:{
  theme.echo $nick Ouverture d'une query avec $basecolor(3) $+ $nick $+ ...
  theme.echo $nick Création: $basecolor(4) $+ $asctimefr($ctime)
  if ($ri(query,stats) == 1) {
    theme.echo $nick Total de queries ouvertes: $basecolor(4) $+ $getStat(queriesCount)
    theme.echo $nick De cet utilisateur: $basecolor(4) $+ $getCStat($nick,queriesCount)
    theme.echo $nick Caractères: $basecolor(4) $+ $getCStat($nick,writtenChars) $+ , Mots: $basecolor(4) $+ $getCStat($nick,writtenWords) $+ , Lignes: $basecolor(4) $+ $getCStat($nick,writtenLines)
  }
  echo $nick 
}

RAW 353:*:{
  if ($ri(query,openuse) == 1) {
    var %list = $2-
    var %nicks = $ri(query,nicks)
    var %i = 1
    while ($gettok(%nicks,%i,59)) {
      var %q = $ifmatch
      if (%q isin %list) && (!$ignore(%q!*@*)) { query %q }
      inc %i
    }
  }
}

ON *:JOIN:#:{
  if (j isin $ri(query,events)) { query.printevent $1- }
  ;Autoopen
  if ($ri(query,openuse) == 1) {
    var %nicks = $ri(query,nicks)
    if ($istok(%nicks,$nick,59)) && (!$ignore($nick!*@*)) { query $nick }
  }
}

ON *:PART:#:{
  if (p isin $ri(query,events)) { query.printevent $1- }
}

ON *:NICK:{
  if ($nick == $me) { if (o isin $ri(query,events)) { set -u5 %menewnick $nick | query.printevent $1- } }
  else { if (n isin $ri(query,events)) { query.printevent $1- } }
}

ON *:KICK:#:{
  if (k isin $ri(query,events)) { set -u5 %knick $knick | query.printevent $1- }
}

ON *:QUIT:{
  if (q isin $ri(query,events)) { query.printevent $1- }
}

ON *:MODE:#:{
  if (m isin $ri(query,events)) { query.printevent $1- }
}

ON *:NOTIFY:{
  if (f isin $ri(query,events)) { query.printevent $1- }
}

ON *:UNOTIFY:{
  if (f isin $ri(query,events)) { query.printevent $1- }
}

#features.query end

alias -l query.printevent {
  if ($ri(query,eventsmp) == 1) {
    if (%knick) && ($query($knick)) { var %n = $query($knick) }
    elseif ($query($newnick)) || ($query($nick)) { var %n = $ifmatch }
    else { return }

    if ($theme.current) {
      if (%menewnick) { theme.vars qecho $color($event) -t <query> }
      else { theme.vars echo $color($event) -t %n }
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
      theme.text $iif(%menewnick,nickself,$event) $upper($event) %::text
    }

    else { 
      if ($event == join) { echo $color($event) -t %n $nick ( $+ $address $+ ) a rejoint le canal $chan } 
      elseif ($event == part) { echo $color($event) -t %n $nick ( $+ $address $+ ) est sorti de $chan } 
      elseif ($event == kick) { echo $color($event) -t %n $nick a kické $knick ( $+ $address($knick,5) $+ ) de $chan (Raison: $1-) }
      elseif ($event == nick) {
        if ($nick == $me) { qecho $color(event) -t <query> Vous avez changé votre pseudo en $newnick } 
        else { echo $color($event) -t %n $nick a changé son pseudo en $newnick }
      }
      elseif ($event == quit) { echo $color($event) -t %n $nick a quitté IRC (Raison: $1-) } 
      elseif ($event == mode) { echo $color($event) -t %n $nick a mis les modes $modes sur $chan }
      elseif ($event isin notify/unotify) { echo $color($event) -t %n $iif($event == notify,Connexion,Déconnexion) : $nick }
    }
  }
}

; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
