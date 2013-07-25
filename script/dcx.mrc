;-------------------------------------------------
; Functions for the dcx.dll usages
; Given by http://dcx.scriptsdb.org/index.htm
; DO NOT UNLOAD!!!
; ------------------------------------------------

 dcx {
  if ($isid) returnex $dll($scriptdir $+ /dlls/dcx.dll,$1,$2-)
  else dll " $+ $scriptdir $+ /dlls/dcx.dll" $1 $2-
}

 udcx {
  if ($dcx(IsUnloadSafe)) $iif($menu, .timer 1 0) dll -u dcx.dll
  else echo 4 -qmlbfti2 [DCX] Unable to Unload Dll.
}

 xdid {
  if ( $isid ) returnex $dcx( _xdid, $1 $2 $prop $3- )
  dcx xdid $2 $3 $1 $4-
}

 xdialog {
  if ( $isid ) returnex $dcx( _xdialog, $1 $prop $2- )
  dcx xdialog $2 $1 $3-
}

 xpop {
  if ( $isid ) returnex $dcx( _xpop, $1 $prop $2- )
  dcx xpop $2 $1 $3-
}

 xpopup {
  if ( $isid ) returnex $dcx( _xpopup, $1 $prop $2- )
  dcx xpopup $2 $1 $3-
}

 xmenubar {
  if ($isid) returnex $dcx(_xmenubar, $prop $1-)
  dcx xmenubar $1-
}

 mpopup {
  dcx mpopup $1 $2
}

 xdock {
  if ($isid) returnex $dcx( _xdock, $1 $prop $2- )
  dcx xdock $1-
}

 xtray {
  if ($isid) returnex $dcx(TrayIcon, $1 $prop $2-)
  dcx TrayIcon $1-
}

 xstatusbar {
  !if ($isid) returnex $dcx( _xstatusbar, mIRC $prop $1- )
  dcx xstatusbar $1-
}

 xtreebar {
  !if ($isid) returnex $dcx( _xtreebar, mIRC $prop $1- )
  dcx xtreebar $1-
}

 dcxml {
  !if ($isid) returnex $dcx( _dcxml, $prop $1- )
  dcx dcxml $1-
}

;xdidtok dialog ID N C Item Text[[C]Item Text[C]Item Text]...
;xdidtok $dname 1 0 44 SomeText1,SomeText2
; xdidtok is only meant for list control!
xdidtok {
  if ($0 < 5) { echo 4 -smlbfti2 [ERROR] /xdidtok Invalid args | halt }
  xdid -A $1 $2 $3 +T $4 $5-
}
 tab {
  var %i = 1, %tab
  while (%i <= $0) {
    if ($eval($+($,%i),2) != $null) {
      %tab = $instok(%tab,$eval($+($,%i),2),$calc($numtok(%tab,9) + 1),9)
    }
    inc %i
  }
  return %tab
}

; Add a new item to a treeview (without icon)
; $1: treeview id; $2: path (_ separated), $3: flags; $4-: text,tooltip text (tab separated)
 treeview.additem {
  xdid -a $dname $$1 $replace($$2,_,$chr(32)) $chr(9) $$3 0 0 0 0 0 0 0 $$4-
}

; Add a new divider and sets two panels (if no width/height supplied, divide in equal sizes). Note: the panels created will have id $divider_id + 1 and + 2 respectively.
; $1: divider id; $2: vertical/horizontal; $3 (optional) : left/top panel width/height, $4 (optional): min left width/height, $5 (optional): min right width/height
 divider {
  xdialog -c $dname $$1 divider 0 0 $dialog($dname).w $dialog($dname).h $iif($2 == vertical,$ifmatch)
  if ($3) { xdid -v $dname $$1 $3 }
  xdid -l $dname $$1 $iif($4,$4,10) 0 $chr(9) $calc($$1 + 1) panel 0 0 $dialog($dname).w $dialog($dname).h
  xdid -r $dname $$1 $iif($5,$5,10) 0 $chr(9) $calc($$1 + 2) panel 0 0 $dialog($dname).w $dialog($dname).h
}

; Add a new button with supplied text. If $1 == 0, add it to the dialog, otherwise add it to the container whose id is $1
; $1:container id, $2: button id, $3: text, $4: coords, $5 (optional): options
 button {
  tokenize 44 $1-
  if ($1 == 0) { xdialog -c $dname $$2 button $$4 $5 }
  else { xdid -c $dname $1 $$2 button $$4 $5 }
  xdid -t $dname $$2 $$3 
}