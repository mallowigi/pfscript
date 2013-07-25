; -----------------------------------
; Touches FN
; -----------------------------------

#features on
on *:START:{
  if ($hget(groups,fkeys) == $null) { hadd -m groups fkeys 1 }
  if ($hget(groups,fkeys) == 1) { 
    splash_text 3 Chargement du script $nopath($script) ...
    .enable #features.fkeys
    loadFkeysAliases
  }
  else { .disable #features.fkeys }
}

ON *:UNLOAD:{
  if ($hget(groups,fkeys)) { hadd groups fkeys 0 }
  unloadFkeys
}

#features end

;;; <Doc>
;; Lit une touche clavier dans le fichier correspondant.
;; $1: touche (F1 à F12,Ctrl+F1 à F12, Shift+F1 à F12)
alias fkeys.readKey {
  if (!$enabled(fkeys)) { return }
  var %file = $qt($iif($ri(paths,fkeys),$v1,data/fkeys.txt))
  var %key = $replace($1,Shift+F,SF,Ctrl+F,CF)
  if (!$exists(%file)) { $errdialog(Le fichier %file est introuvable!) | halt }
  var %bind = $read(%file,wn,%key $+ *)
  if (%bind != $null) { return %bind }
}

; Lit une touche clavier dans le fichier par défaut.
alias fkeys.readDefKey {
  if (!$enabled(fkeys)) { return }
  var %key = $replace($1,Shift+F,SF,Ctrl+F,CF)
  var %file = $qt(data/fkeys-def.txt)
  if (!$exists(%file)) { $errdialog(Le fichier %file est introuvable!) | halt }
  var %bind = $read(%file,wn,%key $+ *)
  if (%bind != $null) { return %bind }
}

;;; <Doc>
;; Change le raccourci clavier
;; $1: touche, $2- (optionnel): commande $chr(1) description
alias fkeys.setKey {
  if (!$enabled(fkeys)) { return }
  var %file = $qt($iif($ri(paths,fkeys),$v1,data/fkeys.txt))
  var %line = $fkeys.readKey($1)
  var %key = $gettok(%line,1,1), %cmd = $gettok(%line,2,1), %desc = $gettok(%line,1,1)
  var %l = $readn
  write $+(-l,%l,w,$qt(%key)) %file $+(%key,$chr(1),$2-)
}

;;; <Doc>
;; Charge les definitions des fkeys enregistrées
alias loadFkeysAliases {
  if (!$enabled(fkeys)) { $infodialog(La fonctionnalité Touches FN est désactivée. Réactivez-là d'abord.) | halt }
  var %i = 1
  var %keys = F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 SF1 SF2 SF3 SF4 SF5 SF6 SF7 SF8 SF9 SF10 SF11 SF12 CF1 CF2 CF3 CF4 CF5 CF6 CF7 CF8 CF9 CF10 CF11 CF12
  while ($gettok(%keys,%i,32)) {
    var %key = $ifmatch
    var %bind = $fkeys.readKey(%key)
    if (!%bind) { continue }

    alias %key $gettok(%bind,2,1)
    inc %i
  }
}

;;; <Doc>
;; Efface toutes les définitions
alias unloadFkeys {
  if (!$enabled(fkeys)) { $infodialog(La fonctionnalité Touches FN est désactivée. Réactivez-là d'abord.) | halt }
  var %i = 1
  var %keys = F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 SF1 SF2 SF3 SF4 SF5 SF6 SF7 SF8 SF9 SF10 SF11 SF12 CF1 CF2 CF3 CF4 CF5 CF6 CF7 CF8 CF9 CF10 CF11 CF12
  while ($gettok(%keys,%i,32)) {
    alias %key 
    inc %i
  }
}

#features.fkeys on

;;; <Doc>
;; Charge les fkeys lors de l'activation de la fonctionnalité
ON *:SIGNAL:feature_fkeyson:{ loadFkeysAliases }

;;; <Doc>
;; Charge les fkeys lors de la désactivation de la fonctionnalité
ON *:SIGNAL:feature_fkeysoff:{ unloadFKeys }

#features.fkeys end



; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
