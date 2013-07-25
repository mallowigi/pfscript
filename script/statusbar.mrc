; ––––––––––––––––––––––––––––––––––––––––
; Barre de statut
; ––––––––––––––––––––––––––––––––––––––––

#features on
ON *:START:{
  if ($hget(groups,statbar) == $null) { hadd -m groups statbar 1 }
  if ($hget(groups,statbar) == 1) { 
    splash_text 3 Chargement du script $nopath($script) ...
    if (!$isalias(dcx)) { $errdialog(DCX.mrc est manquant. Ce fichier est nécessaire pour activer la statusbar.Chargez DCX.mrc, puis rechargez ce script.) | halt }

    if ($ri(statusbar,use) == 1) { activeStatusbar }
    .enable #features.statbar
  }
  else { .disable #features.statbar }
}


ON *:UNLOAD:{
  activeStatusbar -u
  if ($hget(groups,statbar)) { hadd groups statbar 0 }
}
#features end

; Recupere l'élément $1 de la statusbar
; $1: numero de ligne
alias getStatbarItem {
  var %f = $qt($iif($ri(paths,statusbar),$v1,data/statusbar.txt))
  if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas!) | halt }
  return $read(%f,n,$$1) 
}

;Affiche la liste des identifieurs
alias -l showIdentList {
  var %i = 1
  while ($hget(idents,%i).item) {
    var %key = $v1 
    var %value = $hget(idents,%key)

    did -a $dname 201 1 + 0 0 0 %key $+ 	+ 0 0 0 $gettok(%value,1,1)
    inc %i
  }
}


; ----------------------------
; DIALOG et EVENTS
; ----------------------------

dialog addStatusbar {
  title "Nouvel élément"
  size -1 -1 298 316
  option pixels
  icon images/masterIRC2.ico, 0
  button "&Ok", 1, 108 278 80 24, ok
  button "&Annuler", 2, 194 278 80 24, cancel

  tab "Caractéristiques", 100, 5 5 276 306
  text "Icône", 101, 12 37 40 14, tab 100
  edit "", 102, 70 33 174 22, tab 100 autohs limit 300
  button "...", 103, 246 34 28 20, tab 100
  text "Texte", 104, 12 61 40 14, tab 100
  edit "", 105, 70 57 204 22, tab 100 autohs limit 100
  text "Commande", 106, 12 85 52 14, tab 100
  combo 107, 71 81 202 160, tab 100 sort size edit limit 100 drop
  text "Largeur", 108, 12 109 40 14, tab 100
  edit "", 109, 70 105 50 22, tab 100 right limit 3
  text "pixels (min 50, max 1000)", 110, 122 109 130 16, tab 100
  text "Note: Vous pouvez utiliser des % à la place des pixels (ex: 20%), cependant la taille de l'élément sera fixée.", 111, 70 129 204 40, tab 100
  text "Infobulle", 112, 12 173 52 14, tab 100
  edit "", 113, 70 171 204 22, tab 100
  text "Bordure", 114, 12 199 40 14, tab 100
  radio "&Défaut", 115, 70 197 98 18, tab 100
  radio "&Pop-up", 116, 70 215 98 18, tab 100
  radio "Pas de &bordure", 117, 70 233 98 18, tab 100

  tab "Aide", 200
  list 201, 11 49 264 222, tab 200 size
  text "Liste d'identifieurs disponibles:", 202, 13 33 176 14, tab 200
}

