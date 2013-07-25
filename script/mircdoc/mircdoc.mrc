;------------------------------------
; Creation de documentation
;------------------------------------

;Ce script a pour but de créer une documentation semblable à JavaDoc, PHPDoc et cie
;Il contient des fonctions de parsing et de création de documentation (texte pour le moment, pour html on verra après)


; Remove spaces in a text and replace em by $chr(1)
; These are merely for adding items into hash tables and stuff
alias unspace {
  return $replace($1-,$chr(32),$chr(1))
}

; Remove $chr(1) characters and replace em by spaces
alias space {
  return $replace($1-,$chr(1),$chr(32))
}

; Parse le contenu d'un fichier .mrc 
; $$1: chemin du fichier (complet ou relatif)
alias parseFile {
  if (!$hget(mircdoc)) { .hmake mircdoc 100 }
  if (!$hget(functions)) { .hmake functions 100 }
  if (!$hget(dialogs)) { .hmake dialogs 100 }
  if (!$hget(menus)) { .hmake menus 100 }
  if (!$hget(remotes)) { .hmake remotes 100 }
  if (!$hget(raws)) { .hmake raws 100 }
  var %l = 1

  .fopen mircdoc $$1
  if (!$fopen(mircdoc)) { echo -a Erreur: Fichier $$1 inexistant ! | return }
  
  ; Phase 1: Parsing de la doc du fichier
  while (!$feof) {
    var %line = $fread(mircdoc)
    ; Début d'une mircdoc: mot clé ;;;
    if (;;;* iswm %line) { set -e %startdoc 1 }
    ; Si double ;; mircDoc reconnue: on l'ajoute a la base pour la fonction numero %l
    elseif (;;* iswm %line) && (%startdoc) {
      .hadd mircdoc %l $hget(mircdoc,%l) $+  $+ %line
    }
    ; Mot clé alias : ajout de la doc recueillie jusque là pour l'alias "alias (-l) nom" 
    ; On set %Startdoc à 0
    elseif (alias * iswm %line) {
      ; Pas d'affichage des fonctions locales 
      if (alias -l isin %line) { continue }
      .hadd functions $unspace($remove(%line,$chr(123))) $hget(mircdoc,%l)
      set -e %startdoc 0
      inc %l
    }
    elseif (ON * iswm %line) {
      .hadd remotes $unspace($remove(%line,$chr(123))) $hget(mircdoc,%l)
      set -e %startdoc 0
      inc %l
    }
    elseif (dialog * iswm %line) {
      if (dialog -l isin %line) { continue }
      .hadd dialogs $unspace($remove(%line,$chr(123))) $hget(mircdoc,%l)
      set -e %startdoc 0
      inc %l
    }
    elseif (menu * iswm %line) {
      .hadd menus $unspace($remove(%line,$chr(123))) $hget(mircdoc,%l)
      set -e %startdoc 0
      inc %l
    }
    elseif (raw * iswm %line) {
      .hadd raws $unspace($remove(%line,$chr(123))) $hget(mircdoc,%l)
      set -e %startdoc 0
      inc %l
    }
  }
  .fclose mircdoc

  ;Phase 2 : Interprétation des résultats
  generateDoc $$1

  .hfree mircdoc
  ; .hfree functions
  ; .hfree dialogs
  ; .hfree remotes
  ; .hfree menus
  ; .hfree raws
}


; Generation des differentes documentations
; $1: nom de fichier parsé
alias generateDoc {
  ; Une fois les tables remplies, on construit le texte html :o
  generateTxt $$1
  generateHtml $$1
}

alias -l generateHtml { }

; Genere un fichier texte contenant la doc
alias generateTxt { 
  var %f = $$1
  var %dest = $qt($scriptdir/ $+ $remove($nopath($$1),.mrc,.rmt) $+ .txt)
  ; Efface le fichier si il existe
  write -c %dest
    
  ; 1: Affiche les alias
  if ($hget(functions,0).item > 0) {
    write %dest $str(-,20)
    write %dest $str(-,7) $+ Alias $+ $str(-,7)
    write %dest $str(-,20)
    write %dest $crlf
    
    var %i = 1
    while ($hget(functions,%i).item) {
      var %item = $ifmatch, %data = $hget(functions,%item)
      write %dest $space(%item)
      write %dest $replace($remove(%data,;; ),,$crlf)
      write %dest $+($crlf,$str(-,30),$crlf,$crlf)
      inc %i
    }
  }
}

