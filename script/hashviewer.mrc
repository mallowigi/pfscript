; ---------------------------------------------
; Hash Table Viewer and Editor
; Original code by mr_foot http://www.mircscripts.org/comments.php?cid=1739
; ---------------------------------------------

alias hashviewer { dialog -m hashtable hashtable }

; -----------------------------------
; DIALOGS
; -----------------------------------

dialog hashtable {
  title Hash Viewer - by mr_foot
  size -1 -1 353 243
  option dbu
  icon images/masterIRC2.ico

  button "&Quitter", 1, 275 223 75 15, cancel
  ; Hotkeys: new table/element; find table/element; apply modif; revert modif; save table/element
  button "result", 2, -1 -1 0 0, hide result default
  button "alt+&N", 3, -1 -1 0 0, hide default
  button "alt+&F", 4, -1 -1 0 0, hide default
  button "alt+&A", 5, -1 -1 0 0, hide default
  button "alt+&R", 6, -1 -1 0 0, hide default
  button "alt+&S", 7, -1 -1 0 0, hide default


  ; loaded hash tables
  box "Tables chargées", 10, 130 140 144 100
  list 11, 134 148 134 62, sort size vsbar
  button "Charger", 12, 134 213 30 10
  button "Sauver", 13, 168 213 30 10
  button "Nouvelle", 14, 202 213 30 10
  button "Supprimer", 15, 236 213 30 10, disable
  button "Renommer", 16, 134 226 30 10, disable
  button "Copier", 17, 168 226 30 10, disable
  button "Changer taille", 18, 202 226 45 10, disable

  ; values of hashtable
  box "Elements de la table sélectionnée", 20, 3 37 124 203
  list 21, 7 45 116 155, sort size vsbar
  button "Ajouter", 22, 7 203 28 10
  button "Effacer", 23, 37 203 28 10, disable
  button "Renommer", 24, 67 203 30 10, disable
  button "Copier", 25, 99 203 26 10, disable
  edit "", 30, 7 216 116 11, disable
  check "Filtrer éléments avec ce masque", 31, 7 228 86 10, disable

  ; Data  
  box "Données de l'élément sélectionné", 40, 130 37 220 56
  edit "", 41, 134 45 175 44, multi autovs vsbar limit 500 disable
  button "Rétablir", 42, 312 44 36 15, disable
  button "Appliquer", 43, 312 74 36 15, disable

  ; Table information
  box "Informations de la table sélectionnée", 60, 130 94 220 44
  text "Taille:", 61, 135 102 60 8
  text "Nom:", 62, 135 111 60 8
  text "Nombre d'éléments:", 63, 135 120 60 8
  text "Taille recommandée:", 64, 135 129 60 8
  text "[N/A]", 65, 195 102 24 8
  text "[N/A]", 66, 195 111 164 8
  text "[N/A]", 67, 195 120 24 8
  text "[N/A]", 68, 195 129 24 8
  check "Table binaire", 69, 256 126 62 10, disable left hide

  ; Search boxes
  box "Rechercher élément", 80, 3 13 124 23
  box "Rechercher donnée", 90, 130 13 220 23
  edit "", 81, 7 21 93 11
  edit "", 91, 134 21 188 11
  button "Rech.", 82, 103 21 20 11
  button "Rech.", 92, 325 21 21 11
  text "Note: Utilisez les wildcards (*/?) dans vos recherches. Exemples: mis*, *sterfoot, *foot*, mi?ter*, miste?*, etc...", 100, 3 3 347 8

  ; Menus
  menu "Raccourcis", 110
  item "Nouvelle table/élément -> ALT-N", 111, 110
  item "Rechercher dans table/élément -> ALT-F", 112, 110
  item "Appliquer modifications -> ALT-A", 113, 110
  item "Rétablir valeurs -> ALT-R", 114, 110
  item "Sauver table/élément -> ALT-S", 115, 110
  item "EXIT -> ALT-X", 116, 110
  item "Quitter -> ALT-Q", 117, 110

  menu "Aide", 120
  item "Tables de hachage", 121, 120
}
;##########

