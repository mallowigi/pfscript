;----------------------------------------
; Fonctions de Copier/Coller
;----------------------------------------

#features on
ON *:START:{
  if ($hget(groups,copypasta) == $null) { hadd -m groups copypasta 1 }
  if ($hget(groups,copypasta) == 1) { 
    .enable #features.copypasta
    splash_text 3 Chargement du script $nopath($script) ...
  }
  else { .disable #features.copypasta }
}


ON *:UNLOAD:{
  if ($hget(groups,copypasta)) { hadd groups copypasta 0 }
}
#features end


; Prepare la ligne avant de la coller
alias -l processline {
  var %line = $1-
  %line = $stripcodes(%line)
  cropline %line
}

; Enleve les codes de controle selon les options
alias -l stripcodes {
  var %line = $1-
  if ($ri(copypasta,strip) == 1) {
    if ($ri(copypasta,strip.cmode) == 1) {
      if (c isincs $chan($active).mode) return $strip(%line)
    }
    else { return $strip(%line) }
  }
  return %line
}

; Croppe une ligne du presse papier selon les options
; $1- = ligne
alias -l cropline {
  if ($ri(copypasta,crop) == 1) && ($ri(copypasta,cropbytes) > 0) {
    var %maxlen = $ifmatch
    var %wraps = $wordwrap($1-,%maxlen,0)
    var %i 1
    while (%i <= %wraps) {
      pasteline $wordwrap($1-,%maxlen,%i)
      inc %i
    }
  }
  else { pasteline $1- }
}

; Enfin, colle la ligne (sur l'editbox ou directement, selon les options)
alias -l pasteline {
  var %line = $1-
  if ($ri(copypasta,editbox) == 1) {
    ; Sauvegarde du contenu actuel de l'editbox
    var %eb = $editbox($active), %cursor = $editbox($active).selstart, %cursorend = $editbox($active).selend
    var %before = $left(%eb,%cursor), %after = $right(%eb,%cursorend)
    editbox -ap %before $+ %line $+ %after
    return
  }
  else { msg $active %line }
}

; Colle tout le presse papiers en effectuant les options de collage au préalable (sans différé)
alias -l pasteall {
  var %i = 1, %n = $$1
  while (%i <= %n) {
    processline $cb(%i)
    inc %i
  }
  haltdef
}

; Remplacement de la commande coller
alias -l paste {
  var %n = $cbcontent(0)
  if (%n == 0) { return }
  ; Si une seule ligne a coller, pas de differé, coller normalement
  if (%n == 1) {
    processline $cbcontent
    halt
  }
  else {
    var %delaymode = $ri(copypasta,paste)
    ; Mode pas de cc: copier seulement la premiere ligne (et ouais...)
    if (%delaymode == no) {
      processline $cbcontent
      halt
    }
    ; Mode pas de différé: copier coller a la suite
    elseif (%delaymode == default) { pasteall %n }
    ; Enfin le plus chiant
    else {
      ; Verifier si la condition limite est remplie
      if ($ri(copypasta,limitlines) == 1) {
        if ($ri(copypasta,lines) > 0) && (%n >= $ifmatch) { delaypaste %n }
        elseif ($ri(copypasta,bytes) > 0) && ($cb(0).len > $ifmatch) { delaypaste %n }
        else { pasteall %n }
      }
      ; Sinon différé
      else { delaypaste %n }
    }
  }
}

; Collage différé
; $1: nombre de lignes dans le presse papiers
alias -l delaypaste {
  var %n = $$1
  var %ms = $ri(copypasta,delay), %notify = $ri(copypasta,notify)
  if (%notify == 1) {
    theme.echo Activation dans 2 secondes du collage différé de %n lignes à raison de %ms ms par ligne... Tapez /pstop pour annuler.
  }
  var %i = 1, %delay = 2000
  while (%i <= %n) {
    set -u100 %paste $+ %i $cb(%i)
    .timerdelaypaste $+ %i -m 1 %delay subpaste %i
    inc %delay %ms
    inc %i
  }
  haltdef
}

; Ceci afin d'eviter au timer d'evaluer %paste
alias -l subpaste {
  processline %paste [ $+ [ $1 ] ]
  unset %paste [ $+ [ $1 ] ]
}

; Stoppe le collage différé
alias pstop {
  .signal -n stoppaste
}

ON *:SIGNAL:stoppaste:{
  .timerdelaypaste* off
  if ($ri(copypasta,notify) == 1) { theme.echo Interruption du collage différé. }
}

#features.copypasta on

; Si control V/shift insert, coller avec paste
ON &*:INPUT:*:{
  if ($inpaste) { .timerpaste -io 1 0 paste | halt }
}

#features.copypasta end
