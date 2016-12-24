var win = Ti.UI.createWindow({
    backgroundColor: '#fff'
});

var WK = require('ti.wkwebview');

var webView = WK.createWebView({
	url: 'http://appcelerator.com'
});

win.add(webView);
win.open();
