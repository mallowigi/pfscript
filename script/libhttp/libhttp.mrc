/****************************************************************************************
* <b>LibHTTP</b>, small yet powerful library to simplify the use of HTTP in scripts.
* <p>
* Takes care of proxies, authentication, URL parsing, making the actual request, parsing
* headers, and following redirects (HTTP-redirects only). After this "boring" work is
* complete, LibHTTP transfers control back to the calling script, giving you full freedom
* to do whatever your need to do with the data. All headers will have been consumed at
* this point - the data you get from the socket with sockread is the document, without
* headers. LibHTTP accomplishes this by opening the socket with a different [temporary]
* name, and renaming it back to what you specified after it has finished its task.
* <p>
* Right click status window and select "Config HTTP Proxy" to do just that. The dialog
* should be clear enough for end users to understand but if you already have a config
* dialog in your script you may want to move the options there instead. Proxy support is
* automatic and transparent: making and handling the requests works exactly the same way
* whether or not a proxy is used - your script doesn't need to do anything special for
* proxies to work.
* <p>
* <code>/http_get SOCKETNAME %URL<br>
* on *:sockread:SOCKETNAME {<br>
* &nbsp;&nbsp;&nbsp;&nbsp;[read data and do things with it]<br>
* }</code>
* <p>
* <hr width="250" align="left">
* Errors are communicated with signal (replace "SocketName" in the signal name):<br>
* <code>on *:signal:HttpErr_SocketName: /echo -s HTTP connection error: $1-</code><br>
* <p>
* This signal is triggered if 
* <ul>
* <li>LibHTTP is unable to connect to the server 
* <li>the connection is lost while reading headers
* <li>server response code != 200 (200 means all went ok)
* <li>redirection limit is exceeded (limit is 5 redirections)
* </ul>
* The socket is automatically closed if any of these errors occur, meaning your
* custom sockread and sockclose event handlers are never executed. The reverse of this
* also guaranteed - if your sockread handler is executed you can 100% sure everything
* went ok. You don't <i>have to</i> catch and handle the error signal, but in most 
* cases you <i>should</i> do it, at least to echo the message to status window.
* Without any kind of error message users will have no idea what is going wrong and
* how to fix it.
* <p>
* Of course you still need to test for $sockerr in the sockread and sockclose events,
* just like you have to with any other socket. LibHTTP detects errors only while
* connecting and reading headers - after this all control, including responsibilty
* to detect and handle errors, is yours.
* <hr width="250" align="left">
* <p>
* <b>Note:</b> You can not use <code>/sockmark</code> with connections opened
* by LibHTTP, the library uses the mark for storing various data.
* <p>
* <code>/set %libhttp.debug 1</code> - enables some debugging messages. Unset to disable.
*
*/




/****************************************************************************************
* Test whether Sockname is already in use. The normal test '<code>if ($sock(SOCKNAME) !=
* $null)</code>' is not enough because <code>/http_get</code> opens the sockets using
* temporary names (these are later renamed to the final form). $sockfree will also check
* the temporary names to see if there is a socket that will soon be renamed to Sockname.
* @param sockname The socket name to test
* @return boolean $true if Socketname is free, $false if not
*/
alias sockfree {
  var %sockname = $1
  if ($sock(%sockname)) return $false
  var %i = 1 
  var %tempsock = $sock(LIBHTTP_TEMP_*,%i)
  while (%tempsock != $null) { 
    if ($hget(%tempsock,_Final-Sockname) == %sockname) return $false
    inc %i
    var %tempsock = $sock(LIBHTTP_TEMP_*,%i)
  }
  return $true
}



/****************************************************************************************
* Request one file from remote server.
* @param Sockname Name for this connections 
* @param URL Location of the file
* @return void
*/
alias http_get {
  var %sockname = $1, %url = $2
  if (!$sockfree(%sockname)) {
    echo -sat HTTP socket error: socket name %sockname already in use
    halt
  }
  lhttp_sockopen %sockname 0 $lhttp_parse_url(%url)
}



