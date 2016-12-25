var WK = require('ti.wkwebview');

var win = Ti.UI.createWindow({
    backgroundColor: "#fff",
	title: "WKWebView"
});

var progress = Ti.UI.createProgressBar({
    min: 0.0,
    max: 1.0,
    top: 0,
    width: Ti.UI.FILL
});

var nav = Ti.UI.iOS.createNavigationWindow({
	window: win
});
 
var webView = WK.createWebView({
    url: "remote_test.html"
//	url: "https://appcelerator.com",
// 	html: "<!DOCTYPE html><html><head></head><body><p style='font-size: 72px, color: red;'>Hello world!</p><script type=\"text/javascript\">window.webkit.messageHandlers.Ti.postMessage({'foo': 'bar'});</script></body></html>"
});

webView.addEventListener("message", function(e) {
    // Received event from HTML file
    // Call using "window.webkit.messageHandlers.Ti.postMessage({foo: 'bar'},'*');"
    Ti.API.info(e);
});

webView.addEventListener("progress", function(e) {
    
    if (e.progress >= 1.0) {
        progress.setValue(0.0);
        progress.visible && progress.hide();
    } else {
        progress.setValue(e.progress);
        !progress.visible && progress.show();
    }
});
 
webView.addEventListener("beforeload", function(e) {
	Ti.API.info("Will load URL: " + e.url);
});
 
webView.addEventListener("loadprogress", function(e) {
	Ti.API.info("Did receive first content of URL: " + e.url);
});
 
webView.addEventListener("load", function(e) {
	Ti.API.info("Did load URL: " + e.url);
});
 
var btn = Ti.UI.createButton({
   title: 'evalJS'
});

btn.addEventListener('click', function() {
    // Asynchronous to unblock main-thread
    webView.evalJS('document.title', function(e) {
        alert(e.result);
    });
});

win.setLeftNavButton(btn);
win.add(webView);
win.add(progress);
nav.open();
