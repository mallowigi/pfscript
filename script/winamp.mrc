; -----------------------------------
; Winamp Plugin (AMIP)
; Nécessite le plugin winamp AMIP!
; -----------------------------------

ON *:LOAD:{
  configzik
}

; Petite config pour le current playing
alias configzik {
  set -e %songchans $$?="Entrez les canaux sur lesquels afficher la chanson jouée actuellement sous Winamp, séparés par un ;. Laissez vide pour n'afficher que sur le canal actif."
}

; Alias pour appeler le current playing
alias sayzik {
  songinfo
  .timersaysong 1 1 saysong
}

alias adzik {
  songinfo
  .timeradsong 1 1 adsong
}

;Affichages
alias -l saysong {
  var %i = 1
  if (%songchans == $null) { set -e %songchans $active }
  while ($gettok(%songchans,%i,59)) {
    msg $ifmatch 12 Winamp  .::. 7Musique : 15[3 %songname 15] .::. 4Durée : 15[6 $+(%songmin,:,%songsec) 15] .::. 10Bitrate : 15[9 %songbr $+ Kbps 15]
    inc %i
  }
}

alias -l adsong {
  var %i = 1
  if (%songchans == $null) { set -e %songchans $active }
  while ($gettok(%songchans,%i,59)) {
    echo -t $ifmatch 12 Winamp  .::. 7Musique : 15[3 %songname 15] .::. 4Durée : 15[6 $+(%songmin,:,%songsec) 15] .::. 10Bitrate : 15[9 %songbr $+ Kbps 15]
    inc %i
  }
}

;Recuperation des infos Winamp
alias -l songinfo {
  set -e %songfile $dde(mPlug,var_fn)
  set -e %songname $dde(mPlug,var_name)
  set -e %songmin $dde(mPlug,var_min)
  set -e %songsec $dde(mPlug,var_sec)
  set -e %songyear $dde(mPlug,var_5)
  set -e %songalbum $dde(mPlug,var_4)
  set -e %songtyp $dde(mPlug,var_typ)
  set -e %songbr $dde(mPlug,var_br)
  if (%songalbum == $null) { set -e %songalbum Album Inconnu }
  if (%songyear != $null) { set -e %songyear $chr(40) $+ %songyear $+ $chr(41) }
}

menu menubar {
  Outils
  .Winamp Now Playing
  ..Afficher sur le canal:sayzik
  ..Afficher pour soi:adzik
  ..Canaux d'affichage:configzik
}

;-----Control Winamp With mIRC-----
alias mp3 {
  if ($1 = next) {
    dde mPlug control >
  }
  elseif ($1 = prev) {
    dde mPlug control <
  }
  elseif ($1 = play) {
    dde mPlug control play
  }
  elseif ($1 = stop) {
    dde mPlug control stop
  }
  elseif ($1 = pause) {
    dde mPlug control pause
  }
  elseif ($1 = vol) {
    if ($2 == up) {
      dde mPlug control vup
    }
    if ($2 == down) {
      dde mPlug control vdwn
    }
    elseif ($2 == mute) {
      dde mPlug control vol 0
    }
    elseif (($2 >= 0) && ($2 <= 100))  {
      %chvol = $2 / 100
      %chvol = 255 * %chvol
      dde mPlug control vol %chvol
      unset %chvol
    }
    else {
      echo Volume Usage
      echo /mp3 vol       echo Variables:
      echo up - increases volume
      echo down - decreases volume
      echo mute - decreases volume completely
      echo number - sets volume percentage (number between 1 and 100)
    }
  }
  else {
    echo Usage
    echo /mp3  *
    echo -
    echo Variables:\
    echo next - skips to next track on playlist
    echo prev - skips to previous track
    echo play - turns mp3 playback on/restarts track
    echo stop - turns mp3 playback off
    echo pause - pauses mp3 playback
    echo vol * - changes volume, command alone displays * options
  }
}
