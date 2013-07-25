; ==================================================================================
; Author  : fubar
; Function: $striphtml identifier
          ; This identifier strips html code from a string of text. 
		  ; Good for using when retrieving webpages within mirc.  
; ==================================================================================

; This identifier strips html code from a string of text. Good for using when retrieving webpages within mirc.

; Usage: $striphtml(html code)


alias striphtml {
  ; making sure there are parameters to work with
  IF ($1) {
    ; Setting my variables. The %opt is set kind of funky
    ; all it does is combine <two><brackets> into 1 <twobrackets>, fewer loops this way
    ; also stripped tab spaces
    VAR %strip,%opt = <> $remove($1-,> <,><,$chr(9)) <>,%n = 2
    ; using $gettok() I checked the text in front of '>' (chr 62)
    ; then the second $gettok checks the text behind '<' (chr 60)
    ; so I'm extracting anything between >text<
    WHILE ($gettok($gettok(%opt,%n,62),1,60)) {
      ; take each peice of text and add it to the same variable
      %strip = %strip $ifmatch
      ; increase the variable so the while statement can check the next part
      INC %n
    }
    ; now that the loop has finished we can return the stripped html code
    RETURN %strip
  }
}


;-----------------------
; Fin de fichier
;-----------------------