; Sauve une table dans un fichier
dialog savehash {
  title Hash Viewer - Sauver Table
  size -1 -1 260 42
  option dbu
  icon images/masterIRC2.ico
  button "&OK", 1, 3 26 37 12, result default ok
  button "&Annuler", 2, 220 26 37 12, cancel
  check "En tant que table &binaire", 3, 106 26 72 12

  box "Sauvegarde d'une table", 10, 3 1 254 22
  text "Nom:", 11, 7 10 18 8, right
  edit "", 12, 27 9 224 10
  text "Taille:", 13, 14 21 18 8, right hide disable
  edit "100", 14, 38 20 36 10, hide disable
}

; Charge une table a partir d'un fichier
dialog loadhash {
  title "Hash Viewer - Charger Table"
  size -1 -1 260 60
  option dbu
  icon images/masterIRC2.ico
  button "&OK", 1, 3 46 37 12, result default ok
  button "&Annuler", 2, 220 46 37 12, cancel
  check "En tant que table &binaire", 3, 106 46 72 12

  box "Chargement d'une table", 10, 3 1 254 41
  text "Nom:", 11, 14 10 18 8, right
  edit "", 12, 38 9 199 10
  text "Taille:", 13, 14 21 18 8, right
  edit "100", 14, 38 20 36 10
}

; Créé une nouvelle table
dialog createhash {
  title "Création d'une nouvelle table"
  size -1 -1 260 60
  option dbu
  icon images\masterIRC2.ico, 0
  button &OK, 1, 3 45 37 12, result default ok
  button "&Annuler", 2, 220 45 37 12, cancel
  check "En tant que table &binaire", 3, 106 46 72 12, hide 

  box "Création d'une table", 10, 3 1 254 41
  text "Nom:", 11, 18 10 18 8, right
  edit "", 12, 38 9 199 10
  text "Taille:", 13, 18 21 18 8, right
  edit "100", 14, 38 20 36 10
}


;########## ALIASES ##########


; Sauve la table sélectionnée
alias -l hash.saveFile {
  var %name = $did(12)
  %newfile = $qt($$sfile($mircdir $+ %name $+ .dat,Sauvegarder sous,Sauver fichier))
  hsave $iif($did(3).state,-b) %name %newfile
  hash.refTables
}

