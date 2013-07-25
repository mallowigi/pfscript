;---------------------------------
; Quote Manager
;---------------------------------

ON *:START:{
  ; Chargement des quotes au démarrage
  if (!$hget(quotes)) { hmake quotes 100 }
  var %f = $qt($rqi(file))
  if (!$exists(%f)) { return }
  hload -i quotes %f
}

ON *:EXIT:{
  var %f = $qt($rqi(file))
  if ($exists(%f)) && ($hget(quotes)) { write -c %f | hsave -i quotes %f }
}

on *:LOAD:{ 
  loadQuoteFile new
  theme.echo Quote Manager v2.0 par Klarth. Tapez /openquotes pour commencer
}

ON *:UNLOAD:{
  remqi file
  remqi style
  hfree quotes
}


;----------------------------------
; Aliases
;---------------------------------

alias openQuotes { opendialog -mh quotes }

alias -l quoteVer { return QuoteManager v2.0 }

; Lecture/Ecriture dans un fichier de conf
alias -l rqi { return $readini($mircdir/pfscript.ini,quotes,$$1) }
alias -l wqi { if ($3- == $null) { remi $$1 $$2 } | else { writeini " $+ $mircdir $+ /pfscript.ini $+ " quotes $$1 $2- } }
alias -l remqi { remini " $+ $mircdir $+ /pfscript.ini $+ " quotes $1 }

