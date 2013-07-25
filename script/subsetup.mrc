;------------------------------------------
; Alias utilisés dans les options
;------------------------------------------


; Ajout d'un nouveau trigger
alias awaytrigger.add {
  var %newval $$inputdialog(Ajoutez un nouveau highlight à la liste (Ne pas mettre de caractère ';') :)
  if ($chr(59) isin %newval) { $errdialog(Le highlight ne doit pas contenir de ';'!) | return }
  if ($istok($ri(awaylog,triggers),%newval,59)) { $infodialog(Highlight $qt(%newval) déjà présent!) | return }
  did -a settings 220 %newval
  did -u settings 220
  did -b settings 222,223
  did -e settings 224
  wi awaylog triggers $didtok(settings,220,59)
}

;Edition d'un/de plusieurs trigger(s)
alias awaytrigger.edit {
  var %sellines = $did(settings,220,0).sel
  var %i = 1
  while (%i <= %sellines) {
    var %seltext = $did(settings,220).seltext, %sel = $did(settings,220).sel
    %seltext = $$inputdialog(Modifiez le highlight $qt(%seltext) (Ne pas mettre de caractère ';') :,%seltext)
    if ($chr(59) isin %seltext) { $errdialog(Le highlight ne doit pas contenir de ';'!) | did -ku settings 220 %sel }
    elseif ($istok($ri(awaylog,triggers),%seltext,59)) { $infodialog(Highlight $qt(%seltext) déjà présent!) | did -ku settings 220 %sel }
    else { did -o settings 220 %sel %seltext }
    inc %i
  }
  did -u settings 220
  did -b settings 222,223
  did -e settings 224
  wi awaylog triggers $didtok(settings,220,59)
}

;Suppression d'un/plusieurs trigger(s)
alias awaytrigger.del {
  var %sellines = $did(settings,220,0).sel
  if (%sellines > 1) {
    var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer les highlights sélectionnés?)
    if (%yn) {
      var %i = 1
      while (%i <= %sellines) { did -d settings 220 $did(settings,220).sel | inc %i }
    }
  }
  else {
    var %seltext $did(settings,220).seltext, %sel = $did(settings,220).sel
    var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer le highlight $qt(%seltext) $+ ?)
    if (%yn) { did -d settings 220 %sel }
  }
  did -u settings 220
  did -b settings 222,223
  if ($did(settings,220).lines == 0) { did -b settings 224 }
  wi awaylog triggers $didtok(settings,220,59)
}

;Effacement de tous les triggers
alias awaytrigger.clear {
  var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer tous les highlights?)
  if (%yn) { did -r settings 220 }
  did -b settings 222-224
  wi awaylog triggers $null
}

; Ajout d'un nouveau canal à exclure
alias awaymess.add {
  var %newval $$inputdialog(Ajoutez un nouveau canal/query à exclure du répondeur :(Ne pas mettre de caractère ';') :)
  if ($chr(59) isin %newval) { $errdialog(Le canal/query ne doit pas contenir de ';'!) | return }
  if ($istok($ri(awaymess,channels),%newval,59)) { $infodialog(Canal/query $qt(%newval) déjà présent!) | return }
  did -a settings 320 %newval
  did -u settings 320
  did -b settings 322,323
  did -e settings 324
  wi awaymess channels $didtok(settings,320,59)
}

;Edition d'un/de plusieurs canal(ux)
alias awaymess.edit {
  var %sellines = $did(settings,320,0).sel
  var %i = 1
  while (%i <= %sellines) {
    var %seltext = $did(settings,320).seltext, %sel = $did(settings,320).sel
    %seltext = $$inputdialog(Remplacer le canal/query $qt(%seltext) par :(Ne pas mettre de caractère ';'),%seltext)
    if ($chr(59) isin %seltext) { $errdialog(Le canal/query ne doit pas contenir de ';'!) | did -ku settings 320 %sel }
    elseif ($istok($ri(awaymess,channels),%seltext,59)) { $infodialog(Canal/query $qt(%seltext) déjà présent!) | did -ku settings 320 %sel }
    else { did -o settings 320 %sel %seltext }
    inc %i
  }
  did -u settings 320
  did -b settings 322,323
  did -e settings 324
  wi awaymess channels $didtok(settings,320,59)
}

;Suppression d'un/plusieurs canal(ux)
alias awaymess.del {
  var %sellines = $did(settings,320,0).sel
  if (%sellines > 1) {
    var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer les canaux/queries sélectionnés?)
    if (%yn) {
      var %i = 1
      while (%i <= %sellines) { did -d settings 320 $did(settings,320).sel | inc %i }
    }
  }
  else {
    var %seltext $did(settings,320).seltext, %sel = $did(settings,320).sel
    var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer le canal/query $qt(%seltext) $+ ?)
    if (%yn) { did -d settings 320 %sel }
  }
  did -u settings 320
  did -b settings 322,323
  if ($did(settings,320).lines == 0) { did -b settings 324 }
  wi awaymess channels $didtok(settings,320,59)
}

;Effacement de tous les canaux à exclure du répondeur
alias awaymess.clear {
  var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer tous les canaux à exclure?)
  if (%yn) { did -r settings 320 }
  did -b settings 322-324
  wi awaymess channels $null
}

; Ajout d'un nouveau serveur dans la liste des serveurs (menu Away Misc)
alias servers.add {
  var %newval = $$inputdialog(Entrez le nom du nouveau serveur (Ne pas mettre de caractère ';') :)
  if ($chr(59) isin %newval) { $errdialog(Le serveur ne doit pas contenir de ';'!) | return }
  if ($istok($ri(nicks,servers),%newval,59)) { $infodialog(Serveur $qt(%newval) déjà présent!) | return }
  did -a settings 412 %newval
  did -c settings 412 1
  if ($did(settings,412).seltext != Défaut) { did -e settings 414 }
  wi nicks servers $didtok(settings,412,59)  
}

; Suppression du serveur selectionné et de ses informations
alias servers.del {
  var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer ce serveur et toutes les informations qui le concernent?)
  if (%yn) { 
    var %server $did(settings,412).seltext
    did -d settings 412 $did(settings,412).sel
    did -c settings 412 1
    wi nicks servers $didtok(settings,412,59) 
    remi nicks nicks. $+ %server
    if ($did(settings,412).seltext == Défaut) { did -b settings 414 }
  }
}

; Lit la liste des fkeys clavier enregistrés
alias fkeys.loadref {
  did -hr settings 520
  var %i = 1
  var %keys = F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 SF1 SF2 SF3 SF4 SF5 SF6 SF7 SF8 SF9 SF10 SF11 SF12 CF1 CF2 CF3 CF4 CF5 CF6 CF7 CF8 CF9 CF10 CF11 CF12
  while ($gettok(%keys,%i,32)) {
    var %key = $ifmatch
    var %bind = $fkeys.readKey(%key)
    if (!%bind) { continue }
    if (%i <= 36) { %key = $replace(%key,s,Shift+,c,Ctrl+) }
    tokenize 1 %bind

    did -a settings 520 1 + 0 0 0 %key $+ $chr(9) $+ 0 0 0 $2 $+ $chr(9) $+ 0 0 0 $3
    inc %i
  }
  did -v settings 520
  did -b settings 521,523,526
}

; Supprime un raccourci clavier
alias fkeys.delsel {
  var %line = $did(settings,520).sel, %lval = $did(settings,520).seltext
  var %key = $getColValue(settings,520,%line,1)

  fkeys.setKey %key $chr(1)
  fkeys.loadref
}

; Restaure un raccourci a sa valeur par défaut
alias fkeys.setdef {
  var %line = $did(settings,520).sel, %lval = $did(settings,520).seltext
  var %key = $getColValue(settings,520,%line,1)

  fkeys.setKey %key $gettok($fkeys.readDefKey(%key),2-,1)
  fkeys.loadref

}

