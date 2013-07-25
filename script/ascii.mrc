; --------------------------------------
; #### Ascii List v2.0 - by Flobse ####
; Translated by Klarth
; --------------------------------------
;
; ##### Description ####
; Voici la nouvelle liste Ascii (non basée sur la v1.1) optimisée pour les scripters.
; Elle est plus petite, plus rapide et plus efficace que la v1.1
; 
; Version 3.0: Support des caracteres unicode
;
; Elle affiche une @Window pour afficher tous les caractères Ascii (0-255 et plus avec le support unicode ) avec leurs valeurs hexadécimales, 
; octales et le caractère équivalent/la description du caractère pour les caractères spéciaux.
; Vous pouvez utiliser le menu popup (clic droit) pour copier la valeur souhaitée ou utiliser directement les touches clavier (cf. plus bas).
; Vous pouvez aussi activer les couleurs ou la fermeture automatique via le menu.
;
; Une autre fonction utile de ce script est la fonction "Recherche". Tapez ce que vous recherchez et le script vous affichera l'information souhaitée.
; Note: Utilisez exactement le nombre de chiffres affiché pour trouver une donnée spécifique.
; Exemple: 35 vous retournera la valeur Hex 35, soit Ascii 0053. 
; Si vous recherchez la valeur Ascii 35, vous devrez écrire 0035.
; Même chose pour la valeur octale (3 chiffres).
;
; Vous pouvez utiliser certaines fonctions de ce script dans vos scripts
;
; Faites-vous plaisir :)
; --------------------------------------
;
; ##### Syntaxe ##### [] = optionnel, | = ou, <> = obligatoire
; Asciilist Syntaxe: /ascii [searchstring]
; Ouvre la liste et affiche la valeur trouvée.
;
; Identifieur $ascii Syntaxe: $ascii(<searchstring>) [.asc|.chr|.char|.hex|.oct]
; Retourne le premier résultat (Pour les caractères 0-32,127,160, retourne "Text")
;
; Identifieur $ascTo Syntaxe: $ascTo(<0-255>) [.chr|.hex|.oct|.char]
; Convertit la valeur spécifiée.
; --------------------------------------
;
; ##### Exemples #####
; Ouvrir la liste Ascii
; /ascii ou /ascii séparateur ou /ascii 0035 etc.
;
; Utilisez $ascii comme Multi-$chr-$asc:
; Syntaxe: $ascii(<Chars|Asciis separés par un espace>) <.chr|.asc>
; //echo -a $ascii(Hello).asc == 72 101 108 108 111
; //echo -a $ascii(72 101 108 108 111).chr == Hello
;
; Utilisez $ascii comme moteur de recherche pour Ascii, Hex, Oct et Chars:
; Syntaxe: $ascii(<searchstring>) [.hex|.oct|.chr|.char] (Résultat par défaut: Ascii)
; //echo -a $ascii(Separator) == 0028 (pas de propriété: retourne le code Ascii)
; //echo -a $ascii(Separator).hex == 1C (retourne la valeur hexa)
; //echo -a $ascii(0035).oct == 043 (retourne la valeur octale)
; //echo -a $ascii(0035).chr == # (Même fonction que $chr)
; //echo -a $ascii(mission).char == Transmissionend (Retourne le caractère via $ascTo)
;
; Utilisez $ascTo pour convertir d'Ascii vers Hex, Oct ou Char (0-32,127 et 160 retournent "Text")
; Syntaxe: $ascTo(<0-255>) [.hex|.oct|.chr|.char] (Résultat par défaut: Ascii)
; //echo -a $ascTo(35) == 0035 (Format Ascii)
; //echo -a $ascTo(35).hex == 23 (Valeur hexa)
; //echo -a $ascTo(35).oct == 043 (Valeur octale)
; //echo -a $ascTo(35).chr == # (Même fonction que $chr)
; //echo -a $ascTo(18).char == Cancel (Retourne le caractere)
;
; --------------------------------------
; ## #Flobse @ Quakenet - Scripter@Flobse.de - UIN: 152759920 ##

;;;<Doc>
;; Ascii list dans le menu
menu menubar {
  Outils
  .Ascii List : ascii
}