; Charge un fichier de quotes
; $1: chemin du fichier, ou new pour créer un nouveau fichier
alias loadQuoteFile {
  if ($1 == new) {
    var %quotefile = $sfile(data/quotes.txt,Sélectionnez le fichier de quotes à charger:)
    if (%quotefile == $null) { var %err = Vous n'avez pas spécifié de fichier de quotes. En créer un ? }
    elseif (!$exists($qt(%quotefile))) { var %err = Le fichier $qt(%quotefile) n'existe pas! Créer un fichier vierge? }
    elseif ($right(%quotefile,4) !isin .ini/.txt) { var %err = Le fichier spécifié n'est pas un fichier texte valide. Créer un fichier vierge? }

    if (%err) && ($$yndialog(%err)) { write -c data/quotes.txt | wqi file data/quotes.txt }
    else { wqi file %quotefile }
  }
  elseif ($1-) {
    var %quotefile = $1-
    if (!$exists($qt(%quotefile))) { var %err = Le fichier $qt(%quotefile) n'existe pas! Créer un fichier vierge? }
    elseif ($right(%quotefile,4) !isin .ini/.txt) { var %err = Le fichier spécifié n'est pas un fichier texte valide. Créer un fichier vierge? }

    if (%err) && ($$yndialog(%err)) { write -c $qt(%quotefile) | wqi file %quotefile }
    else { wqi file %quotefile }
  }
  else { halt }

  if (!$hget(quotes)) { hmake quotes 100 }
  else { hdel -w quotes * }
  hload -i quotes $qt(%quotefile)
  normalizeHash quotes
}

; Ajoute une quote à la base
; Syntaxe: $addQuote(nom,contenu) ou $addquote(contenu) pour assigner un nom automatiquement
alias addQuote {
  if ($0 == 0) { $errdialog(Vous devez donner un contenu à votre quote) | halt }
  elseif ($0 == 1) { var %titleq = quote $+ $trnum | var %contq = $1 }
  else { var %titleq = $1 | var %contq = $2- }

  var %name = $unspace(%titleq)
  while ($hget(quotes,%name)) { var %name = $unspace($$inputdialog(Une quote de ce nom existe déjà. Veuillez spécifier un autre nom:)) }

  hadd quotes %name %contq
  theme.echo Quote $qt($space(%name)) ajoutée!
  return %name
}

; Supprime une quote par son nom
; Syntaxe: $delquote(nom)
alias delQuote {
  var %titleq = $$1-
  var %name = $hget(quotes,$unspace(%titleq))

  if (!%name) { errdialog Impossible de supprimer la quote $qt(%titleq) : Cette quote n'existe pas. | halt }
  if ($$yndialog(Êtes-vous sûr(e) de vouloir supprimer la quote $qt(%titleq) ?Cette opération est irréversible.)) {
    hdel quotes $unspace(%titleq)
    theme.echo Quote $qt(%titleq) retirée de la base!
  }
}


; Retourne une quote au hasard
; Syntaxe: /randomquote pour afficher sur la fenetre active, $randomquote retourne la valeur
alias randomQuote {
  var %n = $hget(quotes,0).item
  var %i = $rand(1,%n), %quote = $hget(quotes,%i).data

  if ($isid) { return $quotestyle(%quote) }
  else { $iif($active == Status Window,echo -st,say) 2- Random Quote - $quotestyle(%quote) 2- Random Quote - }
}

; Recherche dans les quotes installées
; Syntaxe: $findquote(pattern) pour rechercher dans le contenu des quotes, $findquote(pattern).name pour rechercher dans le nom
; Dans le cas où il y'a plusieurs résultats, renvoie les résultats séparés par le caractère NUL ($chr(1))
alias findQuote {
  var %pattern = $+(*,$1-,*)
  var %result

  var %i = 1
  while ($iif($prop == name,$hfind(quotes,%pattern,%i,w),$hfind(quotes,%pattern,%i,w).data)) {
    var %quote = $ifmatch
    %result = $addtok(%result,$space(%quote),1)
    inc %i
  }
  return %result
}

; Retourne la quote affublée du style de quote choisi.
; Syntaxe: $quoteStyle(phrase)
alias quoteStyle { 
  var %style = $getQuoteStyle($rqi(style))
  if (%style) && (<text> isin %style) { return $replace(%style,<text>,$1-) }
  else { return - Quote - $1- - Quote - }
}


;--------------------------------
; Dialogs
;--------------------------------

; 1) Alias pour les dialogs

; Charge les quotes de la base dans la liste
alias -l loadQuoteNames {
  did -r quotes 10,20
  prevbmp quotes 30 12 normal 2
  did -b quotes 12-14,21,22,104-106
  var %n = $hget(quotes,0).item, %i = 1
  if ($window(@quotes)) window -c @quotes
  window -sh @quotes

  while ($hget(quotes,%i).item) {
    aline @quotes $space($ifmatch)
    inc %i
  }
  filter -cwo @quotes quotes 10 *
}

; Renomme la quote sélectionnée
alias -l renameQuote {
  var %oldname = $did(10).seltext
  var %name = $$inputdialog(Entrez un nouveau nom pour la quote $qt(%oldname) $+ .,%oldname)
  var %quote = $hget(quotes,$unspace(%oldname))
  if (!%quote) { errdialog La quote $qt(%oldname) n'existe plus. | halt }
  while ($hget(quotes,$unspace(%name))) { %name = $$inputdialog(Une quote de ce nom existe déjà. Veuillez spécifier un autre nom.,%name) }

  hadd quotes $unspace(%name) %quote
  hdel quotes $unspace(%oldname)
  loadQuoteNames
}

; Dialog principal
dialog quotes {
  title ""
  size -1 -1 600 480
  option pixels
  icon "images/masterIRC2.ico", 0

  text "Quote Manager v2.0", 1, 4 2 590 16, center
  text "Fichier de quotes:", 2, 6 20 90 14
  edit "", 3, 96 18 460 20, disable autohs
  button "...", 4, 560 18 28 20
  text "Cliquez sur une quote pour l'afficher dans l'editbox de droite, double cliquez pour l'afficher sur le canal actif.", 5, 6 42 580 16

  list 10, 4 58 206 356, sort size
  button "&Nouvelle quote", 11, 6 422 100 24
  button "&Renommer quote", 12, 112 422 100 24, disable
  button "&Supprimer quote", 13, 216 422 100 24, disable
  button "&Copier quote", 14, 322 422 100 24, disable
  button "Re&chercher", 15, 6 450 100 24
  edit "Filtrer", 16, 110 450 206 24, right
  button "Quote &aléatoire", 17, 322 450 100 24

  edit "", 20, 214 58 310 176, multi return
  button "&Appliquer", 21, 525 60 72 24
  button "Res&taurer", 22, 525 206 72 24
  button "", 30, 216 238 376 178, flat
  button "", 40, 0 0 0 0, ok

  button "&Fermer", 50, 510 424 80 48, cancel

  menu "&Fichier", 100
  item "&Charger fichier...", 101, 100
  item break, 102, 100
  item "&Nouvelle quote (Alt+N)", 103, 100
  item "&Renommer quote (Alt+R)", 104, 100
  item "&Supprimer quote (Alt+S)", 105, 100
  item "&Copier Quote (Alt+C)", 106, 100
  item break, 107, 100
  item "Re&chercher", 108, 100
  item break, 109, 100
  item "Quote &aléatoire", 110, 100
  item break, 111, 100
  item "&Fermer", 112, 100
  menu "&Options", 200
  item "&Options des quotes", 201, 200
}

; Dialog d'ajout
dialog addQuote {
  title "Ajout d'une nouvelle quote"
  size -1 -1 360 200
  option pixels
  icon images/masterIRC2.ico, 0

  text "Entrez le nom de votre quote ainsi que son contenu. Si votre quote contient plusieurs lignes, il est d'usage de tout écrire sur une même ligne, pour plus de facilité de lecture.", 1, 6 2 346 40
  text "Nom", 2, 4 50 50 14
  text "Contenu", 3, 4 72 50 16
  edit "", 4, 70 48 280 20, limit 30
  edit "", 5, 70 70 280 100, multi return autovs vsbar
  button "Ajouter", 6, 100 172 80 24, ok
  button "Annuler", 7, 200 172 80 24, cancel
}

; Recherche d'une quote
dialog searchQuote {
  title "Rechercher"
  size -1 -1 280 86
  option pixels
  icon images/masterIRC2.ico, 0

  text "Rechercher:", 1, 4 10 60 14
  edit "", 2, 66 6 200 21
  check "Rechercher dans le contenu des quotes", 3, 20 34 240 20
  button "Rechercher", 4, 100 56 75 25, ok
  button "Annuler", 5, 180 56 75 25, cancel
}

; Options du QuoteManager
dialog quoteOptions {
  title "Quote Manager - Options"
  size -1 -1 360 170
  option pixels
  icon images/masterIRC2.ico, 0

  box "Options de style", 1, 6 2 350 164
  text "Thème", 2, 12 20 33 16
  combo 3, 54 18 294 160, size drop
  edit "", 4, 54 42 295 20, hide
  text "Preview", 5, 12 90 40 16
  text "Inscrivez ici le format de quote personnalisé. N'oubliez pas d'insérer la balise <text>.", 6, 54 60 294 24, hide
  button "", 10, 54 88 295 18
  button "OK", 11, 186 132 75 25, ok
  button "Annuler", 12, 272 132 75 25, cancel
}

ON *:DIALOG:quotes:*:*:{
  if ($devent == init) {
    dialog -t $dname $quotever - Par Klarth
    did -b $dname 21,22,104-106

    mdxLoad
    mdx SetFont $dname 1 14 700 Helvetica UI
    mdx SetColor $dname 16 text $webcolor(DimGray)
    prevbmp $dname 30 12 normal 2 

    did -ra $dname 3 $rqi(file)

    loadQuoteNames
  }
  elseif ($devent == dclick) {
    ; Double clic sur l'element affiche la quote
    if ($did == 10) { 
      var %q = $hget(quotes,$unspace($did($did).seltext))
      if (%q) { $iif($active == Status Window,echo -st,say) $quoteStyle(%q) }
    }
  }
  elseif ($devent == sclick) {
    ; Clic bouton "..."
    if ($did == 4) {
      loadQuoteFile new
      loadQuoteNames
    }
    ; Clic sur un élément de la liste: affichage quote
    elseif ($did == 10) {
      var %text = $unspace($did($did).seltext)
      var %quote = $hget(quotes,%text)
      if (%quote) { did -ra $dname 20 %quote | prevbmp $dname 30 12 normal 2 $quoteStyle(%quote) }
      did $iif($did($did).sel,-e,-b) $dname 12-14,21,22,104-106
    }
    ; Boutons 
    elseif ($did == 11) { opendialog -mh addquote }
    elseif ($did == 12) { renameQuote | loadQuoteNames }
    elseif ($did == 13) { delQuote $did(10).seltext | loadQuoteNames }
    elseif ($did == 14) { clipboard $hget(quotes,$unspace($did(10).seltext)) }
    elseif ($did == 15) { opendialog -mh searchQuote }
    elseif ($did == 17) { randomQuote }
    ; Appliquer
    elseif ($did == 21) { 
      var %name = $did(10).seltext, %quote = $getEditboxValue($dname,20)
      if ($$yndialog(Remplacer le contenu de la quote $qt(%name) ?)) { hadd quotes $unspace(%name) %quote }
    }
    ; Restaurer
    elseif ($did == 22) { 
      var %name = $did(10).seltext, %quote = $getEditboxValue($dname,20)
      if ($$yndialog(Effacer les modifications de la quote $qt(%name) ?)) { 
        did -ra $dname 20 $hget(quotes,$unspace(%name)) 
        prevbmp $dname 30 12 normal 2 $quotestyle($getEditboxValue($dname,20)) 
      }
    }
    ; Bouton ok caché pour prendre un compte la touche entrée
    elseif ($did == 40) { 
      if ($dialog($dname).focus == 16) { 
        filter -cwo @quotes $dname 10 $did(16).text $+ * 
        did -b $dname 12-14,21,22,104-106 
        did -r $dname 20
        prevbmp $dname 30 12 normal 2
      }
      elseif ($dialog($dname).focus == 10) {
        var %q = $hget(quotes,$unspace($did(10).seltext))
        if (%q) { $iif($active == Status Window,echo -st,say) $quoteStyle(%q) } 
      }
      halt
    }
  }
  elseif ($devent == edit) {
    ; Filtrage
    if ($did == 16) { 
      filter -cwo @quotes $dname 10 $did($did).text $+ *
      did -b $dname 12-14,21,22,104-106 
      did -r $dname 20
      prevbmp $dname 30 12 normal 2
    }
    ; Edition
    elseif ($did == 20) {
      prevbmp $dname 30 12 normal 2 $quotestyle($getEditboxValue($dname,20))
    }
  }
  elseif ($devent == menu) {
    if ($did == 101) {
      loadQuoteFile new
      loadQuoteNames
    }
    elseif ($did == 103) { opendialog -mh addquote }
    elseif ($did == 104) { renameQuote | loadQuoteNames }
    elseif ($did == 105) { delQuote $did(10).seltext | loadQuoteNames }
    elseif ($did == 106) { clipboard $hget(quotes,$unspace($did(10).seltext)) }
    elseif ($did == 108) { opendialog -mh searchQuote }
    elseif ($did == 110) { randomQuote }
    elseif ($did == 112) { dialog -c quotes }
    elseif ($did == 201) { opendialog -mh quoteOptions }
  }
}

ON *:DIALOG:addquote:*:*:{
  if ($devent == sclick) {
    if ($did == 6) {
      var %name = $did(4), %content = $getEditboxValue($dname,5)
      if (!%name) { infodialog Attention: Vous n'avez pas entré de nom à votre quote, par conséquent un nom par défaut en "quoteX" lui a été assigné. | var %name = quote $+ $trnum }
      if (!%content) { errdialog Vous n'avez pas donné de contenu à votre quote! | halt }

      noop $addQuote(%name,%content)
      if ($dialog(quotes)) loadQuoteNames
      dialog -c $dname
    }
  }
}


ON *:DIALOG:searchQuote:*:*:{
  if ($devent == sclick) {
    if ($did == 4) {
      var %find = $did(2), %pattern = $iif($did(3).state == 0,.name)

      var %results = $findquote(%find) [ $+ [ %pattern ] ]

      ; Affichage des resultats dans la liste
      if ($dialog(quotes)) {
        did -r quotes 10,20
        prevbmp quotes 30 12 normal 2
        did -b quotes 12-14,21,22,104-106
        didtok quotes 10 1 %results
      }
      ; Sinon affichage dans la fenetre
      else { echo -a %results }
    }
  }
}


; Retorune le style de quote du nom de theme choisi
alias getQuoteStyle {
  if ($1 == Défaut) { return $pubmsg(Citation)  <text> $pubmsg(Citation) }
  elseif ($1 == Ténèbres) { return 0,1 ɊɄøƮɆ  _' <text> '_ 0,1 ɊɄøƮɆ  }
  elseif ($1 == Sang) { return 1,4♦☥ ɋʋɵʈɘ ☥♦ - <text> - 1,4♦☥ ɋʋɵʈɘ ☥♦ }
  elseif ($1 == Sépia) { return 8,5 $lacc $+ $pipe 0,5Citation8,5 $pipe $+ $racc 5 <text> 8,5 $lacc $+ $pipe 0,5Citation8,5 $pipe $+ $racc }
  elseif ($1 == Lavande) { return 15,6[||13,6 Citation 15,6||] - <text> - 15,6[||13,6 Citation 15,6||] }
  elseif ($1 == Vertes Plaines) { return 8,3#@#9,3 Quotation 8,3#@#3 ~~ <text> 3~~ 8,3#@#9,3 Quotation 8,3#@# }
  elseif ($1 == Amour) { return 4,13♥♪☼ Love Quote ☼♪♥ 4- <text> - 4,13♥♪☼ Love Quote ☼♪♥ }
  elseif ($1 == Glaçon) { return 14,0❖░░░ Icyquote ░░░❖ - <text> - 14,0❖░░░ Icyquote ░░░❖ }
  elseif ($1 == Lime) { return 8,3⊛¤×« Citron »×¤⊛ 3- <text> - 8,3⊛¤×« Citron »×¤⊛ }
  elseif ($1 == Inversé) { return ¿¡ əʇonb ¿¡ - <text> - ¿¡ əʇonb ¿¡ }
  elseif ($1 == Enfer) { return 8,4卍† КОТШ †卍 -- <text> -- 8,4卍† КОТШ †卍 }
  elseif ($1 == Neige) { return 0,11⁂⁑* Citation *⁑⁂ 12- <text> - 0,11⁂⁑* Citation *⁑⁂ }
  elseif ($1 == Pimp) { return 8,6 $str($dollar,3) Pimp Quote $str($dollar,3) 6~ <text> 6~ 8,6 $str($dollar,3) Pimp Quote $str($dollar,3) }
  elseif ($1 == Teal) { return 1,10 oOo Citation oOo 10 <text> 1,10 oOo Citation oOo }
  elseif ($1 == Bulles) { return 2,11.••° 12,11Citation2,11 °••. 1,11<text> 2,11.••° 12,11Citation2,11 °••. }
  elseif ($1 == Rainbow) { return 1,8..1,7Q1,4u1,9o1,12t1,2e1,6..1,15 - <text> 1,15- 1,8..1,7Q1,4u1,9o1,12t1,2e1,6.. }
  elseif ($1 == Musique) { return 1,0 ♩♪♫♬♩ Musiquote ♩♪♫♬♩ "<text>" 1,0♩♪♫♬♩ Musiquote ♩♪♫♬♩ }
  elseif ($1 == FFWorld) { return 1,14 .:: Citation ::. 1,15 <text> 1,14 .:: Citation ::. }
  elseif ($1 == Personnalisé) { return $rqi(format) }
  else { return <text> }
}

; Change et affiche le style de quote
alias -l changeQuoteStyle {
  var %name = $did(quoteOptions,3).seltext
  var %style = $getQuoteStyle(%name)

  if (%style) { prevbmp quoteOptions 10 12 normal 2 $replace(%style,<text>,Ceci est une quote :o) }
  did $iif(%name == Personnalisé,-v,-h) quoteOptions 4,6
  if (%name == Personnalisé) { did -ra quoteOptions 4 $rqi(format) }
}

ON *:DIALOG:quoteOptions:*:*:{
  if ($devent == init) {
    mdxLoad
    didtok $dname 3 59 Défaut;Ténèbres;Sang;Sépia;Lavande;Vertes Plaines;Amour;Glaçon;Lime;Inversé;Enfer;Pimp;Neige;Teal;Bulles;Rainbow;Musique;FFWorld;Personnalisé
    did -c $dname 3 1
    changeQuoteStyle
  }
  elseif ($devent == sclick) {
    if ($did == 3) { changeQuoteStyle }
    elseif ($did == 11) { wi quotes style $did(3).seltext | if ($did(3).seltext == Personnalisé) { wi quotes format $did(4) } }
  }
  elseif ($devent == edit) {
    if ($did == 4) { prevbmp quoteOptions 10 12 normal 2 $replace($did($did),<text>,Ceci est une quote :o) }
  }
}

menu menubar {
  Outils
  .Quote Manager
  ..Ouvrir le Quote Manager:openquotes
  ..-
  ..Ajouter une quote:opendialog -mh addQuote
  ..Supprimer une quote:delQuote $unspace($$?="Entrez ici le nom de la quote à supprimer"
  ..-
  ..Rechercher une quote:opendialog -mh searchQuote
  ..Quote aléatoire:randomQuote
  ..-
  ..Décharger le Quote Manager
  ...Êtes-vous sûr(e)?:unload -rs quotes.mrc
}

;--------------------------------------------
; Fin de fichier
;--------------------------------------------
