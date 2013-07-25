/****************************************************************************************
* <b>LibHTTP Examples</b>
* <p>
* Series of simple real-world tests/examples to demonstrate the use of LibHTTP.
* <p>
* <code><b>/load -rs libhttp_examples.mrc</b></code> and run <code><b>/http_test_1</b></code> through <code><b>/http_test_8</b></code>
* <p>
* All tests echo their output to status window.
*/







/****************************************************************************************
* Example 1: Get RSS feed from slashdot and echo the headlines to status window.
* The regex just extracts the string between &lt;title&gt;...&lt;/title&gt;.
* @param void @return void
*/
alias http_test_1 {
  echo -s ----------
  echo -s ex1: Get RSS feed from Slashdot (http://slashdot.org/index.rss)
  http_get SLASHDOT http://slashdot.org/index.rss
}

on *:sockread:SLASHDOT {
  if ($sockerr) return
  var %sockinput
  sockread %sockinput
  if ($regex(%sockinput,/<title>(.+?)<\/title>/))  echo -s Slashdot headline: $regml(1)
}




/****************************************************************************************
* Example 2: Check www.mirc.com for latest mirc release. This could of course break at
* any time if the site maintainers decide to change the layout. No need to complain if
* that happens, it is just an example...
* @param void @return void
*/
alias http_test_2 {
  echo -s ----------
  echo -s ex2: Check http://www.mirc.com/news.html for latest release info
  http_get MIRCVER http://www.mirc.com/news.html
}

on *:sockread:MIRCVER {
  if ($sockerr) return
  var %sockinput
  sockread %sockinput
  if ($regex(%sockinput,/<b>mIRC (\d+(\.\d+)?).*released/i)) {
    echo -s Latest mirc version is: $regml(1) - You are running: $version
    sockclose $sockname
  }
}




/****************************************************************************************
* Example 3: Downloads latest servers.ini. The file is saved in your mircdir as
* servers.ini.demo.txt (so it won't overwrite your real servers.ini). This is a static
* file so the server knows and tells us the filesize, meaning it's possible to have a 
* progress indicator using $httpsock. For dynamic content the filesize is usually not 
* known in advance, so no way to have percentage indicator. @param void @return void
*/
alias http_test_3 {
  echo -s ----------
  echo -s ex3: Download latest servers.ini (http://www.mirc.co.uk/servers.ini)
  .remove servers.ini.demo.txt
  http_get SERVERSINI www.mirc.co.uk:80/servers.ini
}

on *:sockread:SERVERSINI {
  if ($sockerr) { echo -s download failed | return }
  sockread &sockinput
  bwrite servers.ini.demo.txt -1 &sockinput
  echo -s Downloading new servers.ini, $httpsock($sockname).percent $+ % of $bytes($httpsock($sockname).size).suf
}

on *:sockclose:SERVERSINI {
  if ($sockerr) { echo -s download failed | return }
  echo -s Download of servers.ini complete
}




/****************************************************************************************
* Example 4: Test 3 with a twist - redirection. Instead of going directly to mirc.co.uk,
* do "I'm feeling lucky" search on google. The search redirects to the correct
* address, and LibHTTP automatically follows it. @param void @return void
*/
alias http_test_4 {
  echo -s ----------
  echo -s ex4: I'm feeling lucky search on google for "mirc servers.ini" 
  .remove servers.ini.demo.txt
  http_get SERVERSINI2 http://www.google.com/search?hl=en&ie=UTF-8&btnI&q=mirc%20servers.ini
}

on *:sockread:SERVERSINI2 {
  if ($sockerr) { echo -s download failed | return }
  sockread &sockinput
  bwrite servers.ini.demo.txt -1 &sockinput
  echo -s Downloading new servers.ini, $bytes($httpsock($sockname).rcvd).suf of $bytes($httpsock($sockname).size).suf
}

on *:sockclose:SERVERSINI2 {
  if ($sockerr) { echo -s download failed | return }
  echo -s Download of servers.ini complete
}




/****************************************************************************************
* Example 5: Retrieve password protected file. The file is there "for now", some day I'll
* remove it and this test will stop working. Also shows how to guard against making
* duplicate requests by using $sockfree(...). @param void @return void
*/
alias http_test_5 {
  echo -s ----------
  echo -s ex5: Retrieve password protected file (http://test:test@koti.mbnet.fi/kinnunen/passworded/foo.txt)
  if (!$sockfree(SECRET)) {
    echo -s Can't re-request file yet, socket is in use
  }   
  else {
    http_get SECRET http://test:test@koti.mbnet.fi/kinnunen/passworded/foo.txt
  }
}

on *:sockread:SECRET: {
  if ($sockerr) return
  var %sockinput
  sockread %sockinput
  echo -s %sockinput 
}




/****************************************************************************************
* Example 6: Error handling, attempt to download a non-existing file. Server returns the
* <a href="http://offline.home.cern.ch/offline/web/http_error_codes.html">404 error</a>.
* @param void @return void
*/ 
alias http_test_6 {
  echo -s ----------
  echo -s ex6: attempt to download non-existing file (http://www.mirc.co.uk/servers04_.ini)
  http_get BADFILE http://www.mirc.co.uk/servers_.ini
}

; 404 is the code for "File Not Found"
on *:signal:HttpErr_BADFILE: {
  echo -s Error: $1-
}

; This never runs
on *:sockread:BADFILE {
  echo -s Sockread BADFILE
}




/****************************************************************************************
* Example 7: Error handling, attempt connecting to invalid host. The error manifests
* in a slightly different way if user has set to use a proxy. Connection to the
* proxy is possible, but obviously the proxy can't fullfill the request so it returns
* an error (usually code 500). @param void @return void
*/
alias http_test_7 {
  echo -s ----------
  echo -s ex7: attempt connecting to invalid host (http://www.04imrc.oc.uk/servers.ini)
  http_get BADHOST www.imrc.oc.uk/servers.ini
}

; The error message is different if you use a proxy
on *:signal:HttpErr_BADHOST: {
  echo -s Error: $1-
}

; Again, this part never runs
on *:sockread:BADHOST {
  echo -s Sockread BADHOST
}




/****************************************************************************************
* Example 8: Simple URL parsing test. The $parse_url alias used for this is an exact copy
* of LibHTTP's URL parser, <code>lhttp_parse_url</code>. lhttp_parse_url is a local alias
* of LibHTTP, which is why this test cannot use it directly. @param void @return void
*/
alias http_test_8 {
  echo -s ----------
  echo -s ex8: URL parsing test
  echo -s $parse_url(http://mircscripts.org)
  echo -s $parse_url(http://mircscripts.org:81/)
  echo -s $parse_url(mircscripts.org:80/)
  echo -s $parse_url(http://admin:nimda@mircscripts.org)
  echo -s $parse_url(admin:nimda@mircscripts.org:81/path/to/document.ext)
  echo -s $parse_url(http://mircscripts.org/somepage.php?foo=bar&bar=foo)
}


/****************************************************************************************
* Needed for test_8.
* @return String Host Port Path [Username] [Password]
*/
alias parse_url {
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


/**
* Remove server_ini_demo_txt created in tests 2 & 3
*/
on *:UNLOAD: {
  .remove servers.ini.demo.txt
}
