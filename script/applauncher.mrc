; -------------------------------
; Application launcher
; -------------------------------

ON *:START:{
  splash_text 3 Chargement du script $nopath($script) ...
  hmake apps 100
  hload -i apps $qt($iif($ri(paths,apps),$v1,data/apps.txt))
}

ON *:EXIT:{
  if ($hget(apps)) { 
    write -c $qt($iif($ri(paths,apps),$v1,data/apps.txt)) 
    hsave -i apps $qt($iif($ri(paths,apps),$v1,data/apps.txt)) 
  }
}

; Convertit un label en un nom de clé (ex: Mozilla Firefox: mozillafirefox)
; $1-: nom
alias -l labelToName {
  var %name = $remove($1-,$chr(32),-,_,/,\)
  return %name
}

; Lance l'applauncher
alias applauncher {
  if (!$dialog(applauncher)) { opendialog -mh applauncher }
  else { dialog -v applauncher }
  app.load
}

; Callback pour gérer les évènements survenus dans le dialog et utilisé par dcx
alias app.events { 
  if ($2 == labelend) {
    var %sel = $xdid(applauncher,1,1).sel, %seltext = $xdid(applauncher,2,%sel).text
    var %text = $4-
    if (%text) { app.rename %seltext %text }
  }
  elseif ($2 == dclick) { app.run }
  elseif ($2 == keydown) {
    var %sel = $xdid(applauncher,1,1).sel
    if ($4 == 113) && (%sel) { xdid -B applauncher 1 %sel }
    elseif ($4 == 46) && (%sel) { app.del %sel }
  }
  ; Creation d'une xpopup
  elseif ($2 == rclick) { 
    if ($xdid(applauncher,1,1).sel) { app.popupsel }
    else { app.popupnosel }
  }
  elseif ($2 == sclick) {
    if ($xdid(applauncher,1,1).sel) { did -e applauncher 13,14,16 }
    else { did -b applauncher 13,14,16 }
  }
}

; Popup sur la liste
alias -l app.popupnosel {
  newpopup app.nosel
  newmenu app.nosel 1 $chr(9) + 1 0 Nouveau programme (Alt+N)
  newmenu app.nosel 2 $chr(9) + 2 0 Tout effacer (Alt+C)
  newmenu app.nosel 3 $chr(9) + 3 0 -
  newmenu app.nosel 4 $chr(9) + 4 0 Fermer (Alt+Q)
  displaypopup app.nosel
}

; Popup sur un element
alias -l app.popupsel {
  newpopup app.sel
  newmenu app.sel 1 $chr(9) + 1 0 Editer (Alt+E)
  newmenu app.sel 2 $chr(9) + 2 0 Supprimer (Suppr)
  newmenu app.sel 3 $chr(9) + 3 0 -
  newmenu app.sel 4 $chr(9) + 4 0 Renommer (Alt+R)
  displaypopup app.sel
}

ON *:SIGNAL:XPOPUP-app.nosel:{
  if ($1 == 1) { app.add }
  elseif ($1 == 2) { app.clear }
  elseif ($1 == 4) { dialog -x applauncher }
}

ON *:SIGNAL:XPOPUP-app.sel:{
  var %sel $xdid(applauncher,1,1).sel
  if ($1 == 1) { app.edit %sel }
  elseif ($1 == 2) { app.del %sel }
  elseif ($1 == 4) { xdid -B applauncher 1 %sel }
}


; Run le programme selectionné
alias -l app.run {
  var %sel = $xdid(applauncher,1,1).sel, %seltext = $xdid(applauncher,2,%sel).text
  var %data = $hget(apps,%seltext)
  if (%data) { 
    var %program = $gettok(%data,2,59), %args = $gettok(%data,4,59)
    run $qt(%program) %args
  }
}

; Ajoute un nouvel item à la liste
alias -l app.add {
  opendialog -mh addprogram
}

; Edite l'element selectionné
alias -l app.edit {
  set -e %app.edit $1
  opendialog -mh addprogram
}

;Supprime l'élément sélectionné
alias -l app.del {
  var %seltext = $xdid(applauncher,2,$1).text
  if ($$yndialog(Etes-vous sûr de vouloir effacer le programme %seltext ?)) {
    var %prog = $hget(apps,%seltext)
    if (%prog) {
      var %alias = $gettok(%prog,5,59)
      if (%alias) && ($isalias(%alias)) { alias %alias }
      hdel apps %seltext
      app.load
    }
  }
}

; Supprime tout
alias -l app.clear {
  if ($$yndialog(Effacer toutes les applications?)) {
    hdel -w apps *
    app.load
  }
}