; Suppr tous les raccourcis
alias fkeys.delall {
  var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir effacer tous les raccourcis enregistrés?)
  if (%yn) {
    var %i = 2
    while (%i <= $did(settings,520).lines) {
      var %key = $getColValue(settings,520,%i,1)
      fkeys.setKey %key $chr(1)
      inc %i
    }
    fkeys.loadref
  }
}

; Restaure les raccourcis a leur valeur par défaut
alias fkeys.restoreall {
  var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir restaurer tous les raccourcis a leur valeur par défaut?)
  if (%yn) {  
    var %i = 2
    var %file = $qt(data/fkeys-def.txt)
    if (!$exists(%file)) { $errdialog(Le fichier %file est introuvable! | halt }

    while (%i <= $did(settings,520).lines) {
      var %key = $getColValue(settings,520,%i,1)
      fkeys.setKey %key $gettok($fkeys.readDefKey(%key),2-,1)
      inc %i
    }
    fkeys.loadref
  }
}


; Edit le raccourci selectionné
alias fkeys.edit {
  var %sel = $did(settings,520).sel
  var %key $getColValue(settings,520,%sel,1) 
  var %cmd $getColValue(settings,520,%sel,2) 
  var %desc $getColValue(settings,520,%sel,3)
  var %res = $$formdialog(Entrez la nouvelle commande pour la touche %key Vous pouvez aussi lui ajouter une description qui sera affichée dans les options.,Commande,Description,%cmd,%desc)
  fkeys.setKey %key %res
  fkeys.loadref
}

; Remplit la liste des personal protections
alias pprot.reflist {
  var %prot = Ban,CTCPFlood,DCCFlood,HighlightFlood,InviteFlood,NoticeFlood,QueryFlood,Spam
  var %i = 1

  window -h @pprot.setload

  while ($gettok(%prot,%i,44)) {
    var %token = $v1

    var %use = $iif($rci(pprot,%token $+ .use),$ifmatch,0)
    var %times = $iif($rci(pprot,%token $+ .times),$ifmatch,3)
    var %interval = $iif($rci(pprot,%token $+ .interval),$ifmatch,30)
    var %action = $rci(pprot,%token $+ .action)

    if (%times == 1) { %interval = n/a } 
    echo @pprot.setload 0 + 0 0 $iif(%use == 0,1,2) %token $+ 	+ 0 0 0 %times $+ 	+ 0 0 0 %interval $+ 	+ 0 0 0 $parseaction(%action)
    inc %i
  }
  filter -cwo @pprot.setload settings 920
  close -@ @pprot.setload
}

; Remplir la liste de channel protections
alias cprot.reflist {
  var %chan = $iif($did(settings,812).seltext != Tous,$did(settings,812).seltext,default)
  var %cprot = $iif(%chan == default,cprot,cprot. $+ %chan)
  var %prot = Pub,Badwords,Majs,Codes,CTCPFlood,HopFlood,NoticeFlood,Répétitions,Flood
  var %i = 1

  window -h @cprot.setload

  while ($gettok(%prot,%i,44)) {
    var %token = $v1

    var %use = $iif($rci(%cprot,%token $+ .use),$ifmatch,0)
    var %times = $iif($rci(%cprot,%token $+ .times),$ifmatch,3)
    var %interval = $iif($rci(%cprot,%token $+ .interval),$ifmatch,30)
    var %action = $rci(%cprot,%token $+ .action)

    if (%times == 1) { %interval = n/a } 
    echo @cprot.setload 0 + 0 0 $iif(%use == 0,1,2) %token $+ 	+ 0 0 0 %times $+ 	+ 0 0 0 %interval $+ 	+ 0 0 0 $parseaction(%action)
    inc %i
  }
  filter -cwo @cprot.setload settings 830
  close -@ @cprot.setload
}

; Ajoute un canal a la liste des canaux avec protections
alias cprot.add {
  var %newval $$inputdialog(Entrez le nom du canal :(Ne pas mettre de ';') :)
  if ($left(%newval,1) != $chr(35)) { %newval = $chr(35) $+ %newval }
  if ($chr(59) isin %newval) { $errdialog(Le canal ne doit pas contenir de ';'!) | return }
  if ($istok($rci(cprot,channels),%newval,59)) { $infodialog(Canal $qt(%newval) déjà existant!) | return }
  did -ac settings 812 %newval
  did -e settings 814,815,817-819
  wci cprot channels $remove($didtok(settings,812,59),Tous)
  cprot.loaddef
  cprot.reflist
}

; Supprime un canal de la liste des canaux avec protections
alias cprot.del {
  var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer toutes les protections appliquées à ce canal?)
  if (%yn) { 
    var %chan $did(settings,812).seltext
    did -d settings 812 $did(settings,812).sel
    did -c settings 812 1
    wci cprot channels $remove($didtok(settings,812,59),Tous)
    wci cprot. $+ %chan
    if ($did(settings,812).seltext == Tous) { did -b settings 814,815,817-819 }
    cprot.reflist
  }
}

; Charge les prots par défaut
alias cprot.loaddef {
  var %chan = $iif($did(settings,812).seltext != Tous,$did(settings,812).seltext,default)
  var %cprot = $iif(%chan == default,cprot,cprot. $+ %chan)

  var %f = $qt($iif($ri(paths,prot),$v1,data/prot.ini))
  var %nbr = $ini(%f,def,0)

  while (%nbr > 0) {
    var %section $ini(%f,def,%nbr)
    wci %cprot %section $rci(def,%section)
    dec %nbr
  }
}

; Load les parametres de protection par défaut du canal sélectionné
alias cprot.resetdef {
  if ($$yndialog(Êtes-vous sûr(e) de vouloir rétablir toutes les protections pour celles par défaut?)) {
    var %chan = $iif($did(settings,812).seltext != Tous,$did(settings,812).seltext,default)
    var %cprot = $iif(%chan == default,cprot,cprot. $+ %chan)

    var %f = $qt($iif($ri(paths,prot),$v1,data/prot.ini))
    var %nbr = $ini(%f,def,0)

    while (%nbr > 0) {
      var %section $ini(%f,def,%nbr)
      wci %cprot %section $rci(def,%section)
      dec %nbr
    }
    cprot.reflist
  }
}

; Modifie la protection sélectionnée
alias cprot.changeprot {
  set -e %prot.chan $iif($did(settings,812).seltext != Tous,$did(settings,812).seltext,default)
  set -e %prot.prot $getColValue(settings,830,$did(settings,830).sel,1)
  set -e %prot.line $did(settings,830).sel
  opendialog -mh cprot. $+ $lower(%prot.prot)
}

; Load les parametres de protection personnelles par défaut
alias pprot.resetdef {
  if ($$yndialog(Êtes-vous sûr(e) de vouloir rétablir toutes les protections pour celles par défaut?)) {
    var %f = $qt($iif($ri(paths,prot),$v1,data/prot.ini))
    var %nbr = $ini(%f,pdef,0)

    while (%nbr > 0) {
      var %section $ini(%f,pdef,%nbr)
      wci pprot %section $rci(pdef,%section)
      dec %nbr
    }
    pprot.reflist
  }
}

; Modifie la protection sélectionnée
alias pprot.changeprot {
  set -e %prot.chan pprot
  set -e %prot.prot $getColValue(settings,920,$did(settings,920).sel,1)
  set -e %prot.line $did(settings,920).sel
  opendialog -mh pprot. $+ $lower(%prot.prot)
}

; Charge la liste des exclusions
alias excludes.loadref {
  did -r settings 970
  var %i = 1
  while (%i <= $hget(excl,0).item) {
    did -a settings 970 $hget(excl,%i).item
    inc %i
  }
  if ($did(settings,970).lines != 0) { did -e settings 974 }
  did -b settings 972-973
}

