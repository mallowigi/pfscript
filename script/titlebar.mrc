; --------------------------------------
; Barre de titre perso
; --------------------------------------

#features on
ON *:START:{
  if ($hget(groups,titlebar) == $null) { hadd -m groups titlebar 1 }
  if ($hget(groups,titlebar) == 1) { 
    splash_text 3 Chargement du script $nopath($script) ...
    .enable #features.titlebar 
    activeTitlebar
  }
  else { .disable #features.titlebar }
}


ON *:UNLOAD:{
  if ($hget(groups,titlebar)) { hadd groups titlebar 0 }
}
#features end


; Active/Désactive la titlebar perso
alias activeTitlebar {
  if ($ri(titlebar,use) == 1) {
    var %mess = $ri(titlebar,format)
    var %icon = $ri(titlebar,icon)
    var %refresh = $ri(titlebar,refresh)

    dcx WindowProps $window(-2).hwnd +t $replIdents(%mess)
    if ($ri(titlebar,iconuse)) && ($isfile(%icon)) { dcx WindowProps $window(-2).hwnd +i 0 %icon }

    if ($ri(titlebar,refreshuse)) && (%refresh > 0) { .timertitlebar -io 0 %refresh refreshTitlebar }
    else { .timertitlebar off }
  }
  else { 
    titlebar
    dcx WindowProps $window(-2).hwnd +i 0 mirc.exe
    .timertitlebar off
  }
}

; Refresh la titlebar 
alias refreshTitlebar { titlebar $replIdents($ri(titlebar,format)) }

#features.titlebar on
#features.titlebar end


; ---------------------------
; Fin de fichier
; ---------------------------
