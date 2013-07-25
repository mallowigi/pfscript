; --------------------------------------
; Script pour créer des boites de dialogues à la volée
; Types de boites: inputbox, combobox, infobox, passwordbox et errorbox
; ---------------------------------------

alias opendialog {
  if ($isid) { return $dialog($1,$1-,-4) }
  dialog $iif($0 == 2,$iif($dialog($2),-v $$2-,$1-2 $$2-),$iif($dialog($1),-v $$1-,$$1 $$1-))
}

; Open a new input dialog box. To put a text into multiple lines, use the character  (ctrl + U)
; $1 = Dialog message, $2 = default input
alias inputdialog {
  var %t = inputdialog. $+ $trnum
  set %geninp.text $replace($1,,$crlf)
  set %geninp.def $2 
  return $dialog(%t,%t,-4)
}
dialog inputdialog.* {
  title "Entrez une valeur"
  size -1 -1 326 146
  option pixels
  icon images/masterIRC2.ico

  icon 1, 4 4 32 32, mirc.exe, 0, noborder hide
  edit "", 2, 40 4 290 84, read multi return
  edit "", 3, 2 92 321 22, result autohs limit 255
  button "&Ok", 4, 136 118 80 24, ok
  button "&Annuler", 5, 222 118 80 24
}

; Open a new password box dialog. 
; $1 = Dialog message, $2 = default value
alias passdialog {
  var %t = passdialog. $+ $trnum
  set %geninp.text $replace($1,,$crlf)
  set %geninp.def $2
  return $dialog(%t,%t,-4)
}
dialog passdialog.* {
  title "Entrez le mot de passe"
  size -1 -1 326 146
  option pixels
  icon images/masterIRC2.ico

  icon 1, 4 4 32 32, mirc.exe, 0, noborder hide
  edit "", 2, 40 4 290 84, read multi return vsbar
  edit "", 3, 2 92 321 22, result pass autohs limit 32
  button "&Ok", 4, 136 118 80 24, ok
  button "&Annuler", 5, 222 118 80 24
  check "Afficher caractères", 100, 8 119 72 22
  edit "", 101, 2 92 301 22, hide autohs
}
on $*:dialog:m/(pass|input)dialog.*/:*:*:{
  if ($devent == init) {
    mdxload
    mdx SetBorderStyle $dname 2
    showImage $dname 1 images/masterIRC2.ico
    did -a $dname 2 %geninp.text
    did -f $dname 3
    if (%geninp.def != $null) {
      did -a $dname 3 %geninp.def
      did -c $dname 3 1 1 $calc($len($did(3)) +1)
    }
    unset %geninp.*
  }
  elseif ($devent == sclick) {
    if ($did == 5) { dialog -x $dname }
    elseif ($did == 4) {
      if ($did(3) == $null) {
        errdialog Vous devez entrer une valeur!
        halt
      }
    }
    elseif ($did == 100) {
      did -vf $dname $iif($did($did).state,101,3)
      did -h $dname $iif($did($did).state,3,101)
    }
  }
  elseif ($devent == edit) && (passdialog.* iswm $dname) {
    if ($did == 3) { did -ra $dname 101 $did($did) }
    elseif ($did == 101) { did -ra $dname 3 $did($did) }
  }
}

; Open a new dialog of multiple fields
dialog formdialog.* {
  title "Entrez les valeurs souhaitées"
  size -1 -1 306 216
  option pixels
  icon images/masterIRC2.ico

  icon 1, 4 4 32 32, mirc.exe, 0, noborder hide
  edit "", 2, 40 4 262 84, read multi return
  edit "", 3, -1 -1 0 0, result hide autohs
  button "&Ok", 4, 136 186 80 24, ok
  button "&Annuler", 5, 222 186 80 24, cancel
  text "", 6, 4 88 262 14
  edit "", 7, 4 102 298 22, autohs limit 64
  text "", 8, 4 126 262 14
  edit "", 9, 4 142 298 42, limit 255 multi autovs
}


; Open a new form dialog box.
; $1 = Dialog message, $2 = Label 1, $3: Label 2, $4: default text of field1, $5: def text of field2
alias formdialog {
  var %t = formdialog. $+ $trnum
  set %geninp.text $replace($1,,$crlf)
  set %geninp.field1 $2
  set %geninp.field2 $3
  set %geninp.def1 $4
  set %geninp.def2 $5
  return $dialog(%t,%t,-4)
}

on *:dialog:formdialog.*:*:*:{
  if ($devent == init) {
    mdxload
    mdx SetBorderStyle $dname 2
    showImage $dname 1 images/masterIRC2.ico
    did -a $dname 2 %geninp.text
    did -a $dname 6 %geninp.field1
    did -a $dname 8 %geninp.field2
    did -f $dname 7
    if (%geninp.def1 != $null) {
      did -a $dname 7 %geninp.def1
      did -c $dname 7 1 1 $calc($len($did(7)) +1)
      if (%geninp.def2 != $null) { did -a $dname 9 %geninp.def2 }
    }
    unset %geninp.*
  }
  elseif ($devent == sclick) {
    if ($did == 5) { dialog -x $dname }
    elseif ($did == 4) {
      if ($did(7) == $null) {
        errdialog Vous devez au moins remplir le champ principal!
        halt
      }
      else { did -ra $dname 3 $+($did(7),$chr(1),$getEditboxValue($dname,9)) }
    }
  }
}