; Ajoute a la liste des exclusions
alias excludes.add {
  var %newval = $$inputdialog(Ajoutez une adresse à exclure des protections L'adresse doit être au format nick!user@host. Vous pouvez utiliser les jokers (*?).)
  if (*!*@* !iswm %newval) { $errdialog(Erreur: Le format doit être nick!user@host!) | halt }
  if ($hfind(excl,%newval,0,n) > 0) { $errdialog(Erreur: L'adresse $qt(%newval) existe déjà!) | halt }
  did -a settings 970 %newval
  hadd excl %newval 1
  did -e settings 974
}

; Modifie de la liste des exclusions
alias excludes.edit {
  var %seltext = $did(settings,970).seltext, %sel = $did(settings,970).sel
  %newval = $$inputdialog(Remplacer l'entrée $qt(%seltext) par :L'adresse doit être au format nick!user@host. Vous pouvez utiliser les jokers (*?).,%seltext)
  if (*!*@* !iswm %newval) { $errdialog(Erreur: Le format doit être nick!user@host!) | halt }
  if ($hfind(excl,%newval,0,n) > 0) { $errdialog(Erreur: L'adresse $qt(%newval) existe déjà!) | halt }
  did -o settings 970 %sel %newval
  hadd excl %newval 1
  hdel excl %seltext
  if ($did(settings,970).lines == 0) { did -b settings 974 }
}

; Supprime de la lsite des exclusions
alias excludes.del {
  var %sellines = $did(settings,970,0).sel
  if (%sellines > 1) {
    var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir effacer les entrées sélectionnées?)
    if (%yn) {
      var %i = 1
      while (%i <= %sellines) { 
        var %todel = $did(settings,970,1).seltext
        did -d settings 970 $did(settings,970,1).sel 
        hdel excl %todel
        inc %i 
      }
    }
  }
  else {
    var %seltext $did(settings,970).seltext, %sel = $did(settings,970).sel
    var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer l'entrée $qt(%seltext) $+ ?)
    if (%yn) { 
      did -d settings 970 %sel 
      hdel excl %seltext
    }
  }
  did -u settings 970
  did -b settings 972-973
  if ($did(settings,970).lines == 0) { did -b settings 974 }
}

;Effacement de toutes les exclusions
alias excludes.clear {
  var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer toutes les adresses?)
  if (%yn) { did -r settings 970
  did -b settings 972-974
  hfree excl
  hmake excl 100
  }
}

;Rafraichit la statusbar
alias statusbar.reflist { 
  var %f = $qt($iif($ri(paths,statusbar),$v1,data/statusbar.txt))
  if (!$isfile(%f)) { $errdialog(Erreur: Le fichier %f n'existe pas!) | halt }

  window -h @reflist
  var %i = 1
  .fopen sb %f
  did -r settings 1020
  did -i settings 1020 1 clearicons normal
  while (!$feof) {
    var %line = $fread(sb)
    if ($left(%line,1) == $chr(59)) { continue }
    tokenize 1 %line
    if ($1- != $null) {
      if ($1 != noicon) {
        did -i settings 1020 1 seticon normal 0 $mkfullfn($1).noqt
        echo @reflist 0 + %i 0 0 $2 $+ 	+ 0 0 0 $3 $+ 	+ 0 0 0 $4
        inc %i
      }
      else {
        echo @reflist 0 + 0 0 0 $2 $+ 	+ 0 0 0 $3 $+ 	+ 0 0 0 $4
      }
    }
  }
  .fclose sb
  filter -cwo @reflist settings 1020 *
  close -@ @reflist

  if ($did(settings,1020).lines <= 1) { did -b settings 1024,1029 | activeStatusbar -u }
  else { did -e settings 1024,1029 }
  did $iif($did(settings,1020).sel,-e,-b) settings 1022-1023,1025-1026
}

; Ajoute un nouvel élément de statusbar
alias statusbar.add {
  set -e %curline $calc($did(settings,1020).sel - 1)
  opendialog -mh addStatusbar
}

; Edition d'un bouton de toolbar
alias statusbar.edit {
  set -e %curline $calc($did(settings,1020).sel - 1)
  set -e %statusbar.edit 1
  opendialog -mh addStatusbar
}

;Supprime le bouton de toolbar
alias statusbar.del {
  set -e %curline $calc($did(settings,1020).sel - 1)

  var %f = $qt($iif($ri(paths,statusbar),$ifmatch,data/statusbar.txt))
  if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas) | halt }

  if ($$yndialog(Êtes-vous sûr(e) de vouloir supprimer l'élément sélectionné ?)) {
    write -dl $+ %curline %f
  }
  statusbar.reflist
  changeStatusbar
  did -c settings 1020 %curline
  unset %curline
}

; Vide la liste des boutons de toolbar
alias statusbar.clear {
  var %f = $qt($iif($ri(paths,statusbar),$ifmatch,data/statusbar.txt))
  if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas) | halt }

  if ($$yndialog(Êtes-vous sûr(e) de vouloir supprimer tous les éléments?)) {
    write -c %f
    statusbar.reflist
    activeStatusbar -u
    did -b settings 1022-1026,1029
  }
}

; Deplace le bouton selectionné. $1: up/down
alias statusbar.move {
  var %f = $qt($iif($ri(paths,statusbar),$ifmatch,data/statusbar.txt))
  if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas) | halt }

  var %curline = $calc($did(settings,1020).sel - 1)
  var %line = $read(%f,n,%curline), %rline = $readn
  var %uline = $read(%f,n,$calc(%rline - 1)), %urline = $readn
  var %dline = $read(%f,n,$calc(%rline + 1)), %drline = $readn

  if ($$1 == down) { write -l $+ %drline %f %line | write -l $+ %rline %f %dline }
  elseif ($$1 == up) {  write -l $+ %urline %f %line | write -l $+ %rline %f %uline }
  statusbar.reflist
  changeStatusbar 
  did -c settings 1020 $iif($$1 == down,$calc(%curline + 2),%curline)
  did $iif($did(settings,1020).sel == $did(settings,1020).lines,-b,-e) settings 1025
  did $iif($did(settings,1020).sel == 2,-b,-e) settings 1026
}

