;=====================================================
; Project : mScriptBox
; Script  : $regini - INI File Management
;           using Regular Expressions
;=====================================================
; Author  : SSJ4_Son_Goku
; FileName: regini.mrc
;=====================================================
alias regini {
  VAR %echo = echo $color(info) -a * $!regini $+ :
  ; Error checking stuff. Check's if there are 
  ; at least 3 and no more than 7 parameters.
  IF($3 == $null) { 
    %echo Not enough parameters.
    HALT
  }
  IF ($7 != $null) { 
    %echo Too many parameters.
    HALT
  }
  ; Checks if $3 and $5 are numbers.
  IF ($3 !isnum 0-) { 
    %echo $ifmatch is not a number.
    HALT
  }
  IF (($5 != $null) && ($5 !isnum 0-)) { 
    %echo $ifmatch is not a number.
    HALT
  }
  ; Checks if $1 is a file
  IF (!$isfile($+(",$shortfn($1),"))) { 
    %echo $1 is not a file
    HALT 
  }
  ELSE { var %f = $+(",$shortfn($1),") }
  ; Set vars..
  VAR %i = 1,%d,%e,%b = $iif($3 != 0,$3,-1)

  WHILE ($ini(%f,%i)) {
    ; If the section matches the regex in $2 ...
    IF ($regex($ifmatch,$2)) { 
      ; If %b is -1 inc %d , else decrease %b ...
      IF (%b == -1) { INC %d }
      ELSE { DEC %b }
      ; ... until it reaches 0, then break out of the loop 
      ; because we now found Nth match
      IF (%b == 0) { BREAK }
    }
    INC %i
  }
  ; If $4 is $null the format was $regini(file.ini,regexs,num) 
  ; so we return accordingly...
  IF ($4 == $null) {
    IF (%d) { RETURN %d }
    IF (%i > $ini(%f,0)) { RETURN }
    IF ($prop == section) { RETURN $ini(%f,%i) }
    ELSE { RETURN %i }
  }
  ; The next few steps are basically the same as the while loop. 
  ; This loop checks for regex item.
  VAR %c = $iif($5 != 0,$5,-1)
  IF ($4 != $null) {
    VAR %z = 1
    WHILE ($ini(%f,%i,%z)) {
      IF ($regex($ifmatch,$4)) {
        IF (%c == -1) { INC %e }
        ELSE { DEC %c }
        IF (%c == 0) { BREAK }
      }
      INC %z
    }
  }
  ; If the last parameter is not a number, then 
  ; the last parameter should be the regex for value.
  ; If the regex matches the actual value, 
  ; return $true , else it will return $false
  IF ($ [ $+ [ $0 ] ] !isnum) {
    ; If regex matches value return $true , else return $false
    IF ($regex($readini(%f,$ini(%f,%i),$ini(%f,%i,%z)),$ifmatch)) {
      RETURN $true
    }
    ELSE { RETURN $false }
  }
  ; If the last parameters is a number, 
  ; then there was no regex value specified and 
  ; it should return values accordingly.
  IF ($ [ $+ [ $0 ] ] isnum 0-) {
    IF (%e) { RETURN %e }
    IF ((%z > $ini(%f,%i,0)) || ($5 > $ini(%f,%i,0))) { RETURN }
    IF ($prop == section) { rRETURN $ini(%f,%i)  }
    IF ($prop == item) { RETURN $ini(%f,%i,%z) }
    IF ($prop == value) { 
      RETURN $readini(%f,$ini(%f,%i),$ini(%f,%i,%z)) 
    }
    ELSE { RETURN %z }
  }
}

;--------------------------------
; Fin de fichier
;--------------------------------