;;;
;; Syntaxe: /ascii [searchstring]
;; Ouvre la liste et affiche la valeur trouvée.
;;
;; Identifieur $ascii Syntaxe: $ascii(<searchstring>) propriété: [.asc|.chr|.char|.hex|.oct]
;; Retourne le premier résultat (Pour les caractères 0-32,127,160, retourne "Text")
alias ascii { 
  if ($isid) {
    if ($prop == asc) { var %x 1 | while ($mid($1-,%x,1)) { var %r = %r $asc($v1) | inc %x } | return %r }
    elseif ($prop == chr) { var %x 1 | while ($gettok($1-,%x,32)) { var %r = %r $+ $replace($chr($v1),$chr(32),$chr(160)) | inc %x } | return %r }
    else { return $($ $+ ascii.search($1-). $+ $iif($istok(.hex.oct.char.chr,$prop,46),$prop,ascii),2) }
  } 
  if ($window(@ascii)) { window -c @ascii }
  window -adzle0k0 @Ascii -1 -1 480 380 Cambria 16 
  aline @ascii $str($chr(160),3) ASCII $str($chr(160),6) HEX $str($chr(160),6) OCT $str($chr(160),6) UNICODE $str($chr(160),6) CHAR
  aline @ascii $str($chr(160),3) $str(-,8) $str($chr(160),5) $str(-,6) $str($chr(160),6) $str(-,6) $str($chr(160),5) $str(-,14) $str($chr(160),5) $str(-,15) 
  ascii.loadUnicode 0
  set -e %ascii.step 0
}

alias -l ascii.loadUnicode {
  var %x = $calc($1 * 256), %end = $calc(%x + 256)
  if (%x > 0) { dline @ascii $calc((%x + 6) - 3) $+ - $+ $calc((%x + 6) - 1) }
  while (%x < %end) { 
    aline @ascii $str($chr(160),3) $ascTo(%x) $str($chr(160),7) $ascTo(%x).hex $str($chr(160),8) $ascTo(%x).oct $str($chr(160),6) $ascTo(%x).unicode $str($chr(160),9) $ascTo(%x).char 
    inc %x 
  }
  aline @ascii $str($chr(160),3) $str(-,50)
  aline @ascii $str($chr(160),5) $str(-,10) Scripted by Flobse $str(-,9)
  aline @ascii $str($chr(160),3) $str(-,50)
}

;;;
;; Identifieur $ascTo Syntaxe: $ascTo(<0-255>) propriété: [.chr|.hex|.oct|.char]
;; Convertit la valeur spécifiée.
alias ascTo {
  if ($1 isnum 0-65535) {
    if ($prop == hex) { return $base($1,10,16,2) }
    elseif ($prop == oct) { return $base($base($1,10,8),8,8,3) }
    elseif ($prop == chr) { return $chr($1) }
    elseif ($prop == unicode) { return U+ $+ $base($1,10,16,4) }
    elseif ($prop == char) { 
      if ($1 == 0) { return Null }
      var %asc $chr($1)
      var %asc $replacex(%asc,$chr(1),Header Start,$chr(2),Text Start (Ctrl+B),$chr(3),Text End (Ctrl+K),$chr(4),Transmission End,$chr(5),Enquiry (),$chr(6),Acknowledge (),$chr(7),Bell (),$chr(8),Backspace (),$chr(9),TAB,$chr(10),LineFeed ($lf),$chr(11),Vertical TAB (),$chr(12),New Page (),$chr(13),Carriage Return ($cr),$chr(14),Shift Out (),$chr(15),Shift In (Ctrl+O),$chr(16),Delete (),$chr(17),Dev.Control1 (),$chr(18),Dev.Control2 (),$chr(19),Dev.Control3 (),$chr(20),Dev.Control4 (),$chr(21),Neg. Acknowledge (),$chr(22),Sychronous Idle (Ctrl+R),$chr(23),Transmission End (),$chr(24),Cancel (),$chr(25),Medium End (),$chr(26),Substitute (),$chr(27),Escape (),$chr(28),File Separator (),$chr(29),Group Separator (Ctrl+I),$chr(30),Record Separator (),$chr(31),Unit Separator (Ctrl+U),$chr(32),Space,$chr(127),Delete (),$chr(160),Non-breaking space)
      return $iif($1 != 95,$replace(%asc,$chr(95),$chr(32)),%asc) 
    }
    else { return $base($1,10,10,4) }
  }
}

alias -l ascii.search {
  if ($1) { 
    if ($asc($1)) && ($len($1) == 1) { ascii.sline $asc($1) | if ($isid) { return  $($ $+ ascTo($asc($1)). $+ $prop,2) } }
    elseif ($1 isalpha) && ($len($1) > 2) {
      var %x 0
      while (%x <= 31) { 
        if ($1 isin $ascTo(%x).char) { ascii.sline %x | return $iif($isid,$($ $+ ascTo(%x). $+ $prop,2)) }
        inc %x
    } }
    if ($1 isnum 0-65535) && ($len($1) == 4) { ascii.sline $1 | if ($isid) { return $($ $+ ascTo($1). $+ $prop) } }
    elseif ($len($1) == 3) && ($1 isnum 0-177777) { ascii.sline $base($1,8,10) | if ($isid) { return $($ $+ ascTo($base($1,8,10)). $+ $prop) }  }
    elseif ($len($1) == 2) {
      var %x 0
      while (%x <= 255) {
        if ($1 == $base(%x,10,16,2)) { ascii.sline %x | return $iif($isid,$iif($isid,$($ $+ ascTo(%x). $+ $prop,2))) }
        inc %x
      } 
    } 
  } 
} 

