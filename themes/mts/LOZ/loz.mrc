alias loz.load {
  %:echo 2Legend Of Zelda IRCSCRIPT .. Version C .. http://ZeldaIRC.free.fr/
  %:echo 1Site officiel : http://ZeldaIRC.free.fr/
  %:echo -----------------------------------------------------------------------------
  %:echo 1Réalisé par Blaster. Remerciements à Tenchi, Arkh & QuoteManager.
  %:echo 1Activez/Désactivez les smiley colorés en tapant /loz.smiley
  if (%loz.smileycolor == $null) set %loz.smileycolor 1
}

alias loz.unload {
  unset %loz.smileycolor
}

alias loz.smiley {
  if (%loz.smileycolor == 1) { %loz.smileycolor = 0 }
  else { %loz.smileycolor = 1 }
}

alias loz.colorcmode {
  if ($1 == @) { return 6 $+ @ }
  elseif ($1 == $chr(37)) { return 3 $+ $chr(37) $+  }
  elseif ($1 == +) { return 10 $+ + }
}

alias loz.smileycolor {
  var %eff = $1-
  if (%loz.smileycolor == 1) {
    %eff = $replacecs(%eff, =p, 6=12p)
    %eff = $replacecs(%eff, =P, 6=12P)
    %eff = $replacecs(%eff, o_O, 12o6_12O)
    %eff = $replacecs(%eff, o-O, 12o6-12O)
    %eff = $replacecs(%eff, o.O, 12o6.12O)
    %eff = $replacecs(%eff, O_o, 12O6_12o)
    %eff = $replacecs(%eff, O-o, 12O6-12o)
    %eff = $replacecs(%eff, O.o, 12O6.12o)
    %eff = $replacecs(%eff, O_O, 12O6_12O)
    %eff = $replacecs(%eff, O-O, 12O6-12O)
    %eff = $replacecs(%eff, O.O, 12O6.12O)
    %eff = $replacecs(%eff, T_T, 10T12_10T)
    %eff = $replace(%eff, lol, 6L5o6L)
    %eff = $replace(%eff, mdr, 5M12d7R)
    %eff = $replace(%eff, ptdr, 10P3t9D8r)
    %eff = $replace(%eff, expldr, 4E7x8P11l12D2r)
    %eff = $replace(%eff, : $+ $chr(34) $+ $chr(62), 6 $+ : $+ 13 $+ $chr(34) $+ 12 $+ $chr(62) $+ )
    %eff = $replace(%eff, ^^, 10^6-10^)
    %eff = $replace(%eff, ^-^, 10^6-10^)
    %eff = $replace(%eff, ^_^, 10^6-10^)
    %eff = $replacecs(%eff, x_x, 4x7_4x)
    %eff = $replacecs(%eff, x-x, 4x7-4x)
    %eff = $replacecs(%eff, x.x, 4x7.4x)
    %eff = $replacecs(%eff, X_X, 4X7_4X)
    %eff = $replacecs(%eff, X-X, 4X7-4X)
    %eff = $replacecs(%eff, X.X, 4X7.4X)
    %eff = $replacecs(%eff, x_X, 4x7_4X)
    %eff = $replacecs(%eff, x-X, 4x7-4X)
    %eff = $replacecs(%eff, x.X, 4x7.4X)
    %eff = $replacecs(%eff, X_x, 4X7_4x)
    %eff = $replacecs(%eff, X-x, 4X7-4x)
    %eff = $replacecs(%eff, X.x, 4X7.4x)
    %eff = $replacecs(%eff, ><, 12>5_12<)
    %eff = $replacecs(%eff, >-<, 12>5_12<)
    %eff = $replacecs(%eff, >_<, 12>5_12<)
    %eff = $replace(%eff, : $+ $chr(93), 6 $+ : $+ 12 $+ $chr(93) $+ )
    %eff = $replace(%eff, = $+ $chr(41), 3 $+ = $+ 10 $+ $chr(41) $+ )
    %eff = $replacecs(%eff, : $+ D, 6 $+ : $+ 12 $+ D $+ )
    %eff = $replacecs(%eff, : $+ p, 12 $+ : $+ 3 $+ p $+ )
    %eff = $replacecs(%eff, : $+ P, 12 $+ : $+ 3 $+ P $+ )
    %eff = $replace(%eff, %url, 12 $+ %url $+ )
    %eff = $replace(%eff, : $+ $chr(41),3 $+ : $+ 10 $+ $chr(41) $+ )
    %eff = $replace(%eff, : $+ $chr(124), 12 $+ : $+ 4 $+ $chr(124))
    %eff = $replace(%eff, : $+ \, 12 $+ : $+ 4\)
    %eff = $replace(%eff, = $+ $chr(40), 10=12 $+ $chr(40) $+ )
    %eff = $replace(%eff, ¬¬, 14¬1_14¬)
    %eff = $replace(%eff, X $+ $chr(40), 12X11 $+ $chr(40) $+ )
    %eff = $replace(%eff, : $+ $chr(40), 10 $+ : $+ 12 $+ $chr(40) $+ )
    %eff = $replace(%eff, > $+ $chr(40), 4>7 $+ $chr(40) $+ )
    %eff = $replace(%eff, > $+ $chr(40), 4>7 $+ $chr(41) $+ )
    %eff = $replace(%eff, X $+ $chr(40), 4>7 $+ $chr(41) $+ )
    %eff = $replace(%eff, XD, 5X4D)
    %eff = $replace(%eff, =D, 13=4D)
    %eff = $replacecs(%eff, B $+ $chr(41), 12B2 $+ $chr(41) $+ )
    %eff = $replace(%eff, ; $+ $chr(41), 3;10 $+ $chr(41) $+ )
    %eff = $replace(%eff, : $+ $chr(41), 3 $+ : $+ 10 $+ $chr(41) $+ )
    %eff = $replace(%eff, : $+ ' $+ $chr(40), 6 $+ : $+ 12'4 $+ $chr(40) $+  )
    %eff = $replace(%eff, -.-,  ¯·¯)

  }
  return %eff
}

