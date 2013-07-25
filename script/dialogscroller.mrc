; ==================================================================================
; Author  : Scryptic
; Function: Dialog Text Scroller
; Comments: Adjust %trailer for longer space at the end.
; ==================================================================================
DIALOG scroller {
  title "Scroller"
  size 230 55 250 20
  edit "", 10, 1 1 100 18, autohs
  button "X", 20, 420 16 16 16, ok, hide
  button "x", 21, 420 16 16 16, cancel, hide
}
on *:DIALOG:scroller:INIT:0:{ did -f scroller 21 }
on *:DIALOG:scroller:SCLICK:20:{ timerscroller off }
on *:DIALOG:scroller:SCLICK:21:{ timerscroller off }

alias -l spc {
  %times = 1
  IF ($1) {%times = $1}
  RETURN $str($chr(160),%times) 
}
alias -l postscroll {
  VAR %scroll = %scrolltext
  VAR %line = $right(%scroll,-1)
  VAR %left = $remove(%scroll,%line)
  VAR %scroll = %line $+ %left
  %scrolltext = %scroll
  did -o scroller 10 1 %scroll 
}

alias -l post {
  %trailer = 7
  VAR %scroll = $spc($len($1)) $+ $replace($1-,$chr(32),$chr(160)) $+ $spc($calc($len($1) * %trailer))
  %scrolltext = %scroll
  .timerscroller -m 0 100 postscroll
}

alias scrolltest { 
  dialog -mdrvo scroller scroller
  post $chan($chan).topic 
}

;--------------------------
; Fin de fichier
;--------------------------