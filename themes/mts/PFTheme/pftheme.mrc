alias realtimefr {
  var %asctime $duration($1,3)
  var %secs $gettok(%asctime,3,58)
  var %mins $gettok(%asctime,2,58)
  var %hours $gettok(%asctime,1,58)
  var %days $calc(%hours/24)

  return $iif(%days != 0,%days $iif(%days == 1,jour,jours)), $iif(%hours != 0,%hours $iif(%hours == 1,heure,heures)), $iif(%mins != 0,%mins $iif(%mins == 1,minute,minutes)) et %secs $iif(%secs==1,seconde,secondes)
}

alias signontimefr {
  var %asctime $asctime($1,yyyy:m:ddd:d:H:nn:ss)
  var %year $gettok(%asctime,1,58)
  var %month $gettok(%asctime,2,58)
  var %dayweek $gettok(%asctime,3,58)
  var %days $gettok(%asctime,4,58)
  var %hours $gettok(%asctime,5,58)
  var %mins $gettok(%asctime,6,58)
  var %secs $gettok(%asctime,7,58)

  return $shortdayfr(%dayweek) %days $monthfr(%month) %year à %hours $+ h $+ %mins
}

alias shortdayfr {
  if ($1 == Sun) return Dim
  elseif ($1 == Mon) return Lun
  elseif ($1 == Tue) return Mar 
  elseif ($1 == Wed) return Mer
  elseif ($1 == Thu) return Jeu
  elseif ($1 == Fri) return Ven
  elseif ($1 == Sat) return Sam
  elseif ($1 == Sun) return Dim
  else return ???
}

alias dayfr {
  if ($1 == Sunday) return Dimanche
  elseif ($1 == Monday) return Lundi
  elseif ($1 == Tuesday) return Mardi
  elseif ($1 == Wednesday) return Mercredi
  elseif ($1 == Thursday) return Jeudi
  elseif ($1 == Friday) return Vendredi
  elseif ($1 == Saturday) return Samedi
  elseif ($1 == Sunday) return Dimanche
  else return ???
}

alias shortmonthfr {
  if ($1 == 0) return ???
  elseif ($1 == 1) return Jan
  elseif ($1 == 2) return Fev
  elseif ($1 == 3) return Mar
  elseif ($1 == 4) return Avr
  elseif ($1 == 5) return Mai
  elseif ($1 == 6) return Jun
  elseif ($1 == 7) return Jui
  elseif ($1 == 8) return Aou
  elseif ($1 == 9) return Sep
  elseif ($1 == 10) return Oct
  elseif ($1 == 11) return Nov
  elseif ($1 == 12) return Dec
  else return ???
}

alias monthfr {
  if ($1 == 0) return ???
  elseif ($1 == 1) return Janvier
  elseif ($1 == 2) return Fevrier
  elseif ($1 == 3) return Mars
  elseif ($1 == 4) return Avril
  elseif ($1 == 5) return Mai
  elseif ($1 == 6) return Juin
  elseif ($1 == 7) return Juillet
  elseif ($1 == 8) return Août
  elseif ($1 == 9) return Septembre
  elseif ($1 == 10) return Octobre
  elseif ($1 == 11) return Novembre
  elseif ($1 == 12) return Decembre
  else return ???
}