alias loz.mode {
  if (%::nick == $me) { var %moder = Vous }
  else { var %moder = %::nick }

  var %modes $gettok(%::modes,1,32)
  var %nicks $gettok(%::modes,2-,32)

  var %modesonly $right(%modes,-1)
  var %give $iif(%modesonly isin ahoqvb,$iif(%moder == Vous,appliquez,applique),$iif(%moder == Vous,changez,change))

  if ($len(%modesonly) > 1) { var %action les modes de %nicks en %modes ! }
  elseif ($len(%modesonly) == 1) {
    var %action le mode
    var %target $iif(%modesonly isin aoqhvb,%modes sur %nicks !,de %::chan en %modes !)
  }
  %:echo  $+ %::c2 $+ ¤  $+ %moder %give %action %target
}

alias loz.usermode {
  if (%::nick == $me) { var %moder Vous }
  else { var %moder %::nick }

  var %modes $gettok(%::modes,1,32)
  var %nicks $gettok(%::modes,2-,32)

  var %modesonly $right(%modes,-1)

  if ($len(%modesonly) > 1) { var %action les modes %modes ! }
  elseif ($len(%modesonly) == 1) {
    var %give $iif(%moder == Vous,vous appliquez,vous applique)
    var %action le mode %modes !
  }
  %:echo  $+ %::c2 $+ ¤  $+ %moder %give %action
}

alias loz.whoisstart {
  %:echo 3__________________________________________________ 
  %:echo 0 6~ Host : %::nick %::address 
  %:echo 0 6~ Nom : %::realname
}

alias loz.whoisstop {
  %:echo 0 6~ Fin de l'Analyse 
  %:echo 3¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
}
