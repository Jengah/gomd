package html

import "fmt"

//################################################################################
// JS

const JS = `
function themeChange(cb) {
	var rq = new XMLHttpRequest();

	if (cb.checked) {
		rq.open("GET", "/theme/light", true);
	} else {
		rq.open("GET", "/theme/dark", true);
	}
	rq.onreadystatechange = reload;
	rq.send();
}
function codeHlChange(a_theme) {
	var rq = new XMLHttpRequest();
	rq.open("GET", "/theme/" + a_theme.textContent, true);
	rq.onreadystatechange = reload;
	rq.send();
}
function reload() {
	location.reload();
}

`

const HIGHLIGHT_JS = `
<link rel="stylesheet"
      href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/10.1.1/styles/default.min.css">
<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/10.1.1/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>
`

func ReloadJs(bindAddr string) string {
	return fmt.Sprintf(`
<script>
function tryConnectToReload(address) {
  var conn = new WebSocket(address);

  conn.onclose = function() {
    setTimeout(function() {
      tryConnectToReload(address);
    }, 2000);
  };

  conn.onmessage = function(evt) {
    location.reload()
  };
}

try {
  if (window["WebSocket"]) {
    // The reload endpoint is hosted on a statically defined port.
    try {
      tryConnectToReload("ws://%v/reload");
    }
    catch (ex) {
      // If an exception is thrown, that means that we couldn't connect to to WebSockets because of mixed content
      // security restrictions, so we try to connect using wss.
      tryConnectToReload("wss://%v/reload");
    }
  } else {
    console.log("Your browser does not support WebSockets, cannot connect to the Reload service.");
  }
} catch (ex) {
  console.error('Exception during connecting to Reload:', ex);
}
</script>
`, bindAddr, bindAddr)
}