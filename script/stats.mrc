; ––––––––––––––––––––––––––––––––––––––––
; Enregistrement de statistiques
; ––––––––––––––––––––––––––––––––––––––––

;-----------------------------------------------------
; Evenements
;-----------------------------------------------------

#features on
ON *:START:{
  if ($hget(groups,stats) == $null) { hadd -m groups stats 1 }
  if ($hget(groups,stats) == 1) { 
    .enable #features.stats
    hmake stats 100
    hload stats $qt($iif($ri(paths,stats),$ifmatch,data/stats.txt))

    incStat starts
    writeStat lastStart $ctime
    splash_text 3 Chargement du script $nopath($script) ...
    splash_text 4 Script lancé pour la $getStat(starts) $+ e fois.

    ; Show setup on first run
    if ($getStat(starts) <= 1) {
      $infodialog(Bienvenue sur le PFScript version $pfversion $+ !Comme c'est votre premier lancement, prenez quelques minutes pour le configurer!)
      setup
    }
  }
  else { .disable #features.stats }
}


ON *:UNLOAD:{
  if ($hget(groups,stats)) { hadd groups stats 0 }
}
#features end


#features.stats on
ON *:EXIT:{
  hsave stats $iif($ri(paths,stats),$ifmatch,data/stats.txt)
}

ON *:CONNECT:{
  incStat connects. $+ $network
}

ON *:CONNECTFAIL:{
  incStat connectFails. $+ $network
}

ON *:FILERCVD:*:{
  incStat receivedTries
  incStat receivedFiles
}

ON *:FILESENT:*:{
  incStat sentTries
  incStat sentFiles
}

ON *:GETFAIL:*:{
  incStat receivedTries
  incStat receivedFails
}

ON *:SENDFAIL:*:{
  incStat sentTries
  incStat sentFails
}

ON &*:INPUT:#:{
  if ((!$iscmd($1)) || ($ctrlenter)) {
    incStat writtenChars $len($1-)
    incStat writtenWords $0
    incStat writtenLines

    incStat -c $chan writtenChars $len($1-)
    incStat -c $chan writtenWords $0
    incStat -c $chan writtenLines

    if ($left($1,1) == !) { incStat botCommands | incStat -c $chan botCommands }
  }
}

ON &*:INPUT:?:{
  if ((!$iscmd($1)) || ($ctrlenter)) {
    incStat writtenChars $len($1-)
    incStat writtenWords $0
    incStat writtenLines

    incStat -c $target writtenChars $len($1-)
    incStat -c $target writtenWords $0
    incStat -c $target writtenLines

    if ($left($1,1) == !) { incStat botCommands | incStat -c $target botCommands }
  }
}

ON *:INPUT:@:{
  if ((!$iscmd($1)) || ($ctrlenter)) {
    incStat writtenChars $len($1-)
    incStat writtenWords $0
    incStat writtenLines

    incStat -c $target writtenChars $len($1-)
    incStat -c $target writtenWords $0
    incStat -c $target writtenLines

  }
}

ON *:KICK:*:{
  if ($nick == $me) { incStat kickCount | incStat -c $chan kickCount }
  if ($knick == $me) { incStat kickedCount | incStat -c $chan kickedCount }
}

ON *:TOPIC:*:{
  if ($nick == $me) { incStat topicChanges | incStat -c $chan topicChanges }
}

ON *:NICK:{
  if ($nick != $newnick) && ($nick == $me) { incStat nickChanges }
}

ON *:JOIN:*:{
  if ($nick == $me) { incStat joins | incStat -c $chan joins }
}

ON *:OPEN:?:*:{
  incStat queriesCount
  incStat -c $nick queriesCount
}

ON *:BAN:*:{
  if ($nick == $me) { incStat banCount | incStat -c $chan banCount }
  if ($banmask iswm $ial($me)) { incStat bannedCount | incStat -c $chan bannedCount }
}

ON *:VOICE:*:{
  if ($nick == $me) { incStat voiceCount | incStat -c $chan voiceCount }
  if ($vnick == $me) { incStat voicedCount | incStat -c $chan voicedCount }
}

ON *:DEVOICE:*:{
  if ($nick == $me) { incStat devoiceCount | incStat -c $chan devoiceCount }
  if ($vnick == $me) { incStat devoicedCount | incStat -c $chan devoicedCount }
}

ON *:HELP:*:{
  if ($nick == $me) { incStat halfCount | incStat -c $chan halfCount }
  if ($hnick == $me) { incStat halfedCount | incStat -c $chan halfedCount }
}

ON *:DEHELP:*:{
  if ($nick == $me) { incStat dehalfCount | incStat -c $chan dehalfCount }
  if ($hnick == $me) { incStat dehalfedCount | incStat -c $chan dehalfedCount }
}

ON *:OP:*:{
  if ($nick == $me) { incStat opCount | incStat -c $chan opCount }
  if ($opnick == $me) { incStat oppedCount | incStat -c $chan oppedCount }
}

ON *:DEOP:*:{
  if ($nick == $me) { incStat deopCount | incStat -c $chan deopCount }
  if ($opnick == $me) { incStat deoppedCount | incStat -c $chan deoppedCount }
}

ON *:SIGNAL:themechange:{
  incStat themeCount
  writeStat lastTheme $1-
}

ON *:SIGNAL:away:{
  incStat aways
}
#features.stats end

;--------------------------------------------
; Affichage des stats
;--------------------------------------------
alias openstats { if ($enabled(stats)) { opendialog -m stats } }

dialog stats {
  title "Stats diverses [/openstats]"
  size -1 -1 402 404
  option pixels
  icon images/masterIRC2.ico
  combo 1, 100 4 202 230, drop sort
  list 2, 10 30 388 318, size
  button "&Ok", 3, 308 376 80 24, ok
  text "Dernier reset:", 4, 12 352 156 16
  text "", 5, 80 352 220 16, right
  text "", 6, 80 368 220 16, right
  menu "&Fichier", 7
  item "&Fermer", 8, 7
  menu "&Stats", 9
  item "&Poster stats sur le canal", 10, 9
  item break, 11, 9
  item "A&ctualiser", 12, 9
  item "&Remettre a zero", 13, 9
}

on *:dialog:stats:*:*:{
  if ($devent == init) {
    mdxload
    mdx SetControlMDX $dname 2 ListView report showsel single grid rowselect infotip > $mdxfile(views)
    did -i $dname 2 1 headerdims 80:1 300:2 0:3
    did -i $dname 2 1 headertext +r 0 Valeur $chr(9) $+ $+ + 0 Description $chr(9) $+ $+ + 0
    did -b $dname 10

    did -ac $dname 1 Globales
    did -a $dname 1 DCC
    did -a $dname 1 Gestion
    did -a $dname 1 Autres

    didtok $dname 1 59 $hget(stats,sections)
    showstats

    if ($getStat(lastReset)) { .timercounter 0 1 updateSecs $v1 }
  }
  elseif ($devent == sclick) {
    if ($did == 1) { 
      showstats
    }
    elseif ($did == 2) {
      did $iif($did($did).sel,-e,-b) $dname 10
      if (rclick * iswm $did($did,1)) {
        newpopup statpopup
        newmenu statpopup 1 $chr(9) $iif($did($did).sel,+,+g) 1 0 &Afficher sur le canal
        newmenu statpopup 2 $chr(9) $iif($did($did).sel,+,+g) 2 0 Afficher &pour moi
        newmenu statpopup 3 $chr(9) $iif($did($did).sel,+,+g) 3 0 &Réinitialiser
        newmenu statpopup 4 $chr(9) + 4 0 -
        newmenu statpopup 5 $chr(9) + 5 0 A&ctualiser
        newmenu statpopup 6 $chr(9) + 6 0 &Tout réinitialiser
        displaypopup statpopup
      }
    }
  }
  elseif ($devent == dclick) {
    stat.echo $active
  }
  elseif ($devent == menu) {
    if ($did == 8) { dialog -c $dname }
    elseif ($did == 10) { stat.say $active }
    elseif ($did == 12) { stat.refresh }
    elseif ($did == 13) { stat.resetall }
  }
  elseif ($devent == close) { .timercounter off }
}

ON *:SIGNAL:XPOPUP-statpopup:{
  if ($1 == 1) { stat.say $active }
  elseif ($1 == 2) { stat.echo $active }
  elseif ($1 == 3) { stat.reset }
  elseif ($1 == 5) { stat.refresh }
  elseif ($1 == 6) { stat.resetall }

}

alias -l updateSecs {
  did -ra stats 6 Il y'a $durationfr($calc($ctime - $1))
}

;---------------------------------------------
; Alias relatifs à l'affichage
;---------------------------------------------

; Affiche les stats dans la window
alias showstats {
  did -ra stats 5 $iif($getStat(lastReset),$asctimefr($ifmatch),Jamais)
  did -r stats 2
  if ($did(stats,1).seltext == Globales) {
    did -a stats 2 1 + 0 0 0 $getStat(writtenChars) $+ $chr(9) $+ + 0 0 0 Caractères écrits $+ $chr(9) $+  + 0 0 0 writtenChars
    did -a stats 2 1 + 0 0 0 $getStat(writtenWords) $+ $chr(9) $+ + 0 0 0 Mots écrits $+ $chr(9) $+  + 0 0 0 writtenWords
    did -a stats 2 1 + 0 0 0 $getStat(writtenLines) $+ $chr(9) $+ + 0 0 0 Lignes écrites $+ $chr(9) $+  + 0 0 0 writtenLines
    did -a stats 2 1 + 0 0 0 $getStat(queriesCount) $+ $chr(9) $+ + 0 0 0 Query ouvertes $+ $chr(9) $+  + 0 0 0 queriesCount
    did -a stats 2 1 + 0 0 0 $getStat(botCommands) $+ $chr(9) $+ + 0 0 0 Commandes de Bot $+ $chr(9) $+  + 0 0 0 botCommands
  }
  elseif ($did(stats,1).seltext == DCC) {
    did -a stats 2 1 + 0 0 0 $getStat(receivedFiles) $+ $chr(9) $+ + 0 0 0 Fichiers reçus $+ $chr(9) $+  + 0 0 0 receivedFiles
    did -a stats 2 1 + 0 0 0 $getStat(receivedFails) $+ $chr(9) $+ + 0 0 0 Fichiers non reçus $+ $chr(9) $+  + 0 0 0 receivedFails
    did -a stats 2 1 + 0 0 0 $getStat(sentFiles) $+ $chr(9) $+ + 0 0 0 Fichiers envoyés $+ $chr(9) $+  + 0 0 0 sentFiles
    did -a stats 2 1 + 0 0 0 $getStat(sentFails) $+ $chr(9) $+ + 0 0 0 Fichiers non envoyés $+ $chr(9) $+  + 0 0 0 sentFails
    did -a stats 2 1 + 0 0 0 $getStat(receivedTries) $+ $chr(9) $+ + 0 0 0 Tentatives de réception $+ $chr(9) $+  + 0 0 0 receivedTries
    did -a stats 2 1 + 0 0 0 $getStat(sentTries) $+ $chr(9) $+ + 0 0 0 Tentatives d'envoi $+ $chr(9) $+  + 0 0 0 sentTries
  }
  elseif ($did(stats,1).seltext == Gestion) {
    did -a stats 2 1 + 0 0 0 $getStat(joins) $+ $chr(9) $+ + 0 0 0 Joins $+ $chr(9) $+  + 0 0 0 joins
    did -a stats 2 1 + 0 0 0 $getStat(nickChanges) $+ $chr(9) $+ + 0 0 0 Changements de nick $+ $chr(9) $+  + 0 0 0 nickChanges
    did -a stats 2 1 + 0 0 0 $getStat(topicChanges) $+ $chr(9) $+ + 0 0 0 Changements de topic $+ $chr(9) $+  + 0 0 0 topicChanges
    did -a stats 2 1 + 0 0 0 $getStat(kickCount) $+ $chr(9) $+ + 0 0 0 Kicks donnés $+ $chr(9) $+  + 0 0 0 kickCount
    did -a stats 2 1 + 0 0 0 $getStat(kickedCount) $+ $chr(9) $+ + 0 0 0 Kicks reçus $+ $chr(9) $+  + 0 0 0 kickedCount
    did -a stats 2 1 + 0 0 0 $getStat(banCount) $+ $chr(9) $+ + 0 0 0 Bans donnés $+ $chr(9) $+  + 0 0 0 banCount
    did -a stats 2 1 + 0 0 0 $getStat(bannedCount) $+ $chr(9) $+ + 0 0 0 Bans reçus $+ $chr(9) $+  + 0 0 0 bannedCount
    did -a stats 2 1 + 0 0 0 $getStat(voiceCount) $+ $chr(9) $+ + 0 0 0 Voices donnés $+ $chr(9) $+  + 0 0 0 voiceCount
    did -a stats 2 1 + 0 0 0 $getStat(voicedCount) $+ $chr(9) $+ + 0 0 0 Voices reçus $+ $chr(9) $+  + 0 0 0 voicedCount
    did -a stats 2 1 + 0 0 0 $getStat(devoiceCount) $+ $chr(9) $+ + 0 0 0 Devoices  donnés $+ $chr(9) $+  + 0 0 0 devoiceCount
    did -a stats 2 1 + 0 0 0 $getStat(devoicedCount) $+ $chr(9) $+ + 0 0 0 Devoices reçus $+ $chr(9) $+  + 0 0 0 devoicedCount
    did -a stats 2 1 + 0 0 0 $getStat(halfCount) $+ $chr(9) $+ + 0 0 0 Halfops donnés $+ $chr(9) $+  + 0 0 0 halfCount
    did -a stats 2 1 + 0 0 0 $getStat(halfedCount) $+ $chr(9) $+ + 0 0 0 Halfops reçus $+ $chr(9) $+  + 0 0 0 halfedCount
    did -a stats 2 1 + 0 0 0 $getStat(dehalfCount) $+ $chr(9) $+ + 0 0 0 Dehalfops donnés $+ $chr(9) $+  + 0 0 0 dehalfCount
    did -a stats 2 1 + 0 0 0 $getStat(dehalfedCount) $+ $chr(9) $+ + 0 0 0 Halfops reçus $+ $chr(9) $+  + 0 0 0 dehalfedCount
    did -a stats 2 1 + 0 0 0 $getStat(opCount) $+ $chr(9) $+ + 0 0 0 Ops donnés $+ $chr(9) $+  + 0 0 0 opCount
    did -a stats 2 1 + 0 0 0 $getStat(oppedCount) $+ $chr(9) $+ + 0 0 0 Ops reçus $+ $chr(9) $+  + 0 0 0 oppedCount
    did -a stats 2 1 + 0 0 0 $getStat(deopCount) $+ $chr(9) $+ + 0 0 0 Deops donnés $+ $chr(9) $+  + 0 0 0 deopCount
    did -a stats 2 1 + 0 0 0 $getStat(deoppedCount) $+ $chr(9) $+ + 0 0 0 Deops reçus $+ $chr(9) $+  + 0 0 0 deoppedCount
  }
  elseif ($did(stats,1).seltext == Autres) {
    did -a stats 2 1 + 0 0 0 $getStat(starts) $+ $chr(9) $+ + 0 0 0 Lancements du script $+ $chr(9) $+  + 0 0 0 starts
    did -a stats 2 1 + 0 0 0 $calc($script(0) + $alias(0)) $+ $chr(9) $+ + 0 0 0 Scripts chargés dont: 
    did -a stats 2 1 + 0 0 0 $alias(0) $+ $chr(9) $+ + 0 0 0 Alias
    did -a stats 2 1 + 0 0 0 $script(0) $+ $chr(9) $+ + 0 0 0 Scripts
    did -a stats 2 1 + 0 0 0 $getStat(themeCount) $+ $chr(9) $+ + 0 0 0 Changements de thème $+ $chr(9) $+  + 0 0 0 themeCount
    did -a stats 2 1 + 0 0 0 $getStat(connects. $+ $network) $+ $chr(9) $+ + 0 0 0 Connexions réussies au réseau $network $+ $chr(9) $+  + 0 0 0 connects. $+ $network
    did -a stats 2 1 + 0 0 0 $getStat(connectFails. $+ $network) $+ $chr(9) $+ + 0 0 0 Connexions échouées au réseau $network $+ $chr(9) $+  + 0 0 0 connectFails. $+ $network
    did -a stats 2 1 + 0 0 0 $getStat(aways) $+ $chr(9) $+ + 0 0 0 Mises en mode away $+ $chr(9) $+  + 0 0 0 aways
  }
  elseif ($did(stats,1).sel == 0) { return }
  else { getStatsChan }
}

; Show the stats of the selected chan/query
alias -l getStatsChan {
  var %chan = $did(stats,1).seltext
  var %f = $ri(paths,stats)
  var %stats = $ini(%f,%chan,0)

  if (%stats == 0) { return }

  did -a stats 2 1 + 0 0 0 $getCStat(%chan,writtenChars) $+ $chr(9) $+ + 0 0 0 Caractères écrits $+ $chr(9) $+  + 0 0 0 writtenChars
  did -a stats 2 1 + 0 0 0 $getCStat(%chan,writtenWords) $+ $chr(9) $+ + 0 0 0 Mots écrits $+ $chr(9) $+  + 0 0 0 writtenWords
  did -a stats 2 1 + 0 0 0 $getCStat(%chan,writtenLines) $+ $chr(9) $+ + 0 0 0 Lignes écrites $+ $chr(9) $+  + 0 0 0 writtenLines
  did -a stats 2 1 + 0 0 0 $getCStat(%chan,botCommands) $+ $chr(9) $+ + 0 0 0 Commandes de Bot $+ $chr(9) $+  + 0 0 0 botCommands

  if ($left(%chan,1) == #) {  
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,joins) $+ $chr(9) $+ + 0 0 0 Joins $+ $chr(9) $+  + 0 0 0 joins
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,topicChanges) $+ $chr(9) $+ + 0 0 0 Changements de topic $+ $chr(9) $+  + 0 0 0 topicChanges
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,kickCount) $+ $chr(9) $+ + 0 0 0 Kicks donnés $+ $chr(9) $+  + 0 0 0 kickCount
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,kickedCount) $+ $chr(9) $+ + 0 0 0 Kicks reçus $+ $chr(9) $+  + 0 0 0 kickedCount
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,banCount) $+ $chr(9) $+ + 0 0 0 Bans donnés $+ $chr(9) $+  + 0 0 0 banCount
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,bannedCount) $+ $chr(9) $+ + 0 0 0 Bans reçus $+ $chr(9) $+  + 0 0 0 bannedCount
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,voiceCount) $+ $chr(9) $+ + 0 0 0 Voices donnés $+ $chr(9) $+  + 0 0 0 voiceCount
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,voicedCount) $+ $chr(9) $+ + 0 0 0 Voices reçus $+ $chr(9) $+  + 0 0 0 voicedCount
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,devoiceCount) $+ $chr(9) $+ + 0 0 0 Devoices donnés $+ $chr(9) $+  + 0 0 0 devoiceCount
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,devoicedCount) $+ $chr(9) $+ + 0 0 0 Devoices reçus $+ $chr(9) $+  + 0 0 0 devoicedCount
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,halfCount) $+ $chr(9) $+ + 0 0 0 Halfops donnés $+ $chr(9) $+  + 0 0 0 halfCount
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,halfedCount) $+ $chr(9) $+ + 0 0 0 Halfops reçus $+ $chr(9) $+  + 0 0 0 halfedCount
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,dehalfCount) $+ $chr(9) $+ + 0 0 0 Dehalfops donnés $+ $chr(9) $+  + 0 0 0 dehalfCount 
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,dehalfedCount) $+ $chr(9) $+ + 0 0 0 Halfops reçus $+ $chr(9) $+  + 0 0 0 dehalfedCount
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,opCount) $+ $chr(9) $+ + 0 0 0 Ops donnés $+ $chr(9) $+  + 0 0 0 opCount
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,oppedCount) $+ $chr(9) $+ + 0 0 0 Ops reçus $+ $chr(9) $+  + 0 0 0 oppedCount 
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,deopCount) $+ $chr(9) $+ + 0 0 0 Deops donnés $+ $chr(9) $+  + 0 0 0 deopCount
    did -a stats 2 1 + 0 0 0 $getCStat(%chan,deoppedCount) $+ $chr(9) $+ + 0 0 0 Deops reçus $+ $chr(9) $+  + 0 0 0 deoppedCount
  }
}

