;-------------------------------------
; Remplacement d'expressions
;-------------------------------------

#features on
ON *:START:{
  if ($hget(groups,replace) == $null) { hadd -m groups replace 1 }
  if ($hget(groups,replace) == 1) { 
    splash_text 3 Chargement du script $nopath($script) ...
    .enable #features.replace
    replace.loadExpr
  }
  else { .disable #features.replace }
}

ON *:UNLOAD:{
  if ($hget(groups,replace)) { hadd groups replace 0 }
}

#features end

; Charge les expressions à remplacer
alias -l replace.loadExpr {
  if ($hget(replace)) { hfree replace }
  var %f = $qt($iif($ri(paths,replace),$v1,data/replace.txt))
  if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas!) | halt }

  hmake replace 100
  hload replace %f
  normalizeHash replace
}

; Retourne la correction d'un mot
alias getRepl {
  return $hget(replace,$hfind(replace,$unspace($1),1,R))
}

#features.replace on

ON *:EXIT:{
  if ($hget(replace)) { 
    var %f = $qt($iif($ri(paths,replace),$v1,data/replace.txt))
    if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas!) | halt }
    .write -c %f
    hsave replace %f
  }
}

ON &*:INPUT:#:{
  if (!$iscmd($1)) {
    if (c isin $ri(replace,filter)) {
      var %text = $1-, %stext = $1-
      var %finds = $hfind(replace,$unspace(%text),0,R), %i = 1
      while (%i <= %finds) { 
        var %find = $hfind(replace,$unspace(%text),%i,R), %data = $hget(replace,%find)
        ; Case checking: Si la phrase est toute en majs, remplacer par la version maj
        if ($isUpper(%stext)) { noop $regsub(%stext,$space(%find),$upper(%data),%stext) }
        else { noop $regsub(%stext,$space(%find),%data,%stext) }
        inc %i
      }
      msg $chan %stext | halt
    }
  }
}


ON &*:INPUT:?:{
  if (!$iscmd($1)) {
    if (q isin $ri(replace,filter)) {
      var %text = $1-, %stext = $1-
      var %finds = $hfind(replace,$unspace(%text),0,R), %i = 1
      while (%i <= %finds) { 
        ; Case checking: Si la phrase est toute en majs, remplacer par la version maj
        if ($isUpper(%stext)) { noop $regsub(%stext,$space(%find),$upper(%data),%stext) }
        else { noop $regsub(%stext,$space(%find),%data,%stext) }
        inc %i
      }
      msg $target %text | halt
    }
  }
}

#features.replace end

dialog newReplace {
  title "Ajout d'un remplacement"
  size -1 -1 420 272
  option pixels
  icon "images/masterIRC2.ico"

  button "OK", 1, 194 236 75 25, ok result
  button "Annuler", 2, 282 236 75 25, cancel
  text "", 3, 8 8 406 132
  text "Texte à remplacer", 4, 8 148 100 14
  edit "", 5, 6 162 390 22, autohs limit 255
  text "Texte de remplacement", 6, 8 190 120 14
  edit "", 7, 6 204 390 22, autohs limit 255
}

on *:DIALOG:newReplace:*:*:{
  if ($devent == init) {
    did -ra $dname 3 Entrez le texte à remplacer et le texte de remplacement dans les champs ci-dessous. $+ $crlf $+ Il peut être un mot ou un ensemble de mots (ex: tou -> tout; ses sa -> c'est ca...) $+ $crlf $crlf $+ Note pour les utilisateurs avancés: $+ $crlf $+ Vous pouvez aussi utiliser les expressions régulières. Pour cela, il vous suffit d'encadrer l'expression régulière avec des slashs (/). $+ $crlf $+ Exemple: /^bonjour/ -> Bonjour. $+ $crlf $+ D'autre part, vous pouvez aussi utiliser les "groupes de substitution" (\n) $+ $crlf $+ Exemple: /bjr (\w)/ -> Bonjour \1 $+ $crlf $crlf $+ Consultez l'aide pour plus d'informations sur les expressions régulières.

    did -f $dname 5
    if (%replace.edit) {
      var %find = $ifmatch, %data = $hget(replace,%find)
      did -ra $dname 5 $space(%find)
      did -ra $dname 7 %data
    }
  }
  elseif ($devent == sclick) {
    if ($did == 1) {
      var %find = $did(5), %repl = $did(7), %new
      if (!%find) { $errdialog(Vous n'avez pas inséré de texte à remplacer!) | halt }
      if (!%repl) { if (!$$yndialog(Vous n'avez pas inséré de remplacement pour ce texte. Ceci effacera toutes les occurences de %find .Continuer?)) { halt } }

      if (/*/* iswm %find) { %new = %find }
      else { %new = $wordToRegex(-gi,%find) }
      if ($hfind(replace,%new,1,R)) && (%new != %replace.edit) { $errdialog(Erreur: L'expression %new existe déjà!) | halt }

      if (%replace.edit) { hdel replace %replace.edit }
      hadd replace $unspace(%new) %repl
    }
  }
  elseif ($devent == close) { unset %replace.edit }
}

;----------------------------
; Fin de fichier
;----------------------------