; Importe un nouveau panel d'applications
alias -l app.import {
  if ($hget(apps,0).item) { 
    var %save = $yndialog(Sauver le panel d'applications actuel?)
    if (%save) { app.save }
  }
  var %file = $$sfile($mircdirdata/*.txt,Importer un panel d'applications,Choisir)

  hdel -w apps *
  hload -i apps $qt(%file)
  .copy -o $qt(%file) $qt($iif($ri(paths,apps),$v1,data/apps.txt))

  app.load
}

; sauve le panel d'applications actuelles
alias -l app.save {
  var %file = $qt($iif($ri(paths,apps),$v1,data/apps.txt))
  write -c %file | hsave -i apps %file

  var %save = $sfile($mircdirdata/*.txt,Sauvegarder sous...,Sauver)
  if (%save) {
    var %save = $iif(*.txt iswm %save,%save,%save $+ .txt)
    .copy -o %file $qt(%save)
    if ($isfile(%save)) { $infodialog(Sauvegarde effectuée!) }
  }
}

;Renomme un item
; $1: nom de l'item (clé), $2-: nouveau nom
alias -l app.rename {
  var %item = $hget(apps,$1)
  if (%item) {
    var %data = $gettok(%item,2-,59)
    %data = $2- $+ $chr(59) $+ %data
    hadd apps $1 %data
  }
}

; Dialogue contenant la liste des apps
dialog applauncher {
  title "Program Files"
  icon "images/masterIRC2.ico"°
  size -1 -1 480 360
  option pixels

  menu "&Fichier", 5
  item "&Importer", 6, 5
  item "&Enregistrer sous", 7, 5
  item break, 8, 5
  item "&Fermer", 9, 5

  menu "&Actions", 10
  item "&Nouveau programme", 11, 10
  item break, 12, 10
  item "&Renommer", 13, 10
  item "&Editer", 14, 10
  item break, 15, 10
  item "&Supprimer", 16, 10
  item "&Vider liste", 17, 10

  button "&New", 100, -1 -1 -1 -1, hide
  button "&Edit", 101, -1 -1 -1 -1, hide
  button "&Quit", 102, -1 -1 -1 -1, hide
  button "OK", 103, -1 -1 -1 -1, hide ok
  button "&Clear", 104, -1 -1 -1 -1, hide
  button "&Rename", 105, -1 -1 -1 -1, hide
}

; Dialog d'ajout d'un programme
dialog addprogram {
  title "Ajout d'un Programme"
  icon "images/masterIRC2.ico"°
  size -1 -1 312 270
  option pixels

  button "&OK", 1, 114 240 75 24, default ok
  button "&Annuler", 2, 200 240 75 24, cancel
  button "result", 3, -1 -1 -1 -1, result hide

  box "Informations obligatoires", 10, 4 4 300 76
  text "Nom du programme", 11, 12 24 100 20
  edit "", 12, 112 20 152 24, limit 20
  text "Chemin", 13, 12 48 100 20
  edit "", 14, 112 46 152 24, autohs limit 255
  button "...", 15, 268 48 24 20

  box "Informations facultatives", 20, 4 80 300 156
  text "Icône personnalisée", 21, 12 100 96 20
  edit "", 22, 112 96 152 24, autohs limit 255
  button "...", 23, 268 98 24 20
  check "&Pas d'icône", 24, 24 128 80 20
  icon 25, 112 125 32 32
  text "(Laissez vide pour utiliser l'icone par défaut)", 26, 146 125 150 32
  text "Arguments", 27, 12 168 100 20
  edit "", 28, 112 164 184 24, autohs limit 255
  text "Alias personnalisé", 29, 12 204 100 20
  edit "", 30, 112 200 184 24, autohs limit 255
}

ON *:DIALOG:applauncher:*:*:{
  if ($devent == init) {
    dcx Mark $dname app.events
    app.init
    did -b $dname 13,14,16
  }
  elseif ($devent == sclick) {
    if ($did == 100) { app.add }
    elseif ($did == 101) { app.edit $xdid(applauncher,1,1).sel }
    elseif ($did == 102) { dialog -c $dname }
    elseif ($did == 103) { app.run | halt }
    elseif ($did == 104) { app.clear }
    elseif ($did == 105) { xdid -B applauncher 1 $xdid(applauncher,1,1).sel }
  }
  elseif ($devent == menu) {
    var %sel $xdid(applauncher,1,1).sel
    if ($did == 6) { app.import }
    elseif ($did == 7) { app.save }
    elseif ($did == 9) { dialog -c $dname }
    elseif ($did == 11) { app.add }
    elseif ($did == 13) { xdid -B applauncher 1 %sel }
    elseif ($did == 14) { app.edit %sel }
    elseif ($did == 16) { app.del %sel }
    elseif ($did == 17) { app.clear }
  }
}

ON *:DIALOG:addprogram:*:*:{
  if ($devent == init) {
    mdxload
    mdx SetFont $dname 10,20 13 700 Tahoma
    if (%app.edit) {
      var %seltext = $xdid(applauncher,2,%app.edit).text
      var %item = $hget(apps,%seltext)
      if (%item) {
        tokenize 59 %item
        did -ra $dname 12 $1
        did -ra $dname 14 $2

        if ($3 == 0) { did -c $dname 24 | did -b $dname 22,23,26 }
        elseif ($3 == 1) {
          did -r $dname 22
          showImage $dname 25 $qt($2)
        }
        else {
          did -ra $dname 22 $3
          showImage $dname 25 $qt($3)
        }

        did -ra $dname 28 $4
        did -ra $dname 30 $5
      }
    }
  }
  elseif ($devent == sclick) {
    if ($did == 15) { 
      did -ra $dname 14 $$sfile($iif($did(14),$v1,$mircdir/*.exe),Choix du programme)
      if (!$did(24).state) { showImage $dname 25 $qt($shortfn($iif($did(22),$v1,$did(14)))) }
      if (!$did(12)) { did -ra $dname 12 $nopath($did(14)) }
    }
    elseif ($did == 23) { 
      did -ra $dname 22 $$sfile($iif($did(22),$v1,$mircdir/*.ico),Choix d'une icône) 
      if (!$did(24).state) { showImage $dname 25 $qt($shortfn($iif($did(22),$v1,$did(14)))) }
    }
    elseif ($did == 24) {
      if (!$did(24).state) { showImage $dname 25 $qt($shortfn($iif($did(22),$v1,$did(14)))) | did -e $dname 22,23,26 }
      else { did -h $dname 25 | did -b $dname 22,23,26 }
    }
    ; bouton ok
    elseif ($did == 1) { 
      var %name = $did(12), %path = $did(14), %icon = $did(22), %isicon = $did(24).state, %args = $did(28), %alias = $did(30)

      if (!%name) || (!%path) { $errdialog(Vous devez remplir tous les champs obligatoires!) | halt }
      if (!$isfile(%path)) {
        if ($isdir(%path)) { %icon = $iif(%icon,%icon,explorer.exe) } 
        else { $errdialog(%path n'est pas un chemin valide!) | halt }
      }

      var %key = $labelToName(%name)
      var %data = $buildtok(59,%name,%path,$iif(%icon,%icon,$iif(%isicon == 1,0,1)),%args,%alias)

      if (%app.edit) { 
        var %seltext = $xdid(applauncher,2,%app.edit).text
        var %key = %seltext
      }
      if (%alias) { alias %alias /run %path %args }

      hadd apps %key %data
      app.load
    }
  }
  elseif ($devent == edit) {
    if ($did == 14) || ($did == 22) { 
      if (!$did(24).state) { showImage $dname 25 $qt($shortfn($iif($did(22),$v1,$did(14)))) }
    }
  }
  elseif ($devent == close) {
    unset %app.*
  }
}


; Initialisation du dialog avec DCX
alias -l app.init {
  xdialog -b applauncher +tysn
  xdialog -c applauncher 1 listview 4 4 476 356 icon sortasc autoarrange editlabel singlesel tooltip
  xdialog -c applauncher 2 listview 4 4 476 356 icon sortasc autoarrange hidden
}

; Chargement des programmes dans la liste
alias -l app.load {
  xdid -r applauncher 1
  xdid -y applauncher 1 +n
  xdid -r applauncher 2
  xdid -y applauncher 2 +n

  var %i = 1, %p = 0
  while (%i <= $hget(apps,0).item) {
    var %app = $hget(apps,%i).data, %appitem = $hget(apps,%i).item
    tokenize 59 %app

    if ($3 == 1) { 
      xdid -w applauncher 1 +an 0 $qt($2) | inc %p 
      xdid -a applauncher 1 0 0 +afm %p 0 0 0 0 0 $1
    }
    elseif ($3 != 0) { 
      xdid -w applauncher 1 +n 0 $qt($3) | inc %p 
      xdid -a applauncher 1 0 0 +afm %p 0 0 0 0 0 $1
    }
    else { xdid -a applauncher 1 0 0 +afm 0 0 0 0 0 0 $1 }

    xdid -a applauncher 2 0 0 +afm 0 0 0 0 0 0 %appitem
    inc %i
  }
}

menu menubar {
  Outils
  .App Launcher:/applauncher
}
