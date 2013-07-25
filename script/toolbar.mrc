; ––––––––––––––––––––––––––––––––––––––––
; Barre d'outils personnalisée
; ––––––––––––––––––––––––––––––––––––––––

#features on
ON *:START:{
  if ($hget(groups,toolbar) == $null) { hadd -m groups toolbar 1 }
  if ($hget(groups,toolbar) == 1) { 
    .enable #features.toolbar
    splash_text 3 Chargement du script $nopath($script) ...

    ; Load Toolbar
    if ($ri(toolbar,use) == 1) { changeToolbar }
  }
  else { .disable #features.toolbar }  
}

ON *:UNLOAD:{
  if ($hget(groups,toolbar)) { hadd groups toolbar 0 }
  toolbar -r
}
#features end

; Retourne le bouton a la position spécifiée de la toolbar actuelle
; $1: nom/numero
alias getToolbarButton {
  if ($$1 isnum) { return $getToolbarButtonRec($toolbar($$1).name) }
  else {
    if (sep isin $$1) { return - } 
    var %f = $qt($iif($ri(paths,toolbar),$ifmatch,data/toolbar.txt))
    if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas) | halt }

    return $$read(%f,nw,$$1 $+ $chr(1) $+ *)
  }
}

; Recursion
alias -l getToolbarButtonRec { return $getToolbarButton($1-) }

; Liste des boutons mirc
alias -l mircButtons {
  return connect/connect2/connect3/options/chanfolder/chanlist/scripts/scripts2/addrbook/timer/ $&
    colors/send/chat/dccopts/rcvdfiles/logfiles/notify/notify2/urls/urls2/htile/vtile/cascade/arrange
}

; Dialog special pour ajout et edition de boutons dans la toolbar
dialog toolbarButton {
  title "Nouveau bouton"
  size -1 -1 298 366
  option pixels
  icon images/masterIRC2.ico, 0
  button "&Ok", 1, 128 328 80 24
  button "&Annuler", 2, 214 328 80 24, cancel

  box "Général", 10, 4 4 290 138
  text "Type", 11, 14 24 36 16
  combo 12, 112 20 172 160, size drop
  text "Commande", 13, 14 48 52 16
  combo 14, 112 44 172 160, edit limit 200 drop
  combo 1414, 112 44 172 160, limit 200 drop hide
  edit "", 1415, 112 44 141 22, autohs limit 200 hide
  button "...", 1416, 255 44 30 22, hide
  text "Description", 15, 14 72 88 16
  edit "", 16, 111 68 174 22, autohs limit 50
  text "Icone", 17, 14 96 28 16
  edit "", 18, 111 92 141 22, autohs limit 200
  button "&...", 19, 254 92 30 22
  text "Taille", 20, 14 120 28 16
  combo 21, 112 116 172 160, drop

  box "Avancé", 30, 4 148 290 175
  check "&Bouton push", 31, 12 164 84 18
  check "&Ajouter un menu", 32, 12 181 132 18
  button "?", 33, 254 179 30 22
  edit "", 34, 28 202 258 112, disable multi return autohs autovs vsbar limit 200
}