/****************************************************************************************
* Retrieve special information about Sockname. Uses same syntax as mIRC's 
* <code>$sock(...).property</code>, meaning you can specify wildcard Sockname and select
* Nth match by passing a second param. This alias works only with sockets opened by
* <code>/http_get</code>, and even then only after the connection has been handed over
* to the calling script (IOW, when your on:sockread has run at least once). 
* @param sockname Socket name or wildcard
* @optparam n Select Nth wildcard match
* @prop rcvd Number of bytes received, not counting HTTP-headers
* @prop redirects Number of redirects followed (usually 0)
* @prop percent Percent done, available only if .size is known
* @prop size Size of the file (value of the Content-Lenght header). Server does not know
* in advance the size for dynamic content so this works only with static files.
* @return int Numeric value, $null if the value isn't known (size/percent)
*/
alias httpsock {
  var %sockname = $1, %n = $2
  if (%n == $null) %n = 1
  if ($sock(%sockname,%n) == $null) return
  if ($prop == rcvd)      return $calc($sock(%sockname,%n).rcvd - $gettok($sock(%sockname,%n).mark,1,32))
  if ($prop == size)      return $gettok($sock(%sockname,%n).mark,3,32)
  if ($prop == redirects) return $gettok($sock(%sockname,%n).mark,2,32)
  if ($prop == percent) {
    if ($gettok($sock(%sockname,%n).mark,3,32) == $null) return $null
    return $int($calc(($sock(%sockname,%n).rcvd - $gettok($sock(%sockname,%n).mark,1,32)) / $gettok($sock(%sockname,%n).mark,3,32) * 100))
  }
}





;;;;;;;;;;;; Public API ends here. Rest is the internal workings of LibHTTP ;;;;;;;;;;;;






