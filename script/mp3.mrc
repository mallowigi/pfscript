;--------------------------------------
; Lecteur MP3
;--------------------------------------

dialog mp3player {
  title "PFScript MP3 Player"
  size -1 -1 160 240
  option dbu
}

alias mp3player { 
  if ($dialog(mp3player)) { dialog -v mp3player }
  else { dialog -mdh mp3player mp3player }
}

ON *:START:{
  ; Lit le fichier de proprietes du theme si il y'a et le store dans une bdd
}

ON *:EXIT:{
  ; Sauve le fichier de proprietes du theme (?)
}


; Recupere une propriété du theme
; $1: nom du theme, $2: propriete
alias mp3prop {
  if ($1 == $null) { return $null }
  else { return $hget(mp3theme,$$2) }
}

ON *:DIALOG:mp3player:*:*:{
  if ($devent == init) {
    dcx Mark $dname mp3events
    initDialog
  }
  elseif ($devent == close) {
    unset %mp3.*
  }
}

; Fonction de callback pour les events du mp3player
alias mp3events {
  
}

; Initialise le dialogue
alias -l initDialog {
  xdialog -b $dname +stnyz
  xdialog -g $dname $iif($mp3prop(%mp3.themename,background),+is $v1,+b $rgb(face))
  xdialog -q $dname $iif($mp3prop(%mp3.themename,cursor),+f $v1,+r arrow)
  ; xdialog -w $dname $iif($mp3prop(%mp3.themename,icon),+ 0 $v1,+ 0 images/mp3player.ico)
  xdialog -E $dname +cdefsCM -hmt
  xdialog -R $dname +d 1
  
  initControls
}

; Initialise les controles
alias -l initControls {
  ;Stacker
  xdialog -c $dname 1 stacker -1 -1 $dialog($dname).w $dialog($dname).h transparent noformat
  xdid -y $dname 1
  xdid -w $dname 1 + $iif($mp3prop(%mp3.themename,playerheader),$v1,images/mp3player/frame.png)
  xdid -w $dname 1 + $iif($mp3prop(%mp3.themename,playlistheader),$v1,images/mp3player/inactivecaption.png)
  xdid -a $dname 1 0 + 1 1 $iif($mp3prop(%mp3.themename,playercolor),$v1,0) 255 Lecteur $chr(9) 2 panel 0 0 $dialog(mp3player).w $calc($dialog(mp3player).h * 0.4)
  xdid -a $dname 1 0 + 2 2 $iif($mp3prop(%mp3.themename,playlistcolor),$v1,0) 65535 Playlist $chr(9) 3 panel 0 100 $dialog(mp3player).w $calc($dialog(mp3player).h * 0.6)
  xdid -C $dname 3 +b 200
}





; Events sur le mp3
#mp3player on



#mp3player end