on *:dialog:toolbarButton:*:*:{
  if ($devent == init) {
    didtok $dname 12 44 Personnalisé,mIRC,App. externe,Info Box
    did -c $dname 12 1
    didtok $dname 14 59 $aliasList
    didtok $dname 21 47 Petite/Grande/Défaut
    did -c $dname 21 3

    ; Si edition
    if (%toolbar.edit) {
      dialog -t $dname Edition d'un bouton
      var %f = $iif($ri(paths,toolbar),$ifmatch,data/toolbar.txt)  
      tokenize 1 $getToolbarButton(%toolbar.edit)

      ; Mirc handling 
      var %$3 = $remove($3,>,<)
      if ($istok($mircbuttons,%$3,47)) {
        did -c $dname 12 2
        did -h $dname 14
        did -vrac $dname 1414 %$3
        didtok $dname 1414 47 $mircbuttons
        did -ra $dname 16 $2
        did -ra $dname 18 $4
        did -c $dname 21 $iif($5 == 0,3,$v1)
        if ($6 != 0) { did -c $dname 31 }
        if ($7 != 0) { 
          did -c $dname 32
          did -e $dname 34
        }
        var %pop = $+(data/popups/,$1,.pop)
        if ($isfile(%pop)) {
          loadbuf -o $dname 34 %pop
          filter -iocxg $dname 34 $dname 34 ^[ ]*$
        }
      }
      ; App externe
      elseif (<app> isin $3) {
        did -c $dname 12 3
        did -h $dname 14
        did -v $dname 1415,1416
        did -ra $dname 1415 $qt($remove($3,<app>))
        did -b $dname 31-34
        did -ra $dname 16 $2
        did -ra $dname 18 $4
        did -c $dname 21 $iif($5 == 0,3,$v1)
      }
      elseif ($3 == <infobox>) {
        did -c $dname 12 4
        did -b $dname 14,21,31-34
        did -ra $dname 16 $2
        did -rac $dname 14 $3
        did -rac $dname 18 $4
      }
      else {
        did -c $dname 12 1
        did -ra $dname 16 $2
        did -ac $dname 14 $eval($3,1)
        did -ra $dname 18 $4
        did -c $dname 21 $iif($5 == 0,3,$v1)
        if ($6 != 0) { did -c $dname 31 }
        if ($7 != 0) { 
          did -c $dname 32
          did -e $dname 34
        }
        var %pop = $+(data/popups/,$1,.pop)
        if ($isfile(%pop)) {
          loadbuf -o $dname 34 %pop
          filter -iocxg $dname 34 $dname 34 ^[ ]*$
        }
      }
      set -e %sel $did($dname,12).sel
    }
  }
  elseif ($devent == sclick) {
    ; Changement de type
    if ($did == 12)  && ($did($did).sel != %sel) {
      if ($did($did).sel == 2) {
        did -h $dname 14,1415,1416
        did -r $dname 1414
        didtok $dname 1414 47 $mircbuttons
        did -vc $dname 1414 1
        did -e $dname 11-21,31-33
      }
      elseif ($did($did).sel == 3) {
        did -h $dname 14,1414
        did -v $dname 1415,1416
        did -e $dname 11-21,31-33
        did -ra $dname 16 App. Externe
        did -b $dname 14
      }
      elseif ($did($did).sel == 4) {
        did -h $dname 1414-1416
        did -vrac $dname 14 <infobox>
        did -e $dname 11-21,31-34
        did -ra $dname 16 Info Box
        did -u $dname 31,32
        did -b $dname 14,21,31-34
      }
      else {
        did -h $dname 1414-1416
        did -v $dname 14
        didtok $dname 14 59 $aliasList
        did -e $dname 11-21,31-33
      }
      %sel = $did($did).sel
    }
    elseif ($did == 1416) {
      var %file = $$sfile($iif($isfile($did(1415)),$did(1415),$mircdir $+ *.exe),Choisissez le programme externe)	
      did -ra $dname 1415 $qt(%file)
      did -ra $dname 18 $qt(%file)
    }
    elseif ($did == 19) {
      var %file = $remove($$sfile($iif($isfile($did(18)),$did(18),$mircdir $+ images/bars/*.ico),Choisissez une icone),$mircdir)
      did -ra $dname 18 %file
    }
    elseif ($did == 32) { did $iif($did($did).state == 1,-e,-b) $dname 34 }
    elseif ($did == 33) {
      $infodialog(Vous pouvez ajouter un menu personnalisé sous la forme "Nom commande:commande".Ex:Hello World:echo Hello WorldQuitter IRC:quit)
    }
    ; Le plus gros du travail
    elseif ($did == 1) {
      ; Check des doublons
      if ($did(12).sel == 2) && ($did(1414).seltext != %toolbar.edit) && ($toolbar($did(1414).seltext)) { $errdialog(Vous ne pouvez n'avoir qu'un seul bouton de mIRC $qt($did(1414).seltext) !) | return }
      elseif ($did(12).sel == 4) && (infobox != %toolbar.edit) && ($toolbar(infobox)) { $errdialog(Vous ne pouvez n'avoir qu'une seule Infobox !) | return }
      
      ; Pour les popups
      if (!$isdir(data/popups)) { mkdir data/popups }

      ; Creation de variables nécéssaires
      var %f = $qt($iif($ri(paths,toolbar),$ifmatch,data/toolbar.txt))
      if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas) | halt }

      var %type = $did(12).sel
      var %cmd = $iif($did(14),$v1,noop)
      if ($did(12).sel == 1) && ($left(%cmd,1) == $cmdChar) { %cmd = $right(%cmd,-1) }
      var %btn = $iif(%type == 2,$did(1414))
      var %app = $iif(%type == 3,$did(1415))
      var %specialcmd = $iif(%type > 3,$did(14))

      ; Creation du name
      var %name = $iif(%specialcmd,$remove(%specialcmd,<,>),$iif(%app,app,$iif(%btn,%btn,$gettok(%cmd,1,32)))) $+ . $+ $trnum
      if (%toolbar.edit) { var %name = %toolbar.edit }
      if (%btn) { var %name = %btn }
      elseif (%specialcmd) { var %name = $remove(%specialcmd,>,<) }

      var %btn = $iif(%btn,< $+ %btn $+ >)
      var %tooltip = $iif($did(16),$v1,%cmd)
      var %icon = $qt($noqt($iif($did(18),$v1,mirc.exe)))
      var %size = $did(21).sel 
      var %push = $did(31).state
      var %popup = $iif($did(32).state == 1,%name,0)

      ;echo type %type cmd %cmd btn %btn special %specialcmd name %name tooltip %tooltip icon %icon size %size push %push popup %popup 

      var %writeline = $buildtok(1,%name,%tooltip,$iif(%specialcmd,%specialcmd,$iif(%app,<app> $noqt(%app),$iif(%btn,%btn,%cmd))),%icon,%size,%push,%popup)

      if (%toolbar.edit) { write -w $+ $qt(%toolbar.edit $+ $chr(1) $+ *) $qt(%f) %writeline }
      elseif (%linenum) { write -iw $+ $qt(%linenum $+ $chr(1) $+ *) $qt(%f) %writeline }
      else { write $qt(%f) %writeline }
      if (%popup != 0) { savebuf -o $dname 34 $+(data\popups\,%popup,.pop) }

      toolbar.reflist
      changeToolbar
      if ($dialog(settings)) && (%curline) { did -c settings 1820 $iif(%toolbar.edit,%curline,$calc(%curline + 1)) }
      dialog -c $dname
    }
  }
  elseif ($devent == close) {
    unset %toolbar.edit
    unset %linenum
    unset %sel
    unset %curline
  }
}

; Change la toolbar
alias changeToolbar {
  if (!$enabled(toolbar)) { return }
  toolbar -c
  window -h @toolbar
  var %i = 1
  var %f = $qt($iif($ri(paths,toolbar),$ifmatch,data/toolbar.txt))
  if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas) | halt }
  .fopen tb %f
  while (!$feof(tb)) {
    var %line = $fread(tb)
    if ($left(%line,1) == $chr(59)) { continue }
    tokenize 1 %line
    if ($1- != $null) {
      if ($2- == -) { toolbar -as sep $+ %i }
      else {
        if (<app> isin $3) {
          toolbar -a $+ $iif($5 != 0,z $+ $5) $+ $iif($6 != 0,k0) $1 $qt($2) $iif($isfile($4),$4,"mirc.exe") $qt(/run $remove($3,<app>)) $iif($7,data/popups/ $+ $1 $+ .pop)
        }
        elseif ($3 == <infobox>) {
          createinfobox
          drawrect -rf @tb.infobox $rgb(face) 1 0 0 100 23
          toolbar -ay127 $1 $qt($2) @tb.infobox 0 0 100 23 /refreshInfoBox @tbpopup.infobox
          refreshinfobox
        }
        elseif ($3 == <app>) {
          toolbar -a $+ $iif($5 != 0,z $+ $5) $+ $iif($6 != 0,k0) $1 $qt($2) $iif($isfile($4),$4,"mirc.exe") /run $remove($3,<app>) $iif($isfile($iif($7,data/popups/ $+ $1 $+ .pop)),$v1)
        }
        ; Rajout pour la commande server modifiée
        elseif ($3 == <connect>) {
          toolbar -a $+ $iif($5 != 0,z $+ $5) $+ $iif($6 != 0,k0) $1 $qt($2) $iif($isfile($4),$4,"mirc.exe") /server $iif($isfile($iif($7,data/popups/ $+ $1 $+ .pop)),$v1)
        }
        else {
          toolbar -a $+ $iif($5 != 0,z $+ $5) $+ $iif($6 != 0,k0) $1 $qt($2) $iif($isfile($4),$4,"mirc.exe") $iif($left($3,1) != <,$qt(/ $+ $3)) $iif($isfile($iif($7,data/popups/ $+ $1 $+ .pop)),$v1)
        }
      }
      inc %i
    }
  }
  .fclose tb
  close -@ @toolbar
  if ($toolbar(0) == 0) { toolbar -r }
}

;Cree l'infobox
alias -l createInfobox {
  if (!$window(@tb.infobox)) {
    window -fhip +d @tb.infobox -1 -1 100 23
    drawrect -rf @tb.infobox $rgb(face) 1 0 0 100 23
  }
}

;Met a jour la boite d'information de la toolbar
alias refreshInfobox {
  if (!$enabled(toolbar)) { return }
  if ($toolbar(infobox)) {
    if (!$window(@tb.infobox)) { createinfobox }
    drawrect -nrf @tb.infobox $rgb(face) 1 0 11 100 12
    drawtext -nr @tb.infobox $rgb(text) Tahoma 10 0 11 Serveur:
    var %n = $iif($network,$v1,Aucun)
    drawtext -nr @tb.infobox $rgb(text) Tahoma 10 $tb.maxwidth(20,%n) 11 %n
    drawdot @tb.infobox
    toolbar -p infobox @tb.infobox 0 0 100 23
  }
}

; Affiche le nombre de mails non lus dans l'infobox ($1)
alias tb.refMails {
  if (!$enabled(mail)) || (!$enabled(toolbar)) { return }
  if ($toolbar(infobox)) {
    drawrect -nrf @tb.infobox $rgb(face) 1 0 0 100 11
    drawtext -nr @tb.infobox $rgb(text) Tahoma 10 0 0 Mails non lus:
    var %n = $1
    drawtext -nr @tb.infobox $rgb(text) Tahoma 10 $tb.maxwidth(20,%n) 0 %n
    refreshInfobox
  }
}

; Calcule la longueur max de la toolbar
alias -l tb.maxwidth {
  var %w = $calc(98 - $width($2-,Tahoma,10))
  if (%w < $1) { %w = $1 }
  return %w
}


#features.toolbar on
menu @tbpopup.infobox {
  &Ouvrir client de messagerie:run $$ri(mails,client)
  &Configurer...:setup -c Toolbar
}

on *:active:*:{
  refreshinfobox
}
#features.toolbar end

; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