; Ouvre le sélecteur de fichiers pour charger la table spécifiée
alias -l hash.loadFile {
  var %name = $did(12)
  if (%name == $null) { theme.error Vous devez spécifier un nom de table | halt } 
  if ($hget(%name)) { theme.error Une table ayant le nom %name existe déjà. Veuillez spécifier un nom différent ou effacez la table en question. | halt }
  if ($remove(%name,-,_,.) !isalnum) { theme.error Veuillez spécifier un nom ne comportant pas les caractères {}[]\;:'"/?><,~`!@#$%^&*+= | halt } 

  var %size = $did(14)
  if (%size !isnum 1-9999) { theme.error Vous devez spécifier une taille entre 1 et 9999 | halt }

  hmake %name %size
  hload $iif($did(3).state,-b) %name $qt($$sfile(*.*,Selectionnez le fichier à charger))
  hash.refTables
}

; Créé une nouvelle table
alias -l hash.createNewTable {

  var %name = $did(12)
  if (%name == $null) { theme.error Vous devez spécifier un nom de table | halt } 
  if ($hget(%name)) { theme.error Une table ayant le nom %name existe déjà. Veuillez spécifier un nom différent ou effacez la table en question. | halt }
  if ($remove(%name,-,_,.) !isalnum) { theme.error Veuillez spécifier un nom ne comportant pas les caractères {}[]\;:'"/?><,~`!@#$%^&*+= | halt } 

  var %size = $did(14)
  if (%size !isnum 1-9999) { theme.error Vous devez spécifier une taille entre 1 et 9999 | halt }
  hmake %name %size
  hash.refTables
}

;Renomme la table sélectionnée
alias -l hash.renameTable {
  var %base = $did(11).seltext
  var %bsize = $hget(%base).size
  var %bin = $iif($did(69).state,-b)

  var %newname = $$input(Entrez le nouveau nom de la table. Le nom ne doit pas contenir d'espaces ni l'un des caractères {}[]\;:'"/?>< $+ $chr(44) $+ ~`!@#$%^&*+=,eoq,Renommage d'une table)
  if ($remove(%newname,-,_,.) !isalnum) { theme.error Veuillez spécifier un nom ne comportant pas les caractères {}[]\;:'"/?><,~`!@#$%^&*+= | halt }
  if ($istok($didtok($dname,11,44),%newname,44)) { theme.error Une table de ce nom existe déjà. | halt } 

  hsave %bin %base $qt($mircdir $+ temp.tmp)

  hmake %newname %bsize
  hload %bin %newname $qt($mircdir $+ temp.tmp)
  .remove $qt($mircdir $+ temp.tmp)
  hfree %base
  hash.refTables
}
; Duplique la table sélectionnée
alias -l hash.copyTable {
  var %base = $did(11).seltext
  var %bsize = $hget(%base).size
  var %bin = $iif($did(69).state,-b)

  var %newname = $$input(Entrez le nom de la table dupliquée. Le nom ne doit pas contenir d'espaces ni l'un des caractères {}[]\;:'"/?>< $+ $chr(44) $+ ~`!@#$%^&*+=,eoq,Duplication d'une table)
  if ($remove(%newname,-,_,.) !isalnum) { theme.error Veuillez spécifier un nom ne comportant pas les caractères {}[]\;:'"/?><,~`!@#$%^&*+= | halt }
  if ($istok($didtok($dname,11,44),%newname,44)) { theme.error Une table de ce nom existe déjà. | halt } 

  hsave %bin %base $qt($mircdir $+ temp.tmp)

  hmake %newname %bsize
  hload %bin %newname $qt($mircdir $+ temp.tmp)
  .remove $qt($mircdir $+ temp.tmp)
  hash.refTables
}

; Change la taille d'une table
alias -l hash.changeSize {
  var %base = $did(11).seltext
  var %bsize = $hget(%base).size
  var %bin = $iif($did(69).state,-b)

  var %newsize = $$input(Entrez la nouvelle taille de la table,eoq,Nouvelle taille de table)
  if (%newsize !isnum 1-9999) { theme.error La taille doit être un entier compris entre 1 et 9999. | halt }

  hsave %bin %base $qt($mircdir $+ temp.tmp)

  hfree %base
  hmake %base %newsize
  hload %bin %base $qt($mircdir $+ temp.tmp)
  .remove $qt($mircdir $+ temp.tmp)
  hash.refTables
}

; Ajoute un nouvel élément à la table
alias -l hash.addElement {
  var %newname = $$input(Entrez le nom de l'élément à ajouter. Le nom ne doit pas contenir d'espaces ni l'un des caractères {}[]\;:'"/?>< $+ $chr(44) $+ ~`!@#$%^&*+=,eoq,Ajout d'un élément)
  if ($remove(%newname,-,_,.) !isalnum) { theme.error Veuillez spécifier un nom ne comportant pas les caractères {}[]\;:'"/?><,~`!@#$%^&*+= | halt } 
  if ($istok($didtok($dname,21,44),%newname,44)) { theme.error Un élément de ce nom existe déjà. | halt }

  hadd $iif($did($dname,69).state,-b) $did($dname,11).seltext %newname
  hash.refElements
}
; Supprime l'élément sélectionné de la table
alias -l hash.delElement {
  var %elt = $did(21).seltext
  hdel $did($dname,11).seltext %elt
  hash.refElements
}

; Renomme l'élément sélectionné
alias -l hash.renameElement {
  var %base = $did(11).seltext
  var %elt = $did(21).seltext
  var %newname = $$input(Entrez le nouveau nom de l'élément. Le nom ne doit pas contenir d'espaces ni l'un des caractères {}[]\;:'"/?>< $+ $chr(44) $+ ~`!@#$%^&*+=,eoq,Renommage d'un élément)
  if ($remove(%newname,-,_,.) !isalnum) { theme.error Veuillez spécifier un nom ne comportant pas les caractères {}[]\;:'"/?><,~`!@#$%^&*+= | halt }
  if ($istok($didtok($dname,21,44),%newname,44)) { theme.error Un élément de ce nom existe déjà. | halt } 

  hadd $iif($did($dname,69).state,-b) %base %newname $hget(%base,%elt)
  hdel %base %elt
  hash.refElements
}

; Duplique un élément
alias -l hash.copyElement {
  var %base = $did(11).seltext
  var %elt = $did(21).seltext
  var %newname = $$input(Entrez le nom de l'élément dupliqué. Le nom ne doit pas contenir d'espaces ni l'un des caractères {}[]\;:'"/?>< $+ $chr(44) $+ ~`!@#$%^&*+=,eoq,Duplication d'un élément)
  if ($remove(%newname,-,_,.) !isalnum) { theme.error Veuillez spécifier un nom ne comportant pas les caractères {}[]\;:'"/?><,~`!@#$%^&*+= | halt }
  if ($istok($didtok($dname,21,44),%newname,44)) { theme.error Un élément de ce nom existe déjà. | halt } 

  hadd $iif($did($dname,69).state,-b) %base %newname $hget(%base,%elt)
  hash.refElements
}

; Met à jour la donnée de l'élément sélectionné
alias -l hash.refData { 
  if (!$dialog(hashtable)) { halt }

  var %base = $did(hashtable,11).seltext
  var %elt = $did(hashtable,21).seltext
  did -rae hashtable 41 $hget(%base,%elt)
  did -b hashtable 42-43
}

; Met à jour la liste des éléments de la base sélectionnée
alias -l hash.refElements {
  if (!$dialog(hashtable)) { halt }

  var %i = 1
  var %base = $did(hashtable,11).seltext
  did -r hashtable 21,41
  while (%i <= $hget(%base,0).item) {
    var %item = $hget(%base,%i).item
    if ($did(hashtable,31).state) {
      var %filter = $did(hashtable,30)
      if (%filter $+ * iswm %item) { did -a hashtable 21 %item }
    }
    else {
      did -a hashtable 21 %item
    }
    inc %i 
  }
  did -b hashtable 23-25,41-43
}
; Met à jour la liste des tables
alias -l hash.refTables {
  if (!$dialog(hashtable)) { halt }

  did -r hashtable 11,21,41
  var %i = 1

  while (%i <= $hget(0)) {
    did -a hashtable 11 $hget(%i)
    inc %i
  }
  did -b hashtable 15-18,23-25,30-31,41-43
}

; Rétablit les modifications
alias -l hash.undoModifs {
  var %base = $did(11).seltext
  var %elt = $did(21).seltext
  did -ra $dname 41 $hget(%base,%elt)
  did -b $dname 42-43
}


; Applique les modifications a la valeur sélectionnée
alias -l hash.applyModifs {
  var %base = $did(11).seltext
  var %elt = $did(21).seltext
  var %newval = $getEditboxValue($dname,41)
  hadd %base %elt %newval
  did -b $dname 42-43
}

; Récupère le contenu d'une editbox à multilignes
alias getEditboxValue {
  var %i = 1, %lines = $did($$1,$$2).lines
  var %res
  while (%i <= %lines) {
    %res = %res $did($1,$2,%i)
    inc %i
  }
  return %res 
}

; Remplit les informations sur la base sélectionnée
alias -l hash.updateInfo {
  if (!$dialog(hashtable)) { halt }
  var %base = $did(11).seltext
  if (%base) {
    var %size = $hget(%base).size
    var %nbelts = $hget(%base,0).item
    var %rsize = $round($calc(%nbelts / 10),0)

    did -ra $dname 65 $chr(91) $+ %size $+ $chr(93)
    did -ra $dname 66 $chr(91) $+ %base $+ $chr(93)
    did -ra $dname 67 $chr(91) $+ %nbelts $+ $chr(93)
    did -ra $dname 68 $chr(91) $+ $iif(%rsize < 5,5,%rsize) $+ $chr(93)
  }
  else {
    did -ra $dname 65-68 $chr(91) $+ [N/A] $+ $chr(93)
  }
}



; Recherche parmi les données/elements (si $1 == d, data, sinon item), $2: recherche
alias -l hash.find {
  if ($did($dname,31).state) { did -u $dname 31 | hash.refElements }
  var %t = $iif($1 == d,d,i)

  ; Si la recherche a changé depuis, on remet a jour le compteur
  if ($2- != %hash.search) {
    set -e %hash.count 0
  }
  set -e %hash.search $2-
  var %total = $$hash.searchfor(0,%t,%search)
  if (%total < 1) { theme.error Aucune donnée trouvée | halt }

  var %curbase = $did($dname,11).seltext
  inc %hash.count
  ; Si on a deja parcouru tous les résultats, reprise depuis le début
  if (%hash.count > %total) { %hash.count = 1 }
  var %result = $hash.searchfor(%hash.count,%t,%hash.search)

  did -c hashtable 11 $didwm($dname,11,$gettok(%result,1,777))
  var %newbase = $did($dname,11).seltext
  if (%newbase != %curbase) { hash.refElements | hash.updateInfo }

  did -c hashtable 21 $didwm($dname,21,$gettok(%result,2,777))
  hash.refData
}


alias -l hash.searchFor {
  ; Algorithme: 1: etudier les parametres: si $1 = 0 retourner le total, sinon retourner le n-eme %n
  ; Si $2: i, chercher sur les items, sinon chercher sur data
  ; Enfin $3 doit etre un wildtext et non une regex
  var %n = $$1, %t = $$2, %text = $$3

  ; Ensuite: Parcourir la liste des bases. Donc un for
  ; Pour chaque base, envoyer un $hfind(%base,%text,0,w), .data ou non, et recuperer le nombre %nbr
  ; Si %nbr  + %cpt (compteur de résultats) < %n, passer à la base suivante, en mettant %cpt += %nbr bien entendu
  ; Sinon, c'est que le n-ieme resultat se trouve dans cette base
  ; Dans ce cas, cela veut dire que tant que %cpt < %n, on passe au résultat suivant en incrémentant %cpt
  var %cpt = 0, %base_n = 1
  while (%base_n <= $hget(0)) {
    var %base = $hget(%base_n)
    var %nbr = $iif(%t == d,$hfind(%base,%text,0,w).data,$hfind(%base,%text,0,w))

    if (%nbr == 0) { inc %base_n | continue }
    if ($calc(%nbr + %cpt) < %n) { 
      %lastVal = %base $+ $chr(777) $+ $iif(%t == d,$hfind(%base,%text,%nbr,w).data,$hfind(%base,%text,%nbr,w))
      %cpt = $calc(%cpt + %nbr)
    }
    else {
      var %i = 1
      while (%i <= %nbr) {
        %lastVal = %base $+ $chr(777) $+ $iif(%t == d,$hfind(%base,%text,%i,w).data,$hfind(%base,%text,%i,w))
        if (%cpt == %n) && (%cpt > 0) { return %lastVal }
        inc %cpt
        inc %i
      }
    }
    inc %base_n
  }

  ; Lorsqu'enfin %cpt = %n, on renvoie la valeur en question.
  ; Si on a tout parcouru et pas atteint %n, on renvoie la derniere valeur sauvegardée %lastVal
  ; Si $1 = 0 on renvoie %cpt, sinon on renvoie %lastVal
  if (%n == 0) { return %cpt }
  else { return %lastVal }
}

; -----------------------------------------
; EVENEMENTS
; -----------------------------------------

ON *:DIALOG:hashtable:*:*:{
  if ($devent == init) { 
    hash.refTables
  }
  elseif ($devent == dclick) {
    if ($did == 21) {
      ; Selectionne le contenu de l'editbox
      did -fc $dname 41 1 1 $calc($len($getEditboxValue($dname,$did)) + 5)
    }
  }
  elseif ($devent == sclick) {
    ;Liste de tables
    if ($did == 11) {
      if ($did($did).sel) {
        did $iif($did($did).sel,-e,-b) $dname 15-18
        hash.refElements
        did -e $dname 30-31,80-82,90-92
        hash.updateInfo
      }
    }
    ; Charger
    elseif ($did == 12) { 
      set -u10 %hsh.loadName $did(11).seltext
      set -u10 %hsh.loadSize $hget($did(11).seltext).size
      noop $$dialog(loadhash,loadhash,-4)
    }
    ; Sauver
    elseif ($did == 13) { 
      set -u10 %hsh.loadName $did(11).seltext
      set -u10 %hsh.loadSize $hget($did(11).seltext).size
      noop $$dialog(savehash,savehash,-4)
    }
    ; Nouvelle
    elseif ($did == 14) { 
      set -u10 %hsh.loadName $did(11).seltext
      set -u10 %hsh.loadSize $hget($did(11).seltext).size
      noop $$dialog(createhash,createhash,-4)
    }
    ; Supprimer
    elseif ($did == 15) {
      if ($$yndialog(Êtes-vous sûr(e) de vouloir supprimer la table sélectionnée?)) {
        hfree $did(11).seltext
        hash.refTables
      }
    }
    ; Renommer
    elseif ($did == 16) { hash.renameTable }
    ; Copier
    elseif ($did == 17) { hash.copyTable }
    ; Changer Taille
    elseif ($did == 18) { hash.changeSize }
    ; Liste des elements
    elseif ($did == 21) {
      if ($did($did).sel) {
        did $iif($did($did).sel,-e,-b) $dname 23-25
        did -e $dname 30-31,80-82,90-92
        hash.refData 
      }
    }
    elseif ($did == 22) { hash.addElement }
    elseif ($did == 23) { hash.delElement }
    elseif ($did == 24) { hash.renameElement }
    elseif ($did == 25) { hash.copyElement }
    ; Checkbox filter
    elseif ($did == 31) { did $iif($did($did).state,-e,-b) $dname 30 | hash.refElements }
    ; Retablir
    elseif ($did == 42) { 
      if ($did(41).edited) && ($$yndialog(Effacer toutes les modifications?)) { 
        hash.undoModifs
      } 
    }
    ; Appliquer
    elseif ($did == 43) { hash.applyModifs }
    ; Rechercher élément
    elseif ($did == 82) { hash.find i $did(81) }
    elseif ($did == 92) { hash.find d $did(91) }
  }
  elseif ($devent == edit) {
    ; Filter
    if ($did == 30) {
      hash.refElements
    }
    ; Data
    elseif ($did == 41) {
      did $iif($did($did).edited,-e,-b) $dname 42-43
    }
  }
  elseif ($devent == menu) {
    if ($did == 121) { help /hmake }
  }
  elseif ($devent == close) { unset %hash.* }
}

; Dialogs de save/load/create
ON *:DIALOG:*hash:*:*:{
  if ($devent == init) {
    did -ra $dname 12 %hsh.loadName
    if (%hsh.loadSize) { did -ra $dname 14 %hsh.loadSize }
  }
  elseif ($devent == sclick) {
    if ($did == 1) {
      if ($dname == loadhash) { hash.loadFile }
      elseif ($dname == savehash) { hash.saveFile }
      elseif ($dname == createhash) { hash.createNewTable }
    }
  }
}


menu menubar {
  Outils
  .Hash Viewer
  ..Ouvrir:opendialog -mh hashtable
  ..Décharger script:unload -rs $qt($script)
}


; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