; Raccourci pour l'affichage des stats
alias -l stat.select {
  set -u5 %chan $1
  set -u5 %seltext $did(stats,2).seltext
  set -u5 %sel $did(stats,2).sel

  if (!%seltext) { return }
  set -u5 %value $getColValue(stats,2,%sel,1)
  set -u5 %desc $getColValue(stats,2,%sel,2)
  if ($did(stats,1).seltext !isin Globales/Gestion/DCC/Autres) {
    set -u5 %onchan $did(stats,1)
    set -u5 %onchan $iif($left(%onchan,1) == $chr(35),sur le canal %onchan,avec %onchan)
  }
}

; Affiche la stat selectionnée sur le canal
; $1: canal/query/Window
alias stat.say {
  stat.select $1
  msg %chan $pubmsg(Stats d'utilisation: Nombre de $lower(%desc) $iif(%onchan,%onchan) $+ : %value)
}

; Affiche la stat selectionnée en echo
alias stat.echo {
  stat.select $1
  echo -a $pubmsg(Stats d'utilisation: Nombre de $lower(%desc) $iif(%onchan,%onchan) $+ : %value)
}

; Rafraichit les stats
alias stat.refresh {
  did -r stats 1
  didtok stats 1 47 Globales/DCC/Gestion/Autres
  did -c stats 1 1
  didtok stats 1 59 $hget(stats,sections)
  showstats
}

; Reinitialiser la stat selectionnée
alias stat.reset {
  var %chan = $did(stats,1).seltext, %sel = $did(stats,2).sel
  var %stat = $getColValue(stats,2,%sel,3)

  if (%stat) {
    var %yn = $yndialog(Etes-vous sûr(e) de vouloir réinitialiser la stat $qt(%stat) ?)
    if (%yn) {
      if (%chan !isin Globales/DCC/Gestion/Autres) { writeStat -c %chan %stat 0 }
      else { writeStat %stat 0 }
      if ($dialog(stats)) { showstats }
    }
  }
}

; Remet a zero toutes les stats
alias stat.resetall {
  if (!$yndialog(Remettre à zéro toutes les stats?)) { return }
  hfree stats | hmake stats 100
  echo -sc info Stats réinitialisées.
  writeStat lastReset $ctime
  did -r stats 1
  didtok stats 1 59 Globales;DCC;Gestion;Autres
  did -c stats 1 1
  .timercounter 0 1 updateSecs $ctime

  if ($dialog(stats)) { showstats }
}


; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