; Vérifie que tous les champs sont bien remplis
alias -l checkForm {
  var %errmsg
  if ($did(102)) && ($did(102) != noicon) && (!$isfile($did(102))) { %errMsg = %errMsg $+ L'icône spécifiée n'existe pas, par conséquent l'élément n'aura pas d'icône. }
  if (!$did(109)) { %errMsg = %errMsg $+ Vous n'avez pas spécifié de largeur, par conséquent l'élément prendra la largeur par défaut (100 pixels). }
  elseif ($did(109)) && (($did(109) !isnum 50-1000) && (% !isin $did(109))) { %errMsg = %errMsg $+ Largeur invalide. La largeur par défaut sera utilisée (100 pixels). }
  if (!$did(105)) && (!$did(113)) { %errMsg = %errMsg $+ L'élément n'a pas de texte ni d'infobulle spécifiée. Un texte par défaut lui sera alors assigné (N/A). }

  if (%errMsg) { $infodialog(%errMsg) }
}

on *:dialog:addStatusbar:*:*:{
  if ($devent == init) {
    mdxload
    mdx SetControlMDX $dname 201 ListView report showsel single sortascending rowselect > $mdxfile(views)
    did -i $dname 201 1 headerdims 80:1 250:2
    did -i $dname 201 1 headertext +r 0 Identifieur	+ 0 Description
    showIdentList
    didtok $dname 107 59 $aliasList
    if (%statusbar.edit) {
      var %elt = $getStatbarItem(%curline)
      tokenize 1 %elt
      did -a $dname 102 $1
      did -a $dname 105 $2
      did -o $dname 107 0 $3
      did -a $dname 109 $4
      did -a $dname 113 $5
      did -c $dname $iif($6 == normal,115,$iif($6 == popup,116,117))
      dialog -t $dname Edition d'un élément
    }
    else { did -c $dname 115 }
  }
  elseif ($devent == sclick) {
    if ($did == 103) { did -ra $dname 102 $qt($$sfile($iif($did(102),$did(102),$mircdir\*.ico),Choisissez une icône)) }
    elseif ($did == 1) {
      checkForm
      var %icon = $iif($did(102) && $isfile($did(102)),$did(102),noicon)
      var %text = $iif($did(105),$v1,n/a)
      var %cmd = $iif($did(107),$v1,noop)
      if ($left(%cmd,1) == $cmdChar) { %cmd = $right(%cmd,-1) }
      var %w = $did(109)
      var %tip = $iif($did(113),$v1,n/a)
      var %border = $iif($did(115).state,normal,$iif($did(116).state,popup,noborder))
      var %final = $replIdents(%text)

      ; Width handling
      if (% isin %w) {
        var %ww = $remove(%w,%)
        if (%ww !isnum 10-100) { %w = 10% }
      }
      elseif (%w !isnum 50-1000) { %w = 100 }

      %res = $buildtok(1,%icon,%text,%cmd,%w,%tip,%border,%final)
      var %f = $qt($iif($ri(paths,statusbar),$v1,data/statusbar.txt))
      if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas!) | halt }

      if (%statusbar.edit) && (%curline) { write -l $+ %curline %f %res }
      elseif (%curline) { write -il $+ %curline %f %res }
      else { write %f %res }

      statusbar.reflist
      if (!$xstatusbar().visible) && ($ri(statusbar,use) == 1) { activeStatusbar }
      changeStatusbar
      if ($dialog(settings)) && (%curline) { did -c settings 1020 $iif(%statusbar.edit,%curline,$calc(%curline + 1)) }
    }
  }
  elseif ($devent == close) {
    unset %statusbar.edit
    unset %curline
  }
}

; -----------------------------------
; Statusbar 
; ----------------------------------


; Met a jour la statusbar perso (plus ou moins le meme code qu'init, j'y peux rien :()
alias changeStatusbar {
  xstatusbar -y
  var %i = 1, %icon = 0, %w
  while ($getStatbarItem(%i)) {
    var %item = $v1
    var %iconpath = $gettok(%item,1,1)
    if ($isfile(%iconpath)) { 
      xstatusbar -w + 0 $mkfullfn(%iconpath)
      inc %icon
    }
    %w = %w $gettok(%item,4,1)
    xstatusbar -l %w
    setStatbarItem %i %icon %item
    inc %i
  }
}

; Refresh la statusbar
alias refreshStatusbar {
  var %i = 1
  while ($getStatbarItem(%i)) {
    var %item = $v1
    xstatusbar -v %i $replIdents($gettok(%item,2,1))
    inc %i
  }
}

; Créé l'élément et l'ajoute a la statusbar
alias -l setStatbarItem {
  var %n = $1
  var %icon = $2
  tokenize 1 $3-
  if ($1 == noicon) { %icon = 0 }
  var %text = $2, %cmd = $3, %w = $4, %tip = $5, %border = $6
  var %bordstyle = + $+ $iif(%border == popup,p,$iif(%border == noborder,n))

  xstatusbar -t %n %bordstyle %icon $replIdents(%text) $chr(9) %tip
}

; Active/désactive la statusbar
; Si $1 : -u desactivation
alias activeStatusBar {
  if ($1 == -u) {
    xstatusbar -A 0
    .timersbar off
  }
  else {
    xstatusbar -A 1
    if ($ri(statusbar,refreshuse) == 1) {
      var %time = $iif($ri(statusbar,refresh) isnum 1-9999,$v1,30)
      .timersbar -io 0 %time refreshStatusbar
    }
    changeStatusbar
  }
}


; Execute la commande associée a un bouton
alias -l execCommand { 
  if (%sbar.item) && (%sbar.item !isin normal/popup/noborder) { $eval(%sbar.item,2) } 
}

; --------------------------------
; REMOTE EVENTS
; --------------------------------

on *:signal:DCX:{
  if ($1 == DCXStatusbar) {
    if ($2 == dclick) { 
      set -nu %sbar.command $4
      set -nu %sbar.item $gettok($getStatbarItem(%sbar.command),3,1)
      execCommand $4 
    }
    elseif ($2 == rclick) {
      set -nu %sbar.command $4
      set -nu %sbar.item $gettok($getStatbarItem(%sbar.command),3,1)
      newpopup sbarmenu
      if (%sbar.item !isin &null/noop) { 
        newmenu sbarmenu 1 $chr(9) + 1 0 &Executer commande ( $eval(%sbar.item,0)  )
        newmenu sbarmenu 2 $chr(9) + 2 0 -
      }
      newmenu sbarmenu 3 $chr(9) + 3 0 &Options de la statusbar...
      displaypopup sbarmenu
    }
  }
}

; Menu des presets toolbar
ON *:SIGNAL:XPOPUP-sbarmenu:{
  if ($1 == 1) { execCommand %sbar.command }
  elseif ($1 == 3) { setup -c Status bar }
}

#features.statbar on
on *:active:*:{ 
  if ($xstatusbar().visible) { refreshStatusbar } 
}
#features.statbar end

; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