alias -l ascii.sline { if ($window(@ascii)) && ($1 isnum 0-65535) { sline @ascii $calc($1 +3) } }

alias -l ascii.do {
  if ($window(@ascii)) && ($1)  {
    if ($1 == A) { clipboard $int($gettok($sline(@ascii,1),1,160)) }
    elseif ($1 == H) { clipboard $gettok($sline(@ascii,1),2,160) }
    elseif ($1 == O) { clipboard $int($gettok($sline(@ascii,1),3,160)) }
    elseif ($1 == U) { clipboard $gettok($sline(@ascii,1),4,160) }
    elseif ($1 == C) { clipboard $gettok($sline(@ascii,1),5,160) }
    elseif ($1 == T) { clipboard $+($chr(38),$chr(35),$int($gettok($sline(@ascii,1),1,160)),$chr(59)) }
    elseif ($1 == L) { clipboard $remove($gettok($sline(@ascii,1),1-4,160),$chr(160)) }
    elseif ($1 == F) { ascii.search $input(Entrez un code Ascii  $+ $chr(44) Hexa  $+ $chr(44) Octal ou un Caractère à rechercher:,-eoqs,@Ascii,Recherche, $remove($gettok($sline(@ascii,1),1,160),$chr(32))) }
    elseif ($1 == M) { inc %ascii.step | ascii.loadUnicode %ascii.step }
    elseif ($1 == X) { window -c @Ascii }
  }
}


; Return the name of the hashtable
alias -l ascii.hash { return Ascii.hashtable }

on *:close:@Ascii:{ unset %ascii.* }

;;;
;; Appui sur la touche entrée dans la fenêtre @Ascii: Copiage du contenu de l'editbox
On *:INPUT:@Ascii:{ clipboard $1- }

;;;
;; Raccourcis clavier
;; A: Copier la valeur numérique
;; H: Copier la valeur hexadecimale
;; O: Copier la valeur octale
;; U: Copier la valeur unicode
;; C: Copier le caractère
;; T: Copier le caractère au format HTML
;; L: Copier toute la ligne
;; F: Rechercher un caractere
;; M: Afficher les 255 caractères Unicode suivants
on *:keydown:@Ascii:65,67,70,72,76,77,79,84,85,88: { ascii.do $keychar }

;;;
;; Popups lors d'un clic droit sur la fenetre @ascii
;; Double clic sur une ligne copie et colle le caractère ascii sélectionné dans l'editbox
menu @ascii {
  dclick:editbox $active $editbox($active) $+ $chr($gettok($sline(@ascii,1),1,160)) | clipboard $editbox($active)
  $iif($sline(@ascii,1).ln isnum 3-65538, $chr(187) Copy Ascii (A) $+ $chr(58) $gettok($sline(@ascii,1),1,160)) : ascii.do A
  $iif($sline(@ascii,1).ln isnum 3-65538, $chr(187) Copy Hex  (H) $+ $chr(58) $gettok($sline(@ascii,1),2,160)) : ascii.do H
  $iif($sline(@ascii,1).ln isnum 3-65538, $chr(187) Copy Oct (O) $+ $chr(58) $gettok($sline(@ascii,1),3,160)) : ascii.do O
  $iif($sline(@ascii,1).ln isnum 3-65538, $chr(187) Copy Ucode (U) $+ $chr(58) $gettok($sline(@ascii,1),4,160)) : ascii.do U
  $iif($sline(@ascii,1).ln isnum 3-65538, $chr(187) Copy Char (C) $+ $chr(58) $gettok($sline(@ascii,1),5,160)) : ascii.do C
  $iif($sline(@ascii,1).ln isnum 3-65538, $chr(187) Copy Html (T) $+ $chr(58) $+($chr(38),$chr(38),$chr(35),$int($gettok($sline(@ascii,1),1,160)),$chr(59))) : ascii.do T
  $iif($sline(@ascii,1).ln isnum 3-65538, $chr(187) Copy Line (L) $+ $chr(58) $remove($gettok($sline(@ascii,1),1-4,160),$chr(160))) : ascii.do L
  $iif($sline(@ascii,1).ln isnum 3-65538, -)
  $iif($sline(@ascii,1).ln isnum 3-65538, $chr(187) Find.. (F)) : ascii.do F
  $iif($sline(@ascii,1).ln isnum 3-65538, $chr(187) More Lines (M)) : ascii.do M
  $iif($sline(@ascii,1).ln isnum 3-65538, -)
  $iif($sline(@ascii,1).ln isnum 3-65538, $chr(187) Close Window (X)) : ascii.do X
}

; -----------------------------
; Fin de fichier
; -----------------------------
