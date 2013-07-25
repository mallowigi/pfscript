; ------------------------------------
; Gestionnaire de thèmes 
; ------------------------------------

;sec Chargement/Lancement du script
alias themes {
  if (!$enabled(themes)) { $infodialog(La fonctionnalité des themes est désactivée.Réactivez-la d'abord.) | return }
  if (!$dialog(themes)) { dialog -m $+ $iif(d isin $theme.options(manager),d) $+ $iif(o isin $theme.options(manager),o) themes themes } 
  else { dialog -v themes themes }
}

#features on
on *:START:{ 
  if ($hget(groups,themes) == $null) { hadd -m groups themes 1 }
  if ($hget(groups,themes) == 1) { 
    .enable #features.themes
    splash_text 3 Chargement du script $nopath($script) ...
    theme.start
    if (!$hget(theme.current)) { splash_text 2 Note: Le gestionnaire de thèmes n'a pas pu être chargé (current.src manquant). }
    elseif (!$hget(theme.settings)) { splash_text 2 Note: Le gestionnaire de thèmes n'a pas pu être chargé (settings.src manquant). }
    else { splash_text 2 Gestionnaire de thèmes chargé. $iif($theme.current,Thème actuel: $hgt(name) $iif($hgt(scheme),- $hgt(scheme))) }
  }
  else { .disable #features.themes }  
}

on *:LOAD:{
  if (!$hget(theme.settings)) { hmake theme.settings 20 }
  theme.opt.restoreevents
  theme.opt.restoreraws

  pfwi loadoptions fcnsbite
  pfwi addoptions hwlug
  pfwi manageropt pcdorz
  pfwi listing name
  pfwi format 1 
  hsave -o theme.settings $qt($datathemes(settings.src))
}

on *:UNLOAD:{
  theme.unload
  if ($dialog(themes)) { dialog -x themes }
  if ($hget(theme.settings)) { hfree theme.settings }
  if ($hget(theme.current)) { hfree theme.current }
  if ($isfile($datathemes(current.src))) { .remove $qt($datathemes(current.src)) }
  if ($isfile($datathemes(settings.src))) { .remove $qt($datathemes(settings.src)) }

  if ($hget(groups,themes)) { hadd groups themes 0 }
}
#features end

; Action au lancement de mIRC
alias -l theme.start {
  if (!$hget(theme.current)) { hmake theme.current 50 }
  if ($exists($qt($datathemes(current.src)))) { hload theme.current " $+ $datathemes(current.src) $+ " }
  if (!$hget(theme.settings)) { hmake theme.settings 100 }
  if ($exists($qt($datathemes(settings.src)))) { hload theme.settings " $+ $datathemes(settings.src) $+ " }

  $eval($hgt(init),2)
  theme.vars
  if ($isfile($hgt(script))) && (!$script($hgt(script))) { .load -rs " $+ $hgt(script) $+ " }
  if ($hgt(timestampformat)) { .timestamp -f $theme.parse($iif($theme.current == mts,m,$iif($theme.current == nnt,y,x)),$hgt(timestampformat)) }

  if (r isin $theme.options(manager)) { theme.refresh }
  theme.sound start
}

; Raccourci pour les données de themes
alias -l datathemes { return $mircdir/data/themes/ $+ $1- }

; Créé le sous-menu des schemes du theme
alias -l theme.menu.schemes {
  if ($1 == begin) || ($1 == end) { return - }
  var %s = $gettok($hgt(schemenames),$1,59)
  if (!%s) { return - }
  return $iif($hgt(scheme) == %s,$style(1)) $1 $+ . %s $+ :theme.scheme $1
}

;ces

;sec Aliases
alias -l mtsversion { return 1.5 }
alias -l themesversion { return 1.5 }
alias -l themesengine { return Theme Engine MX by Voice of Power & Klarth version $themesversion for MTS $mtsversion & NNThemes }


; Retourne une propriété du theme actuel
alias -l theme.setting { if ($hgt($1)) { return $ifmatch } }

;Verifie si l'option "Flasher fenetre/Query" est cochée
alias -l flashchan { return $gettok($rmi(options,n7),5,44) }
alias -l flashquery { return $gettok($rmi(options,n7),6,44) }
;Couleurs par défaut
alias -l cdef { return 0,6,4,5,2,3,3,3,3,3,3,1,5,7,6,1,3,2,3,5,1,0,1,0,1,15,6,0 }
;Couleurs rgb par défaut
alias -l rgbdef { return 255,255,255 0,0,0 0,0,128 0,144,0 255,0,0 128,0,0 160,0,160 255,128,0 255,255,0 0,255,0 0,144,144 0,255,255 0,0,255 255,0,255 128,128,128 208,208,208 }

;htables getters and setters
alias -l ha { hadd theme.settings $1- }
alias -l hg { return $hget(theme.settings,$1) }
alias -l hat { hadd theme.current $1- }
alias -l hgt { return $hget(theme.current,$1) }
alias -l hap { hadd theme.preview $1- }
alias -l hgp { return $hget(theme.preview,$1) }
alias -l had { hadd theme.default $1- }
alias -l hgd { return $hget(theme.default,$1) }

alias -l pfri { return $readini($mircdir/pfscript.ini,themes,$$1) }
alias -l pfwi { $iif($2-,writeini,remini) $qt($mircdir/pfscript.ini) themes $$1 $2- }
alias -l pfremi { remini $qt($mircdir/pfscript.ini) themes $$1 }

;Write mirc ini about an option
alias -l wmi { if ($3) { writeini " $+ $mircini $+ " $1- } }
;Remove an option in the mirc ini
alias -l remmi { if ($1) { remini " $+ $mircini $+ " $1- } }
;Read mirc ini
alias -l rmi { return $readini($mircini,n,$1,$2) }

;Initialize mdx
alias -l mdx { return $dll($qt($mdxdir $+ mdx.dll),$1,$2-) }
alias -l mdxdir { return $shortfn($mircdir $+ script/dlls/) }

;Initialize xml
alias -l xml { return $dll($xmldir $+ xml.dll,$1,$2-) }
alias -l xmldir { return $shortfn($mircdir $+ script/dlls/) }

;Initialize szip
alias -l szip { return $dll($szipdir $+ szip.dll,$1,$2-) }
alias -l szipdir { return $shortfn($mircdir $+ script/dlls/) }

;Initialize font dll for selecting fonts
alias -l fontdll { return $dll($fontdir $+ font.dll,Font,Select a font) }
alias -l fontdir { return $shortfn($mircdir $+ script/dlls/) }

; Return mdx listview cell value
alias -l cell { return $gettok($gettok($gettok($did($1,$2,$3),$4,9),$iif($4 = 1,6,5) $+ -,32),1,4) }

;Retourne l'index de couleurs de mirc.ini du scheme donné
;$1-: Nom du scheme
alias -l theme.colornum {
  var %i = 1
  while ($ini($mircini,colors,%i)) {
    var %m = $ifmatch

    if ($gettok($rmi(colors,%m),1,44) == $1-) { var %p = %m }
    inc %i
  }
  if (!%p) { return n $+ $calc($right(%m,-1) + 1) }
  return %p
}

; Retourne les options de chargement et de listing des themes
alias -l theme.options {
  if ($1 == load) {
    return $pfri(loadoptions)
  }
  if ($1 == add) {
    return $pfri(addoptions)
  }
  if ($1 == manager) {
    return $pfri(manageropt)
  }
}

; Return a ctrl+k base color
alias -l bc { 
  if ($1 isnum) && ($hgt(basecolors)) { 
    return  $+ $gettok($hgt(basecolors),$1,44) $+ 
  } 
}


;ces
;################# PARSING ################
;sec Parsing

; Recupere les informations du theme actuel
; theme.info(champ,fichier de theme), theme.info(scheme number,champ,fichier de theme), theme.info(scheme number,champ,fichier de theme)
alias theme.info {
  if (!$enabled(themes)) { return }
  if (!$isid) { return }
  if ($0 == 3) {
    if ($1 isnum) { var %s = $1,%e = $2,%f = $3 }
    else { var %s = 0,%e = $2,%f = $3 }
  }
  elseif ($0 == 2) { var %e = $1,%f = $2 }

  if (!$isfile(%f)) { return }
  if ($right(%f,4) == .mts) { var %t = m }
  elseif ($right(%f,4) == .nnt) { var %t = y }
  else { var %t = x }

  if (%t == m) {
    var %s = $iif(%s,%s,0)
    if ($fopen(parse)) { .fclose parse }
    .fopen parse $qt(%f)
    if ($ferr) { .fclose parse | return }

    ;Listage des noms de schemes
    if (%e == schemenames) {
      .fseek -w parse scheme*
      while (!$feof) {
        var %r = $fread(parse)
        if (scheme* iswm %r) { var %n = $addtok(%n,$gettok(%r,2-,32),59) }
        elseif ($+($chr(91),scheme*,$chr(93)) iswm $1) { .fclose parse | break }
      }
      .fclose parse | return %n
    }
    else {
      ; Si scheme fourni, place a l'endroit du scheme requis
      if (%s) { 
        .fseek -w parse $+($chr(91),scheme $+ %s,$chr(93)) 
        var %l = $fread(parse)
      }
      while (!$feof) {
        if ($fread(parse)) {
          tokenize 32 $ifmatch
          if ($1 == [mts]) || (!$1) || ($left($1,1) == $chr(59)) { continue }
          elseif ($+($chr(91),scheme*,$chr(93)) iswm $1) { .fclose parse | return }
          elseif ($1 == %e) { .fclose parse | return $2- }
        }
      }
    }
    if ($fopen(parse)) { .fclose parse }
  }
  elseif (%t == y) {
    var %s = $iif(%s,%s,0)
    if ($fopen(parse)) { .fclose parse }
    .fopen parse $qt(%f)
    if ($ferr) { .fclose parse | return }

    ;Listage des noms de schemes
    if (%e == schemenames) {
      ; On omet délibérément le scheme par défaut (0)
      .fseek -w parse Scheme0* | noop $fread(parse)
      while (!$feof) {
        var %r = $fread(parse)
        if (Scheme* iswm %r) { 
          var %new = $regml($regex(%r,/Scheme\d+ (\S+) \d/))
          var %n = $addtok(%n,%new,59) 
        }
      }
      .fclose parse | return %n
    }
    else {
      if (%s) { .fseek -w parse Scheme $+ %s $+ * }
      while (!$feof) {
        if ($fread(parse)) {
          tokenize 32 $ifmatch
          if ((!$1) || ($left($1,1) == $chr(59))) { continue }
          elseif ($1 == %e) { .fclose parse | return $2- }
          elseif ($lower($theme.mtsequiv($1)) == %e) { .fclose parse | return $2- }
        }
      }
    }
    if ($fopen(parse)) { .fclose parse }
  }
}


; Convert a nick to a color number
; $1: nick
alias -l nickToColor {
  var %i = 1, %col = 0
  while (%i <= $len($1)) {
    inc %col $mid($1,%i,1)
    inc %i
  }
  %col = %col % 16
  if (%col == 0) %col = 1
  elseif (%col == 8) %col = 7
  return %col
}

; Preparsing
alias -l theme.preparse {
  ; Eviter de perdre les espaces...
  if (!%::cmode) { set -nu %::cmode  }
  if (!%::kcmode) { set -nu %::kcmode  }
  if (!%::isoper) { set -nu %::isoper regular user }
}

;Parse un theme en remplacant les <champs>
; $1: type de theme (m, y), $2: ligne a parser
alias theme.parse {
  if (!$enabled(themes)) { return }
  if (!$isid) { return }

  theme.preparse  
  ; Coloriage des nicks
  if ($pfri(colors) == 1) { 
    if (%::nick) %::nick =  $+ $nickToColor(%::nick) $+ %::nick
    if (%::me) %::me =  $+ $nickToColor(%::me) $+ %::me
  }
  if ($1 == m) {
    var %t = $replace($2,<pre>,%::pre,<timestamp>,%::timestamp,<c1>,%::c1,<c2>,%::c2,<c3>,%::c3,<c4>,%::c4,<c5>,%::c5)
    var %t = $replace(%t,<me>,%::me,<server>,%::server,<port>,%::port,<nick>,%::nick,<chan>,%::chan,<address>,%::address,<me>,%::nick)
    var %t = $replace(%t,<cmode>,%::cmode,<cnick>,%::cnick,<target>,%::target,<knick>,%::knick,<kaddress>,%::kaddress,<newnick>,%::newnick)
    var %t = $replace(%t,<modes>,%::modes,<ctcp>,%::ctcp,<numeric>,%::numeric,<value>,%::value,<fromserver>,%::fromserver,<users>,%::users)
    var %t = $replace(%t,<away>,%::away,<realname>,%::realname,<isoper>,%::isoper,<operline>,%::operline,<isregd>,%::isregd)
    var %t = $replace(%t,<wserver>,%::wserver,<serverinfo>,%::serverinfo,<idletime>,%::idletime,<signontime>,%::signontime,<iaddress>,%::iaddress,<naddress>,%::naddress,<raddress>,%::raddress)
    var %t = $replace(%t,<file>,%::file,<path>,%::path,<size>,%::size,<sent>,%::sent,<rcvd>,%::rcvd,<bps>,%::bps,<percent>,%::percent,<secs>,%::secs,<resume>,%::resume)
    var %t = $replace(%t,<ts>,,<lt>,<,<gt>,>,<parentext>,%::parentext,<text>,% $+ ::text)
    return %t
  }
  elseif ($1 == y) {
    var %t = $2
    if ($2 == !empty) { haltdef }

    ; Conversion des !if (FIXME)
    while ($regex(thmps,%t,/!if (<[^>]+>) (.+)/i)) {
      var %v1 $regml(thmps,1), %v2 $regml(thmps,2)
      if ($theme.parse(y,%v1) != $null) { noop $regsub(%t,/!if (<[^>]+>) (.+)/i,\2,%t) }
      else { noop $regsub(%t,/!if (<[^>]+>) (.+)/i,,%t) }
    }
    ; Espacage automatique
    noop $regsub(%t,/([^ ])(<[^>]+>)([^ ])/g,\1 \$+ \2 \$+ \3,%t) $regsub(%t,/([^ ])(<[^>]+>)/g,\1 \$+ \2,%t) $regsub(%t,/(<[^>]+>)([^ ])/g,\1 \$+ \2,%t)
    ; Auto-evaluation des identifieurs mIRC
    while ($regsub(%t,/(^| )([\#\[\]\{\}])($| )/g,\1\$(\2 $+ $chr(44) $+ 0)\3,%t)) { }
    ; Conversion des align et brackets
    while ($regsub(prop,%t,/(<[^ >]+) align="(-?\d\d?)">/i,\$align(\1> $+ $chr(44) $+ \2),%t)) { }
    while ($regsub(prop,%t,/(<[^ >]+) (?:brackets="1" align="(-?\d\d?)"|align="(-?\d\d?)" brackets="1")>/i,\$theme.ptext(\$align(\1> $+ $chr(44) $+ \2)),%t)) { }
    while ($regsub(prop,%t,/(<[^ >]+) brackets="1">/i,\$theme.ptext(\1>),%t)) { }
    noop $regsub(prop,%t,/ \| /i,$chr(32) \$chr(124) $chr(32),%t)

    ; Remplacements des idenfitieurs simples
    var %t = $replace(%t,<c1>,%::c1,<c2>,%::c2,<c3>,%::c3,<c4>,%::c4,<c5>,%::c5,<pre>,%::pre,<timestamp>,%::timestamp,<linesep>,%::linesep)
    var %t = $replace(%t,<me>,%::me,<myaddress>,%::myaddress,<myhost>,%::myhost,<myident>,%::myident,<myport>,%::port,<myserver>,%::server,<mynetwork>,%::network,<note>,%::comments,<names>,%::text,<server>,%::server)
    var %t = $replace(%t,<nick>,%::nick,<chan>,%::chan,<address>,%::address,<clonenum>,$clones(%::address,%::chan),<clones>,$clonenames(%::address,%::chan),<comchannum>,$comchan(%::nick,0),<comchans>,$comchans(%::nick),<users>,%::users)
    var %t = $replace(%t,<oppedusers>,$nusers(op),<oppeduserspercent>,$nusers(op).percent,<hoppedusers>,$nusers(hop),<hoppeduserspercent>,$nusers(hop).percent,<voicedusers>,$nusers(voice),<voiceduserspercent>,$nusers(voice).percent,<regusers>,$nusers(reg),<reguserspercent>,$nusers(reg).percent)
    var %t = $replace(%t,<synctime>,,<topic>,%::text,<topicnick>,%::nick,<topicdate>,%::text)
    var %t = $replace(%t,<cmode>,%::cmode,<cme>, $+ %::cnick,<cnick>, $+ %::cnick,<cnickcolor>,%::cnick,<cmecolor>,%::cnick,<target>,%::target,<kickednick>,%::knick,<kickedaddress>,%::kaddress,<kickedcmode>,%::kcmode,<newnick>,%::newnick,<message>,%::text)
    var %t = $replace(%t,<mode>,%::modes,<ctcp>,%::ctcp,<numeric>,%::numeric,<value>,%::value,<fromserver>,%::fromserver)
    var %t = $replace(%t,<reason>,%::away,<name>,%::nick,<realname>,%::realname,<host>,%::server,<ident>,%::nick $+ @ $+ %::address,<status>,%::isoper,<operline>,%::operline,<isregd>,%::isregd,<auth>,%::text,<ip>,%::text,<info>,%::serverinfo)
    var %t = $replace(%t,<chans>,%::chan,<opchans>,$onchans(%::chan).op,<hopchans>,$onchans(%::chan).hop,<vchans>,$onchans(%::chan).voice,<regchans>,$onchans(%::chan).reg,<channum>,$numtok(%::chan,32),<chans hlcommon="1">,$onchans(%::chan).common)
    var %t = $replace(%t,<wserver>,%::wserver,<serverinfo>,%::serverinfo,<idle>,%::idletime,<signontime>,%::signontime,<signonago>,%::signonago,<iaddress>,%::iaddress,<naddress>,%::naddress,<raddress>,%::raddress,<version>,%::version,<usermodes>,%::usermodes,<chanmodes>,%::chanmodes,<protocols>,%::text)
    var %t = $replace(%t,<ban>,%::address,<banned>,$asctime(%::value),<bannedago>,$duration(%::value,2),<created>,%::created,<createdago>,$duration(%::created,2),<modes>,%::modes,<invisible>,%::invisible,<servers>,%::servers,<operators>,%::value,<connections>,%::value,<channels>,%::value,<clients>,%::clients,<date>,$asctime(%::text),<dateago>,$duration(%::text,2),<cmd>,%::value)
    var %t = $replace(%t,<ts>,,<lt>,<,<gt>,>,<text>,% $+ ::text)

    return %t
  }
  return $2
}

alias theme.ptext {
  if (!$1-) { return }
  if (!$enabled(themes)) { return ( $+ $1- $+ ) }
  if ($left($1-,1) == $lparen) && ($right($1-,1) == $rparen) { return $1- }
  if ($hget(theme.current,parentext)) {
    set -nu %::text $1-
    var %repl = $theme.parse(y,$ifmatch)
    ; %repl = $replace(%repl,<text>,$ $+ 1-)
    return [ [ %repl ] ]
  }
  else { return ( $+ $1- $+ ) }
}

;ces


;sec Printing theme and Sounds

;Assigne les variables de base
;$1- commande echo
alias theme.vars {
  if (!$enabled(themes)) { return }
  set -nu %:echo $1-
  set -nu %::me $me
  set -nu %::server $server
  set -nu %::network $network
  set -nu %::port $port
  set -nu %::target $target
  set -nu %::c1 $bc(1)
  set -nu %::c2 $bc(2)
  set -nu %::c3 $bc(3)
  set -nu %::c4 $bc(4)
  set -nu %::c5 $bc(5)
  set -nu %::pre $pre
  set -nu %::timestamp $time($theme.parse($iif($theme.current == mts,m,$iif($theme.current == nnt,y,x)),$hgt(timestampformat)))
  set -nu %::linesep $theme.parse($iif($theme.current == mts,m,$iif($theme.current == nnt,y,x)),$hgt(linesep)))
  set -nu %::myaddress $+($identd,@,$host)
  set -nu %::myhost $host
  set -nu %::myident $identd
}

;Ecrit un texte selon le format donné par le theme et les options
; $1 : theme event/raw number, $2: IRC event/type d'affichage, $3- text
alias theme.text {
  if (!$enabled(themes)) { return }
  ;Parenthesage
  if (%::text) { set -nu %::parentext $theme.ptext(%::text) }
  ;Event trouvé dans le theme?
  if ($1) { set -nu %:text $hgt($1) }
  ;Si Highlight et pas de format d'hl, utiliser le format de base
  if (!%:text) && ($1 == highlight) { set -nu %:text $hgt(textchan) }
  ; Si pas de format, imprimer tel quel
  if (!%:text) { set -nu %:text %::text }

  ;%e: type d'affichage
  if (RAW. isin $1) { var %e = $calc($2 + 1) }
  else { var %e = $gettok($hg(theme.event. $+ $2),1,32) }

  if (!%e) { %e = 3 }
  ; 1 : dont show any raw; 2: show the default raw; 3: show the theme raw; 4: show the custom defined raw/event
  if (%e == 1) { halt }
  elseif (%e == 2) || (!$theme.current) { goto end }
  elseif (%e == 3) {
    set -nu %:text $theme.parse($iif($theme.current == mts,m,$iif($theme.current == nnt,y,x)),%:text)
    if ($gettok(%:text,1,32) == !script) {
      if (!$gettok(%:text,2,32)) {
        if (raw. isin $1) { halt }
      }
      else { $eval($gettok(%:text,2-,32),2) }
    }
    else {
      ; NNT themes: conversion du $chr(1) pour ecrire plusieurs lignes
      if ($theme.current == nnt) {
        var %nlines = $numtok(%:text,1), %i = 1
        while (%i <= %nlines) { 
          set -nu %:stext [ [ $gettok(%:text,%i,1) ] ]
          set -nu %:stext $replace(%:stext,% $+ ::text,%::text)
          [ [ %:echo ] ] %:stext 
          inc %i 
        }
      }
      else { 
        set -nu %:text [ [ %:text ] ] 
        set -nu %:text $replace(%:text,% $+ ::text,%::text)
        [ [ %:echo ] ] %:text
      }
      ; while (%i <= %nlines) { $eval(%:echo,2) [ [ $gettok(%:text,%i,1) ] ] | inc %i }
      ; }
      ; else { $eval(%:echo,2) [ [ %:text ] ] }
    }
    haltdef
  }
  elseif (%e == 4) {
    if (RAW. isin $1) { var %h = $gettok($hg($hfind(theme.settings,theme.raw.*. $+ $gettok($1,2,46),1,w)),3-,32) }
    else { var %h = $gettok($hg(theme.event. $+ $2),2-,32) }

    set -nu %:text $theme.parse($iif($theme.current == mts,m,$iif($theme.current == nnt,y,x)),%:text)
    $eval(%h,2)
    haltdef
  }
  :end
}

; Joue le son de l'event
;$1: Event
alias theme.sound {
  if (!$enabled(themes)) { return }
  if (s !isin $theme.options(load)) { return }
  if (!$hgt(snd $+ $1)) { return }
  var %f = $shortfn($nofile($hgt(file))) $+ $hgt(snd $+ $1)
  if ($isfile(%f)) {
    if ($right(%f,4) == .wav) { var %p = -w }
    elseif ($right(%f,4) == .mid) { var %p = -m }
    elseif ($right(%f,4) == .mp3) { var %p = -p }
    .splay %p %f
  }
}

;ces

;################## MAIN DIALOG #####################
;sec Dialogs

dialog -l themes {
  title "Theme Engine MX"
  size -1 -1 230 160
  option dbu

  list 1, 2 2 65 100, size extsel
  list 2, 2 104 65 40, size
  button "&Charger", 3, 133 148 30 10, default
  button "&Décharg.", 4, 165 148 30 10
  button "&Fermer", 5, 198 148 30 10, cancel

  tab "Preview", 10, -20 -20 0 0
  tab "Information", 30
  tab "Appliquer", 50
  tab "RAW", 100

  list 21, 71 1 160 10, size
  text "", 17, 0 0 230 1
  text "", 18, 70 12 160 1
  text "", 19, 0 145 230 1
  text "", 20, 70 0 1 146

  text "Preview: aucun", 11, 77 17 80 8, tab 10
  button "&Preview", 12, 164 15 30 10, tab 10
  button "L&arge", 13, 196 15 30 10, tab 10
  box "", 14, 75 25 151 116, tab 10
  text "Pas de preview générée.", 15, 105 77 120 8, tab 10
  icon 16, 72 29 156 112, $mircexe, 0, border hide tab 10

  box "", 31, 75 14 151 14, tab 30
  text "Aucun thème sélectionné...", 32, 78 19 144 8, tab 30
  text "Nom:", 33, 78 34 30 8, tab 30
  text "", 34, 115 34 80 8, tab 30
  text "Version:", 35, 78 45 30 8, tab 30
  text "", 36, 115 45 80 8, tab 30
  text "Auteur:", 37, 78 56 30 8, tab 30
  text "", 38, 115 56 80 8, tab 30
  text "E-mail:", 39, 78 67 30 8, tab 30
  link "", 40, 115 67 80 8, tab 30
  text "Site Web:", 41, 78 77 30 8, tab 30
  link "", 42, 115 77 100 8, tab 30
  text "Description:", 44, 78 92 40 8, tab 30
  edit "", 43, 75 100 151 38, read multi vsbar tab 30

  text "Appliquer sur le thème choisi:", 51, 77 16 120 8, tab 50
  check "&Tout", 52, 192 16 35 8, tab 50
  check "&Polices", 53, 80 25 60 8, tab 50
  check "&Couleurs", 54, 80 33 60 8, tab 50
  check "&Sons", 55, 80 49 60 8, tab 50
  check "Couleurs de &Nicks", 56, 80 41 60 8, tab 50
  check "&Images de fond", 57, 150 25 70 8, tab 50
  check "I&mages Toolbar/Switchbar", 58, 150 33 70 8, tab 50
  check "Timest&amp", 59, 150 41 70 8, tab 50
  check "&Evènements", 60, 150 49 70 8, tab 50
  text "", 61, 73 60 155 1, tab 50

  text "Evènements:", 62, 77 63 100 8, tab 50
  list 63, 77 71 50 70, tab 50 size vsbar
  text "Description:", 64, 131 71 30 8, tab 50
  box "", 65, 130 76 96 20, tab 50
  text "Description de l'évènement", 66, 133 81 86 14, tab 50
  text "Action:", 67, 131 98 30 8, tab 50
  combo 68, 130 106 96 10, drop tab 50
  text "Format de l'évènement:", 69, 131 120 70 8, tab 50
  edit "", 70, 130 128 96 10, autohs tab 50

  text "Options des RAWS:", 101, 77 17 129 8, tab 100
  combo 102, 165 15 60 10, tab 100 drop
  text "", 103, 73 28 155 1, tab 100
  text "RAWs dispo:", 104, 77 32 50 8, tab 100
  list 105, 77 40 40 101, tab 100 size vsbar
  text "Description:", 106, 121 40 50 8, tab 100
  box "", 107, 120 45 106 34, tab 100
  text "Description de la RAW.", 108, 123 50 96 28, tab 100
  text "Afficher dans:", 109, 121 81 60 8, tab 100
  combo 110, 120 89 106 10, drop tab 100
  text "Action:", 111, 121 102 30 8, tab 100
  combo 112, 120 110 106 10, drop tab 100
  text "Format de la RAW:", 113, 121 121 70 8, tab 100
  edit "", 114, 120 129 106 10, autohs tab 100

  menu "&Fichier", 151
  item "&Ouvrir", 152, 151
  item "&Charger répertoire", 153, 151
  item break, 154, 151
  item "&Actualiser", 155, 151
  item "&Vider", 156, 151
  item break, 159, 151
  item "&Quitter", 160, 151

  menu "&Options", 171
  menu "&Chargement", 172, 171
  item "Charger tous les sc&hemes", 173, 172
  item break, 174, 172
  item "Afficher pro&gression", 175, 172
  item "&Effacer toutes les fenêtres", 176, 172
  item "&Minimiser tout", 177, 172
  item "&Décharger l'ancien thème", 178, 172

  menu "&Previews", 179, 171
  item "&Preview au clic", 180, 179
  item "Mettre en &cache", 181, 179
  item break, 182, 179
  item "&Vider le cache", 183, 179
  item break, 184, 171
  item "&Actualiser auto.", 185, 171
  item break, 186, 171
  item "Fenêtre de &bureau", 187, 171
  item "Toujours &visible", 188, 171  

  menu "&Edition", 201
  menu "&Dossiers", 202, 201
  item "Dossiers des &thèmes", 203, 202
  menu "&Listing", 207, 201
  item "Lister les thèmes &zippés", 222, 207
  item break, 223, 207
  item "&Nom du thème", 208, 207
  item "Nom de &fichier", 209, 207
  item break, 210, 207
  item "&Format (MTS)", 211, 207
  item "&Version", 212, 207
  item "Aucu&n", 213, 207
  item break, 214, 201
  item "&Colorier les pseudonymes", 215, 201
  item "&Remplacer police", 216, 201
  item "Rétablir &events par défaut", 219, 201
  item "Rétablir &raws par défaut", 220, 201

  menu "&Aide", 231
  item "&Aide", 232, 231
  item break, 233, 231
  item "A &Propos", 234, 231
}

on *:dialog:themes:*:*:{
  if ($devent == init) {
    mdx SetMircVersion $version
    mdx MarkDialog $dname
    mdx SetControlMDX $dname 1 ListView rowselect report single showsel sortascending noheader labeltip > $mdxdir $+ views.mdx
    mdx SetControlMDX $dname 21 ToolBar nodivider flat arrows list > $mdxdir $+ bars.mdx
    did -i $dname 1 1 headerdims 74:1 35:2 0:3
    did -i $dname 1 1 headertext Thème 	Format 	Fichier
    mdx SetColor $dname 43 background $rgb(hilight)
    mdx SetColor $dname 43 textbg $rgb(hilight)
    mdx SetColor $dname 43 text $rgb(text)
    mdx SetBorderStyle $dname 17,18,19,20,61,103 staticedge
    mdx SetBorderStyle $dname 21

    did -i $dname 21 1 bmpsize 16 16
    did -i $dname 21 1 setimage 0 icon small 0, $+ $shortfn($scriptdir) $+ icons.icl
    did -i $dname 21 1 setimage 0 icon small 1, $+ $shortfn($scriptdir) $+ icons.icl
    did -i $dname 21 1 setimage 0 icon small 2, $+ $shortfn($scriptdir) $+ icons.icl
    didtok -a $dname 21 59 +acgx 1 Preview;+acg 2 Information;+acg 3 Appliquer;+acg 3 RAW

    theme.list

    var %l = $theme.options(load)
    if (a isin %l) { did -c $dname 52 | did -b $dname 53,54,55,56,57,58,59,60 }
    if (f isin %l) { did -c $dname 53 }
    if (c isin %l) { did -c $dname 54 }
    if (s isin %l) { did -c $dname 55 }
    if (n isin %l) { did -c $dname 56 }
    if (b isin %l) { did -c $dname 57 }
    if (i isin %l) { did -c $dname 58 }
    if (t isin %l) { did -c $dname 59 }
    if (e isin %l) { did -c $dname 60 }

    didtok -a $dname 63 59 on INPUT;on TEXT;on ACTION;on NOTICE;on CHAT;on JOIN;on PART;on NICK;on QUIT;on NOTIFY;on UNOTIFY;on MODE;on DNS;on USERMODE;on ERROR;on SNOTICE;on INVITE;on TOPIC;on KICK;on RAWMODE;on WALLOPS;on CTCPREPLY;CTCP;on CONNECT;on CONNECTFAIL;on DISCONNECT;on START;on BAN;on UNBAN;on OP;on DEOP;on HELP;on DEHELP;on VOICE;on DEVOICE;on FILESENT;on FILERCVD;on SENDFAIL;on GETFAIL
    didtok -a $dname 68 59 Ne pas afficher;Format par défaut;Format du thème;Format personnalisé
    did -c $dname 63,68 1
    theme.opt.dispevent $did(63).seltext

    var %a = $theme.options(add)
    if (h isin %l) { did -c $dname 173 }
    if (g isin %a) { did -c $dname 175 }
    if (l isin %a) { did -c $dname 176 }
    if (w isin %a) { did -c $dname 177 }
    if (u isin %a) { did -c $dname 178 }

    var %m = $theme.options(manager)
    if (p isin %a) { did -c $dname 180 }
    if (c isin %a) { did -c $dname 181 }
    if (r isin %m) { did -c $dname 185 }
    if (d isin %m) { did -c $dname 187 }
    if (o isin %m) { did -c $dname 188 }
    if (z isin %m) { did -c $dname 222 }

    if ($pfri(listing) == name) { did -c $dname 208 | did -u $dname 209 }
    else { did -c $dname 209 | did -u $dname 208 }

    if ($pfri(format) == 1) { did -c $dname 211 | did -u $dname 212,213 }
    elseif ($pfri(format) == 2) { did -c $dname 212 | did -u $dname 211,213 }
    else { did -c $dname 213 | did -u $dname 211,212 }

    did $iif($pfri(colors) == 1,-c,-u) $dname 215
    did $iif($pfri(fontrep) == 1,-c,-u) $dname 216

    didtok -a $dname 102 59 Connexion;Join;Whois;Who;Mode;Error;Stats;Admin;Misc;All
    didtok -a $dname 110 59 Fenêtre définie ou fenêtre active;Fenêtre définie ou fenêtre de statut;Toujours fenêtre active;Toujours fenêtre de statut;Nulle part
    didtok -a $dname 112 59 Format par défaut;Format du thème;Format personnalisé
    did -c $dname 102,110,112 1
    theme.opt.listraw 1

    if (!$theme.current) { did -b $dname 4 }
  }
  if ($devent == sclick) {
    if ($did == 21) {
      var %b = $did(21).sel
      if (%b == 2) { did -f $dname 10 }
      elseif (%b == 3) { did -f $dname 30 }
      elseif (%b == 4) { did -f $dname 50 }
      elseif (%b == 5) { did -f $dname 100 }
    }
    if ($did == 1) && ($gettok($did(1,1),1,32) == sclick) { 
      if (p isin $theme.options(manager)) { 
        theme.preview $iif($did(2).sel > 1,$calc($did(2).sel - 1)) $cell(themes,1,$did(1).sel,3) 
      }
      theme.dispinfo $cell(themes,1,$did(1).sel,3) 
    }
    if ($did == 2) { 
      if (p isin $theme.options(manager)) { 
        theme.preview $iif($did(2).sel > 1,$calc($did(2).sel - 1)) $cell(themes,1,$did(1).sel,3) 
      } 
    }
    if ($did == 3) { 
      if (a isin $theme.options(load)) { var %loadoptions = fcnsbite }
      else { var %loadoptions = $theme.options(load) }
      if (a isin $theme.options(add)) { var %addoptions = hwlug }
      else { var %addoptions = $theme.options(add) }
      if (g isin %addoptions) { var %progress = 1 }

      $iif(%progress == 0,.) $+ theme.load - $+ %loadoptions $+ %addoptions $iif($did(2).sel != 1,$calc($did(2).sel - 1)) $cell(themes,1,$did(1).sel,3) 
    }
    if ($did == 4) {
      if (a isin $theme.options(add)) { var %addoptions = hwlug }
      else { var %addoptions = $theme.options(add) }
      if (g isin %addoptions) { var %progress = 1 }

      $iif(%progress == 0,.) $+ theme.unload - $+ %addoptions
    }
    if ($did == 12) && ($did(1).sel) { theme.preview $iif($did(2).sel > 1,$calc($did(2).sel - 1)) $cell(themes,1,$did(1).sel,3) }
    if ($did == 13) && ($did(1).sel) { theme.preview -l $iif($did(2).sel > 1,$calc($did(2).sel - 1)) $cell(themes,1,$did(1).sel,3) }
    if ($did == 40) && ($did(40)) { url -n $did(40) }
    if ($did == 42) && ($did(42)) { url -n $did(42) }

    if ($did == 52) {
      if ($did(52).state) { did -b $dname 53,54,55,56,57,58,59,60 }
      else { did -e $dname 53,54,55,56,57,58,59,60 }
      pfwi loadoptions $iif($did(52).state,fcnsbite,$theme.opt.checkoptions(load))
    }
    if ($did >= 53) && ($did <= 60) { 
      pfwi loadoptions $theme.opt.checkoptions(load)
    }

    if ($did == 63) { theme.opt.dispevent $did(63).seltext }
    if ($did == 68) {
      if ($did(68).sel == 4) { did -e $dname 69,70 }
      else { did -b $dname 69,70 }
      theme.opt.editevent -a $iif($did(63).seltext == CTCP,$ifmatch,$right($did(63).seltext,-3)) $did(68).sel
    }

    if ($did == 102) { theme.opt.listraw $did(102).sel }
    if ($did == 105) { 
      var %r = $iif($did(102).seltext == Connexion,con,$iif($lower($did(102).seltext) != all,$ifmatch)) 
      theme.opt.dispraw $iif(%r,%r $+ .) $+ $did(105).seltext 
    }
    if ($did == 110) {
      if ($did(110).sel == 5) { did -b $dname 111,112 }
      else { did -e $dname 111,112 }
      var %r = $iif($did(102).seltext == Connexion,con,$lower($did(102).seltext))
      theme.opt.editraw -d $iif(%r,%r $+ .) $+ $did(105).seltext $theme.opt.inforaw($did(110).sel)
    }
    if ($did == 112) {
      if ($did(112).sel == 3) { did -e $dname 113,114 | did -b $dname 109,110 }
      else { did -b $dname 113,114 | did -e $dname 109,110 }
      var %r = $iif($did(102).seltext == Connexion,con,$lower($did(102).seltext))
      theme.opt.editraw -a $iif(%r,%r $+ .) $+ $did(105).seltext $did(112).sel
    }
  }
  if ($devent == dclick) {
    if ($did == 1) || ($did == 2) { 
      if (a isin $theme.options(load)) { var %loadoptions = fcnsbite }
      else { var %loadoptions = $theme.options(load) }
      if (a isin $theme.options(add)) { var %addoptions = hwlug }
      else { var %addoptions = $theme.options(add) }
      if (g isin %addoptions) { var %progress = 1 }

      $iif(%progress == 0,.) $+ theme.load - $+ %loadoptions $+ %addoptions $iif($did(2).sel != 1,$calc($did(2).sel - 1)) $cell(themes,1,$did(1).sel,3)
    }
  }
  if ($devent == edit) {
    if ($did == 70) { theme.opt.editevent -f $iif($did(63).seltext == CTCP,$ifmatch,$right($did(63).seltext,-3)) $did(70) }
    if ($did == 114) {
      var %r = $iif($did(102).seltext == Connexion,con,$lower($did(102).seltext))
      theme.opt.editraw -f $iif(%r,%r $+ .) $+ $did(105).seltext $did(114)
    }
  }
  if ($devent == menu) {
    if ($did == 152) {
      var %f = $$sfile($scriptdir*.mts;*.nnt,Choisissez un thème,Choix de thème)
      theme.list -a %f
    }
    if ($did == 153) {
      var %f = $$sdir($scriptdir,Choisissez le répertoire des thèmes)
      var %m = $findfile(%f,*.mts;*.nnt,0,theme.list -a $1-)
    }
    if ($did == 155) { theme.list }
    if ($did == 156) { did -r $dname 1,2 }
    if ($did == 160) { dialog -x themes }

    if ($did == 173) || (($did >= 175) && ($did <= 178)) { did $iif($did($did).state,-u,-c) $dname $did | pfwi addoptions $theme.opt.checkoptions(add) }

    if ($did == 183) { theme.clearcache -p }
    if ($did == 180) || ($did == 181) || ($did == 185) || ($did == 187) || ($did == 188) { 
      did $iif($did($did).state,-u,-c) $dname $did
      pfwi manageropt $theme.opt.checkoptions(manager)
    }
    if ($did == 203) { $dialog(theme.folders,theme.folders,-4) }
    if ($did == 222) { 
      did $iif($did($did).state,-u,-c) $dname $did |
      pfwi manageropt $theme.opt.checkoptions(manager)
      theme.list 
    }
    if ($did == 208) { 
      did -c $dname 208 | did -u $dname 209 
      pfwi listing name
      theme.list 
    }
    if ($did == 209) { 
      did -c $dname 209 | did -u $dname 208 
      pfwi listing file
      theme.list 
    }
    if ($did == 211) { 
      did -c $dname 211 | did -u $dname 212,213 
      pfwi format 1
      theme.list 
    }
    if ($did == 212) { 
      did -c $dname 212 | did -u $dname 211,213 
      pfwi format 2
      theme.list 
    }
    if ($did == 213) { 
      did -c $dname 213 | did -u $dname 211,212 
      pfwi format 0
      theme.list 
    }
    if ($did == 215) { did $iif($did($did).state,-u,-c) $dname $did | pfwi colors $did($did).state }
    if ($did == 216) { 
      did $iif($did($did).state,-u,-c) $dname $did
      if ($did($did).state == 1) {
        var %newf = $dcx(FontDialog,default + ansi 9 $did(2242))
        if (%newf) { 
          tokenize 32 %newf
          var %fff = $buildtok(44,$5-,$4,$2)
          pfwi font %fff
        }
        else { did -u $dname $did | halt }
      }
      else { pfremi font }
      pfwi fontrep $did($did).state 
    }
    if ($did == 219) { if ($input(Etes-vous sûr de vouloir rétablir tous les évènements par défaut? $crlf $crlf $+ Toutes les modifications seront perdues.,yw,Theme Engine MX)) { theme.opt.restoreevents } }
    if ($did == 220) { if ($input(Etes-vous sûr de vouloir rétablir toutes les raws par défaut? $crlf $crlf $+ Toutes les modifications seront perdues.,yw,Theme Engine MX)) { theme.opt.restoreraws } }

    if ($did == 232) { themes help }
    if ($did == 234) { var %a = $input(Theme Engine MX version $themesversion $+ . $crlf $crlf $+ Written by Voice of Power - translated and corrected by Klarth $crlf $chr(32) $chr(32) $chr(32) Contact: mariosmilax@free.fr $crlf $crlf $+ Supported theme formats: $crlf $chr(32) $chr(32) $chr(32) MTS (mIRC Theme Standard) 1.3 - NNT (NNScript Themes) $crlf $crlf $+ Credits and other info in the help file.,io,Theme Engine MX) }
  }
  if ($devent == close) {
    window -c @theme.desc
    window -c @theme.filter
    window -c @theme.preview
    theme.clearcache -z
  }
}

; Retourne l'état des options cochées
; $1: load : options load, add: options add, manager: options manager
alias -l theme.opt.checkoptions {
  if ($1 == load) { return $iif($did(53).state,f) $+ $iif($did(54).state,c) $+ $iif($did(55).state,s) $+ $iif($did(56).state,n) $+ $iif($did(57).state,b) $+ $iif($did(58).state,i) $+ $iif($did(59).state,t) $+ $iif($did(60).state,e) }
  elseif ($1 == add) { return $iif($did(173).state,h) $+ $iif($did(175).state,g) $+ $iif($did(176).state,l) $+ $iif($did(177).state,w) $+ $iif($did(178).state,u) }
  elseif ($1 == manager) { return $iif($did(180).state,p) $+ $iif($did(181).state,c) $+ $iif($did(185).state,r) $+ $iif($did(187).state,d) $+ $iif($did(188).state,o) $+ $iif($did(222).state,z) }
}

; Affiche la description de l'evenement
; $1- Evenement
alias -l theme.opt.dispevent {
  if (!$window(@theme.desc)) { window -h @theme.desc }
  if (!$window(@theme.filter)) { window -h @theme.filter }
  clear @theme.desc
  loadbuf -tEvents @theme.desc $qt($datathemes(desc.src))
  var %e = $iif($1 == CTCP,$1,$2)

  filter -ww @theme.desc @theme.filter %e *
  if ($filtered) {
    tokenize 9 $line(@theme.filter,$line(@theme.filter,0))
    did -ra themes 66 $gettok($1,2-,32)
    did -c themes 68 $gettok($hg(theme.event. $+ %e),1,32)
    did $iif($gettok($hg(theme.event. $+ %e),1,32) == 4,-e,-b) themes 69,70
    did -ra themes 70 $gettok($hg(theme.event. $+ %e),2-,32)
  }
}

; Edition de l'evenement
; $1: options (-f: modifie le type d'affichage, -a: modifie l'affichage de l'evenement), $2 evenement, $3-: nouvelle valeur
alias -l theme.opt.editevent {
  var %o = $hg(theme.event. $+ $2)
  if (a isin $1) { ha theme.event. $+ $2 $3 $gettok(%o,2-,32) }
  elseif (f isin $1) { ha theme.event. $+ $2 $gettok(%o,1,32) $3- }
}

; Retablit les types d'affichage des evenements (cf desc.txt)
alias -l theme.opt.restoreevents {
  ha theme.event.ACTION 3 | ha theme.event.CHAT 3 | ha theme.event.CTCP 3 | ha theme.event.CTCPREPLY 3 | ha theme.event.DNS 3 
  ha theme.event.ERROR 3 | ha theme.event.INPUT 3 | ha theme.event.INVITE 3 | ha theme.event.SNOTICE 3 | ha theme.event.TEXT 3 
  ha theme.event.TOPIC 3 | ha theme.event.WALLOPS 3 | ha theme.event.JOIN 3 | ha theme.event.KICK 3 | ha theme.event.NICK 3 
  ha theme.event.NOTICE 3 | ha theme.event.NOTIFY 3 | ha theme.event.PART 3 | ha theme.event.QUIT 3 | ha theme.event.RAWMODE 3 
  ha theme.event.UNOTIFY 3 | ha theme.event.USERMODE 3 | ha theme.event.CONNECT 3 | ha theme.event.DISCONNECT 3 
  ha theme.event.MODE 3 | ha theme.event.CONNECTFAIL 3 | ha theme.event.START 3 | ha theme.event.BAN 3 | ha theme.event.UNBAN 3
  ha theme.event.VOICE 3 | ha theme.event.DEVOICE 3 | ha theme.event.OP 3 | ha theme.event.DEOP 3 | ha theme.event.HELP 3
  ha theme.event.DEHELP 3 | ha theme.event.FILESENT 3 | ha theme.event.FILERCVD 3 | ha theme.event.GETFAIL 3 | ha theme.event.SENDFAIL 3
}

; Rétablit les types d'affichage des raws (cf desc.src)
alias -l theme.opt.restoreraws {
  window -h @theme.restore
  loadbuf -tRaws @theme.restore $qt($datathemes(desc.src))
  var %l = $line(@theme.restore,0),%i = 1
  if (%l == 0) { $errdialog(Le fichier desc.src est manquant ou incorrect. Veuillez réinstaller le script) | return }
  while (%i <= %l) {
    if ($line(@theme.restore,%i)) { ha theme.raw. $+ $gettok($ifmatch,1-2,32) 2 }
    inc %i
  }
  window -c @theme.restore
}

; Créé la liste des descriptions des raws
;$1: type de raw
alias -l theme.opt.listraw {
  did -ra themes 105 All
  if ($1 == 1) { 
    didtok -a themes 105 59 001;002;003;004;005;221;250;251;252;253;254;255;265;266;372;375;376;391 | var %r = con 
  }
  elseif ($1 == 2) { 
    didtok -a themes 105 59 331;332;333;353;366;471;473;474;475 | var %r = join 
  }
  elseif ($1 == 3) { 
    didtok -a themes 105 59 301;307;311;312;313;314;317;318;319;330;338;369;406;431 | var %r = whois 
  }
  elseif ($1 == 4) { 
    didtok -a themes 105 59 315;352;416 | var %r = who 
  }
  elseif ($1 == 5) { 
    didtok -a themes 105 59 324;329;367;368;467;472;478;484;501;502 | var %r = mode 
  }
  elseif ($1 == 6) { 
    didtok -a themes 105 59 263;401;403;404;405;411;421;432;433;436;437;442;451;481;482 | var %r = error 
  }
  elseif ($1 == 7) { 
    didtok -a themes 105 59 211;212;213;214;215;216;217;218;219;223;243;244;247;248;249 | var %r = stats 
  }
  elseif ($1 == 8) { 
    didtok -a themes 105 59 256;257;258;259;423 | var %r = admin 
  }
  elseif ($1 == 9) { 
    didtok -a themes 105 59 006;007;271;272;302;303;305;306;323;381;382;438;443;600;601;603;604;606 | var %r = misc 
  }
  elseif ($1 == 10) { 
    didtok -a themes 105 59 001;002;003;004;005;006;007;212;213;214;215;216;217;218;219;221;223;243;244;247;248;249;250;251;252;253;254;255;256;257;258;259;263;265;266;271;272;301;302;303;305;306;307;311;312;313;314;315;317;318;319;323;330;331;332;333;338;352;353;366;369;372;375;381;382;391;401;403;404;405;406;411;416;421;423;431;432;433;436;437;438;442;443;451;471;473;474;475;481;482;483;600;601;603;604;606 
  }

  if (!$window(@theme.desc)) { window -h @theme.desc }
  if (!$window(@theme.filter)) { window -h @theme.filter }
  clear @theme.desc
  loadbuf -tRaws @theme.desc $qt($datathemes(desc.src))
  did -c themes 105 1
  theme.opt.dispraw $iif(%r,%r $+ .) $+ $did(105).seltext
}

;Affiche la description de la raw
;$1: raw selectionnée
alias -l theme.opt.dispraw {
  filter -ww @theme.desc @theme.filter $iif(($numtok($1,46) == 2) || ($gettok($1,1,46) == All),$1,*. $+ $1) *
  if ($filtered) {
    tokenize 32 $line(@theme.filter,$line(@theme.filter,0))
    did -ra themes 108 $3-
    did -c themes 110 $theme.opt.inforaw($gettok($hg(theme.raw. $+ $1),1,32))
    did -c themes 112 $gettok($hg(theme.raw. $+ $1),2,32)

    if ($did(themes,110).sel == 5) { did -b themes 111,112,113,114 | did -e themes 109,110 }
    else {
      did -e themes 110,111,112
      if ($did(themes,112).sel == 3) { did -b themes 109,110 | did -e themes 113,114 }
      else { did -e themes 109,110 | did -b themes 113,114 }
    }

    did -ra themes 114 $gettok($hg(theme.raw. $+ $1),3-,32)
  }
}

; Edite une raw
; $1: options, $2: nom de la raw (sous la forme type.numero)
alias -l theme.opt.editraw {
  ; Récupération de la raw dans la table des settings
  if ($gettok($2,1,46) != all) { var %r = $2 }
  elseif ($gettok($2,2,46) == all) { var %r = all }
  else {
    var %h = $hfind(theme.settings,theme.raw.*. $+ $gettok($2,2,46),1,w)
    var %r = $gettok(%h,3-,46)
  }

  if (all isin %r) {
    var %h = $hfind(theme.settings,theme.raw. $+ $iif(%r == all,*,$gettok(%r,1,46) $+ .*),0,w),%i = 1
    while (%i <= %h) {
      var %t = $hfind(theme.settings,theme.raw. $+ $iif(%r == all,*,$gettok(%r,1,46) $+ .*),%i,w),%o = $hg(%t)
      if (d isin $1) { ha %t $3 $gettok(%o,2-,32) }
      elseif (a isin $1) { ha %t $gettok(%o,1,32) $3 $gettok(%o,3-,32) }
      elseif (f isin $1) { ha %t $gettok(%o,1-2,32) $3- }
      inc %i
    }
  }
  else {
    var %o = $hg(theme.raw. $+ %r)
    if (d isin $1) { ha theme.raw. $+ %r $3 $gettok(%o,2-,32) }
    elseif (a isin $1) { ha theme.raw. $+ %r $gettok(%o,1,32) $3 $gettok(%o,3-,32) }
    elseif (f isin $1) { ha theme.raw. $+ %r $gettok(%o,1-2,32) $3- }
  }
}

; Get the info for the raws
alias -l theme.opt.inforaw {
  if ($1 == 5) { return 0 }
  if ($1 == 4) { return 1 }
  if ($1 == 3) { return 2 }
  if ($1 == 2) { return 3 }
  if ($1 == 1) { return 4 }
  return 5
}


; Affiche la liste des themes contenus dans les dossiers de themes
; $1: options (-a: ajout), $2: fichier de theme
alias -l theme.list {
  if ($dialog(themes)) {
    if ($1 == -a) && ($isfile($2-)) {
      ;Verifie que les infos de bases sont renseignées (name, version)
      if ($right($2-,4) == .mts) && ($theme.info(mtsversion,$2-)) && ($theme.info(name,$2-)) { var %n = $ifmatch,%t = MTS }
      elseif ($right($2-,4) == .nnt) && ($theme.info(nntversion,$2-)) && ($theme.info(name,$2-)) { var %n = $ifmatch,%t = NNT }
      elseif (z isin $theme.options(manager)) { var %n = $left($nopath($2-),-4),%t = ZIP }
      else { var %n = unknown,%t = XXX }

      if ($pfri(listing) == file) { var %n = $nopath($2-)) }
      if ($pfri(format) == 2) { var %t = $theme.info(version,$2-) }

      ;Ajout de la ligne
      did -a themes 1 0 0 0 0 %n 	0 0 0 %t 	0 0 0 $2-
    }
    else {
      did -r themes 1
      if ($pfri(format) == 1) { did -i $dname 1 1 headerdims 74:1 35:2 0:3 }
      elseif ($pfri(format) == 2) { did -i $dname 1 1 headerdims 72:1 37:2 0:3 }
      else { did -i $dname 1 1 headerdims 109:1 0:2 0:3 }

      var %i = 1
      while ($themesdir(%i)) {
        var %f = $ifmatch
        var %m = $findfile(%f,*.mts,0,theme.list -a $1-)
        var %y = $findfile(%f,*.nnt,0,theme.list -a $1-)
        if (z isin $theme.options(manager)) { var %z = $findfile(%f,*.zip,0,theme.list -a $1-) }

        ; Selection automatique du theme actuel
        if (!$did(themes,1).sel) && ($hgt(file)) {
          if (%f isin $hgt(file)) { did -c themes 1 $didwm(themes,1,* $hgt(file)) }
          elseif ($scriptdirextracted\ isin $hgt(file)) { did -c themes 1 $didwm(themes,1,* $+ $left($nopath($hgt(file)),-4) $+ .zip) }
        }
        inc %i
      }
      if (!$did(themes,1).sel) { did -c themes 1 2 }
      theme.dispinfo $cell(themes,1,$did(themes,1).sel,3)
    }
  }
}

; Affiche les infos de base du theme
; $1: options (-p: afficher preview) et $2- : fichier de theme, sinon $1-
alias -l theme.dispinfo {
  if ($1 == -p) { var %f = $2- }
  else { var %f = $1- }

  if ($right(%f,4) == .mts) { var %t = m }
  elseif ($right(%f,4) == .nnt) { var %t = y }
  elseif ($right(%f,4) == .zip) { var %t = z }
  else { var %t = x }

  if ($dialog(themes)) && ($isfile(%f)) {
    if (%t == z) {
      ;Dezippage
      var %z = $scriptdirextracted\ $+ $left($nopath(%f),-4) $+ \
      ha theme.extract $+(disp,	,%f,	,%z)
      if (!$isdir(%z)) { szip SUnZipFile %f > %z }
      else { .signal SZIP Z_OK %f }
      return
    }
    ; Check basique
    elseif (%t == m) && (($theme.info(mtsversion,%f) > $mtsversion) || ($theme.info(mtsversion,%f) < 1.0) || (!$theme.info(mtsversion,%f)) || (!$theme.info(name,%f))) { var %e = 1 }
    elseif (%t == y) && ((!$theme.info(nntversion,%f)) || (!$theme.info(name,%f))) { var %e = 1 }


    did -ra themes 32 $shorten(55,%f).cutpath
    if (%e) {
      did -b themes 2,3,12,13,33,34,35,36,37,38,39,40,41,42,43,44
      did -r themes 36,38,40,42,43
      did -ra themes 34 (fichier de thème invalide)
      did -ra themes 2 Défaut
      did -c themes 2 1
    }
    else {
      did -e themes 2,3,12,13,33,34,35,36,37,38,39,40,41,42,43,44
      did -ra themes 34 $theme.info(name,%f)
      did -ra themes 36 $theme.info(version,%f) ( $+ $iif(%t == m,MTS,$iif(%t == y,NNT,XXX)) standard v $+ $theme.info( $+ $iif(%t == m,mts,$iif(%t == y,nnt,def)) $+ version,%f) $+ )
      did -ra themes 38 $theme.info(author,%f)
      did -ra themes 40 $theme.info(email,%f)
      did -ra themes 42 $theme.info(website,%f)

      if (%t == m) || (%t == y) {
        did -ra themes 43 $theme.info(description,%f)
        did -ra themes 2 Défaut
        var %i = 1,%s = $theme.info(schemenames,%f)
        while ($gettok(%s,%i,59)) { did -a themes 2 $ifmatch | inc %i }
      }

      did -c themes 2 1
      if ($did(themes,2).lines > 1) { did -e themes 2 }
      else { did -b themes 2 }

      if ($pfwi(scheme)) { did -c themes 2 $didwm(themes,2,$ifmatch) }
      else { did -c themes 2 1 }

      if ($1 == -p) || (p isin $theme.options(add)) || (a isin $theme.options(add)) { theme.preview $iif($did(themes,2).sel > 1,$calc($did(themes,2).sel - 1)) %f }
    }
  }
}

; Clear the cache previews
alias -l theme.clearcache {
  if ((p isin $1) || (!$1)) && ($findfile($scriptdirpreview\,*.bmp,0)) {
    if ($input(Etes vous sûr de vouloir effacer le cache? $crlf $crlf $+ Il y'a actuellement $ifmatch previews en cache.,yw,Theme Engine MX)) {
      did -ra themes 11 Preview: none | did -h themes 16 | did -v themes 14,15
      var %p = $findfile($scriptdirpreview\,*.bmp,0,.remove " $+ $1- $+ ")
    }
  }
  if ((z isin $1) || (!$1)) && ($finddir($scriptdirextracted\,*,0)) {
    var %i = $ifmatch
    if ($dll(szip.dll)) { dll -u $ifmatch }

    while ($finddir($scriptdirextracted\,*,%i)) {
      var %f = $ifmatch $+ \
      if ($nofile($hgt(file)) isin %f) { 
        dec %i 
        if (%i == 0) { break } 
        else { continue } 
      }
      var %d = $findfile(%f,*,0,.remove " $+ $1- $+ ")
      .rmdir " $+ %f $+ "
      dec %i
      if (%i == 0) { break }
    }
  }
}

;Dezippage
on *:SIGNAL:SZIP:{
  if ($1 == Z_OK) && ($hg(theme.extract)) {
    var %a = $gettok($ifmatch,1,9),%z = $gettok($ifmatch,2,9),%f = $gettok($ifmatch,3,9),%o = $gettok($ifmatch,4,9)
    if ($2- == %z) && ($findfile(%f,*.mts;*.nnt,1,var %t = $1-)) {
      if (%a == disp) { theme.dispinfo %t }
      elseif (%a == load) { theme.load %o %t }
      elseif (%a == preview) { theme.preview %o %t }
    }
    hdel theme.settings theme.extract
  }
}


dialog -l theme.folders {
  title "Répertoires de thèmes"
  size -1 -1 150 99
  option dbu

  list 1, 2 2 146 85, size extsel
  button "&Ajouter", 2, 2 88 25 10
  button "&Supprimer", 3, 29 88 30 10
  button "&Ok", 4, 86 88 30 10, ok default
  button "&Cancel", 5, 118 88 30 10, cancel
}
on *:dialog:theme.folders:*:*:{
  if ($devent == init) {
    mdx SetMircVersion $version
    mdx MarkDialog $dname
    mdx SetControlMDX $dname 1 ListView rowselect report single showsel labeltip > $mdxdir $+ views.mdx
    did -i $dname 1 1 headerdims 211:1 60:2
    did -i $dname 1 1 headertext Répertoire 	Nb Thèmes

    var %i = 1
    while ($themesdir(%i)) {
      var %f = $ifmatch,%m = $findfile(%f,*.mts;*.nnt,0),%z = $findfile(%f,*.zip,0)
      did -a $dname 1 0 0 0 0 %f 	0 0 0 $calc(%m + %z)
      inc %i
    }
  }
  if ($devent == sclick) {
    if ($did == 2) {
      var %f = $shortfn($$sdir($mircdir,Choix d'un répertoire de thèmes))
      var %m = $findfile(%f,*.mts;*.nnt,0)
      did -a $dname 1 0 0 0 0 %f 	0 0 0 $calc(%m + %z)
    }
    if ($did == 3) {
      var %d = $$input(Voulez vous vraiment supprimer le répertoire de thèmes: $crlf $crlf $+ $cell($dname,1,$did(1).sel,1),wy,Répertoire de thèmes)
      did -d $dname 1 $did(1).sel
    }
    if ($did == 4) {
      var %f = 2
      var %folds
      pfremi folders
      while ($did(1,%f)) {
        var %a = $gettok($gettok($ifmatch,6-,32),1,9)
        %folds = $addtok(%folds,%a,59)
        pfwi folders %folds
        inc %f
      }
      theme.list
    }
  }
}
;ces

;############## LOADING AND UNLOADING ##################

;sec Loading and unloading themes

; Load un theme
; Si $0 >= 2 et $2 est un nombre, $1 = options, $2: scheme, $3: theme file
; Si $0 >= 2 et $2 un string, $1 = options et $2: theme file
; Sinon si $1 est un nombre, $1: scheme et $2: theme file
; Sinon $1: theme file
alias theme.load {
  if (!$enabled(themes)) { $infodialog(La fonctionnalité des themes est désactivée.Réactivez-la d'abord.) | return }
  var %fl,%s,%f
  if ($left($1,1) == -) { 
    if ($2 isnum) { %s = $2 | %f = $3- } 
    else { %f = $2- } 
  }
  elseif ($1 isnum) { %s = $1 | %f = $2- }
  else { %f = $1- }

  if ($right(%f,4) == .mts) { %fl = m }
  elseif ($right(%f,4) == .nnt) { %fl = y }
  elseif ($right(%f,4) == .zip) { %fl = z }
  else { %fl = x }

  ;Options
  %fl = %fl $+ $iif(a isin $1,fcnsbite) $+ $right($1,-1)

  if (%s) { %s = scheme $+ %s }
  else { %s = $iif(m isin %fl,mts,$iif(y isin %fl,0)) }

  if ($isfile(%f)) {

    ;; STEP ONE: VERSION CHECKING / UNZIPPING
    if (z isin %fl) {
      var %z = $scriptdirextracted\ $+ $left($nopath(%f),-4) $+ \
      ha theme.extract $+(load,	,%f,	,%z,	,$iif($remove(%fl,m,y,z),- $+ $ifmatch) $iif($2 isnum,$2))
      if (!$isdir(%z)) { szip SUnZipFile %f > %z }
      else { .signal SZIP Z_OK %f }
      return
    }
    elseif (m isin %fl) && ($theme.info(mtsversion,%f) > $mtsversion) {
      var %v = $$input(Ce thème est invalide $+ $chr(44) il est de version MTS $ifmatch $+ . Or, cet outil ne prend en compte que jusqu'à la version $mtsversion $+ $chr(44). $crlf $crlf $+ Continuer quand même?,yvwd,Version invalide)
      if (%v == $no) { return }
    }
    if ($dialog(themes)) { did -b themes 3 }
    if ($dialog(theme.load)) { dialog -x theme.load }
    if ($show) { dialog -m theme.load theme.load }
    theme.load.show 3 1 0 2
    if (w isin %fl) { wins -n }
    if (l isin %fl) { scid -a clearall }
    theme.load.show 2 1 0 11
    theme.load.show 3 2 0 2

    ;; STEP TWO: UNLOADING OLD THEME
    theme.load.show 1 Déchargement du thème actif
    if (u isin %fl) && ($theme.current) { .theme.unload }
    elseif ($script($hgt(script))) { .unload -rsn " $+ $hgt(script) $+ " }

    if ($dialog(theme.load)) { dialog -t theme.load Chargement du thème... }
    theme.load.show 2 2 0 11

    ;; STEP THREE: LOADING HASH TABLE THEME
    theme.load.show 3 0 0 2
    theme.load.show 1 Generation du thème
    if ($hget(theme.current)) { hfree theme.current }
    hmake theme.current 100
    theme.load.show 3 1 0 2
    hat file %f

    ; Scheme choisi
    var %schemeinfo = $theme.info(%s,%f)
    if (y isin %fl) { %schemeinfo = $regml($regex(%schemeinfo,/(\S+) \d/)) }
    hat scheme %schemeinfo

    theme.load.hash $iif(h isin %fl,-h) %f

    theme.load.show 2 3 0 11
    theme.load.show 3 2 0 2

    ;; STEP FOUR: SCHEME OVERLAY
    theme.load.show 3 0 0 1
    theme.load.show 1 Chargement des schemes
    if ($hgt(scheme)) { theme.load.hash $right(%s,-6) %f }
    if (!$hgt(colors)) { hat colors $cdef }
    if (!$hgt(rgbcolors)) { hat rgbcolors $rgbdef }
    hsave -o theme.current $qt($datathemes(current.src))
    theme.load.show 2 4 0 11

    ;; STEP FIVE: LOADING SCRIPT (ONLY IN MTS)
    theme.load.show 3 0 0 3
    theme.load.show 1 Chargement des scripts
    if (m isin %fl) { hat script $nofile(%f) $+ $hgt(script) }
    theme.load.show 3 1 0 3
    if ($isfile($hgt(script))) { .load -rs " $+ $hgt(script) $+ " }
    theme.load.show 3 2 0 3
    theme.vars

    theme.load.show 2 5 0 11
    theme.load.show 3 3 0 3

    ;; STEP SIX: TIMESTAMP APPLYING
    theme.load.show 3 0 0 2
    if (t isin %fl) {
      theme.load.show 1 Chargement du timestamp
      if (m isin %fl) { .timestamp $iif($hgt(timestamp),$ifmatch,ON) }
      elseif (y isin %fl) { .timestamp $iif($hgt(timestamp),$replace($ifmatch,1,ON,0,OFF),ON) }
      theme.load.show 3 1 0 2
      .timestamp -f $iif($theme.parse($iif(m isin %fl,m,$iif(y isin %fl,y,x)),$hgt(timestampformat)),$v1,[HH:nn:ss])
    }
    else { .timestamp on | .timestamp -f [HH:nn:ss] }

    theme.load.show 2 6 0 11
    theme.load.show 3 2 0 2

    ;; STEP SEVEN: LOAD EVENT (ONLY IN MTS)
    theme.load.show 1 Application de l'évènement load
    theme.load.show 3 0 0 1

    if (m isin %fl) && ($hgt(load)) {
      theme.vars echo $color(info) $+(-at,$iif($hgt(indent),i $+ $ifmatch,i12))
      if ($gettok($hgt(load),1,32) == !script) { $eval($gettok( [ $hgt(load) ] ,2-,32),2) }
      else { %:echo $theme.parse(m,$hgt(load)) }
    }
    theme.load.show 2 7 0 11
    theme.load.show 3 1 0 1

    ;; STEP EIGHT: COLOR LOADING
    theme.load.show 3 0 0 15
    if (c isin %fl) {
      theme.load.show 1 Chargement des couleurs
      .theme.load.resetcolors

      ;Charger tous les schemes
      if (h isin %fl) {
        var %c = 1
        while ($gettok($hgt(rgbcolors.theme),%c,32) != $null) {
          var %r = %r $+ , $+ $rgb( [ $theme.load.color($ifmatch) ] )
          inc %c
        }
        wmi palettes $theme.colornum($hgt(name)) $right(%r,-1)
        hat rgbpalette.theme $right(%r,-1)

        if (m isin %fl) {
          var %c = $hgt(colors.theme)
          if ($numtok(%c,44) == 26) { var %c = %c $+ , $+ $gettok(%c,-1,44) }
          if ($numtok(%c,44) == 27) { var %c = %c $+ , $+ $gettok(%c,22,44) }
          wmi colors $theme.colornum($hgt(name)) $hgt(name) $+ , $+ %c
          hat colorspalette.theme $hgt(name) $+ , $+ %c
        }
        elseif (y isin %fl) {
          var %c = 1,%g = $hgt(colors.theme)
          while ($gettok(%g,%c,32) != $null) {
            var %rc = %rc $+ , $+ $ifmatch
            inc %c
          }
          wmi colors $theme.colornum($hgt(name)) $hgt(name) $+ %rc
          hat colorspalette.theme $hgt(name) $+ %rc
        }

        var %i = 1,%s = $hgt(schemenames)
        while ($gettok(%s,%i,59)) {
          var %n = $ifmatch
          var %c = 1,%r,%g = $iif($hgt(rgbcolors.scheme $+ %i),$ifmatch,$hgt(rgbcolors.theme))
          while ($gettok(%g,%c,32) != $null) {
            var %r = %r $+ , $+ $rgb( [ $theme.load.color($ifmatch) ] )
            inc %c
          }

          wmi palettes $theme.colornum($hgt(name) - %n) $right(%r,-1)
          hat rgbpalette.scheme $+ %i $right(%r,-1)

          if (m isin %fl) {
            var %c = $iif($hgt(colors.scheme $+ %i),$ifmatch,$hgt(colors.theme))
            if ($numtok(%c,44) == 26) { var %c = %c $+ , $+ $gettok(%c,-1,44) }
            if ($numtok(%c,44) == 27) { var %c = %c $+ , $+ $gettok(%c,22,44) }
            wmi colors $theme.colornum($hgt(name) - %n) $hgt(name) - %n $+ , $+ %c
            hat colorspalette.scheme $+ %i $hgt(name) - %n $+ , $+ %c
          }
          elseif (y isin %fl) {
            var %c = 1,%g = $iif($hgt(colors.scheme $+ %i),$ifmatch,$hgt(colors.theme))
            while ($gettok(%g,%c,32) != $null) {
              var %rc = %rc $+ , $+ $ifmatch
              inc %c
            }
            wmi colors $theme.colornum($hgt(name) - %n) $hgt(name) - %n $+ %rc
            hat colorspalette.scheme $+ %i $hgt(name) - %n $+ %rc
          }

          theme.load.show 3 %i 0 $numtok(%s,59)
          inc %i
        }

        .color -ls $hgt(name) $iif($hgt(scheme),- $hgt(scheme))
      }
      else {
        ;Creation de la palette de couleurs
        var %c = 1,%g = $hgt(rgbcolors)
        while ($gettok(%g,%c,32) != $null) {
          var %r = %r $+ , $+ $rgb( [ $theme.load.color($ifmatch) ] )
          inc %c
        }
        wmi palettes $theme.colornum($hgt(name)) $right(%r,-1)
        hat rgbpalette.theme $right(%r,-1)

        if (m isin %fl) {
          var %c = $hgt(colors)
          if ($numtok(%c,44) == 26) { var %c = %c $+ , $+ $gettok(%c,-1,44) }
          if ($numtok(%c,44) == 27) { var %c = %c $+ , $+ $gettok(%c,22,44) }
          wmi colors $theme.colornum($hgt(name)) $hgt(name) $+ , $+ %c
          hat colorspalette.theme $hgt(name) $+ , $+ %c
        }
        elseif (y isin %fl) {
          var %c = 1,%g = $hgt(colors)
          while ($gettok(%g,%c,32) != $null) {
            var %rc = %rc $+ , $+ $ifmatch
            inc %c
          }
          wmi colors $theme.colornum($hgt(name)) $hgt(name) $+ %rc
          hat colorspalette.theme $hgt(name) $+ %rc
        }

        .color -ls $hgt(name)
      }
    }
    theme.load.show 2 8 0 11

    ;; STEP NINE: NICKLIST COLOR APPLYING
    theme.load.show 3 0 0 1
    if (n isin %fl) {
      theme.load.show 1 Chargement des couleurs de nicks
      theme.load.show 3 1 0 1
      theme.remnickcolors
      theme.load.show 3 2 0 2
      theme.load.nicks m0 clineme
      theme.load.show 3 8 0 3
      theme.load.nicks m0 clineowner .
      theme.load.show 3 3 0 4
      theme.load.nicks m0 clineop @
      theme.load.show 3 4 0 5
      theme.load.nicks m0 clinehop %
      theme.load.show 3 5 0 6
      theme.load.nicks m0 clinevoice +
      theme.load.show 3 6 0 7
      theme.load.nicks m0 clineregular
      theme.load.show 3 7 0 8
      theme.load.nicks ovpym0 clinefriend
      theme.load.show 3 9 0 9
      theme.load.nicks im0 clineenemy
      theme.load.show 3 10 0 10
      theme.load.nicks m0 clineircop
      theme.load.show 3 11 0 11
    }
    theme.load.show 2 9 0 11


    ;; STEP TEN: FONT APPLYING
    theme.load.show 3 0 0 1
    if (f isin %fl) {
      theme.load.show 1 Chargement des polices
      remmi fonts
      theme.load.show 3 1 0 3
      if (y isin %fl) { 
        var %font = $iif($hgt(font),$ifmatch,Arial), %fs = $iif($hgt(fontsize),$ifmatch,11)
        hat fontdefault $+(%font,$chr(44),%fs)
      }
      if (!$hgt(fontchan)) { hat fontchan $hgt(fontdefault) }
      if (!$hgt(fontquery)) { hat fontquery $hgt(fontdefault) }

      var %l = 1,%n
      while (%l <= 3) {
        if (%l == 1) { %n = default }
        elseif (%l == 2) { %n = chan }
        else { %n = query }

        if ($hgt(font $+ %n)) {
          var %font = $ifmatch,%i = 1

          while ($gettok(%font,%i,59)) {
            var %fnt = $gettok($ifmatch,1,44),%size = $gettok($ifmatch,2,44),%bold = $gettok($ifmatch,3,44)
            if ($isfont(%fnt)) { theme.load.font %n %fnt %size %bold | break }
            else { 
              var %install = $input(La police %fnt n'est pas disponible sur votre système. Voulez vous la télécharger?,yqa)
              if (%install) { run http://www.dafont.com/search.php?psize=m&q= $+ %fnt | halt }
            }
            inc %i
          }
        }
        inc %l
      }
    }
    else { theme.load.resetfont }
    theme.load.show 2 10 0 11
    theme.load.show 3 3 0 3

    ;; STEP ELEVEN: BACKGROUND IMAGES APPLYING (MTS ONLY)
    theme.load.show 3 0 0 1
    theme.load.resetback
    if (m isin %fl) {
      if (b isin %fl) {
        theme.load.show 1 Chargement des images de fond
        remmi background

        if ($hgt(imagestatus)) { theme.load.background status $ifmatch }
        if ($hgt(imagechan)) { theme.load.background chan $ifmatch }
        if ($hgt(imagequery)) { theme.load.background query $ifmatch }
      }
      if (i isin %fl) {
        theme.load.show 1 Chargement des images de mIRC
        if ($hgt(imagemirc)) { theme.load.background mirc $ifmatch }
        if ($hgt(imagetoolbar)) { theme.load.background toolbar $ifmatch }
        if ($hgt(imagebuttons)) { theme.load.background buttons $ifmatch }
        if ($hgt(imageswitchbar)) { theme.load.background switchbar $ifmatch }
      }
    }
    theme.load.show 2 11 0 11
    theme.load.show 3 4 0 4

    ; Sauvegarde theme
    if (w isin %fl) { wins -r }
    if ($dialog(theme.load)) { dialog -x theme.load }
    if ($dialog(themes)) { did -e themes 3,4 }
    pfwi theme $hgt(name)
    pfwi scheme $iif($hgt(scheme),$ifmatch,Défaut)
    .signal themeChange $hgt(name)
  }
  else { themes }
}

;Read all the theme properties and store them in the hashtable
alias -l theme.load.hash {
  if ($left($1,1) == -) && ($2 isnum) { var %fl = $1,%s = $2,%f = $3- }
  elseif ($left($1,1) == -) && ($2 !isnum) { var %fl = $1,%f = $2- }
  elseif ($1 isnum) { var %s = $1,%f = $2- }
  else { var %f = $1- }

  if ($right(%f,4) == .mts) { var %t = m }
  elseif ($right(%f,4) == .nnt) { var %t = y }
  else { var %t = z }
  var %ha = $iif(p isin %fl,hap,hat)

  if (%t == m) {
    if ($fopen(pre)) { .fclose pre }
    .fopen pre " $+ %f $+ "
    if ($ferr) { .fclose pre | return }
    if (%s) { .fseek -w pre $+($chr(91),scheme $+ %s,$chr(93)) | var %l = $fread(pre) }

    var %r1 = 1,%r2 = $lines(%f)
    while (!$feof) {
      if ($fread(pre)) {
        tokenize 32 $ifmatch
        if ($1 == [mts]) || (!$1) || ($left($1,1) == $chr(59)) { continue }
        elseif ($+($chr(91),scheme*,$chr(93)) iswm $1) { .fclose pre | break }
        elseif ($theme.isevent(m,$lower($1))) && (e !isin $theme.options(load)) { continue } 
        elseif (snd isin $lower($1)) && (s !isin $theme.options(load)) { continue } 
        else { %ha $lower($1) $2- }
      }
      theme.load.show 3 %r1 0 %r2
      inc %r1
    }
    if ($fopen(pre)) { .fclose pre }

    theme.load.show 3 0 0 1
    hat schemenames $theme.info(schemenames,%f)
    if (h isin %fl) {
      var %i = 1,%sn = $hgt(schemenames)

      while ($gettok(%sn,%i,59)) {
        hat colors.scheme $+ %i $theme.info(%i,colors,%f)
        hat rgbcolors.scheme $+ %i $theme.info(%i,rgbcolors,%f)
        theme.load.show 3 %i 0 $numtok(%sn,59)

        inc %i
      }
      hat allschemesloaded 1
    }
    hat colors.theme $hgt(colors)
    hat rgbcolors.theme $hgt(rgbcolors)
    theme.load.show 3 1 0 1
  }
  elseif (%t == y) {
    if ($fopen(pre)) { .fclose pre }
    .fopen pre " $+ %f $+ "
    if ($ferr) { .fclose pre | return }
    if (%s) { 
      .fseek -w pre Scheme $+ %s $+ * 
      var %scheme = $gettok($fread(pre),2-,32)
      .fclose pre

      noop $regex(scheme,%scheme,/(\S+) (\d+ )(.*)/)
      var %scn = $regml(scheme,1), %scheme = $regml(scheme,2) $+ $regml(scheme,3)
      var %rgbcolors = $gettok(%scheme,1-16,32),%colors = $gettok(%scheme,17-,32)
      hat colors %colors
      hat rgbcolors %rgbcolors
      return
    }

    var %r1 = 1,%r2 = $lines(%f)
    while (!$feof) {
      if ($fread(pre)) {
        tokenize 32 $ifmatch
        if (!$1) || ($left($1,1) == $chr(59)) { continue }
        elseif ($theme.isevent(y,$lower($1))) && (e !isin $theme.options(load)) { continue } 
        else { %ha $lower($theme.mtsequiv($1)) $2- }
      }
      theme.load.show 3 %r1 0 %r2
      inc %r1
    }
    if ($fopen(pre)) { .fclose pre }

    theme.load.show 3 0 0 1
    hat schemenames $theme.info(schemenames,%f)
    var %i = 0
    while ($hgt(scheme $+ %i $+ .rgb.colors)) {
      var %scheme = $ifmatch
      noop $regex(scheme,%scheme,/(\S+) (\d+ )(.*)/)
      var %scn = $regml(scheme,1), %scheme = $regml(scheme,2) $+ $regml(scheme,3)
      var %rgbcolors = $gettok(%scheme,1-16,32),%colors = $gettok(%scheme,17-,32)

      if (%i == 0) {
        hat colors %colors
        hat rgbcolors %rgbcolors
        hat colors.theme %colors
        hat rgbcolors.theme %rgbcolors
      }
      else {
        hat colors.scheme $+ %i %colors
        hat rgbcolors.scheme $+ %i %rgbcolors
      }

      if (h isin %fl) { inc %i }
      else { break }
    }
    if (h isin %fl) hat allschemesloaded 1

    theme.load.show 3 1 0 1
  }
}

; Check if $2 is an event or raw ($1: theme type)
alias -l theme.isEvent {
  if ($1 == m) {
    if ($2 isin Join/JoinSelf/Part/Quit/Nick/NickSelf/Mode/ModeUser/Kick/KickSelf/Topic/Invite/Rejoin/TextChan/TextChanSelf/ActionChan/ActionChanSelf/TextQuery/TextQuerySelf/ActionQuery/ActionQuerySelf/Notice/NoticeSelf/NoticeChan/NoticeChanSelf/TextMsg/TextMsgSelf/ActionMsg/ActionMsgSelf/WallOp/NoticeServer/ServerError/Ctcp/CtcpSelf/CtcpChan/CtcpChanSelf/CtcpReply/CtcpReplySelf/Whois/Whowas/Notify/UNotify/DNS/DNSResolve/DNSError/FileRcvd/FileSent/GetFail/SendFail/Highlight) { return $true }
    elseif (RAW isin $2) { return $true }
    else { return $false }
  }
  elseif ($1 == y) {
    if ($2 isin Join/JoinOwn/Part/Quit/Kick/KickOwn/Nick/NickOwn/Mode/UserMode/ChanText/ChanTextOwn/QueryText/QueryTextOwn/Msg/MsgOwn/ChanAction/ChanActionOwn/QueryAction/QueryActionOwn/Action/ActionOwn/WhoisStart/WhoisAddress/WhoisChans/WhoisServer/WhoisStatus/WhoisAway/WhoisAuth/WhoisRealIP/WhoisIdle/WhoisEnd/WhowasStart/WhowasAddress/WhowasServer/WhowasAway/WhowasEnd/Notice/NoticeOwn/ChanNotice/ServerNotice/CTCP/CTCPOwn/ChanCTCP/CTCPReply/CTCPReplyOwn/DNS/DNSError/DNSResolve/Notify/UnNotify/Names/NamesEnd/TopicChange/Invite/InviteOwn/InviteAlreadyOnChan/AwayStatus/Bans/BansEnd/ChannelCreation/ChannelModes/ChanFull/ChanInviteOnly/ChanBanned/ChanKeyRequired/ChanRegOnly/CustomRaws/HiddenHost/LUsers1/LUsers2/LUsers3/LUsers4/LUsers5/NickInUse/NoSuchNick/NoSuchChan/NoTopic/NotOpped/RegisterFirst/RawDef/SupportedInfo/Topic/TopicBy/UnknownCmd/UnableToSend/WallOp/Welcome1/Welcome2/Welcome3/Welcome4/Who/WhoEnd) { return $true }
    else { return $false }
  }
  return $false
}

;Find the mts equivalent of a nnt property
; $1: property
alias -l theme.mtsequiv {
  var %f = data/themes/theme.hash.txt
  if (!$isfile(%f)) { $errdialog(Impossible de charger le thème: fichier %f manquant!) | halt }

  if (Scheme* iswm $1) { set -nu %::prop $1 $+ .RGB.Colors }
  else { filter -fk %f filter.mtsequiv $1 $+ =* }
  if (%::prop) { return %::prop }
}

alias -l filter.mtsequiv {
  if ($gettok($1-,2,61)) { set -nu %::prop $ifmatch }
  else { set -nu %::prop $gettok($1-,1,61) }
}

; Reset default colors
alias -l theme.load.resetcolors {
  remmi colors
  remmi palettes
  wmi colors n0 mIRC Classic,0,6,4,5,2,3,3,3,3,3,3,1,5,7,6,1,3,2,3,5,1,0,1,0,1,15,7,0
  wmi palettes n0 16777215,0,8323072,37632,255,127,10223772,32764,65535,64512,9671424,16776960,16515072,16711935,8355711,13816530
  color -ls mIRC Classic
}


;Remove global nick colors without removing the ones you added yourself
alias -l theme.remnickcolors {
  .cnick -ri *
  .cnick -r $!me
  .cnick -r * * @
  .cnick -r * * +
  .cnick -r * * %
  .cnick -r * * .
  .cnick -rn *
  .cnick -rp *
}

; Get the rgb values of a color
alias -l theme.load.color {
  if ($remove($1,$chr(44)) isalpha) {
    if ($1 == Aliceblue) { return 240,248,255 }
    elseif ($1 == Antiquewhite) { return 250,235,215 }
    elseif ($1 == Aqua) { return 0,255,255 }
    elseif ($1 == Aquamarine) { return 127,255,212 }
    elseif ($1 == Azure) { return 240,255,255 }
    elseif ($1 == Beige) { return 245,245,220 }
    elseif ($1 == Bisque) { return 255,228,196 }
    elseif ($1 == Black) { return 0,0,0 }
    elseif ($1 == Blanchedalmond) { return 255,235,205 }
    elseif ($1 == Blue) { return 0,0,255 }
    elseif ($1 == Blueviolet) { return 138,43,226 }
    elseif ($1 == Brown) { return 165,42,42 }
    elseif ($1 == Burlywood) { return 222,184,135 }
    elseif ($1 == Cadetblue) { return 95,158,160 }
    elseif ($1 == Chartreuse) { return 127,255,0 }
    elseif ($1 == Chocolate) { return 210,105,30 }
    elseif ($1 == Coral) { return 255,127,80 }
    elseif ($1 == Cornflowerblue) { return 100,149,237 }
    elseif ($1 == Cornsilk) { return 255,248,220 }
    elseif ($1 == Crimson) { return 220,20,60 }
    elseif ($1 == Cyan) { return 0,255,255 }
    elseif ($1 == Darkblue) { return 0,0,139 }
    elseif ($1 == Darkcyan) { return 0,139,139 }
    elseif ($1 == Darkgoldenrod) { return 184,134,11 }
    elseif ($1 == Darkgray) { return 169,169,169 }
    elseif ($1 == Darkgreen) { return 0,100,0 }
    elseif ($1 == Darkkhaki) { return 189,183,107 }
    elseif ($1 == Darkmagenta) { return 139,0,139 }
    elseif ($1 == Darkolivegreen) { return 85,107,47 }
    elseif ($1 == Darkorange) { return 255,140,0 }
    elseif ($1 == Darkorchid) { return 153,50,204 }
    elseif ($1 == Darkred) { return 139,0,0 }
    elseif ($1 == Darksalmon) { return 233,150,122 }
    elseif ($1 == Darkseagreen) { return 143,188,143 }
    elseif ($1 == Darkslateblue) { return 72,61,139 }
    elseif ($1 == Darkslategray) { return 47,79,79 }
    elseif ($1 == Darkturquoise) { return 0,206,209 }
    elseif ($1 == Darkviolet) { return 148,0,211 }
    elseif ($1 == Deeppink) { return 255,20,147 }
    elseif ($1 == Deepskyblue) { return 0,191,255 }
    elseif ($1 == Dimgray) { return 105,105,105 }
    elseif ($1 == Dodgerblue) { return 30,144,255 }
    elseif ($1 == Firebrick) { return 178,34,34 }
    elseif ($1 == Floralwhite) { return 255,250,240 }
    elseif ($1 == Forestgreen) { return 34,139,34 }
    elseif ($1 == Fuchsia) { return 255,0,255 }
    elseif ($1 == Gainsboro) { return 220,220,220 }
    elseif ($1 == Ghostwhite) { return 248,248,255 }
    elseif ($1 == Gold) { return 255,215,0 }
    elseif ($1 == Goldenrod) { return 218,165,32 }
    elseif ($1 == Gray) { return 128,128,128 }
    elseif ($1 == Green) { return 0,128,0 }
    elseif ($1 == Greenyellow) { return 173,255,47 }
    elseif ($1 == Honeydew) { return 240,255,240 }
    elseif ($1 == Hotpink) { return 255,105,180 }
    elseif ($1 == Indianred) { return 205,92,92 }
    elseif ($1 == Indigo) { return 75,0,130 }
    elseif ($1 == Ivory) { return 255,255,240 }
    elseif ($1 == Khaki) { return 240,230,140 }
    elseif ($1 == Lavender) { return 230,230,250 }
    elseif ($1 == Lavenderblush) { return 255,240,245 }
    elseif ($1 == Lawngreen) { return 124,252,0 }
    elseif ($1 == Lemonchiffon) { return 255,250,205 }
    elseif ($1 == Lightblue) { return 173,216,230 }
    elseif ($1 == Lightcoral) { return 240,128,128 }
    elseif ($1 == Lightcyan) { return 224,255,255 }
    elseif ($1 == Lightgoldenrodyellow) { return 250,250,210 }
    elseif ($1 == Lightgreen) { return 144,238,144 }
    elseif ($1 == Lightgrey) { return 211,211,211 }
    elseif ($1 == Lightpink) { return 255,182,193 }
    elseif ($1 == Lightsalmon) { return 255,160,122 }
    elseif ($1 == Lightseagreen) { return 32,178,170 }
    elseif ($1 == Lightskyblue) { return 135,206,250 }
    elseif ($1 == Lightslategray) { return 119,136,153 }
    elseif ($1 == Lightsteelblue) { return 176,196,222 }
    elseif ($1 == Lightyellow) { return 255,255,224 }
    elseif ($1 == Lime) { return 0,255,0 }
    elseif ($1 == Limegreen) { return 50,205,50 }
    elseif ($1 == Linen) { return 250,240,230 }
    elseif ($1 == Magenta) { return 255,0,255 }
    elseif ($1 == Maroon) { return 128,0,0 }
    elseif ($1 == Mediumauqamarine) { return 102,205,170 }
    elseif ($1 == Mediumblue) { return 0,0,205 }
    elseif ($1 == Mediumorchid) { return 186,85,211 }
    elseif ($1 == Mediumpurple) { return 147,112,216 }
    elseif ($1 == Mediumseagreen) { return 60,179,113 }
    elseif ($1 == Mediumslateblue) { return 123,104,238 }
    elseif ($1 == Mediumspringgreen) { return 0,250,154 }
    elseif ($1 == Mediumturquoise) { return 72,209,204 }
    elseif ($1 == Mediumvioletred) { return 199,21,133 }
    elseif ($1 == Midnightblue) { return 25,25,112 }
    elseif ($1 == Mintcream) { return 245,255,250 }
    elseif ($1 == Mistyrose) { return 255,228,225 }
    elseif ($1 == Moccasin) { return 255,228,181 }
    elseif ($1 == Navajowhite) { return 255,222,173 }
    elseif ($1 == Navy) { return 0,0,128 }
    elseif ($1 == Oldlace) { return 253,245,230 }
    elseif ($1 == Olive) { return 128,128,0 }
    elseif ($1 == Olivedrab) { return 104,142,35 }
    elseif ($1 == Orange) { return 255,165,0 }
    elseif ($1 == Orangered) { return 255,69,0 }
    elseif ($1 == Orchid) { return 218,112,214 }
    elseif ($1 == Palegoldenrod) { return 238,232,170 }
    elseif ($1 == Palegreen) { return 152,251,152 }
    elseif ($1 == Paleturquoise) { return 175,238,238 }
    elseif ($1 == Palevioletred) { return 216,112,147 }
    elseif ($1 == Papayawhip) { return 255,239,213 }
    elseif ($1 == Peachpuff) { return 255,218,185 }
    elseif ($1 == Peru) { return 205,133,63 }
    elseif ($1 == Pink) { return 255,192,203 }
    elseif ($1 == Plum) { return 221,160,221 }
    elseif ($1 == Powderblue) { return 176,224,230 }
    elseif ($1 == Purple) { return 128,0,128 }
    elseif ($1 == Red) { return 255,0,0 }
    elseif ($1 == Rosybrown) { return 188,143,143 }
    elseif ($1 == Royalblue) { return 65,105,225 }
    elseif ($1 == Saddlebrown) { return 139,69,19 }
    elseif ($1 == Salmon) { return 250,128,114 }
    elseif ($1 == Sandybrown) { return 244,164,96 }
    elseif ($1 == Seagreen) { return  46,139,87 }
    elseif ($1 == Seashell) { return  255,245,238 }
    elseif ($1 == Sienna) { return  160,82,45 }
    elseif ($1 == Silver) { return  192,192,192 }
    elseif ($1 == Skyblue) { return  135,206,235 }
    elseif ($1 == Slateblue) { return  106,90,205 }
    elseif ($1 == Slategray) { return  112,128,144 }
    elseif ($1 == Snow) { return  255,250,250 }
    elseif ($1 == Springgreen) { return  0,255,127 }
    elseif ($1 == Steelblue) { return  70,130,180 }
    elseif ($1 == Tan) { return  210,180,140 }
    elseif ($1 == Teal) { return  0,128,128 }
    elseif ($1 == Thistle) { return  216,191,216 }
    elseif ($1 == Tomato) { return  255,99,71 }
    elseif ($1 == Turquoise) { return  64,224,208 }
    elseif ($1 == Violet) { return  238,130,238 }
    elseif ($1 == Wheat) { return  245,222,179 }
    elseif ($1 == White) { return  255,255,255 }
    elseif ($1 == Whitesmoke) { return 245,245,245 }
    elseif ($1 == Yellow) { return 255,255,0 }
    elseif ($1 == YellowGreen) { return 154,205,50 }
  }
  elseif ($remove($1,$chr(44)) == $1) { return $rgb($1) } 
  elseif ($remove($1,$chr(44)) isnum) { return $1- }
  else { return 0,0,0 }
}

; Load nick colors
; $1: options, $2: property, $3: mode character
alias -l theme.load.nicks {
  if ($hgt($2)) { .cnick - $+ $1 $iif($2 == clineme,$!me,*) $iif($hgt($2),$ifmatch) $3 }
}

;Load the given fonts
alias -l theme.load.font {
  if ($lower($gettok($2-,-1,32)) isin bi) { var %f = $gettok($2-,1- $+ $calc($0 - 3),32),%s = $gettok($2-,-2,32),%b = $lower($gettok($2-,-1,32)) }
  else { var %f = $gettok($2-,1- $+ $calc($0 - 2),32),%s = $gettok($2-,-1,32) }

  var %ini = $+(%f,$chr(44),$calc(%s + $iif(b isin %b,700,400)),$chr(44),1)

  if ($pfri(fontrep) == 1) && ($pfri(font)) { var %font = $ifmatch }

  if (%font) {
    tokenize 44 $1 $+ , $+ %font
    %f = $2
    if ($remove($3,$chr(32)) isnum) { %s = $3 }
    if ($remove($lower($4),+) isin bi) { var %b = $remove($lower($4),+) }
  }

  if ($isfont(%f)) && (%s) {
    if ($1 == default) {
      var %serv = $scon(0),%win = $window(0)

      while (%serv) { scon %serv | font -ds $+ %b %s %f | dec %serv }
      while (%win) { font -d $window(%win) %s %f | dec %win }
      if ($window(Finger Window)) { font -dg $+ %b %s %f }
      else { wmi fonts ffinger %ini }
      wmi fonts flinks %ini
      wmi fonts flist %ini
      wmi fonts fwwwlist %ini
      wmi fonts fnotify %ini
      wmi fonts fdccg %ini
      wmi fonts fdccs %ini
    }
    elseif ($1 == chan) {
      var %serv = $scon(0),%a,%p = -d $+ %b
      while (%serv) {
        scon %serv
        var %i = $chan(0)
        while (%i) { font %p $chan(%i) %s %f | dec %i | inc %a }
        dec %serv
      }
      if (!%a) { wmi fonts fchannel %ini }
    }
    elseif ($1 == query) {
      var %serv = $scon(0),%a,%a2,%a3,%p = -d $+ %b
      while (%serv) {
        scon %serv
        var %i = $query(0),%c = $chat(0),%j = $fserv(0)
        while (%i) { font %p $query(%i) %s %f | dec %i | inc %a }
        while (%c) { font %p $chat(%c) %s %f | dec %c | inc %a2 }
        while (%j) { font %p $fserv(%j) %s %f | dec %j | inc %a3 }
        dec %serv
      }
      if (!%a) { wmi fonts fquery %ini }
      if (!%a2) { wmi fonts fchat %ini }
      if (!%a3) { wmi fonts fserv %ini }
      wmi fonts fmessage %ini
    }
  }
  else {
  }
}

; Put default font
alias -l theme.load.resetfont {
  remmi fonts
  theme.load.font default Arial -9
  theme.load.font chan Arial -9
  theme.load.font query Arial -9
}

; Load the given backgrounds
alias -l theme.load.background {
  var %s = $iif($1 != buttons,$2),%f = $nofile($hgt(file)) $+ $iif($1 != buttons,$3-,$2-),%ini = $+(",%f,",$chr(44),$calc($findtok(center fill normal stretch tile photo,%s,1,32) -1))

  if ($isfile($eval(%f,2))) {
    %s = $iif(%s == stretch,r,$left(%s,1))
    if ($1 == mirc) { background -me $+ %s " $+ %f $+ " }
    elseif ($1 == toolbar) { background -l $+ %s " $+ %f $+ " }
    elseif ($1 == buttons) { background -u " $+ %f $+ " }
    elseif ($1 == switchbar) { background -h $+ %s " $+ %f $+ " }
    else {
      var %serv = $scon(0)
      while (%serv) {
        scon %serv
        if ($1 == status) { background -se $+ %s " $+ $eval(%f,2) $+ " }
        elseif ($1 == chan) {
          var %c = $chan(0),%a
          while (%c) { background - $+ %s $chan(%c) " $+ $eval(%f,2) $+ "  | dec %c | inc %a }
          if (!%a) { wmi background wchannel %ini }
        }
        elseif ($1 == query) {
          var %q = $query(0),%c = $chat(0),%a,%a2
          while (%q) { background - $+ %s $query(%q) " $+ $eval(%f,2) $+ " | dec %q | inc %a }
          while (%c) { background - $+ %s $chat(%c) " $+ $eval(%f,2) $+ " | dec %c | inc %a2 }
          if (!%a) { wmi background wquery %ini }
          if (!%a2) { wmi background wchat %ini }
        }
        dec %serv
      }
    }
  }
}

; Remove all backgrounds
alias -l theme.load.resetback {
  remmi background
  var %s = $scon(0)
  while (%s) {
    scon %s
    background -xs
    background -xm
    background -xl
    background -xu
    background -xh
    background -xg
    var %c = $chan(0),%q = $query(0),%d = $chat(0),%w = $window(0)
    while (%c) { background -x $chan(%c) | dec %c }
    while (%q) { background -x $query(%q) | dec %q }
    while (%d) { background -x $+(=,$chat(%d)) | dec %d }
    while (%w) { if ($window(%w).type != picture && $window(%w).type != listbox) background -x $window(%w) | dec %w }
    dec %s
  }
}

; Unload current theme
alias theme.unload {
  if (!$enabled(themes)) { $infodialog(La fonctionnalité des themes est désactivée.Réactivez-la d'abord.) | return }
  if (!$theme.current) { return }
  if (w isin $1) { wins -n }
  if (l isin $1) { scid -a clearall }
  if ($dialog(themes)) { did -b themes 4 }
  if ($dialog(theme.load)) { dialog -x theme.load }
  if ($show) { dialog -m theme.load theme.load | dialog -t theme.load Déchargement du thème... }

  if ($theme.current == mts) && ($hgt(unload)) {
    theme.vars echo $color(info) $+(-at,$iif($hgt(indent),i $+ $ifmatch,i12))
    if ($gettok($hgt(unload),1,32) == !script) { $eval($gettok( [ $hgt(unload) ] ,2-,32),2) }
    else { %:echo $theme.parse(m,$hgt(unload)) }
  }

  ;; STEP ONE : Restoring default colors
  theme.load.show 1 Restauration des couleurs
  theme.load.resetcolors
  theme.load.show 2 1 0 7

  ;; STEP TWO :Removing nick colors
  theme.load.show 1 Suppression des couleurs de nicks
  theme.remnickcolors
  theme.load.show 2 2 0 7

  ;; STEP THREE: Restore rgb colors (set at step 1)
  theme.load.show 1 Restauration des couleurs
  theme.load.show 2 3 0 7

  ;; STEP FOUR: Reset bg images
  theme.load.show 1 Suppression des images
  theme.load.resetback
  theme.load.show 2 4 0 7

  ;; STEP FIVE: Reset fonts
  theme.load.show 1 Restauration des polices
  theme.load.resetfont
  theme.load.show 2 5 0 7

  ;; STEP SIX: Reset timestamp
  theme.load.show 1 Restauration du timestamp
  .timestamp on
  .timestamp -f [HH:nn:ss]
  theme.load.show 2 6 0 7

  ;; STEP SEVEN: unload script and free theme table
  theme.load.show 1 Déchargement des scripts
  if ($script($hgt(script))) { .unload -rsn $shortfn($nofile($hgt(script))) $+ $nopath($hgt(script)) }
  if ($hget(theme.current)) { hfree theme.current }
  if ($isfile($qt($datathemes(current.src)))) { .remove $qt($datathemes(current.src)) }

  theme.load.show 2 7 0 7
  if ($dialog(theme.load)) { dialog -x theme.load }
  if (w isin $1) { wins -r }

  pfremi theme
  pfremi scheme
}

; Set the theme scheme
; $1: scheme index
alias theme.scheme {
  if (!$enabled(themes)) { $infodialog(La fonctionnalité des themes est désactivée.Réactivez-la d'abord.) | return }
  ha theme.edit.curscheme $iif($1,scheme $+ $1,theme)
  if ($1) { hat scheme $gettok($hgt(schemenames),$1,59) }
  else { hat scheme }

  $iif(!$show,.) $+ theme.load - $+ $iif(a isin $theme.options(load),fcnsbite,$theme.options(load)) $+ $iif(h isin $theme.options(load),h) $+ $iif(a isin $theme.options(add),wlu,$theme.options(add)) $iif($1,$1) $hgt(file)
}

; Refresh colors
alias theme.refresh {
  if (!$enabled(themes)) { $infodialog(La fonctionnalité des themes est désactivée.Réactivez-la d'abord.) | return }
  .theme.load.resetcolors
  wmi text theme $hgt(name) $iif($hgt(scheme),- $hgt(scheme))
  wmi palettes $theme.colornum($hgt(name)) $hgt(rgbpalette.theme)
  wmi colors $theme.colornum($hgt(name)) $hgt(colorspalette.theme)
  var %i = 1,%s = $hgt(schemenames)
  while ($gettok(%s,%i,59)) {
    wmi palettes $theme.colornum($hgt(name) - $ifmatch) $hgt(rgbpalette.scheme $+ %i)
    wmi colors $theme.colornum($hgt(name) - $ifmatch) $hgt(colorspalette.scheme $+ %i)
    inc %i
  }
  if ($show) && ($hgt(allschemesloaded)) { .color -ls $hgt(name) $iif($hgt(scheme),- $hgt(scheme)) }
}

;ces

;###################### COMMAND REWRITING #########################
;sec Commands

alias say {
  if (!$enabled(themes)) { !say $1- | return }
  if (!$theme.current) || (!$server) {
    if ($active == Status Window) { echo -a * Vous ne pouvez pas écrire sur cette fenêtre! }
    else { !say $1- }
  }
  elseif ($1 != $null) && (($active ischan) || ($query($active)) || ($left($active,1) == $chr(61))) { msg $active $1- }
}

alias msg {
  if (!$enabled(themes)) { !msg $1- | return }
  if (!$theme.current) || (!$server) { !msg $1- }
  elseif ($2 != $null) {
    if ($show) {
      if (!$window($1)) || ($1 != $active) { var %t = textmsgself }
      elseif ($1 ischan) { var %t = textchanself }
      else { var %t = textqueryself }
      if ($hgt(%t)) && ($gettok($hg(theme.event.INPUT),1,32) != 2) {
        var %i =  $iif($hgt(indent),i $+ $ifmatch,i12)
        theme.vars echo $color(own) $iif(%t == textmsgself,-ta $+ %i,-tm $+ %i $1)
        set -nu %::nick $me
        set -nu %::chan $1
        set -nu %::target $1
        set -nu %::address $address($me,5)
        if ($1 ischan) { set -u %::cmode $cmode($me,$1) }
        set -u %::cnick $hgt(clineme)
        set -nu %::me $me
        set -nu %::text $2-
        var %m = .msg
        set -nu %:raw $1-
        theme.text %t INPUT $iif($target,$ifmatch,$active) %::text
        if ($window($1)) && ($1 != $active) {
          theme.vars echo $color(own) -tm $+ %i $1
          theme.text textqueryself $target %::text
        }
      }
      else { var %m = msg }
      theme.sound %t 
    }
    else { var %m = .msg }
    %m $1-
  }
}
alias dns {
  if (!$enabled(themes)) { !dns $1- | return }
  if (!$theme.current) || (!$server) { !dns $1- }
  elseif ($hgt(dns)) {
    if ($left($1,1) == -) { var %t = $2 }
    else { var %t = $1 }
    theme.vars echo $color(other) -a $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -u %::nick %t
    set -u %::address %t
    set -u %:raw $1-
    .dns $1-
    if ($show) { theme.text dns DNS %t }
  }
  else { $iif($show,dns,.dns) $1- }
}

alias describe {
  if (!$enabled(themes)) { !describe $1- | return }
  if (!$theme.current) || (!$server) { !describe $1- }
  else {
    if ($1 ischan) || ($1 == Status) { var %t = actionchanself }
    else { var %t = actionqueryself }
    if ($1 != $null) && ($1 ischan) || ($query($1)) || ($left($1,1) == $chr(61)) {
      if ($show) {
        if ($hgt($iif($active ischan,actionchanself,actionqueryself))) && ($gettok($hg(theme.event.ACTION),1,32) != 2) {
          theme.vars echo $color(action) -tm $+ $iif($hgt(indent),i $+ $ifmatch,i12) $1
          set -nu %::nick $active
          set -nu %::chan $active
          set -nu %::address $address($me,5)
          if ($active ischan) { set -u %::cmode $cmode($me,$active) }
          set -u %::cnick $hgt(clineme)
          set -nu %::me $me
          set -nu %::text $2-
          set -u %:raw $1-
          var %m = .describe
          theme.text %t ACTION %::text
        }
        else { var %m = describe }
        theme.sound %t 
      }
      else { var %m = .describe }
      %m $1-
    }
  }
}
alias me {
  if (!$enabled(themes)) { !me $1- | return }
  if (!$theme.current) || (!$server) { !me $1- }
  elseif ($1 != $null) && (($active ischan) || ($query($active)) || ($left($active,1) == $chr(61))) { describe $active $1- }
}

alias amsg {
  if (!$enabled(themes)) { !amsg $1- | return }
  if (!$theme.current) || (!$server) { !amsg $1- }
  elseif ($1 != $null) {
    set -u %:raw $1-
    theme.msg amsg textchanself $1-
    %m $1-
    theme.sound textchanself
  }
}

alias ame {
  if (!$enabled(themes)) { !ame $1- | return }
  if (!$theme.current) || (!$server) { !ame $1- }
  elseif ($1 != $null) {
    set -u %:raw $1-
    theme.msg ame actionchanself $1-
    %m $1-
    theme.sound actionchanself 
  }
}

alias qmsg {
  if (!$enabled(themes)) { !qmsg $1- | return }
  if (!$theme.current) || (!$server) { !qmsg $1- }
  elseif ($1 != $null) {
    set -u %:raw $1-
    theme.msg qmsg textqueryself $1-
    %m $1-
    theme.sound textqueryself
  }
}

alias qme {
  if (!$enabled(themes)) { !qme $1- | return }
  if (!$theme.current) || (!$server) { !qme $1- }
  elseif ($1 != $null) {
    set -u %:raw $1-
    theme.msg qme actionqueryself $1-
    %m $1-
    theme.sound actionqueryself
  }
}

alias theme.notice {
  if (!$enabled(themes)) { !notice $1- | return }
  if (!$theme.current) || (!$server) { !notice $1- }
  elseif ($2 != $null) {
    if ($show) {
      if ($hgt($iif($left($1,1) == $chr(35),noticechanself,noticeself))) {
        theme.vars echo $color(notice) -ta $+ $iif($hgt(indent),i $+ $ifmatch,i12)
        set -nu %::nick $1
        set -nu %::target $1
        set -nu %::chan $1
        set -nu %::address $address($me,5)
        if ($1 ischan) { set -u %::cmode $cmode($me,$1) }
        set -u %::cnick $cnick($1).color
        set -nu %::me $me
        set -nu %::text $2-
        var %m = !.notice
        set -u %:raw $1-
        theme.text $iif($left($1,1) == $chr(35),noticechanself,noticeself) NOTICE
      }
      else { var %m = !notice }
      theme.sound $iif($left($1,1) == $chr(35),noticechanself,noticeself) NOTICE
    }
    else { var %m = !.notice }
    %m $1-
  }
}

alias hop {
  if (!$enabled(themes)) { !hop $1- | return }
  if (!$theme.current) || (!$server) { !hop $1- }
  else {
    if ($active !ischan) { theme.error Cannot hop out of a channel window | return }
    if ($show) {
      if ($hgt(rejoin)) {
        theme.vars echo $color(join) -ta $+ $iif($hgt(indent),i $+ $ifmatch,i12)
        set -nu %::chan $active
        set -nu %::address $address($me,5)
        set -nu %::me $me
        theme.text rejoin JOIN
      }
      else { theme.echo -ta Attempting to rejoin $basecolor(4) $+ $active $+ ... }
    }
    .hop $1-
  }
}

alias ctcp {
  if (!$enabled(themes)) { !ctcp $1- | return }
  if (!$theme.current) || (!$server) { !ctcp $1- }
  elseif ($2 != $null) {
    set -u %:raw $1-
    theme.ctcp ctcp CTCP $1-
    %m $iif($2 == PING,$1 $2 $ctime,$1-)
    theme.sound ctcpself
  }
}

alias ctcpreply {
  if (!$enabled(themes)) { !ctcpreply $1- | return }
  if (!$theme.current) || (!$server) { !ctcpreply $1- }
  elseif ($2 != $null) {
    set -u %:raw $1-
    theme.ctcp ctcpreply CTCPREPLY $1-
    %m $1-
    theme.sound ctcpreplyself
  }
}

alias quit {
  if (!$enabled(themes)) { !quit $1- | return }
  if (!$theme.current) || (!$server) { !quit $1- }
  else {
    if ($show) {
      theme.vars echo $color(quit) -ta $+ $iif($hgt(indent),i $+ disconnect)
      set -u %::text $1-
      theme.text quitself QUIT %::text
    }
    .quit $1-
  }
}

alias -l theme.msg {
  if ($show) {
    set -u %::address $address($me,5)
    set -u %::cnick $cnick($me).color
    set -u %::text $3-
    set -u %m . $+ $1
    var %i = 1
    while ($iif($left($1,1) == a,$chan(%i),$query(%i))) {
      var %target $ifmatch
      theme.vars echo $color($iif(($1 == amsg) || ($1 == qmsg),own,action)) -t $+ $iif($hgt(indent),i $+ $ifmatch,i12) %target
      set -u %::me $me
      set -u %::cmode $cmode($me,$chan(%i))
      set -u %::nick $nick
      set -u %::chan %target

      theme.text $2 $iif(($1 == amsg) || ($1 == qmsg),INPUT,ACTION) $iif(($2 == textchanself) || ($2 == textqueryself),$me) %::text
      inc %i
    }
  }
  else { set -u %m . $+ $1 }
}

alias -l theme.ctcp {
  if ($show) {
    if ($hgt($+($1,$iif($left($3,1) == $chr(35),chanself,self)))) {
      theme.vars echo $color(own) -at $+ $iif($hgt(indent),i $+ $ifmatch,i12)
      set -u %::nick $3
      set -u %::cnick $cnick($3).color
      set -u %::target $3
      set -u %::chan $3
      set -u %::ctcp $upper($4)
      set -u %::text $5-
      set -nu %m . $+ $1
      var %t = $iif($1 == ctcpreply,ctcpreplyself,ctcpself)
      theme.text %t $2-
    }
    else { set -nu %m $1 }
  }
  else { set -nu %m . $+ $1 }
}

alias -l theme.highlight {
  if ($highlight($1-).sound) {
    var %s = $ifmatch
    $iif(%s == beep,%s,.splay -wmp $+(",%s,"))
  }
  else { theme.sound highlight }
  if ($highlight($1-).color) { var %c = $ifmatch - 1 }
  if ($highlight($1-).flash) { flash $+(-r,$ifmatch) $highlight($1-).message }

  theme.vars echo $color(highlight) -t $iif($chan,$chan,$nick)
  set -nu %::nick $nick
  set -nu %::cnick $cnick($nick).color
  set -nu %::address $iif($address,$ifmatch,N/A)
  set -nu %::text $1-
  theme.text highlight $upper($event) %::text
}

alias -l theme.textevent {
  var %i = $iif($hgt(indent),i $+ $ifmatch,i12)
  if ($chan) {
    var %t = -tlm $+ %i $chan
    if ($event == text) { var %e = textchan }
    elseif ($event == action) { var %e = actionchan }
    else { var %e = noticechan }
    set -nu %::chan $chan
    set -u %::cmode $cmode($nick,$chan)
    set -u %::cnick $nick($chan,$nick).color
  }
  else {
    var %t = $iif($event != notice,$iif($query($nick),-tlm $+ %i $nick,-tldm $+ %i),-tlam $+ %i)
    if ($event == text) { var %e = $iif($query($nick),textquery,textmsg) }
    elseif ($event == action) { var %e = actionquery }
    else { var %e = notice }
    set -u %::cnick $cnick($nick).color
  }
  if ($hgt(%e)) {
    if ($highlight($1-)) && ($highlight) && ($1 !isnum) && (%e != notice) {
      theme.highlight $1-
      halt
    }
    theme.vars echo $iif(%c != $null,%c,$color($iif($event == text,normal,$event))) %t
    set -nu %::nick $nick
    set -nu %::address $iif($address,$ifmatch,N/A)
    set -nu %::text $1-
    theme.text %e $upper($event) %::text

    if (%::target != $active) && (query !isin %e) { theme.sound %e }
    elseif (query isin %e) && (%::nick != $active) { theme.sound %e }

    if ($chan) && ($flashchan == 1) { flash -r }
    elseif ($flashquery == 1) { flash -r }
  }
}

alias -l theme.joinpart {
  if ($hgt($1)) {
    theme.vars echo $color($event) -t $+ $iif($hgt(indent),i $+ $ifmatch,i12) $chan
    set -nu %::nick $nick
    set -nu %::cnick $cnick($nick).color
    set -nu %::address $iif($address,$ifmatch,N/A)
    set -nu %::chan $chan
    set -nu %::text $2-
    theme.text $1 $upper($event) %::text

    if ($hgt(imagechan) && ($1 == joinself) && (b isin $theme.options(load))) { theme.load.background chan $hgt(imagechan) }
  }
}

alias -l theme.nickquit {
  var %i = 1
  while ($comchan($2,%i)) {
    theme.vars echo $color($event) -t $+ $iif($hgt(indent),i $+ $ifmatch,i12) $comchan($2,%i)
    theme.text $1 $upper($event) %::text
    inc %i
  }
}

alias -l theme.notify {
  if ($hgt($event)) {
    theme.vars echo $color(notify) -at $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::nick $nick
    set -nu %::cnick $cnick($nick).color
    set -nu %::address $notify($nick).addr
    set -nu %::text $notify($nick).note
    theme.text $event $upper($event) %::text
  }
}

;ces
;####################### EVENTS #######################
;sec Events


#features.themes on
on &*:INPUT:*:{
  if (!$iscmd($1)) && ($theme.current) {
    say $1-
    halt
  }
  if ($iscmd($1)) && ($1 isin .echo/echo//echo) {
    if ($pfri(echo) == 1) { theme.echo $eval($2-,2) | halt }
  }
}
on ^&*:TEXT:*:*:{
  if ($theme.current) {
    set -u %:raw $1-
    theme.textevent $1-
  }
}
on ^&*:ACTION:*:*:{
  if ($theme.current) {
    set -u %:raw $1-
    theme.textevent $1-
  }
}
on ^&*:NOTICE:*:*:{
  if ($theme.current) {
    set -u %:raw $1-
    theme.textevent $1-
    theme.sound notice $+ $iif($nick == $me,self)
  }
}
on ^&*:CHAT:*:{
  if ($hgt(textquery)) && ($theme.current) {
    theme.vars echo $color(normal) -mlt $+ $iif($hgt(indent),i $+ $ifmatch,i12) = $+ $nick
    set -nu %::nick $nick
    set -nu %::address $iif($address,$ifmatch,N/A)
    set -nu %::text $1-
    set -u %::cnick $cnick($nick).color
    set -nu %::nick $nick
    set -u %:raw $1-
    theme.text textquery CHAT %::text
  }
  theme.sound chat
}
on ^&*:JOIN:#:{
  if ($theme.current) {
    set -u %:raw $1-
    theme.joinpart $event $+ $iif($nick == $me,self)
    theme.sound join $+ $iif($nick == $me,self)
  }
}
on ^&*:PART:#:{
  if ($theme.current) {
    if ($nick != $me) { set -u %:raw $1- | theme.joinpart $event $1- }
    theme.sound part $+ $iif($nick == $me,self)
  }
}
on ^&*:NICK:{
  if ($hgt($iif($nick == $me,nickself,nick))) && ($theme.current) {
    set -nu %::nick $nick
    set -u %::cnick $cnick($nick).color
    set -nu %::newnick $newnick
    set -nu %::address $iif($address,$ifmatch,N/A)
    set -u %:raw $1-
    theme.nickquit $iif($nick == $me,nickself,nick) $newnick
  }
  theme.sound nick $+ $iif($nick == $me,self)
}
on ^&*:QUIT:{
  if ($hgt(quit)) && ($theme.current) {
    set -nu %::nick $nick
    set -u %::cnick $cnick($nick).color
    set -nu %::address $iif($address != $null,$ifmatch,N/A)
    set -nu %::text $1-
    set -u %:raw $1-
    theme.nickquit quit $nick
  }
  theme.sound quit $+ $iif($nick == $me,self)
}

on *:NOTIFY:{
  if ($theme.current) {
    set -u %:raw $1-
    theme.notify
    theme.sound notify
    haltdef
  }
}
on *:UNOTIFY:{
  if ($theme.current) {
    set -u %:raw $1-
    theme.notify
    theme.sound unotify
    haltdef
  }
}

on &*:DNS:{
  var %t = $iif($dns(0) > 0,dnsresolve,dnserror)
  if ($hgt(%t)) && ($theme.current) {
    theme.vars echo $color(other) -a $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::nick $nick
    set -nu %::cnick $cnick($nick).color
    set -nu %::address $address
    set -nu %::iaddress $iaddress
    set -nu %::naddress $naddress
    if (%t == dnsresolve) {
      var %i = 1
      while ($dns(%i)) {
        set -nu %::address $dns(%i).ip
        set -nu %::raddress $dns(%i)
        set -u %:raw $1-
        theme.text %t DNS $address $iaddress $naddress $nick
        inc %i
      }
    }
    else { theme.text %t DNS $address $iaddress $naddress $nick }
  }
}

on ^&*:USERMODE:{
  if ($hgt(modeuser)) && ($theme.current) {
    theme.vars echo $color(mode) -st $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::nick $nick
    set -nu %::cnick $cnick($nick).color
    set -nu %::modes $1-
    set -u %:raw $1-
    theme.text modeuser USERMODE %::modes
  }
  theme.sound usermode
}
on ^&*:ERROR:*:{
  if ($hgt(servererror)) && ($theme.current) {
    theme.vars echo $color(info) -st $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::text $1-
    set -u %:raw $1-
    theme.text servererror ERROR %::text
    halt
  }
  theme.sound error
}
on ^&*:SNOTICE:*:{
  if ($hgt(noticeserver)) && ($theme.current) {
    theme.vars echo $color(info) -st $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::nick $nick
    set -nu %::cnick $cnick($nick).color
    set -nu %::address $iif($address != $null,$ifmatch,N/A)
    set -nu %::text $1-
    set -u %:raw $1-
    theme.text noticeserver SNOTICE %::text
  }
  theme.sound snotice
}
on ^&*:INVITE:#:{
  if ($hgt(invite)) && ($theme.current) {
    theme.vars echo $color(invite) -at $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::nick $nick
    set -nu %::cnick $cnick($nick).color
    set -nu %::address $iif($address != $null,$ifmatch,N/A)
    set -nu %::chan $chan
    set -nu %::text $1-
    set -u %:raw $1-
    theme.text invite INVITE %::text
  }
  theme.sound invite $+ $iif($nick == $me,self)
}
on ^&*:TOPIC:#:{
  if ($hgt(topic)) && ($theme.current) {
    theme.vars echo $color(topic) -t $+ $iif($hgt(indent),i $+ $ifmatch,i12) $chan
    set -u %::nick $nick
    set -nu %::cnick $cnick($nick).color
    set -u %::address $iif($address,$ifmatch,N/A)
    set -u %::chan $chan
    set -u %::text $1-
    set -u %:raw $1-
    theme.text topic TOPIC %::text
  }
  theme.sound topic $+ $iif($nick == $me,self)
}
on ^&*:KICK:#:{
  var %t = $iif($knick == $me,kickself,$event),%i = $iif($hgt(indent),i $+  $ifmatch)
  if ($hgt(%t)) && ($theme.current) {
    theme.vars echo $color(kick) -t $+ %i $chan
    set -u %::nick $nick
    set -nu %::cnick $cnick($nick).color
    set -u %::address $address
    set -u %::chan $chan
    set -u %::knick $knick
    set -u %::kcmode $cmode($knick,$chan)
    set -u %::kaddress $address($knick,5)
    set -u %::text $1-
    set -u %:raw $1-
    theme.text %t KICK %::text
    if %t == kickself {
      theme.vars echo $color(kick) -st $+ %i
      theme.text %t KICK %::text
    }
  }
  theme.sound kick $+ $iif($nick == $me,self)
}

on ^&*:RAWMODE:#:{
  if ($hgt(mode)) && ($theme.current) {
    theme.vars echo $color(mode) -t $+ $iif($hgt(indent),i $+ $ifmatch,i12) $chan
    set -u %::nick $nick
    set -nu %::cnick $cnick($nick).color
    set -u %::address $iif($address,$ifmatch,N/A)
    set -u %::chan $chan
    set -u %::modes $1-
    set -u %:raw $1-
    theme.text mode RAWMODE %::modes
  }
}
on ^&*:WALLOPS:*:{
  if ($hgt(wallops)) && ($theme.current) {
    theme.vars echo  $color(wallops) -st $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::nick $nick
    set -nu %::address $iif($address != $null,$ifmatch,N/A)
    set -nu %::text $1-
    set -u %:raw $1-
    theme.text wallops WALLOPS %::text
  }
}

ctcp &*:*:*:{
  if ($hgt($iif($chan,ctcpchan,ctcp))) && ($theme.current) {
    if ($1 == VERSION) || ($1 == DCC) { return }
    theme.vars echo $color(ctcp) -at $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::nick $nick
    set -nu %::address $iif($address,$ifmatch,N/A)
    set -nu %::chan $chan
    set -nu %::ctcp $1
    set -nu %::text $2-
    if ($1 == PING) { set -un %ctcpreply $2- }
    elseif ($1- == TIME) { set -un %ctcpreply $fulldate }
    elseif ($1- == FINGER) { set -un %ctcpreply $me ( $+ $fullname - $emailaddr $+ ) - Idle $idle seconds - $readini(mirc.ini,text,finger) }
    set -u %:raw $1-
    theme.text $iif($chan,ctcpchan,ctcp) CTCP
    if (%ctcpreply) { ctcpreply $nick $1 %ctcpreply }
  }
  theme.sound ctcp
}
on &*:CTCPREPLY:*:{
  if ($hgt(ctcpreply)) && ($theme.current) {
    theme.vars echo $color(ctcp) -at $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::nick $nick
    set -nu %::chan $chan
    set -nu %::ctcp $1
    set -nu %::text $2-
    set -u %:raw $1-
    ;if ($1 == PING) { set -nu %ctcpreply $duration($calc($ctime - $2)) }
    theme.text ctcpreply CTCPREPLY %::ctcp $iif(%ctcpreply,$ifmatch,%::text)
  }
  theme.sound ctcpreply
}

on *:CONNECT:{
  if ($hgt(connect)) && ($theme.current) {
    theme.vars echo $color(info2) -st $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    theme.text connect CONNECT
  }
  theme.sound connect 
}

on *:DISCONNECT:{ 
  if ($hgt(disconnect)) && ($theme.current) {
    theme.vars echo $color(info2) -st $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    theme.text disconnect DISCONNECT
  }
  theme.sound disconnect 
}


ON *:DCCSERVER:SEND:{
  if ($hgt(send)) && ($theme.current) {
    theme.vars echo $color(info2) -at $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::nick $nick
    set -nu %::address $address
    set -nu %::file $filename
    theme.text send SEND
  }
  theme.sound send 
}

ON *:DCCSERVER:FSERVE:{
  if ($hgt(fserve)) && ($theme.current) {
    theme.vars echo $color(info2) -at $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::nick $nick
    set -nu %::address $address
    set -nu %::file $filename
    theme.text fserve FSERVE
  }
  theme.sound fserve 
}

on *:FILESENT:*:{ 
  if ($hgt(filesent)) && ($theme.current) {
    theme.vars echo $color(info2) -at $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::nick $send(-1)
    set -nu %::file $send(-1).file
    set -nu %::path $send(-1).path
    set -nu %::size $bytes($send(-1).size,3).suf
    set -nu %::sent $bytes($send(-1).sent,3).suf
    set -nu %::bps $bytes($send(-1).cps,3).suf
    set -nu %::percent $send(-1).pc
    set -nu %::secs $send(-1).secs
    set -nu %::resume $send(-1).resume
    theme.text filesent FILESENT
  }
  theme.sound filesent 
}

on *:FILERCVD:*:{
  if ($hgt(filercvd)) && ($theme.current) {
    theme.vars echo $color(info2) -at $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::nick $get(-1)
    set -nu %::file $get(-1).file
    set -nu %::path $get(-1).path
    set -nu %::size $bytes($get(-1).size,3).suf
    set -nu %::rcvd $bytes($get(-1).rcvd,3).suf
    set -nu %::bps $bytes($get(-1).cps,3).suf
    set -nu %::percent $get(-1).pc
    set -nu %::secs $get(-1).secs
    set -nu %::resume $get(-1).resume
    theme.text filercvd FILERCVD
  }
  theme.sound filercvd 
}

on *:SENDFAIL:*:{ 
  if ($hgt(sendfail)) && ($theme.current) {
    theme.vars echo $color(info2) -at $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::nick $send(-1)
    set -nu %::file $send(-1).file
    set -nu %::path $send(-1).path
    set -nu %::size $bytes($send(-1).size,3).suf
    set -nu %::sent $bytes($send(-1).sent,3).suf
    set -nu %::bps $bytes($send(-1).cps,3).suf
    set -nu %::percent $send(-1).pc
    set -nu %::secs $send(-1).secs
    set -nu %::resume $send(-1).resume
    theme.text sendfail SENDFAIL
  }
  theme.sound sendfail 
}
on *:GETFAIL:*:{ 
  if ($hgt(getfail)) && ($theme.current) {
    theme.vars echo $color(info2) -at $+ $iif($hgt(indent),i $+ $ifmatch,i12)
    set -nu %::nick $get(-1)
    set -nu %::file $get(-1).file
    set -nu %::path $get(-1).path
    set -nu %::size $bytes($get(-1).size,3).suf
    set -nu %::rcvd $bytes($get(-1).rcvd,3).suf
    set -nu %::bps $bytes($get(-1).cps,3).suf
    set -nu %::percent $get(-1).pc
    set -nu %::secs $get(-1).secs
    set -nu %::resume $get(-1).resume
    theme.text getfail GETFAIL
  }
  theme.sound getfail 
}


on *:OP:#:{ theme.sound op $+ $iif($nick == $me,self) }
on *:DEOP:#:{ theme.sound deop $+ $iif($nick == $me,self) }
on *:HELP:#:{ theme.sound hop $+ $iif($nick == $me,self) }
on *:DEHELP:#:{ theme.sound dehop $+ $iif($nick == $me,self) }
on *:VOICE:#:{ theme.sound voice $+ $iif($nick == $me,self) }
on *:DEVOICE:#:{ theme.sound devoice $+ $iif($nick == $me,self) }
on *:BAN:#:{ theme.sound ban $+ $iif($nick == $me,self) }
on *:MODE:#:{ theme.sound mode $+ $iif($nick == $me,self) }
on *:OPEN:?:{ theme.sound query }
on *:OPEN:@:{ theme.sound open }
on *:OPEN:=:{ theme.sound open }
on *:OPEN:!:{ theme.sound open }
On *:SIGNAL:away:{ theme.sound away }
ON *:SIGNAL:back:{ theme.sound back }


;################# RAW EVENT HANDLING ##################

RAW *:*:{
  var %n = $theme.rawdigit($numeric)
  if ($halted) { return }
  if ($hgt(raw. $+ %n)) { var %r = RAW. $+ %n }
  if (!%r) { var %r = RAW.Other }
  if (%r) && ($theme.current) {
    if (%n == 001) { set -nu %::text $2- | set -nu %::nick $eval($ $+ $0, 2) }
    elseif (%n == 002) { set -nu %::value $8 | set -nu %::version $8 }
    elseif (%n == 003) { set -nu %::value $6- | set -nu %::created $6- }
    elseif (%n == 004) { set -nu %::value $3- | set -nu %::version $3 | set -nu %::usermodes $4 | set -nu %::chanmodes $5 }
    elseif (%n == 005) { set -nu %::text $2-15 }

    elseif (%n == 219) { set -nu %::value $2 | set -nu %::text $3- }
    elseif (%n == 221) { set -nu %::nick $1 | set -nu %::modes $2 }

    elseif (%n == 250) { set -nu %::value $4- }
    elseif (%n == 251) { set -nu %::users $4 | set -nu %::text $7 | set -nu %::value $10 | set -nu %::invisible $7 | set -nu %::servers $10 }
    elseif (%n == 252) { set -nu %::value $2 }
    elseif (%n == 253) { set -nu %::value $2 }
    elseif (%n == 254) { set -nu %::value $2 }
    elseif (%n == 255) { set -nu %::value $4 | set -nu %::text $7 | set -nu %::clients $4 | set -nu %::servers $7 }
    elseif (%n == 256) { set -nu %::value $5 }

    elseif (%n == 265) { set -nu %::users $5 | set -nu %::value $7 }
    elseif (%n == 266) { set -nu %::users $5 | set -nu %::value $7 }

    elseif (%n == 271) { set -nu %::nick $2 | set -nu %::text $3- }

    elseif (%n == 302) { set -nu %::nick $gettok($2,1,61) | set -nu %::address $gettok($2,2,64) | set -nu %::value $2 }

    elseif (%n == 315) { set -nu %::chan $2 }
    elseif (%n == 322) { set -nu %::chan $2 | set %::users $3 | set %::text $4- }
    elseif (%n == 324) { set -nu %::chan $2 | set -nu %::modes $3 | set -nu %::value $4- }
    elseif (%n == 329) { set -nu %::chan $2 | set -nu %::value $3- | set -nu %::created $asctime($3-) }

    elseif (%n == 331) { set -nu %::chan $2 }
    elseif (%n == 332) { set -nu %::chan $2 }
    elseif (%n == 333) { set -nu %::chan $2 | set -nu %::nick $3 | set -nu %::text $4- }
    elseif (%n == 338) { set -nu %::nick $2 | set -nu %::value $3 | set -nu %::value $4 | set -nu %::text $5- }

    elseif (%n == 352) { set -nu %::nick $6 | set -nu %::address $4 | set -nu %::cmode $right($7,1) | set -nu %::away $iif($left($7,1) == G,yes,no) | set -nu %::chan $2 | set -nu %::wserver $5 | set -nu %::realname $3 | set -nu %::value $8 | set -nu %::text $1- | set -nu %::isoper $iif(* isin $7,is,is not) }
    elseif (%n == 353) { set -nu %::chan $3 | set -nu %::text $4- }

    elseif (%n == 341) { set -nu %::nick $2 | set -nu %::chan $3 | set -nu %::value $4- }
    elseif (%n == 364) || (%n == 365) { return }
    elseif (%n == 366) { set -nu %::chan $2 }
    elseif (%n == 367) { set -nu %::chan $2 | set -nu %::address $3 | set -nu %::nick $4 | set -nu %::value $5 }
    elseif (%n == 368) { set -nu %::chan $2 }
    elseif (%n == 372) || (%n == 375) || (%n == 376) { if ($gettok($rmi(options,n1),11,44) == 1) { haltdef | return } else { set -nu %::text    $2- } }

    elseif (%n == 382) { set -nu %::value $2 }
    elseif (%n == 391) { set -nu %::text $3- }
    elseif (%n == 396) { set -nu %::value $3- }

    elseif (%n == 401) || (%n == 403) || (%n == 406) || (%n == 421) || (%n == 433) || (%n == 471) || (%n == 473) || (%n == 474) || (%n == 475) || (%n == 477) || (%n == 482) { set -nu %::chan $2 | set -nu %::nick $2 | set -nu %::text $3- }
    elseif (%n == 404) { set -nu %::chan $7- | set -nu %::nick $2 | set -nu %::text $3- }
    elseif (%n == 405) { set -nu %::chan $2 }
    elseif (%n == 416) { set -nu %::value $2 }
    elseif (%n == 432) { set -nu %::nick $2 }
    elseif (%n == 436) { set -nu %::nick $2 }
    elseif (%n == 437) { set -nu %::nick $1 | set -nu %::chan $2 | set -nu %:target null }
    elseif (%n == 438) { set -nu %::nick $2 }
    elseif (%n == 442) { set -nu %::chan $2 }
    elseif (%n == 443) { set -nu %::nick $2 | set -nu %::chan $3 }
    elseif (%n == 451) { set -nu %::value $2 }
    elseif (%n == 600) { set -nu %::nick $2 | set -nu %::address $3-4 | set -nu %::value $asctime($5) }
    elseif (%n == 601) { set -nu %::nick $2 | set -nu %::address $3-4 | set -nu %::value $asctime($5) }
    elseif (%n == 603) { set -nu %::value $3 | set -nu %::text $7 }
    elseif (%n == 604) { set -nu %::nick $2 | set -nu %::value $3 | set -nu %::text $4- }
    elseif (%n == 606) { set -nu %::nick $2 }
    elseif (%n == 671) { set -nu %::nick $2 }

    ;Whois et whowas
    elseif (%n == 311) || (%n == 314) { set -nu %::nick $2 | set -nu %::address $3 $+ @ $+ $4 | set -nu %::realname $6- 
      if ($hgt(whois)) { set %whois.nick $2 | set %whois.address $3 $+ @ $+ $4 | set %whois.realname $6- | halt } 
      if (%n == 311) && ($hgt(whoisstart)) && ($theme.current == nnt) {
        theme.vars echo $color(whois) $gettok($theme.raw.echo(311),1,9)
        theme.text whoisstart $gettok($theme.raw.echo(311),2,9) $1-
      }
      elseif (%n == 314) && ($hgt(whowasstart)) && ($theme.current == nnt) {
        theme.vars echo $color(whois) $gettok($theme.raw.echo(314),1,9)
        theme.text whowasstart $gettok($theme.raw.echo(314),2,9) $1-
      }
    }
    elseif (%n == 319) { set -nu %::nick $2 | set -nu %::chan $3- 
      if ($hgt(whois)) { set %whois.chan %whois.chan $3- | halt } 
    }
    elseif (%n == 312) { set -nu %::nick $2 | set -nu %::wserver $3 | set -nu %::serverinfo $4- 
      if ($hgt(whois)) { set %whois.wserver $3 | set %whois.serverinfo $4- | halt } 
    }
    elseif (%n == 301) { set -nu %::nick $2 | set -nu %::away $3- 
      if ($hgt(whois)) { set %whois.away $3- | halt } 
    }
    elseif (%n == 307) { set -nu %::nick $2 | set -nu %::isregd is 
      if ($hgt(whois)) { set %whois.isregd is | halt } 
    }
    elseif (%n == 313) { set -nu %::nick $2 | set -nu %::isoper is | set -nu %::operline $3-
      if ($hgt(whois)) { set %whois.isoper is | set %whois.operline $3- | halt } 
    }
    elseif (%n == 317) { set -nu %::nick $2 | set -nu %::idletime $3 | set -nu %::signontime $asctime($4) | set -nu %::signontimeraw $4 
      if ($hgt(whois)) { set %whois.idletime $3 | set %whois.signontime $asctime($4) | set %whois.signontimeraw $4 | halt } 
    }
    elseif (%n == 330) { set -nu %::nick $2 }
    elseif (%n == 335) { set -nu %::nick $2 | set -nu %::text $3- }
    elseif (%n == 378) { set -nu %::nick $2 | set -nu %::text $3- }
    elseif (%n == 318) {
      set -nu %::nick $2
      if (($hgt(whois)) && ($theme.current == mts) && ($gettok($theme.raw.echo(318),1,9)) && (%whois.nick)) {
        set -nu %::nick %whois.nick
        set -nu %::address %whois.address 
        set -nu %::realname %whois.realname
        set -nu %::chan %whois.chan
        set -nu %::wserver %whois.wserver
        set -nu %::serverinfo %whois.serverinfo
        set -nu %::away %whois.away
        set -nu %::isregd %whois.isregd
        set -nu %::isoper %whois.isoper
        set -nu %::operline %whois.operline
        set -nu %::idletime %whois.idletime
        set -nu %::signontime %whois.signontime
        theme.vars echo $color(whois) $gettok($theme.raw.echo(318),1,9)
        theme.text whois $gettok($theme.raw.echo(318),2,9) $1-
        unset %whois.*
        halt
      }
    }
    elseif (%n == 369) {
      set -nu %::nick $2
      if ($hgt(whowas)) && ($theme.current == mts) && ($gettok($theme.raw.echo(369),1,9)) && (%whois.nick) {
        set -nu %::nick %whois.nick
        set -nu %::address %whois.address
        set -nu %::realname %whois.realname
        set -nu %::wserver %whois.wserver
        set -nu %::serverinfo %whois.serverinfo
        theme.vars echo $color(whois) $gettok($theme.raw.echo(369),1,9)
        theme.text whowas $gettok($theme.raw.echo(369),2,9) $1-
        unset %whois.*
        halt
      }
    }

    if ((!%::text) && ((%::chan == $2) || (%::nick == $2) || (%::value == $2))) { set -nu %::text $3- }
    if (!%::value) { set -nu %::value $2 }
    if (!%::text) { set -nu %::text $2- }
    if (!%:target) { set -nu %:target $2 }
    set -nu %::fromserver $nick
    set -nu %::numeric %n

    var %e = $theme.raw.echo(%n,%:target)
    if (%e) {
      if ($gettok(%e,2,9) == 2) || ($gettok(%e,2,9) == 3) {
        theme.vars echo $color(info) $gettok(%e,1,9)
        set -u %:raw $1-
        theme.text %r $gettok(%e,2,9) $1-
      }
    }
    else { halt }
  }
}

on *:EXIT:{
  hsave -o theme.settings " $+ $datathemes(settings.src) $+ "
  hsave -o theme.current " $+  $datathemes(current.src) $+ "
}

menu menubar {
  -
  $iif($enabled(themes),Themes)
  .Ouvrir TEMX:themes
  .$iif($hgt(schemenames),Changer Scheme)
  ..$iif(!$hgt(scheme),$style(1)) Défaut:theme.scheme
  ..-
  ..$submenu($theme.menu.schemes($1))
  .-
  .Liens
  ..mIRCscripts.org:url -n http://www.mircscripts.org/archive/themes
  ..ScriptsDB.org:url -n http://www.scriptsdb.org/files.php?type=theme
  .Aide:themes help
  -
}

#features.themes end

alias -l theme.rawdigit {
  if ($len($1) == 1) { return 00 $+ $1 }
  elseif ($len($1) == 2) { return 0 $+ $1 }
  return $1
}
alias -l theme.raw.echo {
  var %i = $iif($hgt(indent),i $+ $ifmatch,i12)
  var %h = $hg($hfind(theme.settings,theme.raw.*. $+ $1,1,w))
  if (%h == $null) { var %h = $hg(theme.raw.all) }
  var %d = $gettok(%h,1,32),%a = $gettok(%h,2,32)

  if (%d == 4) { return $iif($window($2),-t $+ %i $2,-ta $+ %i) 	 $+ %a }
  elseif (%d == 3) { return $iif($window($2),-t $+ %i $2,-ts $+ %i) 	 $+ %a }
  elseif (%d == 2) { return -ta $+ %i 	 $+ %a }
  elseif (%d == 1) { return -ts $+ %i 	 $+ %a }
  return
}
;ces

;################### PREVIEWING ######################
;sec Previews

;Print the previews (-l print on the larger preview window, -s print on the themes window)
alias theme.preview {
  if (!$enabled(themes)) { $infodialog(La fonctionnalité des themes est désactivée.Réactivez-la d'abord.) | return }
  ;Parsing options
  if ($1 == -l) {
    var %z = l
    if ($2 isnum) { var %s = $2,%f = $3- }
    else { var %f = $2- }
  }
  elseif ($1 isnum) { var %z = s,%s = $1,%f = $2- }
  else { var %z = s,%f = $1- }
  if ($right(%f,4) == .mts) { var %t = m }
  elseif ($right(%f,4) == .nnt) { var %t = y }
  elseif ($right(%f,4) == .zip) { var %t = z }

  var %s = $iif(%s,%s,0)
  if ($isfile(%f)) {
    ;unzip
    if (%t == z) {
      var %z = $scriptdirextracted\ $+ $left($nopath(%f),-4) $+ \
      ha theme.extract $+(preview,	,%f,	,%z,	,$iif($1 == -l,-l) %s)
      if (!$isdir(%z)) { szip SUnZipFile %f > %z }
      else { .signal SZIP Z_OK %f }
      return
    }

    if ($dialog(themes)) { did -b themes $iif(%z == s,12,13) }

    ;deterrmination du theme et du scheme sélectionné
    set -u %:theme $iif(%t != z,$theme.info(name,%f))
    set -u %:scheme $iif(%t != z,$theme.info(%s,%f))

    var %p = $+($shortfn($scriptdirpreview\),$nopath(%f),$iif(%s,-),%s,-,%z,.bmp)
    ; Si preview en cache, charger le cache
    if ($isfile(%p)) { 
      theme.preview.show %p 
      if ($dialog(themes)) { did -e themes $iif(%z == s,12,13) } 
      return 
    }
    if (!$hget(theme.preview)) { hmake theme.preview 50 }
    if ($window(@theme.preview.text)) { window -c @theme.preview.text }
    window -h @theme.preview.text

    ;Loader le theme selectionné dans la table preview
    theme.preview.hash %f
    if (%s > 0) || ((%s == 0) && (%t == y)) { theme.preview.hash %s %f }
    ;couleurs par défaut
    if (!$hgp(colors)) { hap colors $cdef }
    if (!$hgp(rgbcolors)) { hap rgbcolors $rgbdef }

    if (%t == m) {
      ; Assignation des variables
      if (%s) { hap scheme $theme.info(%s,%f) }

      if ($hgp(basecolors) != $null) {
        var %chi = $ifmatch
        set -u %::c1  $+ $iif($gettok(%chi,1,44),$v1,$basecolor(1))
        set -u %::c2  $+ $iif($gettok(%chi,2,44),$v1,$basecolor(2))
        set -u %::c3  $+ $iif($gettok(%chi,3,44),$v1,$basecolor(3))
        set -u %::c4  $+ $iif($gettok(%chi,4,44),$v1,$basecolor(4))
        set -u %::c5  $+ $iif($gettok(%chi,5,44),$v1,$basecolor(5))
      }
      set -u %::pre $theme.parse(m,$hgp(prefix))
      set -u %::timestampformat $iif($hgp(timestampformat),$ifmatch, [HH:nn:ss])
      set -u %::timestamp $iif($hgp(timestamp) == on,$theme.parse(m,%::timestampformat))

      var %:script = $nofile(%f) $+ $hgp(script)
      if ($isfile(%:script)) && (!$script(%:script)) {
        .load -rs $+(",%:script,")
        set -u %:unload 1
      }
    }
    elseif (%t == y) {
      hap scheme $theme.info(%s,%f)
      set -u %::pre $theme.parse(y,$hgp(prefix))
      set -u %::linesep $theme.parse(y,$hgp(linesep))
      set -u %::timestampformat $iif($hgp(timestampformat),$ifmatch, [HH:nn:ss])
      set -u %::timestamp $iif($iif($hgp(timestamp) != $null,$ifmatch,1) == 1,%::timestampformat)
    }

    ;creation des lignes de preview
    set -u %::me $me
    set -u %::chan #pokemonfrance
    set -u %::address Klarth@TalesOfPhantasia.com
    set -u %::created $asctime
    set -u %::server $iif($status == connected,$server,irc.epiknet.org)
    set -u %::network $iif($status == connected,$network,Epiknet)
    set -u %::port $port
    set -u %::target #pokemonfrance
    set -u %::myaddress %::address
    set -u %::myident TalesOfPhantasia.com
    set -u %::myhost Klarth

    theme.preview.add %t 8 joinself
    if (%z == l) {
      set -u %::text Visitez mircscripts.org! pour télécharger plein de scripts MIRC!
      set -u %::numeric 332
      theme.preview.add %t 21 raw.332 %::me %::chan %::text
      set -u %::nick Zhu'
      set -u %::text $asctime($calc($ctime - $rand(5,864000)))
      set -u %::numeric 333
      theme.preview.add %t 21 raw.333 %::me %::chan %::nick %::text
      set -u %::text $calc($ctime - $rand(864000,8640000))
      set -u %::numeric 329
      theme.preview.add %t 21 raw.329 %::me %::chan %::text
    }

    set -u %::nick Misdre
    set -u %::cmode @
    set -u %::text $gettok(Salut Bonjour Bonsoir,$r(1,3),32) %::me !
    theme.preview.add %t 4 highlight %::text
    unset %::cmode
    set -u %::text $gettok(lu slt wech Salut Bonsoir Bonjour,$r(1,6),32) Misdrou :o
    theme.preview.add %t 16 textchanself %::me %::text
    set -u %::nick TomicBomb
    set -u %::address Romain128@griknot.org
    theme.preview.add %t 8 join
    if (%z == l) {
      set -u %::fromserver Epiknet
      set -u %::isregd is
      set -u %::realname BOMB BOMB BOMB
      set -u %::chan @#bomball +#AL-Qaida #pokemonfrance
      set -u %::idletime 42
      set -u %::signontime $asctime($calc(1063090795 - $rand(360,7200)))
      set -u %::wserver irc.epiknet.org
      set -u %::serverinfo Epiknet server
      if ($hgp(whois)) { var %whois1 = $ifmatch }
      if (%whois1) {
        set -u %::numeric 318
        var %whois = $theme.parse(m,$ifmatch)
        set -u %:echo aline -p @theme.preview.text 21 $time(%::timestamp)
        if ($gettok(%whois,1,32) == !script) { $gettok(%whois,2-,32) }
        else { %:echo %whois }
      }
      else {
        if (%t == y) { theme.preview.add %t 21 whoisstart }
        set -u %::numeric 311
        theme.preview.add %t 21 raw.311 %:me %::nick %::fromserver %::wserver * %::realname
        set -u %::numeric 307
        theme.preview.add %t 21 raw.307 %::me %::nick %::isregd
        set -u %::numeric 319
        theme.preview.add %t 21 raw.319 %::me %::nick %::chan
        set -u %::numeric 312
        theme.preview.add %t 21 raw.312 %::me %::nick %::wserver %::serverinfo
        set -u %::numeric 317
        theme.preview.add %t 21 raw.317 %::me %::nick %::idletime %::signontime
        set -u %::numeric 313
        theme.preview.add %t 21 raw.313 %::me %::nick %::isoper %::operline
        set -u %::numeric 318
        theme.preview.add %t 21 raw.318 %::me %::nick End of /WHOIS list
      }
    }
    set -u %::chan #pokemonfrance
    set -u %::nick Eole
    set -u %::modes +h TomicBomb
    theme.preview.add %t 10 mode %::modes
    set -u %::nick TomicBomb
    set -u %::cmode %
    set -u %::text plop $gettok(everybody tlm,$r(1,2),32)
    theme.preview.add %t 12 textchan %::text
    set -u %::nick Zhu[aw]
    set -u %::newnick Zhu'
    set -u %::cmode @
    set -u %::chan #pokemonfrance
    theme.preview.add %t 11 nick
    set -u %::nick Zhu'
    set -u %::text slaps Misdre qui s'amuse avec son op
    theme.preview.add %t 2 actionchan %::text
    set -u %::nick Misdre
    set -u %::address ~misdroug@pokepedia.org
    set -u %::knick Zhu'
    set -u %::kaddress zhu@quarnage.com
    set -u %::chan #pokemonfrance
    set -u %::text Le voila ton op :)
    theme.preview.add %t 9 kick %::text
    set -u %::nick Misdre
    set -u %::address ~misdroug@pokepedia.org
    set -u %::chan #pokemonfrance
    theme.preview.add %t 17 part
    set -u %::nick TomicBomb
    set -u %::address Romain128@griknot.org
    set -u %::cmode %
    set -u %::modes +v %::me
    theme.preview.add %t 10 mode %::modes
    set -u %::nick Zhu'
    set -u %::address zhu@quarnage.com
    theme.preview.add %t 8 join
    set -u %::nick Eole
    set -u %::address services@epiknet.org
    set -u %::modes +o Zhu'
    theme.preview.add %t 10 mode %::modes
    set -u %::nick $me
    set -u %::address Klarth@TalesOfPhantasia.org
    set -u %::cmode +
    set -u %::text owned Zhu' 
    theme.preview.add %t 16 textchanself %::me %::text
    set -u %::nick Zhu'
    set -u %::address zhu@quarnage.com
    set -u %::cmode @
    set -u %::text MISDROU TU VAS PAYER!
    theme.preview.add %t 19 topic %::text
    set -u %::nick Zhu'
    set -u %::address zhu@quarnage.com
    set -u %::modes +b ~misdroug@*.*
    theme.preview.add %t 10 mode %::modes
    set -u %::nick TomicBomb
    set -u %::address Romain128@griknot.org
    set -u %::cmode %
    set -u %::text Attention il est IRCOP maintenant!
    theme.preview.add %t 13 notice %::text
    set -u %::target TomicBomb
    set -u %::address ~misdroug@pokepedia.org
    set -u %::cmode 
    set -u %::text Hahahaz
    theme.preview.add %t 13 textmsg %::target %::text
    set -u %::nick Balthier
    set -u %::address fredo@pi.org
    set -u %::cmode +
    set -u %::text Quit: Je préfère etre belle et rebelle que moche et remoche!
    theme.preview.add %t 18 quit %::text
    if (%z == l) { theme.preview.add %t 14 unotify }
    set -u %::nick robindu93
    set -u %::address rob1du93@skyrock.com
    set -u %::ctcp PING
    set -u %::cmode
    set -u %::text $ctime
    theme.preview.add %t 3 ctcp %::ctcp %::text
    if (%z == l) {
      set -u %::target robindu93
      set -u %::text 1sec
      theme.preview.add %t 3 ctcpreplyself %::text
      set -u %::chan #bogosscherchefemmejoliebelle
      theme.preview.add %t 7 invite
      set -u %::modes +w
      theme.preview.add %t 10 modeuser %::modes
      set -u %::nick Balthier
      theme.preview.add %t 14 notify
      set -u %::nick Zhu'
      set -u %::address zhu@quarnage.com
      set -u %::cmode @
      set -u %::text Demain c'est la fête a Fae!!!
      theme.preview.add %t 20 wallop %::text
      set -u %::nick Misdre
      set -u %::address ~misdroug@pokepedia.org
      set -u %::cmode
      set -u %::text osef?
      theme.preview.add %t 11 textmsg %::text
      set -u %::nick Zhu'
      set -u %::address zhu@quarnage.com
      set -u %::cmode @
      set -u %::text Alors %::me $+ , il est bien le nouveau theme?
      theme.preview.add %t 12 textchan %::text
      set -u %::cmode +
      set -u %::text Ouais, j'utilise le scheme $iif($hgp(scheme),$ifmatch,default) , toi aussi?
      theme.preview.add %t 16 textchanself %::me %::text
      set -u %::cmode @
      set -u %::text non
      theme.preview.add %t 12 textchan %::text
      set -u %::cmode +
      set -u %::text :(
      theme.preview.add %t 16 textchanself %::me %::text
      set -u %::text teste
      theme.preview.add %t 16 actionchanself %::me %::text
      theme.preview.add %t 5 load
    }

    ;Recuperation des colors et des fonts
    set -u %:colors $iif($hgp(colors),$v1,$cdef)
    set -u %:rgbcolors $iif($hgp(rgbcolors),$v1,$rgbdef) 
    set -u %:fontchan $iif($hgp(fontchan),$v1,Arial $+ $comma $+ -9)
    if (%t == y) { var %font = $iif($hgp(font),$v1,Arial), %fsize = $iif($hgp(fontsize),$v1,-9) | set -u %:fontchan $+(%font,$comma,%fsize) }

    var %nn = $theme.colornum(preview)
    wmi colors %nn preview $+ $comma $+ $replace(%:colors,$chr(32),$chr(44))
    var %c = 1
    while ($gettok(%:rgbcolors,%c,32) != $null) {
      var %r = %r $+ , $+ $rgb( [ $theme.load.color($ifmatch) ] )
      inc %c
    }
    wmi palettes %nn $right(%r,-1)

    ;test de la font
    var %i = 1, %fontdef, %font, %size, %bold
    while ($gettok(%:fontchan,%i,59)) {
      var %fontdef = $ifmatch
      var %font = $gettok(%fontdef,1,44), %size = $gettok(%fontdef,2,44), %bold = $gettok(%fontdef,3,44)

      if ($isfont(%font)) { break }
      else { 
        var %install = $input(La police %font n'est pas disponible sur votre système. Voulez vous la télécharger?,yqa)
        if (%install) { run http://www.dafont.com/search.php?psize=m&q= $+ %font | halt }
      }
      inc %i
    }
    if (!$isfont(%font)) { %font = Arial }
    if (!%size) || (%size !isnum) { %size = -9 }
    if (!$regex(%bold,[biBI]*)) { %bold = $null } 


    ; Recuperation de la couleur d'arriere plan
    var %delim = $iif(%t == m,44,$iif(%t == y,32,44))
    var %bg = $gettok(%:colors,1,%delim)

    ; Creation de la fenetre de preview
    if ($window(@theme.preview)) { window -c @theme.preview }
    window -Bpfh +d @theme.preview -1 -1 $iif(%z == s,300 222,650 700)
    drawfill -r @theme.preview $rgbcolor(%bg) $rgbcolor(%bg) 1 1

    .color -ls preview
    ; Copiage des lignes dans la fenetre
    var %i = 1
    while ($line(@theme.preview.text,%i)) {
      var %tline $ifmatch
      var %color = $gettok(%:colors,$gettok(%tline,1,32),$iif(%t == m,44,32))
      var %line = $gettok(%tline,2-,32)

      drawtext -prnb $+ $iif(b isin %bold,o) @theme.preview $rgbcolor(%color) $rgbcolor(%bg) $qt(%font) %size 3 $iif(%i != 1,$calc(1 + ((%i - 1) * $height(%line,$qt(%font),%size))),1) %line
      inc %i
    }
    .color -ls $hgt(name) $iif($hgt(scheme),- $hgt(scheme))
    ; remmi colors $theme.colornum(preview)
    ; remmi palettes %nn

    drawsave @theme.preview %p
    theme.preview.show %p
    window -c @theme.preview.text
    hfree theme.preview
    if ($hget(theme.default)) { hfree theme.default }

    if (%:unload) { .unload -rs " $+ %:script $+ " }
    if ($dialog(themes)) { did -e themes $iif(%z == s,12,13) }
  }
}

; Load a dummy theme to show not formatted events to a default format
alias -l theme.default.hash {
  var %f = themes/default.mts

  if ($isfile(%f)) {
    if ($fopen(def)) { .fclose def }
    .fopen def " $+ %f $+ "
    if ($ferr) { .fclose def | return }
    while (!$feof) {
      if ($fread(def)) {
        tokenize 32 $ifmatch
        if ($1 == [mts]) || (!$1) || ($left($1,1) == $chr(59)) { continue }
        elseif ($+($chr(91),scheme*,$chr(93)) iswm $1) { .fclose def | return }
        else { had $lower($1) $2- }
      }
    }
    .fclose def
  }
}

; Add the theme properties to the preview htable
alias -l theme.preview.hash {
  if ($1 isnum) { var %s = $1,%f = $2- }
  else { var %f = $1- }
  var %t = $iif($right(%f,4) == .mts,m,$iif($right(%f,4) == .nnt,y,x))

  if ($isfile(%f)) {
    if ($fopen(pre)) { .fclose pre }
    .fopen pre " $+ %f $+ "
    if ($ferr) { .fclose pre | return }

    if (%t == m) {
      if (%s) { .fseek -w pre $+($chr(91),scheme $+ %s,$chr(93)) | var %l = $fread(pre) }
      while (!$feof) {
        if ($fread(pre)) {
          tokenize 32 $ifmatch
          if ($1 == [mts]) || (!$1) || ($left($1,1) == $chr(59)) { continue }
          elseif ($+($chr(91),scheme*,$chr(93)) iswm $1) { .fclose pre | return }
          else { hap $lower($1) $2-  }
        }
      }
    }
    elseif (%t == y) {
      if (%s != $null) { 
        .fseek -w pre scheme $+ %s $+ *
        var %scheme = $gettok($fread(pre),2-,32)
        .fclose pre

        noop $regex(scheme,%scheme,/(\S+) (\d+ )(.*)/)
        var %scn = $regml(scheme,1), %scheme = $regml(scheme,2) $+ $regml(scheme,3)
        var %rgbcolors = $gettok(%scheme,1-16,32),%colors = $gettok(%scheme,17-,32)

        hap colors %colors
        hap rgbcolors %rgbcolors
        return 
      }
      while (!$feof) {
        if ($fread(pre)) {
          tokenize 32 $ifmatch
          if (!$1) || ($left($1,1) == $chr(59)) { continue }
          else { hap $lower($theme.mtsequiv($1)) $2- }
        }
      }
    }
    .fclose pre
  }
}

;Add a line to the preview window
;$1 type of theme, $2 color name,$3 event, $4- parameters
alias -l theme.preview.add {
  if (!$hget(theme.default)) { hmake theme.default 100 } 
  if (!$hgd($3)) { theme.default.hash }

  set -nu %:text $iif($hgp($3),$ifmatch,$hgd($3))
  if (!%:text) || (%:text == !empty) { return }
  if ($3 == load) && ($1 == y) { return }
  if ($3 == highlight) && (!$hgp(highlight)) { set -nu %:text $iif($hgp(textchan),$ifmatch,$hgd(textchan)) }

  set -nu %:echo aline -p @theme.preview.text $2 $time(%::timestamp)
  set -nu %::parentext $theme.ptext(%::text)
  set -nu %:text $theme.parse($1,%:text)

  if ($gettok(%:text,1,32) == !script) {
    if (!$gettok(%:text,2,32)) {
      if (raw. isin $1) { halt }
    }
    else { [ [ $gettok(%:text,2-,32) ] ] }
  }
  else {
    ; NNT themes: conversion du $chr(1) pour ecrire plusieurs lignes
    if ($1 == y) {
      var %nlines = $numtok(%:text,1), %i = 1
      while (%i <= %nlines) { 
        set -nu %:stext [ [ $gettok(%:text,%i,1) ] ]
        set -nu %:stext $replace(%:stext,% $+ ::text,%::text)
        %:echo %:stext 
        inc %i 
      }
    }
    else { 
      set -nu %:text [ [ %:text ] ] 
      set -nu %:text $replace(%:text,% $+ ::text,%::text)
      %:echo %:text
    }
  }
}

; Load the preview in the theme manager
; $1: image en cache
alias -l theme.preview.show {
  ;Type de cache (large/small)
  var %s = $mid($1-,-5,1)
  if (%s == s) {
    if (!$dialog(themes)) { themes }
    did -ra themes 11 $shorten(32,Preview: %:theme $iif(%:scheme,- $ifmatch))
    did -g themes 16 $1-
    did -h themes 14,15
    did -v themes 16
  }
  elseif (%s == l) {
    if ($dialog(theme.large)) { dialog -x theme.large theme.large }
    dialog -hm theme.large theme.large
    did -g theme.large 4 $1-
    did -ra theme.large 2 Preview: %:theme $iif(%:scheme,- $ifmatch)
  }
  if (c !isin $theme.options(manager)) { .remove $1- }
}


; Retourne la couleur rgb d'un index de couleurs en piochant dans les variables deja assignées %:colors et %:rgbcolors
; $1: numero de couleur dans la palette
alias -l rgbcolor {
  if (!%:colors) || (!%:rgbcolors) { return 0 }
  if ($1- isnum) { var %index = $1 }
  elseif ($1 isalnum) { var %index = $colorindex($1-) }

  var %rgbcolor = $gettok(%:rgbcolors,$calc(%index + 1),32)

  return $rgb( [ $theme.load.color(%rgbcolor) ] )
}

dialog -l theme.large {
  title " Large Theme Preview"
  size -1 -1 700 705
  text "Preview:", 2, 10 2 250 14
  icon 4, 9 18 680 700, $mircexe, 0
}
on *:dialog:theme.large:*:*:{
  if ($devent == init) {
    mdxload
    mdx SetDialog $dname style title sysmenu tool
  }
  elseif ($devent == rclick) && ($did == 4) {
    newpopup preview
    newmenu preview 1 $chr(9) + 1 0 &Enregistrer Sous
    newmenu preview 2 $chr(9) + 2 0 -
    newmenu preview 3 $chr(9) + 3 0 &Fermer
    displaypopup preview
  }
}

ON *:SIGNAL:XPOPUP-preview:{
  if ($1 == 1) { drawsave @theme.preview $qt($$sfile($nopath($did(theme.large,4)),Enregistrer preview sous...,Sauver)) }
  elseif ($1 == 3) { dialog -c theme.large }
}
;ces

;sec Loading window
alias -l theme.load.show { 
  if ($1 isnum) && ($dialog(theme.load)) { did -a theme.load $1 $2- } 
}

dialog theme.load {
  title "Chargement du thème..."
  size -1 -1 87 38
  option dbu
  text "", 1, 5 4 76 8, center
  text "", 3, 5 16 76 8
  text "", 2, 5 26 76 8
}
on *:dialog:theme.load:init:*:{
  mdxload
  mdx SetControlMDX $dname 2,3 progressbar smooth > $mdxdir $+ ctl_gen.mdx
}

;ces

; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
