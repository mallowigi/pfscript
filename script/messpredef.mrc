; ---------------------------------
; Messages prédéfinis
; ---------------------------------

#features on
ON *:START:{
  if ($hget(groups,messages) == $null) { hadd -m groups messages 1 }
  if ($hget(groups,messages) == 1) { 
    splash_text 3 Chargement du script $nopath($script) ...
    .enable #features.messages
    loadPresetMessages
  }
  else { .disable #features.messages }
}


ON *:UNLOAD:{
  if ($hget(groups,messages)) { hadd groups messages 0 }
}

ON *:EXIT:{
  savePresetMessages
}
#features end

; Charge les messages predefinis
alias loadPresetMessages {
  var %types = kicks,quits,slaps,aways
  if ($1) && ($1 isin %types) { lpm $1 | return }
  var %i = 1
  while ($gettok(%types,%i,44)) {
    var %type = $v1
    var %f = $qt($iif($ri(paths,%type),$v1,data/ $+ %type $+ .txt))

    if ($hget(%type)) { hfree %type }
    hmake %type 10

    hload -i %type %f
    inc %i
  }
}

;Recursion...
alias -l lpm {
  var %type = $1
  var %f = $qt($iif($ri(paths,%type),$v1,data/ $+ %type $+ .txt))

  if ($hget(%type)) { hfree %type }
  hmake %type 100
  hload -i %type %f
}

;Sauvegarde les messages prédef
alias -l savePresetMessages {
  var %types = kicks,quits,slaps,aways

  var %i = 1
  while ($gettok(%types,%i,44)) {
    var %type = $v1
    var %f = $qt($iif($ri(paths,%type),$v1,data/ $+ %type $+ .txt))
    write -c %f
    hsave -i %type %f
    inc %i
  }
}

; Calcule le nombre de messages d'un certain type
; $1: type
alias -l num {
  var %type = $1
  if ($hget(%type)) { return $hget(%type,0).item }
}

; Retourne un menu popup de message prédéfini
; $1: type (kicks/quits/slaps/aways), $2: num ligne
; Si prop n, renvoie seulement le nom, si prop m renvoie seulement le message
alias presetMessage {
  if (!$isid) { return }
  if ($2 == begin) return -
  elseif ($2 == end) return -
  else {
    var %type = $1
    if ($hget(%type)) {
      var %mess = $hget(%type,$2).data
      var %key = $replace($hget(%type,$2).item,_,$chr(32))

      if ($prop == m) { return %mess }
      elseif ($prop == n) { return %key }

      if (%type == kicks) { return %key $+ : $+ kickAll $replaceidents(%mess) }
      elseif (%type == quits) { return %key $+ : $+ quit %mess }
      elseif (%type == aways) { return %key $+ : $+ away -n $+($me,[,%key,]) %mess }
      else { return %key $+ : $+ %mess }
    }
  }
}

; Random message de quit
alias quitMessage {
  var %n = $num(quits), %r = $rand(1,%n)
  if (%r == 0) { return Le professeur demande à Toto : - Toto, voudrais-tu aller au tableau, nous montrer sur la carte géographique, où se situe l’Amérique.? Toto va, et pointe du doigt l’Amérique. Maintenant que vous savez tous où se trouve l’Amérique, Pourriez-vous me dire qui l’a découvert ? C’est Toto !  }
  var %mess = $hget(quits,%r).data
  return %mess
}

#features.messages on

menu nicklist,channel {
  $iif($enabled(messages),Messages prédéfinis)
  .$iif($menu == nicklist,Kicks)
  ..$submenu($presetMessage(kicks,$1))
  ..Random kick:kickAll $replaceIdents($presetMessage(kicks,$rand(1,$num(kicks))).m)
  .-
  .$iif($menu == nicklist,Slaps)
  ..$submenu($presetMessage(slaps,$1))
  ..Random slap:$presetMessage(slaps,$rand(1,$num(slaps))).m
  .-
  .$iif($menu == channel,Quits)
  ..$submenu($presetMessage(quits,$1))
  ..Random quit:quit $presetMessage(quits,$rand(1,$num(quits))).m  
  .-
  .$iif($menu == channel,S'absenter)
  ..$submenu($presetMessage(aways,$1))
  ..Random away:tokenize 58 $presetMessage(aways,$rand(1,$num(aways))) | away -n $+($me,[,$1,]) $2-
  
}

menu status {
  $iif($menu == status,Quitter IRC)
  .Quits personnalisés
  ..$submenu($presetMessage(quits,$1))
  ..Random quit:quit $presetMessage(quits,$rand(1,$num(quits))).m  
  $iif($menu == status,S'absenter)
  .Messages d'absence
  ..$submenu($presetMessage(aways,$1))
  ..Random away:tokenize 58 $presetMessage(aways,$rand(1,$num(aways))) | away -n $+($me,[,$1,]) $2-
}

#features.messages end

;-------------------------------------
; Fin du fichier
;-------------------------------------
