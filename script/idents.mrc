; -------------------------------------------
; Gestion des Identifieurs personnalisés
; -------------------------------------------

#features on
ON *:START:{
  if ($hget(groups,idents) == $null) { hadd -m groups idents 1 }
  if ($hget(groups,idents) == 1) { 
    splash_text 3 Chargement du script $nopath($script) ...
    .enable #features.idents
    loadIdents
  }
  else { .disable #features.idents }
}

ON *:UNLOAD:{
  if ($hget(groups,idents)) { hadd groups idents 0 }
}

ON *:EXIT:{
  saveIdents
}

#features end

; Charge la liste des identifieurs spéciaux
alias loadIdents {
  if (!$hget(idents)) { hmake idents 100 }
  var %f = $qt($iif($ri(paths,idents),$v1,data/idents.txt))
  if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas) | halt }
  hload -i idents %f
}

; Sauve la lste des identifieurs spéciaux
alias saveIdents {
  if ($hget(idents)) { 
    var %f = $qt($iif($ri(paths,idents),$v1,data/idents.txt))
    if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas) | halt }
    write -c %f
    hsave -i idents %f
  }
}

; Remplace les identifieurs spéciaux par leur valeur (2e parametre)
alias replaceIdents {
  if (!$enabled(idents)) { return $1- }
  var %msg = $1-
  return $regsubex(%msg,/(<[^>]+>)/g,$eval($gettok($eval($hget(idents,\1),2),2,1),2))
}

; Ouvre le dialog newident
alias newident {
  var %t = newident. $+ $trnum
  set %ident.text $replace($1,,$crlf)
  set %ident.id $2
  set %ident.val $3
  set %ident.desc $4
  return $dialog(%t,%t,-4)
}

; Open a new dialog of multiple fields
dialog newIdent.* {
  title "Nouvel Identifieur"
  size -1 -1 306 276
  option pixels
  icon images/masterIRC2.ico

  icon 1, 4 4 32 32, mirc.exe, 0, noborder hide
  edit "", 2, 40 4 262 84, read multi return
  edit "", 3, -1 -1 0 0, result hide autohs
  button "&Ok", 4, 136 246 80 24, ok
  button "&Annuler", 5, 222 246 80 24, cancel
  text "Identifieur:", 6, 4 88 262 14
  edit "", 7, 4 102 296 22, autohs
  text "Valeur:", 8, 4 126 262 14
  edit "", 9, 4 142 296 22, autohs
  text "Description:", 10, 4 168 262 14
  edit "", 11, 4 182 296 42, autohs multi
}

on *:dialog:newIdent.*:*:*:{
  if ($devent == init) {
    mdxload
    mdx SetBorderStyle $dname 2
    showImage $dname 1 images/masterIRC2.ico
    did -a $dname 2 %ident.text
    did -f $dname 4
    if (%ident.id) {
      did -ab $dname 7 %ident.id
      did -a $dname 9 %ident.val
      did -a $dname 11 %ident.desc
    }
  }
  elseif ($devent == sclick) {
    if ($did == 5) { dialog -c $dname }
    elseif ($did == 4) {
      if ($did(7) == $null) { errdialog Vous devez remplir le champ principal! | halt }
      if ($did(9) == $null) { errdialog Vous devez donner une valeur à l'identifieur! | halt }
      var %key = < $+ $remove($did(7),<,>) $+ >, %desc = $getEditboxValue($dname,11), %val = $did(9)
      if (!%ident.id) && ($hget(idents,%key)) { errdialog Identifieur $qt(%key) déjà présent! | halt }

      did -ra $dname 3 $buildtok(1,%key,%desc,%val)
    }
  }
  elseif ($devent == close) {
    unset %ident.*
  }
}


#features.idents on
#features.idents end

; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