alias pftheme.mode {
  if (%::nick == $me) { var %moder Vous avez }
  else { var %moder %::cnick %::nick a }

  var %action mis le(s) mode(s) %::c3 $+ %::modes
  var %target $null

  var %modes $gettok(%::modes,1,32)
  var %nicks $gettok(%::modes,2-,32)

  var %plusoumoins $left(%modes,1)
  var %modesonly $right(%modes,-1)

  if ($len(%modesonly) > 1) { var %action mis les modes %::c3 $+ %modes %nicks sur }
  elseif ($len(%modesonly) == 1) {
    var %action le(s) mode(s) %::c3 $+ %::modes
    if (%plusoumoins == +) { var %give donné }
    else { var %give enlevé }

    var %target $iif(%plusoumoins == +,à %::c2 $+ %nicks sur,de %::c2 $+ %nicks sur)

    if (%modesonly === v) { var %action le statut de  $+ $cnick(+).color $+ voice }
    elseif (%modesonly === h) { var %action le statut d' $+ $cnick(%).color $+ halfop }
    elseif (%modesonly === o) { var %action le statut d' $+ $cnick(@).color $+ op }
    elseif (%modesonly === a) { var %action le statut  $+ $cnick(.).color $+ protect }
    elseif (%modesonly === q) { var %action le statut d' $+ $cnick(.).color $+ owner }
    elseif (%modesonly === e) { var %action le statut d' $+ 0 $+ except }
    elseif (%modesonly === I) { var %action le statut de  $+ 0 $+ privilégié }
    elseif (%modesonly === b) {
      var %give $iif(%plusoumoins == +,banni,débanni)
      var %action 
      var %target %::c2 $+ %nicks de
    }
    else {
      var %give $iif(%plusoumoins == +,activé ,désactivé )
      var %target
      if (%modesonly === c) { var %action l'anticouleurs }
      elseif (%modesonly === f) { var %action l'antiflood (options : %nicks) }
      elseif (%modesonly === i) { var %action le mode invités }
      elseif (%modesonly === m) { var %action le mode modération (seuls les +vhoaq peuvent parler) }
      elseif (%modesonly === n) { var %action le mode anti-notices externes }
      elseif (%modesonly === p) { var %action le mode canal privé }
      elseif (%modesonly === R) { var %action l'accès restreint aux utilisateurs enregistrés }
      elseif (%modesonly === s) { var %action le mode canal secret }
      elseif (%modesonly === t) { var %action le changement de topic aux modérateurs uniquement }
      elseif (%modesonly === z) { var %action le mode canal sécurisé }
      elseif (%modesonly === A) { var %action le mode ServerAdmins uniquement }
      elseif (%modesonly === C) { var %action l'anti-ctcp }
      elseif (%modesonly === G) { var %action le mode canal censuré }
      elseif (%modesonly === M) { var %action le mode semi-modéré (seuls les +r et +vhoaq peuvent parler) }
      elseif (%modesonly === K) { var %action l'interdiction de KNOCK }
      elseif (%modesonly === N) { var %action l'interdiction de changement de nick }
      elseif (%modesonly === O) { var %action le mode IRCOPs uniquement }
      elseif (%modesonly === Q) { var %action l'interdiction de kicks }
      elseif (%modesonly === S) { var %action le mode monochrome }
      elseif (%modesonly === T) { var %action l'interdiction de notices }
      elseif (%modesonly === V) { var %action l'interdiction d'invites }
      elseif (%modesonly === u) { var %action le mode auditorium (/who ne montre que les ops) }
      elseif (%modesonly === j) { 
        var %njoins $gettok(%nicks,1,58)
        var %jsec $gettok(%nicks,2,58)
        var %give $iif(%plusoumoins == +,restreint,désactivé)
        var %action $iif(%plusoumoins == +,le nombre de joins à4 %njoins $+  par4 %jsec $+  seconde(s),l'antiflood join)
      }
      elseif (%modesonly === k) { 
        var %give $iif(%plusoumoins == +,protégé,désactivé)
        var %action $iif(%plusoumoins == +,le canal avec la clé 4 $+ %nicks $+ ,l'accès au canal avec clé)
      }
      elseif (%modesonly === l) {
        var %give $iif(%plusoumoins == +,restreint,désactivé)
        var %action $iif(%plusoumoins == +,le nombre max d'utilisateurs à4 %nicks $+ ,la limite d'utilisateurs joignant le canal)
      }
      elseif (%modesonly === L) {
        var %give $iif(%plusoumoins == +,linké,délinké)
        var %action $iif(%plusoumoins == +,le canal à4 %nicks $+ ,le canal de4 %nicks $+ )
      }
      else { var %action un mode non pris en compte }
      var %action %action sur
    }
  }
  %:echo %::pre ```  $+ %moder %give %action %target  $+ %::c5 $+ %::chan ´´´
}

alias pftheme.usermode {
  if (%::nick == $me) { var %moder Vous vous êtes }
  else { var %moder %::cnick %::nick a }

  var %action mis le(s) mode(s) %::c3 $+ %::modes
  var %target $null

  var %modes $gettok(%::modes,1,32)
  var %nicks $gettok(%::modes,2-,32)

  var %plusoumoins $left(%modes,1)
  var %modesonly $right(%modes,-1)

  if ($len(%modesonly) > 1) { var %action mis les modes %::c3 $+ %modes }
  elseif ($len(%modesonly) == 1) {
    var %give $iif(%plusoumoins == +,activé ,désactivé )
    var %action le(s) mode(s) %::c3 $+ %::modes
    var %target $iif(%nicks,$iif(%plusoumoins == +,sur %::c2 $+ %nicks ,de %::c2 $+ %nicks ))

    if (%modesonly === i) { var %action le mode invisible (non affiché par /who) }
    elseif (%modesonly === o) { var %action le statut d'IRCOp }
    elseif (%modesonly === O) { var %action le statut de LocOp }
    elseif (%modesonly === A) { var %action le statut de ServerAdmin }
    elseif (%modesonly === N) { var %action le statut de ServerRoot }
    elseif (%modesonly === C) { var %action le statut de ServerCoAdmin }
    elseif (%modesonly === d) { var %action le mode sourd (bloque la réception de /privmsg) }
    elseif (%modesonly === g) { var %action l'envoi des messages GlobOps et LocOps }
    elseif (%modesonly === h) { var %action le statut de HelpOp (Help Operator) }
    elseif (%modesonly === p) { var %action le mode insondable (cache les canaux sur lesquels vous êtes) }
    elseif (%modesonly === q) { var %action le mode intouchable (seuls les Ulines peuvent vous kicker) }
    elseif (%modesonly === r) { var %action le mode pseudo enregistré }
    
    elseif (%modesonly === s) { var %action le mode omniscient (peut voir les notices du serveur) }
    elseif (%modesonly === t) { var %action l'affichage de votre VHOST }
    elseif (%modesonly === v) { var %action le mode responsable DCC (affiche les notices de DCC infectés) }
    elseif (%modesonly === w) { var %action l'affichage des messages Wallops }
    elseif (%modesonly === x) { var %action le chiffrement du hostname }
    elseif (%modesonly === z) { var %action le mode sécurisé (connexion SSL) }
    elseif (%modesonly === B) { var %action le statut de Bot }
    elseif (%modesonly === G) { var %action le mode censuré (censure vos badwords) }
    elseif (%modesonly === H) { var %action le mode IRCOp caché (cache le statut de IRCOp des /who) }
    elseif (%modesonly === R) { var %action le mode semi-sourd (ne recoit que les /privmsg des users enregistrés) }
    elseif (%modesonly === S) { var %action le statut de Service }
    elseif (%modesonly === V) { var %action le statut de client WebTV }
    elseif (%modesonly === W) { var %action la notification de Whois (vous avertit lorsqu'on vous Whois) }
    elseif (%modesonly === T) { var %action le mode No-CTCP (bloque la réception des CTCP) }
    else { var %action un mode non pris en compte }
  }
  %:echo %::pre ```  $+ %moder %give %action ( %::c3 $+ %::modes ) %target ´´´
}

alias pftheme.servererror {
  if (!(Closing Link isin %::text)) {
    %:echo %::pre 4### SERVER ERROR : %::text ###
  }
}

alias pftheme.whoisstart {
  %:echo 4------------------------------------------ Whois --------------------------------------
  %:echo  7~~~~ 12Whois sur %::c2 $+ %::nick 10(14 $+ %::address $+ 10) 7~~~~ 
  %:echo  7~~~~ 12Nom Réel : %::c2 $+ %::realname 7~~~~ 
}


alias pftheme.isircop {
  if (%::isoper == is) {
    %:echo  7~~~~ %::c2 $+ %::nick 6 $iif(%::operline,%::operline,Est IRCOp) 7~~~~ 
  }
}

alias pftheme.server {
  if ($server) {
    %:echo  7~~~~ 12Serveur: %::c2 $+ %::wserver 10( $+ %::c1 $+ %::serverinfo $+ 10) 7~~~~ 
  }
}

alias pftheme.registered {
  if (%::isregd == is) {
    %:echo  7~~~~ 12Son pseudo est enregistré 7~~~~ 
  }
}

alias pftheme.awaymode {
  %:echo  7~~~~ 12Absent 10( $+ %::c1 $+ Raison: %::away $+ 10) 7~~~~ 
}

alias pftheme.idle {
  %:echo  7~~~~ 12Inactif depuis %::c2 $+ $realtimefr(%::idletime) 7~~~~ 
  %:echo  7~~~~ 12Connecté depuis le %::c2 $+ $signontimefr(%::signontimeraw) 7~~~~ 
}

alias pftheme.channels {
  %:echo  7~~~~ 12Présent sur les canaux : %::c2 $+ %::chan 7~~~~ 
}

alias pftheme.whoisstop {
  %:echo 4------------------------------------------------------------------------------------------
}

alias pftheme.whowasstart {
  %:echo 13---------------------------------------- Whowas ------------------------------------
  %:echo  7~~~~ 11Whowas sur %::c2 $+ %::nick 10(14 $+ %::address $+ 10) 7~~~~ 
  %:echo  7~~~~ 11Nom Réel : %::c2 $+ %::realname 7~~~~ 
}

alias pftheme.whowasstop {
  %:echo 13-----------------------------------------------------------------------------------------
}

alias pftheme.topicsetby {
  %:echo %::pre %::c1 $+ Topic créé par %::c4 $+ %::nick le %::c1 $+ $signontimefr(%::text)
}

alias pftheme.listusers {
  var %list %::text
  %:echo %::c3 $+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  %:echo %::pre %::c1 $+ Liste des utilisateurs présents sur le canal %::c4 $+ %::chan :  
  var %i 2
  var %end %::pre $gettok(%list,1,32)
  while ($gettok(%list,%i,32)) {
    %end = %end - %::c3 $+ $gettok(%list,%i,32) $+ 
    inc %i
  }
  %:echo %end
}

alias pftheme.chanlist {
  window -c @chans
  window -ak0n2lvsz +btxn @chans "Calibri" 12 
  aline @chans 4,8!---------------------------- LISTE DES CANAUX ------------------------------------------!
}

alias pftheme.chanlistadd {
  aline @chans %::c4 $+ %::chan %::c1 $+ Users: %::c5 $+ %::users $+ %::c1 $+ , Topic: %::text
}

menu @chans {
  dclick: join $strip($gettok($sline(@chans,1),1,32))
}

alias pftheme.motdbegin {
  window -knvw0z +etln @motd "Lucida Console" 12 
  aline 4 @motd ------------------- MESSAGE OF THE DAY -----------------------
  aline @motd  %::c1 Et voici le MOT DU JOUR de notre président du serveur %::c2 $+ %::server !
}

alias pftheme.motd {
  aline @motd 1,14 %::text
}

alias pftheme.motdend {
  aline @motd %::c1 C'était le mot du président! Merci de votre écoute!
}

alias pftheme.ctcpreply {
  if (%::ctcp == PING) && ($isalias(durationfr)) { %::text = $durationfr($calc($ctime - %::text)).short }
  if (%::text == 0 s) { %::text = < 1 s }
  %:echo ~#* %::c5 $+ ( $+ %::cnick $+ %::nick CTCP %::ctcp $+ %::c5 $+ ) Réponse : %::c1 $+ %::text *#~
}