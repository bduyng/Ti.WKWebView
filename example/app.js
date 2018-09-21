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
  //  -- Enable to test remote URL's or change to a local html file
  //  url: "https://apple.com",
  html: "<!DOCTYPE html><html><head><title>Local HTML</title></head><body><p style='font-size: 72px, color: red;'>Hello world!</p><script type=\"text/javascript\">function invokeMyJSMethod(e) {alert('Hello from your HTML file: ' + e.message);} window.webkit.messageHandlers.Ti.postMessage({message: 'Titanium rocks!'});</script></body></html>"
});

webView.addEventListener("message", function(e) {
  // Received event from HTML file
  // Call using "window.webkit.messageHandlers.Ti.postMessage({foo: 'bar'},'*');"
  Ti.API.info('-- did receive message')
  Ti.API.info(e.body.message);
});

webView.addEventListener("progress", function(e) {
  if (e.value >= 1.0) {
    progress.setValue(0.0);
    progress.visible && progress.hide();
  } else  {
    progress.setValue(e.value);
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
  win.setTitle(e.title);
});

var btn = Ti.UI.createButton({
  title: 'Post message'
});

btn.addEventListener('click', function() {
  // Asynchronous to unblock main-thread, with optional second parameter for callback
  webView.evalJS('invokeMyJSMethod({message: \'Titanium rocks!\'})', function(e) {});
});

win.setLeftNavButton(btn);
win.add(webView);
win.add(progress);
nav.open();