; Charge un preset de statusbar
; $1: nom du preset, $2: nom de la statusbar. Si pas d'arguments, clear la statusbar
alias statusbar.loadPreset {
  if ($yndialog(Etes-vous sûr de vouloir charger la Statusbar $qt($iif($1-,$1-,Noes)) $+ ? Toutes vos modifications seront perdues.)) {
    var %cwd = images/bars/ $+ $lower($1) $+ /
    var %dest = $qt($iif($ri(paths,statusbar),$ifmatch,data/statusbar.txt))
    if ($0 == 0) { write -c %dest }
    ; Cherche dans le dossier bars de images, le dossier $1
    ; Puis copie le fichier $2.txt dans data a la place du précedent
    elseif ($isdir($qt(images/bars/ $+ $1))) { 
      if ($isfile($qt(%cwd $+ $2 $+ .txt))) { .copy -o $qt(%cwd $+ $2 $+ .txt) %dest }
      else { $errdialog(Erreur: Fichier $2 $+ .txt manquant dans le répertoire $qt($mircdir $+ %cwd)) ! | halt }
    }
    else { $errdialog(Erreur: Le preset $1 n'existe pas dans le répertoire images/bars ! | halt }

    statusbar.reflist
    changeStatusbar
    did -c settings 1020 1
    did -e settings 1024,1029
  }
}

; Menu des presets toolbar
ON *:SIGNAL:XPOPUP-statusmenu:{
  if ($1 == 1) { statusbar.loadPreset HeartGold Defaut }
  elseif ($1 == 2) { statusbar.loadPreset NNScript Default }
  elseif ($1 == 3) { statusbar.loadPreset Megapack ConnectionInfo }
  elseif ($1 == 4) { statusbar.loadPreset Megapack Newsticker }
}

;Importer une statusbar
alias statusbar.import {
  if ($did(settings,1020).lines > 1) {
    var %yn = $yndialog(Enregistrer la Statusbar actuelle?)
    if (%yn) { statusbar.save }
  }
  var %new = $$sfile($mircdirdata/*.txt,Importer une Statusbar...,Charger)
  var %dest = $qt($iif($ri(paths,statusbar),$ifmatch,data/statusbar.txt))
  .copy -o $qt(%new) %dest

  statusbar.reflist
  changeStatusbar
  if ($did(settings,1020).lines > 1) { 
    did -c settings 1020 1
    did -e settings 1024,1029
  }
}

; Sauver la statusbar actuelle
alias statusbar.save {
  var %new = $sfile($mircdirdata/*.txt,Sauver la Statusbar sous...,Sauver)
  var %src = $qt($iif($ri(paths,statusbar),$ifmatch,data/statusbar.txt))
  if (%new) {
    var %new = $iif(*.txt iswm %new,%new,%new $+ .txt)
    .copy -o %src $qt(%new)
    if ($isfile(%new)) { $infodialog(Statusbar sauvée!) }
  }
}

; Charge la liste des mess prédef.
alias mess.reflist {
  var %type = $1
  var %didlist $iif(%type == kicks,1220,$iif(%type == quits,1320,$iif(%type == slaps,1420,470)))
  var %didlist2 $iif(%type == kicks,1231,$iif(%type == quits,1331,$iif(%type == slaps,1431,481)))

  did -hr settings %didlist
  var %i = 1
  while (%i <= $hget(%type,0).item) {
    var %mess = $hget(%type,%i).data
    var %key = $replace($hget(%type,%i).item,_,$chr(32))

    did -a settings %didlist 1 + 0 0 0 %key $+ $chr(9) $+ 0 0 0 %mess
    inc %i
  }
  did -v settings %didlist
  prevbmp settings %didlist2 10 normal 2
  did -b settings $calc(%didlist + 2) $+ - $+ $calc(%didlist + 3)
}

; Kicks, quits et slaps prédéfinis: Ajoute un message
alias mess.add {
  var %type = $1
  var %didlist $iif(%type == kicks,1220,$iif(%type == quits,1320,$iif(%type == slaps,1420,470)))

  var %newval = $$formdialog(Entrez un nouveau message de $left(%type,-1) $+ .Vous pouvez utiliser les identifieurs spéciaux $lparen $+ <nick> $+ $comma <chan>... $+ $rparen ainsi que les codes spéciaux dans vos messages.,Nom du $left(%type,-1),Message)
  tokenize 1 %newval

  hadd %type $replace($1,$chr(32),_) $2-
  mess.reflist %type
  did -e settings $calc(%didlist + 4)
}

; Edite le message sélectionné
alias mess.edit {
  var %type = $1
  var %didlist $iif(%type == kicks,1220,$iif(%type == quits,1320,$iif(%type == slaps,1420,470)))

  var %sel = $did(settings,%didlist).sel
  var %name = $getColValue(settings,%didlist,%sel,1), %mess = $getColValue(settings,%didlist,%sel,2)

  var %newval = $$formdialog(Modifiez le message de $left(%type,-1) sélectionné.Vous pouvez utiliser les identifieurs spéciaux $lparen $+ <nick> $+ $comma <chan>... $+ $rparen ainsi que les codes spéciaux dans vos messages.,Nom du $left(%type,-1),Message,%name,%mess)
  tokenize 1 %newval

  hadd %type $replace($1,$chr(32),_) $2-
  if ($1 != %name) { hdel %type $replace(%name,$chr(32),_) }
  mess.reflist %type
  did -e settings $calc(%didlist + 4)
}

; Supprime le message sélectionné
alias mess.del {
  var %type = $1
  var %didlist $iif(%type == kicks,1220,$iif(%type == quits,1320,$iif(%type == slaps,1420,470)))

  var %sel = $did(settings,%didlist).sel
  var %seltext = $getColValue(settings,%didlist,%sel,1)
  if ($$yndialog(Supprimer le $left(%type,-1) sélectionné?)) {
    hdel %type $replace(%seltext,chr(32),_)
  }
  mess.reflist %type
  if ($did(settings,%didlist).lines == 1) { did -b settings $calc(%didlist + 4) }
}

;Vide la liste des messages prédef
alias mess.clear {
  var %type = $1
  var %didlist $iif(%type == kicks,1220,$iif(%type == quits,1320,$iif(%type == slaps,1420,470)))

  if ($$yndialog(Êtes-vous sûr(e) de vouloir effacer tous les messages prédéfinis de $left(%type,-1) ?)) {
    hdel -w %type *
  }
  mess.reflist %type
  did -b settings $calc(%didlist + 4)
}

; Retablit les messages par défaut
alias mess.def {
  var %type = $1
  var %f = $qt(data/ $+ %type $+ -def.txt))
  if (!$exists(%f)) { $errdialog(Le fichier %f n'existe pas!) | halt }
  var %didlist $iif(%type == kicks,1220,$iif(%type == quits,1320,$iif(%type == slaps,1420,470)))

  if ($$yndialog(Êtes-vous sûr(e) de vouloir rétablir les messages prédéfinis de $left(%type,-1) par défaut?Toutes les modifications seront perdues.)) {
    .copy -o %f $qt($iif($ri(paths,%type),$v1,data/ $+ %type $+ .txt))
  }
  loadPresetMessages %type
  mess.reflist %type
  did -e settings $calc(%didlist + 4)
}

;Affiche la liste des identifieurs
alias idents.loadref {
  did -hr settings 1520
  var %i = 1
  while ($hget(idents,%i).item) {
    var %key = $v1 
    var %value = $hget(idents,%key)

    did -a settings 1520 1 + 0 0 0 %key $+ $chr(9) $+ + 0 0 0 $gettok(%value,1,1) $+ $chr(9) $+ + 0 0 0 $gettok(%value,2,1)
    inc %i
  }
  did -v settings 1520
  did -b settings 1522-1523
  if ($did(settings,1520).lines == 1) { did -b settings 1524 }
}

; Ajoute un nouvel identifieur
alias idents.add {
  var %newval $$newident(Entrez le nouvel identifieur et sa valeur représentée. Vous pouvez aussi ajouter une description si vous le souhaitez.)
  var %key = $gettok(%newval,1,1), %value = $gettok(%newval,2-,1)
  hadd idents %key %value
  idents.loadref
  did -e settings 1524
}

; Edite l'identifieur selectionné
alias idents.edit {
  var %sel = $did(settings,1520).sel, %seltext = $getColValue(settings,1520,%sel,1), %desc = $getColValue(settings,1520,%sel,2), %val = $getColValue(settings,1520,%sel,3)
  var %newval $$newident(Edition de l'identifieur $qt(%seltext). Vous pouvez aussi ajouter une description si vous le souhaitez.,%seltext,%val,%desc)
  var %key = $gettok(%newval,1,1), %value = $gettok(%newval,2-,1)
  hadd idents %key %value
  idents.loadref
}

; Supprime l'identifieur sélectionné
alias idents.del {
  var %sel = $did(settings,1520).sel, %seltext = $getColValue(settings,1520,%sel,1)
  if ($$yndialog(Etes-vous sûr(e) de vouloir supprimer l'identifieur $qt(%seltext)?)) {
    hdel idents %seltext
    idents.loadref
  }
  if ($did(settings,1520).lines == 1) { did -b settings 1524 }
}

;Vide la liste des identifieurs
alias idents.clear {
  if ($$yndialog(Êtes-vous sûr(e) de vouloir effacer tous les identifieurs personnalisés?)) {
    hdel -w idents *
    idents.loadref
  }
  did -b settings 1524
}

; Retablit les identifieurs par défaut
alias idents.def {
  if ($$yndialog(Êtes-vous sûr(e) de vouloir rétablir les identifieurs par défaut? Toutes les modifications seront perdues.)) {
    var %f = $qt(data/ $+ idents-def.txt))
    if (!$exists(%f)) { $errdialog(Le fichier %f n'existe pas!) | halt }
    .copy -o %f $qt($iif($ri(paths,idents),$v1,data/idents.txt))
    loadIdents
    idents.loadref
    did -e settings 1524
  }
}

; Ajoute un nouveau nick pour nickserv
alias nserv.add {
  var %serv = $did(settings,1612).seltext
  var %line = $ri(services,nicks. $+ %serv)

  var %newval $$inputdialog(Entrez le nouveau nick à ajouter à la liste des nicks.Un nick convenable doit commencer par une lettre et ne comprendre que des caractères alphanumériques ou les caractères -_[]\`^{})
  if (!$regex(%newval,/^[a-zA-Z][a-zA-Z0-9\|\[\]\{\}\`\^_-]+$/)) { $errdialog(Le nick $qt(%newval) n'est pas un nick valide!) | halt }
  if ($istok(%line,%newval,59)) { $errdialog(Le nick $qt(%newval) existe déjà!) | halt }
  wi services nicks. $+ %serv $addtok(%line,%newval,59)
}

; Suppression du nick sélectionné
alias nserv.del {
  var %serv = $did(settings,1612).seltext
  var %line = $ri(services,nicks. $+ %serv)
  var %seltext = $did(settings,1616).seltext
  if (!%serv) || (!%seltext) { return }

  if ($$yndialog(Êtes-vous sûr(e) de vouloir supprimer le nick $qt(%seltext) ?Toutes les modifications seront perdues.)) {
    wi services nicks. $+ %serv $remtok(%line,%seltext,59)
    remi services $buildtok(46,nick,%serv,%seltext)
  }
}

; Ajoute un nouveau nick pour chanserv
alias cserv.add {
  var %serv = $did(settings,1662).seltext
  var %line = $ri(services,chans. $+ %serv)

  var %newval $$inputdialog(Entrez le nouveau chan à ajouter à la liste des chans.Un chan convenable doit commencer par un diese et ne comprendre que des caractères alphanumériques ou les caractères -_[]\`^{})
  if (!$regex(%newval,/^[#][a-zA-Z0-9\|\[\]\{\}\`\^_-]+$/)) { $errdialog(Le chan $qt(%newval) n'est pas un nom de chan valide!) | halt }
  if ($istok(%line,%newval,59)) { $errdialog(Le chan $qt(%newval) existe déjà!) | halt }
  wi services chans. $+ %serv $addtok(%line,%newval,59)
}

; Suppression du chan sélectionné
alias cserv.del {
  var %serv = $did(settings,1662).seltext
  var %line = $ri(services,chans. $+ %serv)
  var %seltext = $did(settings,1666).seltext
  if (!%serv) || (!%seltext) { return }

  if ($$yndialog(Êtes-vous sûr(e) de vouloir supprimer le chan $qt(%seltext) ?Toutes les modifications seront perdues.)) {
    wi services chans. $+ %serv $remtok(%line,%seltext,59)
    remi services $buildtok(46,chan,%serv,%seltext)
  }
}

; Ajoute un nouveau chan pour botserv
alias bserv.add {
  var %serv = $did(settings,1712).seltext
  var %line = $ri(services,bots. $+ %serv)

  var %newval $$inputdialog(Entrez le nouveau chan à ajouter à la liste des chans contenant un bot.Un chan convenable doit commencer par un diese et ne comprendre que des caractères alphanumériques ou les caractères -_[]\`^{})
  if (!$regex(%newval,/^[#][a-zA-Z0-9\|\[\]\{\}\`\^_-]+$/)) { $errdialog(Le chan $qt(%newval) n'est pas un nom de chan valide!) | halt }
  if ($istok(%line,%newval,59)) { $errdialog(Le chan $qt(%newval) existe déjà!) | halt }
  wi services bots. $+ %serv $addtok(%line,%newval,59)
}

; Suppression du chan sélectionné
alias bserv.del {
  var %serv = $did(settings,1712).seltext
  var %line = $ri(services,bots. $+ %serv)
  var %seltext = $did(settings,1716).seltext
  if (!%serv) || (!%seltext) { return }

  if ($$yndialog(Êtes-vous sûr(e) de vouloir supprimer le chan $qt(%seltext) ?Toutes les modifications seront perdues.)) {
    wi services bots. $+ %serv $remtok(%line,%seltext,59)
    remi services $buildtok(46,bot,%serv,%seltext)
  }
}


; Ajoute un nouveau bouton de toolbar
alias toolbar.add {
  set -e %linenum $getColValue(settings,1820,$did(settings,1820).sel,1)
  set -e %curline $did(settings,1820).sel
  opendialog -mh toolbarButton
}

;Ajoute un separateur a la toolbar
alias toolbar.addsep {
  set -e %curline $did(settings,1820).sel
  var %linenum = $getColValue(settings,1820,$did(settings,1820).sel,1)
  var %f = $qt($iif($ri(paths,toolbar),$ifmatch,data/toolbar.txt))
  if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas) | halt }

  write -iw $+ %linenum $+ $chr(1) $+ * %f $+(sep,$trnum,$chr(1),-)
  toolbar.reflist
  changeToolbar
  did -c settings 1820 $calc(%curline + 1)
  unset %curline
}

; Edition d'un bouton de toolbar
alias toolbar.edit {
  set -e %curline $did(settings,1820).sel
  set -e %toolbar.edit $getColValue(settings,1820,$did(settings,1820).sel,1)
  opendialog -mh toolbarButton
}

;Supprime le bouton de toolbar
alias toolbar.del {
  set -e %curline $did(settings,1820).sel
  var %button = $getColValue(settings,1820,$did(settings,1820).sel,1)

  var %f = $qt($iif($ri(paths,toolbar),$ifmatch,data/toolbar.txt))
  if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas) | halt }

  if (<Separateur> isin $did(settings,1820).seltext) { write -dw $+ %button $+ * %f }
  elseif ($$yndialog(Êtes-vous sûr(e) de vouloir supprimer ce bouton : $qt(%button) ?)) {
    write -dw $+ %button $+ $chr(1) $+ * %f
  }
  toolbar.reflist
  changeToolbar
  did -c settings 1820 %curline
  did $iif(<Separateur> isin $did(settings,1820).seltext,-b,-e) settings 1823
  unset %curline
}

; Vide la liste des boutons de toolbar
alias toolbar.clear {
  var %f = $qt($iif($ri(paths,toolbar),$ifmatch,data/toolbar.txt))
  if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas) | halt }

  if ($$yndialog(Êtes-vous sûr(e) de vouloir supprimer tous les boutons de la barre d'outils?)) {
    write -c %f
    toolbar.reflist
    toolbar -r
    did -b settings 1823-1827,1830
  }
}

; Deplace le bouton selectionné. $1: up/down
alias toolbar.move {
  var %f = $qt($iif($ri(paths,toolbar),$ifmatch,data/toolbar.txt))
  if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas) | halt }

  var %button = $getColValue(settings,1820,$did(settings,1820).sel,1), %sel = $did(settings,1820).sel
  var %line = $read(%f,nw,%button $+ $chr(1) $+ *), %rline = $readn
  var %uline = $read(%f,n,$calc(%rline - 1)), %urline = $readn
  var %dline = $read(%f,n,$calc(%rline + 1)), %drline = $readn
  if ($$1 == down) { write -l $+ %drline %f %line | write -l $+ %rline %f %dline }
  elseif ($$1 == up) {  write -l $+ %urline %f %line | write -l $+ %rline %f %uline }
  toolbar.reflist
  changeToolbar 
  did -c settings 1820 $iif($$1 == down,$calc(%sel + 1),$calc(%sel - 1))
  did $iif($did(settings,1820).sel == $did(settings,1820).lines,-b,-e) settings 1827
  did $iif($did(settings,1820).sel == 2,-b,-e) settings 1826
}

; Affiche les boutons de la barre d'outils dans le menu d'options
alias toolbar.reflist {
  window -h @reflist
  var %i = 1
  .fopen tb $qt($iif($ri(paths,toolbar),$ifmatch,data/toolbar.txt))
  did -r settings 1820
  did -i settings 1820 1 clearicons normal
  while (!$feof) {
    var %line = $fread(tb)
    if ($left(%line,1) == $chr(59)) { continue }
    tokenize 1 %line
    if ($1- != $null) {
      if ($2- == -) { echo @reflist 0 + 0 0 0 $1 $+ 	+ 0 0 0 <Separateur> }
      else {
        did -i settings 1820 1 seticon normal 0 $mkfullfn($4).noqt
        echo @reflist 0 + %i 0 0 $1 $+ 	+ 0 0 0 $2 $+ 	+ 0 0 0 $3
        inc %i
      }
    }
  }
  .fclose tb
  filter -cwo @reflist settings 1820 *
  close -@ @reflist
}

; Charge un preset de Toolbar
; $1: nom du preset. Si pas d'arguments, load la toolbar par défaut
alias toolbar.loadPreset {
  if ($yndialog(Etes-vous sûr de vouloir charger la Toolbar $qt($iif($1-,$1-,Défaut)) $+ ? Toutes vos modifications seront perdues.)) {
    var %cwd = images/bars/ $+ $1- $+ /
    var %dest = $qt($iif($ri(paths,toolbar),$ifmatch,data/toolbar.txt))
    if ($0 == 0) { write -c %dest }
    ; Cherche dans le dossier bars de images, le dossier $1
    ; Puis copie le fichier toolbar.txt dans data a la place du précedent
    elseif ($isdir($qt(images/bars/ $+ $1-))) { 
      if ($isfile($qt(%cwd $+ toolbar.txt))) { .copy -o $qt(%cwd $+ toolbar.txt) %dest }
      else { $errdialog(Erreur: Fichier toolbar.txt manquant dans le répertoire $qt($mircdir $+ %cwd)) ! | halt }
    }
    else { $errdialog(Erreur: La toolbar $1 n'existe pas dans le répertoire images/bars ! | halt }

    toolbar.reflist
    changeToolbar
    did -c settings 1820 1
    did -e settings 1825,1830
  }
}

; Menu des presets toolbar
ON *:SIGNAL:XPOPUP-presetmenu:{
  if ($1 == 1) { toolbar.loadPreset }
  elseif ($1 == 2) { toolbar.loadPreset HeartGold }
  elseif ($1 == 3) { toolbar.loadPreset buttons }
  elseif ($1 == 4) { toolbar.loadPreset jaffa }
  elseif ($1 == 5) { toolbar.loadPreset nnscript }
  elseif ($1 == 6) { toolbar.loadPreset phoenity }
  elseif ($1 == 7) { toolbar.loadPreset moonshine }
  elseif ($1 == 8) { toolbar.loadPreset classic }
  elseif ($1 == 9) { toolbar.loadPreset modern }
  elseif ($1 == 10) { toolbar.loadPreset megapack }
}

;Importer une toolbar
alias toolbar.import {
  if ($did(settings,1820).lines > 1) {
    var %yn = $yndialog(Enregistrer la Toolbar actuelle?)
    if (%yn) { toolbar.save }
  }
  var %new = $$sfile($mircdirdata/*.txt,Importer une Toolbar...,Charger)
  var %dest = $qt($iif($ri(paths,toolbar),$ifmatch,data/toolbar.txt))
  .copy -o $qt(%new) %dest

  toolbar.reflist
  changeToolbar
  if ($did(settings,1820).lines > 1) { 
    did -c settings 1820 1
    did -e settings 1825,1830
  }
}

; Sauver la toolbar actuelle
alias toolbar.save {
  var %new = $sfile($mircdirdata/*.txt,Sauver la Toolbar sous...,Sauver)
  var %src = $qt($iif($ri(paths,toolbar),$ifmatch,data/toolbar.txt))
  if (%new) { 
    var %new = $iif(*.txt iswm %new,%new,%new $+ .txt)
    .copy -o %src $qt(%new)
    if ($isfile(%new)) { $infodialog(Toolbar sauvée!) }
  }
}


; Ajout d'un nouveau nick dans la liste des autoquery
alias qnick.add {
  var %newval $$inputdialog(Ajoutez un nouveau nick à la liste des nicks (Ne pas mettre de caractère ';') :)
  if ($chr(59) isin %newval) { $errdialog(Le nick ne doit pas contenir de ';'!) | return }
  if ($istok($ri(query,nicks),%newval,59)) { $infodialog(Nick $qt(%newval) déjà présent!) | return }
  did -a settings 2440 %newval
  did -u settings 2440
  did -b settings 2442,2443
  did -e settings 2444
  wi query nicks $didtok(settings,2440,59)
}

;Edition d'un/de plusieurs nick(s)
alias qnick.edit {
  var %sellines = $did(settings,2440,0).sel
  var %i = 1
  while (%i <= %sellines) {
    var %seltext = $did(settings,2440).seltext, %sel = $did(settings,2440).sel
    %seltext = $$inputdialog(Modifiez le nick $qt(%seltext) (Ne pas mettre de caractère ';') :,%seltext)
    if ($chr(59) isin %seltext) { $errdialog(Le nick ne doit pas contenir de ';'!) | did -ku settings 2440 %sel }
    elseif ($istok($ri(query,nicks),%seltext,59)) { $infodialog(Nick $qt(%seltext) déjà présent!) | did -ku settings 2440 %sel }
    else { did -o settings 2440 %sel %seltext }
    inc %i
  }
  did -u settings 2440
  did -b settings 2442,2443
  did -e settings 2444
  wi query nicks $didtok(settings,2440,59)
}

;Suppression d'un/plusieurs nick(s)
alias qnick.del {
  var %sellines = $did(settings,2440,0).sel
  if (%sellines > 1) {
    var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer les nicks sélectionnés?)
    if (%yn) {
      var %i = 1
      while (%i <= %sellines) { did -d settings 2440 $did(settings,2440).sel | inc %i }
    }
  }
  else {
    var %seltext $did(settings,2440).seltext, %sel = $did(settings,2440).sel
    var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer le nick $qt(%seltext) $+ ?)
    if (%yn) { did -d settings 2440 %sel }
  }
  did -u settings 2440
  did -b settings 2442,2443
  if ($did(settings,2440).lines == 0) { did -b settings 2444 }
  wi query nicks $didtok(settings,2440,59)
}

;Effacement de tous les nicks
alias qnick.clear {
  var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer tous les nicks?)
  if (%yn) { did -r settings 2440 }
  did -b settings 2442-2444
  wi query nicks $null
}

; Ajout d'un nouveau mail dans la liste
alias mail.add {
  var %newval $$inputdialog(Entrez une nouvelle adresse mail à ajouter à la liste des adresses(Ne pas mettre de caractère ';') :)
  if ($chr(59) isin %newval) { $errdialog(L'adresse ne doit pas contenir de ';'!) | return }
  if (!$regex(%newval,[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9._-]+)) { $errdialog(Le format de l'adresse n'est pas valide!) | return }
  if ($istok($ri(mails,accounts),%newval,59)) { $infodialog(L'adresse $qt(%newval) existe déjà!) | return }
  did -ac settings 2032 %newval
  wi mails accounts $didtok(settings,2032,59)

  if ($did(settings,2032).lines >= 0) { did -e settings 2034-2044 }
}

; Suppression du mail
alias mail.del {
  var %sel = $did(settings,2032).sel, %seltext = $did(settings,2032).seltext
  if (%seltext) && ($$yndialog(Effacer l'adresse $qt(%seltext)? Toutes les modifications seront perdues.)) {
    did -d settings 2032 %sel | did -c settings 2032 1
    wi mails accounts $didtok(settings,2032,59)
    remi mails mail. $+ %seltext
    remi mails. $+ %seltext

    if ($did(settings,2032).lines == 0) { 
      did -b settings 2034-2044 | did -r settings 2039,2042,2044,2045 
    }
  }
}

; Charge les remplacements
alias replace.load {
  did -hr settings 2120
  var %i = 1
  while ($hget(replace,%i).item) {
    var %key = $v1
    var %value = $hget(replace,%key)

    var %stripkey = %key

    did -a settings 2120 1 + 0 0 0 $space(%stripkey) $+ $chr(9) $+ + 0 0 0 %value
    inc %i
  }
  did -v settings 2120
  did -b settings 2122-2123
  if ($did(settings,2120).lines == 1) { did -b settings 2124 }
}

; Ajout d'un nouveau remplacement
alias replace.add {
  noop $opendialog(newReplace)
  replace.load
}

;Edite le remplacement selecitonné
alias replace.edit {
  var %sel = $did(settings,2120).sel, %selected = $getColValue(settings,2120,%sel,1)
  if (/*/* !iswm %selected) { %selected = $escape(%selected) }
  var %find = $hfind(replace,* $+ $unspace(%selected) $+ *,1,w)
  set -e %replace.edit %find
  noop $opendialog(newReplace)
  replace.load
}

;Supprime le remplacement sélectionné
alias replace.del {
  var %sel = $did(settings,2120).sel, %selected = $getColValue(settings,2120,%sel,1)
  if (/*/* !iswm %selected) { %selected = $escape(%selected) }
  var %find = $hfind(replace,* $+ $unspace(%selected) $+ *,1,w)
  if (%find) { hdel replace %find }
  replace.load
}

;Vide tous les remplacements
alias replace.clear {
  if ($$yndialog(Êtes-vous sûr(e) de vouloir supprimer tous les remplacements?)) {
    hdel -w replace *
    replace.load
  }
}


; Charge les themes
alias theme.loadThemes {
  var %file = $ri(themes,theme)
  if ($1 == -a) && ($isfile($2-)) {
    if ($right($2-,4) == .mts) && ($theme.info(mtsversion,$2-)) && ($theme.info(name,$2-)) { var %n = $ifmatch,%t = MTS }
    elseif ($right($2-,4) == .nnt) && ($theme.info(nntversion,$2-)) && ($theme.info(name,$2-)) { var %n = $ifmatch,%t = NNT }
    else { var %n = $left($nopath($2-),-4),%t = ZIP }

    did -a settings 2212 %n
    did -a settings 2216 $2-
    if (%n == %file) && ($theme.info(schemenames,$2-)) { didtok settings 2214 59 $theme.info(schemenames,$2-) } 
  }
  else {
    did -ra settings 2212 Aucun 
    did -ra settings 2216 <none>
    did -ra settings 2214 Défaut
    var %i = 1
    while ($themesdir(%i)) {
      var %f = $ifmatch
      var %m = $findfile(%f,*.mts,0,theme.loadThemes -a $1-)
      var %x = $findfile(%f,*.nnt,0,theme.loadThemes -a $1-)
      var %z = $findfile(%f,*.zip,0,theme.loadThemes -a $1-)

      inc %i
    }
  }

  did -c settings 2212 $didwm(settings,2212,$iif($ri(themes,theme),$v1,Aucun))
  did -c settings 2214 $didwm(settings,2214,$iif($ri(themes,scheme),$v1,Défaut))
  did $iif($did(settings,2212) != Aucun,-e,-b) settings 2213-2214
}


; Ajout d'un nouveau répertoire de themes
alias folder.add {
  var %newval $shortfn($$sdir($mircdirthemes,Ajout d'un nouveau répertoire de thèmes))
  if ($istok($ri(themes,folders),%newval,59)) { $infodialog(Répertoire $qt(%newval) déjà présent!) | return }
  did -a settings 2220 %newval
  did -u settings 2220
  did -b settings 2222,2223
  did -e settings 2224
  wi themes folders $didtok(settings,2220,59)
  theme.loadThemes
}

; Edition des repertoires de themes selectionnés
alias folder.edit {
  var %sellines = $did(settings,2220,0).sel
  var %i = 1
  while (%i <= %sellines) {
    var %seltext = $did(settings,2220).seltext, %sel = $did(settings,2220).sel
    %seltext = $shortfn($$sdir($longfn(%seltext),Ajouter un répertoire de thèmes))
    if ($istok($ri(themes,folders),%seltext,59)) { $infodialog(Répertoire $qt(%seltext) déjà présent!) | did -ku settings 2220 %sel }
    else { did -o settings 2220 %sel %seltext }
    inc %i
  }
  did -u settings 2220
  did -b settings 2222,2223
  did -e settings 2224
  wi themes folders $didtok(settings,2220,59)
  theme.loadThemes
}

;Suppression d'un/plusieurs répertoire(s)
alias folder.del {
  var %sellines = $did(settings,2220,0).sel
  if (%sellines > 1) {
    var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer les répertoires de thèmes sélectionnés?)
    if (%yn) {
      var %i = 1
      while (%i <= %sellines) { did -d settings 2220 $did(settings,2220).sel | inc %i }
    }
  }
  else {
    var %seltext $did(settings,2220).seltext, %sel = $did(settings,2220).sel
    var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer le répertoire $qt(%seltext) $+ ?)
    if (%yn) { did -d settings 2220 %sel }
  }
  did -u settings 2220
  did -b settings 2222,2223
  if ($did(settings,2220).lines == 0) { did -b settings 2224 }
  wi themes folders $didtok(settings,2220,59)
  theme.loadThemes
}

;Effacement de tous les répertoires
alias folder.clear {
  var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer tous les répertoires de thèmes?)
  if (%yn) { did -r settings 2220 }
  did -b settings 2222-2224
  wi themes folders $null
  theme.loadThemes
}

; Charge les elements de la blist/wlist
alias bwlist.reflist {
  var %comboid = $iif($1 == w,2762,2712), %listid = $iif($1 == w,2770,2720), %mid = $iif($1 == w,2764,2714), %clid = $iif($1 == w,2774,2724)
  var %edcid = $iif($1 == w,2772-2774,2722-2724)
  var %type = $iif($1 == w,wlist,blist)
  var %chan = $iif($did(settings,%comboid).seltext == Tous,*,$did(settings,%comboid).seltext)
  
  did $iif(%chan == *,-b,-e) settings %mid
  did -r settings %listid
  var %i = 1
  while ($hget(%type,%i).item) {
    var %elt $ifmatch
    if ($gettok(%elt,1,46) == %chan) { did -a settings %listid $gettok(%elt,2-,46) }
    inc %i
  }
  did -b settings %edcid
  if ($did(settings,%listid).lines != 0) { did -e settings %clid }
}

; Ajout d'un canal a la liste des canaux pour la blist/wlist
alias bwlist.addchan {
  var %type = $iif($1 == w,wlist,blist)
  var %cid = $iif($1 == w,2762,2712), %mid = $iif($1 == w,2764,2714), %edid = $iif($1 == w,2772-2773,2722-2723)
  
  var %newval $$inputdialog(Entrez le nom du canal à ajouter à la liste :(Ne pas mettre de ';') :)
  if ($left(%newval,1) != $chr(35)) { %newval = $chr(35) $+ %newval }
  if ($chr(59) isin %newval) { $errdialog(Le canal ne doit pas contenir de ';'!) | return }
  
  if ($istok($ri(%type,channels),%newval,59)) { $infodialog(Canal $qt(%newval) déjà existant!) | return }
  
  did -ac settings %cid %newval
  did -e settings %mid
  wi %type channels $remove($didtok(settings,%cid,59),Tous)
  bwlist.reflist $1
}

; Suppression du canal sélectionné
alias bwlist.delchan {
  var %type = $iif($1 == w,wlist,blist)
  var %cid = $iif($1 == w,2762,2712)
  
  var %yn = $$yndialog(Etes-vous certain(e) de vouloir supprimer la $iif(%type == w,whitelist,blacklist) de ce canal?)
  if (%yn) { 
    var %chan $did(settings,%cid).seltext
    did -d settings %cid $did(settings,%cid).sel
    did -c settings %cid 1
    wi %type channels $remove($didtok(settings,%cid,59),Tous)
    wi %type list. $+ %chan
    bwlist.reflist $1
  }
}

; Ajout d'un element de bwlist
alias bwlist.add {
  var %type = $iif($1 == w,wlist,blist)
  var %cid = $iif($1 == w,2762,2712), %listid = $iif($1 == w,2770,2720)
  var %chan = $iif($did(settings,%cid).seltext == Tous,*,$did(settings,%cid).seltext)
  
  var %newval = $$inputdialog(Entrez l'adresse à ajouter à la $iif($1 == w,whitelist,blacklist)L'adresse doit être au format nick!user@host. Vous pouvez utiliser les jokers (*?).)
  if (@ !isin %newval) { %newval = %newval $+ !*@* }
  if (*!*@* !iswm %newval) { $errdialog(Erreur: Le format doit être nick!user@host!) | halt }
  if ($hfind(%type,$+(%chan,.,%newval),0,n) > 0) { $errdialog(L'entrée $qt(%newval) existe déjà!) | halt }
  
  hadd %type $+(%chan,.,%newval) 1
  bwlist.reflist $1
}

; Edition
alias bwlist.edit {
  var %type = $iif($1 == w,wlist,blist)
  var %cid = $iif($1 == w,2762,2712), %listid = $iif($1 == w,2770,2720)
  var %chan = $iif($did(settings,%cid).seltext == Tous,*,$did(settings,%cid).seltext)
  var %seltext = $did(settings,%listid).seltext, %sel = $did(settings,%listid).sel
  
  var %newval = $$inputdialog(Remplacer l'entrée $qt(%seltext) par :L'adresse doit être au format nick!user@host. Vous pouvez utiliser les jokers (*?).,%seltext)
  if (@ !isin %newval) { %newval = %newval $+ !*@* }
  if (*!*@* !iswm %newval) { $errdialog(Erreur: Le format doit être nick!user@host!) | halt }
  if ($hfind(%type $+(%chan,.,%newval),0,n) > 0) { $errdialog(L'entrée $qt(%newval) existe déjà!) | halt }
  
  hadd %type $+(%chan,.,%newval) 1
  hdel %type $+(%chan,.,%seltext)
  bwlist.reflist $1
}

; Supprimer l'entree
alias bwlist.del {
  var %type = $iif($1 == w,wlist,blist)
  var %cid = $iif($1 == w,2762,2712), %listid = $iif($1 == w,2770,2720), %edcid = $iif($1 == w,2772-2774,2722-2724), %clid = $iif($1 == w,2774,2724)
  var %chan = $iif($did(settings,%cid).seltext == Tous,*,$did(settings,%cid).seltext)
  var %seltext = $did(settings,%listid).seltext, %sel = $did(settings,%listid).sel
  
  var %sellines = $did(settings,%listid,0).sel
  if (%sellines > 1) {
    var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir effacer les entrées sélectionnées?)
    if (%yn) {
      var %i = 1
      while (%i <= %sellines) { 
        var %todel = $did(settings,%listid,1).seltext
        did -d settings %listid $did(settings,%listid,1).sel 
        hdel %type $+(%chan,.,%todel)
        inc %i 
      }
    }
  }
  else {
    var %seltext $did(settings,%listid).seltext, %sel = $did(settings,%listid).sel
    var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer l'entrée $qt(%seltext) $+ ?)
    if (%yn) { 
      did -d settings %listid %sel 
      hdel %type $+(%chan,.,%seltext)
    }
  }
  did -u settings %listid
  did -b settings %edcid
  if ($did(%listid).lines > 0) { did -e settings %clid }
}

; Tout effacer
alias bwlist.clear {
  var %type = $iif($1 == w,wlist,blist)
  var %cid = $iif($1 == w,2762,2712), %listid = $iif($1 == w,2770,2720), %edcid = $iif($1 == w,2772-2774,2722-2724), %clid = $iif($1 == w,2774,2724)
  var %chan = $iif($did(settings,%cid).seltext == Tous,*,$did(settings,%cid).seltext)
  
  var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer toutes les adresses?)
  if (%yn) { 
    did -r settings %listid 
    did -b settings %edcid
    hdel -w %type %chan $+ .*
  }
}

; Ajout d'une nouvelle fenetre à exclure
alias ac.add {
  var %newval $$inputdialog(Ajoutez une nouvelle fenêtre à la liste des fenêtres à exclure(Ne pas mettre de caractère ';') :)
  if ($chr(59) isin %newval) { $errdialog(La fenêtre ne doit pas contenir de ';'!) | return }
  if ($istok($ri(autocomp,excludes),%newval,59)) { $infodialog(Fenêtre $qt(%newval) déjà dans la liste!) | return }
  did -a settings 2860 %newval
  did -u settings 2860
  did -b settings 2862,2863
  did -e settings 2864
  wi autocomp excludes $didtok(settings,2860,59)
}

;Edition d'une/de plusieurs fenetres
alias ac.edit {
  var %sellines = $did(settings,2860,0).sel
  var %i = 1
  while (%i <= %sellines) {
    var %seltext = $did(settings,2860).seltext, %sel = $did(settings,2860).sel
    %seltext = $$inputdialog(Modifier $qt(%seltext) par : (Ne pas mettre de caractère ';') :,%seltext)
    if ($chr(59) isin %seltext) { $errdialog(La fenêtre ne doit pas contenir de ';'!) | did -ku settings 2860 %sel }
    elseif ($istok($ri(autocomp,excludes),%seltext,59)) { $infodialog(Fenêtre $qt(%seltext) déjà dans la liste!) | did -ku settings 2860 %sel }
    else { did -o settings 2860 %sel %seltext }
    inc %i
  }
  did -u settings 2860
  did -b settings 2862,2863
  did -e settings 2864
  wi autocomp excludes $didtok(settings,2860,59)
}

;Suppression d'une/plusieurs fenetres
alias ac.del {
  var %sellines = $did(settings,2860,0).sel
  if (%sellines > 1) {
    var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir enlever les fenêtres sélectionnées de la liste?)
    if (%yn) {
      var %i = 1
      while (%i <= %sellines) { did -d settings 2860 $did(settings,2860).sel | inc %i }
    }
  }
  else {
    var %seltext $did(settings,2860).seltext, %sel = $did(settings,2860).sel
    var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir supprimer la fenêtre $qt(%seltext) de la liste?)
    if (%yn) { did -d settings 2860 %sel }
  }
  did -u settings 2860
  did -b settings 2862,2863
  if ($did(settings,2860).lines == 0) { did -b settings 2860 }
  wi autocomp excludes $didtok(settings,2860,59)
}

;Effacement de tout
alias ac.clear {
  var %yn = $$yndialog(Êtes-vous sûr(e) de vouloir vider la liste des exclusions?)
  if (%yn) { did -r settings 2860 }
  did -b settings 2862-2864
  wi autocomp excludes $null
}


; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