; Open a new combobox dialog box.
; $1 = Dialog message, $2 = default combo entries, $3 def selected entry
alias combodialog {
  var %t = combodialog. $+ $trnum
  set %geninp.text $replace($1,,$crlf)
  set %geninp.entries %t $2
  set %geninp.def $3
  return $dialog(%t,%t,-4)
}

; Load combo entries. 
; $1-: entries file
alias combodialog.df {
  var %t = $1-
  tokenize 32 %geninp.entries
  if (%t != $null) { did -a $1 3 %t }
}
dialog combodialog.* {
  title "Choisissez une valeur"
  size -1 -1 326 146
  option pixels
  icon images/masterIRC2.ico
  icon 1, 4 4 32 32, mirc.exe, 0, noborder hide
  edit "", 2, 40 4 290 84, read multi return vsbar
  combo 3, 2 92 321 170, result sort size edit drop
  button "&Ok", 4, 136 118 80 24, ok
  button "&Annuler", 5, 222 118 80 24
}
on *:dialog:combodialog.*:*:*:{
  if ($devent == init) {
    mdxload
    mdx SetBorderStyle $dname 2
    showImage $dname 1 images/masterIRC2.ico
    tokenize 32 %geninp.entries
    filter -k $iif($isfile($3-),$mkfullfn($3-),$3-) $2
    if (@* iswm $3-) { close -@ $3- }
    did -a $dname 2 %geninp.text
    if (%geninp.def != $null) {
      did -a $dname 3 %geninp.def
      did -c $dname 3 1 1 $calc($len($did(3)) +1)
    }
    unset %geninp.*
  }
  elseif ($devent == sclick) {
    if ($did == 5) { dialog -x $dname }
    elseif ($did == 4) {
      if ($did(3) == $null) {
        errdialog Vous devez entrer une valeur!
        halt
      }
    }
  }
}


; Open an information dialog box
; $1 = Dialog message
alias infodialog {
  var %t = infodialog. $+ $trnum
  set %geninp.text $replace($1-,,$crlf)
  if ($isid) { return $dialog(%t,%t,-4) }
  else { opendialog -mh %t }
}
dialog infodialog.* {
  title "Information"
  size -1 -1 325 121
  option pixels
  icon images/masterIRC2.ico
  icon 1, 4 4 32 32, mirc.exe, 0, noborder hide
  edit "", 2, 40 4 288 84, read multi return
  button "&Ok", 4, 221 93 80 24, ok
}
on *:dialog:infodialog.*:*:*:{
  if ($devent == init) {
    mdxload
    mdx SetBorderStyle $dname 2
    showImage $dname 1 images/masterIRC2.ico
    did -ra $dname 2 %geninp.text
    did -f $dname 4
    unset %geninp.text
  }
}

; Open an error dialog box
; $1 = Dialog message
alias errdialog {
  var %t = errdialog. $+ $trnum
  set %geninp.text Erreur: $replace($1-,,$crlf)
  if ($isid) { return $dialog(%t,%t,-4) }
  else { opendialog -mh %t }
}
dialog errdialog.* {
  title "Erreur!"
  size -1 -1 325 121
  option pixels
  icon images/masterIRC2.ico
  icon 1, 4 4 32 32, mirc.exe, 0, noborder hide
  edit "", 2, 40 4 290 84, read multi return
  button "&Ok", 4, 221 93 80 24, ok
}
on *:dialog:errdialog.*:*:*:{
  if ($devent == init) {
    mdxload
    mdx SetBorderStyle $dname 2
    showImage $dname 1 images/masterIRC2.ico
    did -ra $dname 2 %geninp.text
    did -f $dname 4
    unset %geninp.text
  }
}

; Open an Yes/No dialog box.
; $1 = Dialog message
alias yndialog {
  var %t = yndialog. $+ $trnum
  set %geninp.text $replace($1-,,$crlf)
  if ($isid) { return $dialog(%t,%t,-4) }
  else { opendialog -mh %t }
}
dialog yndialog.* {
  title "Confirmer?"
  size -1 -1 325 121
  option pixels
  icon images/masterIRC2.ico
  icon 1, 4 4 32 32, mirc.exe, 0, noborder hide
  edit "", 2, 40 4 288 84, read multi return
  button "&Oui", 3, 135 93 80 24, ok
  button "&Non", 4, 221 93 80 24, cancel
  text "1", 5, -10 -10 2 2, result hide

}
on *:dialog:yndialog.*:*:*:{
  if ($devent == init) {
    mdxload
    mdx SetBorderStyle $dname 2
    showImage $dname 1 images/masterIRC2.ico
    did -a $dname 2 %geninp.text
    did -f $dname 3
    unset %geninp.text
  }
}

; Open a progression dialog without buttons
alias waitdialog {
  var %t = waitdialog. $+ $trnum
  set %geninp.text $replace($1-,,$crlf)
  if ($isid) { return $dialog(%t,%t,-4) }
  else { opendialog -mh %t }
}

dialog waitdialog.* {
  title "En cours..."
  size -1 -1 225 71
  option pixels
  icon images/masterIRC2.ico
  icon 1, 4 4 32 32, mirc.exe, 0, noborder hide
  edit "", 2, 40 4 188 84, read multi return
  button "", 3, 0 0 0 0, ok
}

on *:dialog:waitdialog.*:*:*:{
  if ($devent == init) {
    mdxload
    mdx SetBorderStyle $dname 2
    showImage $dname 1 images/masterIRC2.ico
    did -a $dname 2 %geninp.text
    did -f $dname 3
    unset %geninp.text
  }
}


; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