/****************************************************************************************
* Parses URL and returns a space separated list of URL-components, suitable for input
* to <code>/http_get</code>. 
* @param URL The url to parse
* @return String Host Port Path [User] [Pass]
*/
alias -l lhttp_parse_url {
  var %url = $1
  var %port = 80
  var %host = $gettok($remove(%url,http://),1,47)
  var %path = / $+ $gettok($remove(%url,http://),2-,47)
  if ($regex(%host,/^(.+):(.+)@(.+)$/)) {
    var %user = $regml(1), %pass = $regml(2), %host = $regml(3)
  }
  if ($regex(%host,/^(.+):(\d+)$/)) {
    var %host = $regml(1), %port = $regml(2)
  }
  return %host %port %path %user %pass
}



/****************************************************************************************
* This is what actually opens the connection. http_get is really just a wrapper, this
* where the magic happens. The point of having a wrapper is to be able to change this
* API without breaking existing programs. Programs use the public, very simple API of
* the wrapper that never changes, internally we have this more complex and freely 
* changable thing. 
* <p>
* The socket is opened with a temporary name, LIBTTP_TEMP_[number]. A hash table of the
* same name is also created, it is used for storing both request and response headers
* plus other misc data LibHTTP uses. The hashtable is automatically hfreed if an error
* occurs, or when control is handed over to user (socket is renamed).
*
* @param finalname The final name for this connections
* @param redirects Number of redirects followed so far
* @param host Hostname or IP-address of the server
* @param port Port to connect to (usually 80)
* @param path Path of the requested resource
* @optparam user Username (if the server requires one)
* @optparam pass Password (if the server requires one)
* @return void
*/
alias -l lhttp_sockopen {
  var %finalname = $1, %redirects = $2, %host = $3, %port = $4, %path = $5, %user = $6, %pass = $7, %auth = none

  if (%redirects > 5) {
    .signal HttpErr_ $+ %finalname Redirect limit (5) exceeded - likely an infinite redirect loop.
    return
  }

  var %i = 1 
  while ($sock(LIBHTTP_TEMP_ $+ %i) != $null) inc %i
  var %tempname = LIBHTTP_TEMP_ $+ %i
  hmake %tempname

  if ((%libhttp.useproxy) && (%libhttp.proxy.host != $null) && (%libhttp.proxy.port != $null)) {
    if (%libhttp.debug) echo -s *** sockopen %tempname %libhttp.proxy.host %libhttp.proxy.port
    sockopen %tempname %libhttp.proxy.host %libhttp.proxy.port
    hadd %tempname _Request-String GET http:// $+ %host $+ : $+ %port $+ %path HTTP/1.0
    hadd %tempname _Connection-Host %libhttp.proxy.host
    hadd %tempname _Connection-Port %libhttp.proxy.port
    if ((%libhttp.proxy.user != $null) && (%libhttp.proxy.pass != $null)) {
      hadd %tempname Proxy-Authorization: Basic $encode(%libhttp.proxy.user $+ : $+ %libhttp.proxy.pass,m)
    }
    hadd %tempname Proxy-Connection: close
  }
  else {
    if (%libhttp.debug) echo -s *** sockopen %tempname %host %port
    sockopen %tempname %host %port
    hadd %tempname _Request-String GET %path HTTP/1.0
    hadd %tempname _Connection-Host %host
    hadd %tempname _Connection-Port %port
  }

  ; Vars with leading underscore are for internal use of LibHTTP
  hadd %tempname _Redirects-Followed %redirects
  hadd %tempname _Final-Sockname %finalname

  ; Vars without leading underscore are headers
  hadd %tempname Host: %host $+ : $+ %port
  hadd %tempname Pragma: no-cache
  hadd %tempname Cache-Control: no-cache
  hadd %tempname Connection: close
  hadd %tempname User-Agent: Mirc/ $+ $version (Windows $os $+ ) LibHTTP/1.0
  if ((%user != $null) && (%pass != $null)) {
    hadd %tempname Authorization: Basic $encode(%user $+ : $+ %pass,m)
  }
}



/****************************************************************************************
* Writes the HTTP-request to socket. The request string and the headers were constructed
* in lhttp_sockopen, this just loops throught the headers and sends them over the socket.
* <p>
* It is very important that this event be "duplication tolerant", meaning it must still
* work if user has two copies of this script installed (happens if two independently
* distributed scripts bundle LibHTTP). First script to handle this sockopen event sets a
* hash table item "_Request-Sent" to $true - second script detects the presence of that
* flag and returns immediately. "if ($hget($sockname) != $null)" in the sockerr-branch
* of the code provides the same safeguard in error conditions.
*/
on *:sockopen:LIBHTTP_TEMP_*: {
  if ($sockerr > 0) { 
    if ($hget($sockname) != $null) {
      .signal HttpErr_ $+ $hget($sockname,_Final-Sockname) Unable to connect to $hget($sockname,_Connection-Host) $+ , port $hget($sockname,_Connection-Port)
      hfree $sockname
    }
    return
  }

  if ($hget($sockname,_Request-Sent)) return
  hadd $sockname _Request-Sent $true

  if (%libhttp.debug) echo -s --> $hget($sockname,_Request-String)
  sockwrite -n $sockname $hget($sockname,_Request-String)

  var %hindex = $hget($sockname,0).item
  while (%hindex > 0) {
    var %key = $hget($sockname,%hindex).item
    if (_* iswm %key) {
      ; Key is some internal var, not a header
    }
    else {     
      sockwrite -n $sockname %key $hget($sockname,%key)
      if (%libhttp.debug) echo -s --> %key $hget($sockname,%key)
    }
    dec %hindex
  }

  sockwrite $sockname $crlf
  .timer $+ $sockname $+ _TIMEOUT 1 30 lhttp_timeout $sockname
}



/****************************************************************************************
* Read and save headers. Once headers have been fully consumed, calls http_process_reply
* which determines what to do next.
* <p>
* Duplication tolerance is needed here also: Ordinarily getting $null from sockread
* indicates end of headers - with two scripts installed that may not always be correct.
* Since the sockread event now triggers twice whenever there is a CRLF terminated line
* in the buffer, it is possible that the first script consumes a normal headerline, 
* leaving the buffer completely empty. When the second script triggers, sockread
* tries to read from empty buffer and returns $null. Thus it is crucial to test $sockbr
* to verify that we indeed got an "empty" line, instead of just hitting empty buffer.
*/
on *:sockread:LIBHTTP_TEMP_*: {
  if ($sockerr > 0) { 
    if ($hget($sockname) != $null) {
      .signal HttpErr_ $+ $hget($sockname,_Final-Sockname) Connection lost while reading headers (sockerr $sockerr $+ )
      .timer $+ $sockname $+ _TIMEOUT off
      hfree $sockname
    }
    return
  }

  var %sockinput
  sockread %sockinput
  if (%libhttp.debug) echo -s <-- %sockinput [ $+ $sockbr bytes]

  if (%sockinput != $null) {
    var %header = $gettok(%sockinput,1,32), %value = $gettok(%sockinput,2-,32)
    if (HTTP/1.? iswm %header) {
      hadd $sockname _Response-Code $gettok(%value,1,32)
    }
    else {
      hadd $sockname _Response-Header_ $+ %header %value
    }
    .timer $+ $sockname $+ _TIMEOUT 1 30 lhttp_timeout $sockname
  }
  elseif ($sockbr > 0) {
    lhttp_process_reply $sockname
  }
}



/****************************************************************************************
* Headers have been read, determine the next step. If server replied with code 200,
* rename the socket and hand over control. If the server replied with code 301 or 302 AND
* sent a Location: header, follow the redirect and close current connection. If the server
* replied with any other code, signal an error. @return void
*/
alias -l lhttp_process_reply {
  var %sockname = $1
  var %respcode = $hget(%sockname,_Response-Code)
  var %location = $hget(%sockname,_Response-Header_Location:)
  var %filesize = $hget(%sockname,_Response-Header_Content-Length:)
  var %finalname = $hget(%sockname,_Final-Sockname)
  var %redirects = $hget(%sockname,_Redirects-Followed)

  if (%respcode == 200) {
    sockmark %sockname $sock(%sockname).rcvd %redirects %filesize
    if (%libhttp.debug) echo -s *** sockrename %sockname %finalname
    sockrename %sockname %finalname
  }
  elseif ((%respcode isnum 301-302) && (%location != $null)) {
    lhttp_sockopen %finalname $calc(%redirects + 1) $lhttp_parse_url(%location)
    if (%libhttp.debug) echo -s *** sockclose %sockname
    sockclose %sockname
  }
  else {
    .signal HttpErr_ $+ %finalname Server returned error %respcode
    if (%libhttp.debug) echo -s *** sockclose %sockname
    sockclose $sockname
  }
  hfree %sockname
  .timer $+ %sockname $+ _TIMEOUT off
}




/****************************************************************************************
* 30 second timeout for the temp-socket. If server doesn't respond within 30 seconds of
* sending the request, or if the connection goes idle for more than 30 sec while reading
* headers, close the socket and signal an error. @return void
*/
alias -l lhttp_timeout {
  var %sockname = $1
  if ($hget(%sockname) != $null) {
    .signal HttpErr_ $+ $hget(%sockname,_Final-Sockname) Connection timeout of 30 seconds reached while awaiting server responce
    sockclose %sockname
    hfree %sockname
  }
}




/****************************************************************************************
* Connection closed while we were still reading headers
*/
on *:sockclose:LIBHTTP_TEMP_*: {
  if ($hget($sockname) != $null) {
    .signal HttpErr_ $+ $hget($sockname,_Final-Sockname) Connection lost while reading headers (sockerr: $sockerr $+ )
    hfree $sockname
  }
}




/****************************************************************************************
* Fancy dialog for proxy configuration
*/
menu status {
  Config HTTP Proxy: dialog -md ProxyConfig ProxyConfig_Table
}

dialog ProxyConfig_Table {
  size -1 -1 250 150
  title "HTTP Proxy Configuration"
  check "Use Proxy for HTTP connections", 1, 5 5 180 14
  box "Server and Port" 10, 6 22 240 75
  edit "" 11, 12 38 165 24, autohs disabled
  text ":" 12, 179 41 3 14
  edit "" 13, 183 38 55 24, autohs disabled
  text "Status:" 14, 20 69 40 14
  text "" 15, 60 69 170 14
  box "Login and Password (optional)" 20, 6 89 240 55
  edit "" 21, 12 110 110 24, autohs disabled
  edit "" 22, 128 110 110 24, autohs pass disabled
}

/****************************************************************************************
* Proxy configuration dialog init
*/
on *:dialog:ProxyConfig:init:0: {
  did -ra $dname 11 %libhttp.proxy.host
  did -ra $dname 13 %libhttp.proxy.port
  did -ra $dname 21 %libhttp.proxy.user
  did -ra $dname 22 %libhttp.proxy.pass
  if (%libhttp.useproxy) { did -c $dname 1 | did -e $dname 11,13,21,22 }
  lhttp_proxytest
}


/****************************************************************************************
* User toggled the "Use Proxy" checkbox
*/
on *:dialog:ProxyConfig:sclick:1: {
  if ($did($dname,$did).state == 1) { %libhttp.useproxy = $true | did -e $dname 11,13,21,22 }
  if ($did($dname,$did).state == 0) { %libhttp.useproxy = $false | did -b $dname 11,13,21,22 }
  lhttp_proxytest
}


/****************************************************************************************
* User edited one of the four text inputs
*/
on *:dialog:ProxyConfig:edit:*: {
  %libhttp.proxy.host = $did($dname,11)
  %libhttp.proxy.port = $did($dname,13)
  %libhttp.proxy.user = $did($dname,21)
  %libhttp.proxy.pass = $did($dname,22)
  if ($did < 20) .timerTEST_PROXY 1 1 lhttp_proxytest
}


/****************************************************************************************
* Test proxy address by attempting to connect to it @param void @return void
*/
alias -l lhttp_proxytest {
  if ($dialog(ProxyConfig) == $null) return
  if ($sock(LIBHTTP_PROXYTEST) != $null) sockclose LIBHTTP_PROXYTEST
  if ((%libhttp.proxy.host != $null) && (%libhttp.proxy.port != $null) && (%libhttp.useproxy)) {
    sockopen LIBHTTP_PROXYTEST %libhttp.proxy.host %libhttp.proxy.port
    did -ra ProxyConfig 15 Testing....
  }
  else did -r ProxyConfig 15 
}


/****************************************************************************************
* Show result of the proxy test
*/
on *:sockopen:LIBHTTP_PROXYTEST: {
  if ($dialog(ProxyConfig) != $null) did -ra ProxyConfig 15 $iif($sockerr, Unable to connect, OK)
  sockclose $sockname
}


/****************************************************************************************
* Unset global variables used by libhttp
*/
on *:UNLOAD: {
  unset %libhttp.*
}
