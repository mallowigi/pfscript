; --------------------------
; A propos du PFScript
; --------------------------

;Open the about window
alias pfabout { opendialog -m about }

; About dialog
dialog about {
  title A Propos du PF Script version $pfversion [/pfabout]
  size -1 -1 308 656
  option pixels
  icon images/masterIRC2.ico
  box "", 1, 4 4 300 604
  box "", 2, -10 604 330 50
  button "&Ok", 3, 224 618 80 24, ok
  link "http://www.pokemon-france.com/script", 4, 6 624 220 16
}


on *:dialog:about:*:*:{
  if ($devent == init) {
    mdxload
    mdx SetControlMDX $dname 1 Window > $mdxfile(dialog)
    showaboutwindow
    did -a $dname 1 grab $window(@habout).hwnd @habout
  }
  elseif ($devent == sclick) {
    if ($did == 4) { url -an $did($did) }
  }
  elseif ($devent == close) {
    unset %dfprog
    close -@ @habout
  }
}

; Ecrit un texte centré a la fenetre
; Thanks for the NNScript coders
; $1: options, $2: taille du texte, $3: position y ,$4- : texte
alias -l about.center {
  var %p = $int($calc(150- $width($4-,"Segoe UI",$2,$iif(o isin $1,1,0)) /2))
  if (o isin $1) { drawtext $1 @habout 11184810 "Segoe UI" $2 $calc(%p +1) $calc($3 +1) $4- }
  if (~ isin $4-) {
    var %n = $gettok($4-,1,126),%j = $gettok($4-,2,126)
    drawtext $1 @habout 4605510 "Segoe UI" $2 $calc(125- $width(%n,"Segoe UI",$2)) $3 %n
    drawtext $1 @habout 460691 "Segoe UI" $2 145 $3 %j
  }
  else { drawtext $1 @habout 4605510 "Segoe UI" $2 %p $3- }
}

; Affiche la fenetre about
alias -l showaboutwindow {
  window -hpf @habout -1 -1 400 600
  ;drawrect -nrf @habout 14935011 1 0 0 300 900
  if ($isfile(images/about.png)) { drawpic -c @habout 1 1 images/about.png }

  var %t = 1,%r,%p = 100,%b
  if ($isfile(images/masterirc2.ico)) { drawpic -ntrg @habout 16711935 134 10 images/masterIRC2.ico }
  about.center -nro 20 45 PFScript
  about.center -nr 12 70 by Klarth
  about.center -nr 12 85 version %version
  while ($gettok(-|!Equipe du script|Klarth~Développeur du script v4.0|Zhu'~Développeur de la v3.0|Djidane~Développeur de la v2.0|Dagnan~Développeur de la v1.0|Might~Webmaster de Pokémon-France|-|!Autres contributeurs|Khaled Mardam-Bey~http://www.mirc.com|Epiknet.org~http://www.epiknet.org|PearlSaurus~pearlsaurus.fc2web.com|NNScript~http://www.nnscript.com|DragonZap~MDX.DLL|ClickHeRe $+ $chr(44) twig* & Ook~DCX.dll|Serebii Pokemon Portal~http://www.serebii.net|DesMuME|GameFreak & Nintendo|mircscripts.org| |... Et vous : $+ $chr(41),%t,124)) {
    %r = $v1
    if (!* iswm %r) {
      inc %p 9
      about.center -nro 12 %p $mid(%r,2)
      inc %p 18
    }
    elseif (%r == -) {
      inc %p 8
      drawline -nr @habout 4605510 1 20 %p 280 %p
      inc %p
      drawline -nr @habout 11184810 1 21 %p 281 %p
    }
    else {
      about.center -nr 11 %p %r
      inc %p 14
    }
    inc %t
  }
  drawdot @habout
}

; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
