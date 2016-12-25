# Ti.WKWebView

Summary
---------------
Ti.WKWebView is an open source project to support the `WKWebView` component with Titanium

Requirements
---------------
- Titanium Mobile SDK 6.0.0.GA or later
- iOS 9 or later
- Xcode 8.0 or later

Download + Setup
---------------

### Download
* [Stable release](https://github.com/hansemannn/ti.wkwebview/releases)
* Install from gitTio    <a href="http://gitt.io/component/ti.wkwebview" target="_blank"><img src="http://gitt.io/badge@2x.png" width="120" height="18" alt="Available on gitTio" /></a>

### Setup
Unpack the module and place it inside the `modules/iphone` folder of your project.
Edit the modules section of your `tiapp.xml` file to include this module:
```xml
<modules>
    <module>ti.wkwebview</module>
</modules>
```

Features
---------------
**Properties**:
- disableBounce
- suppressesIncrementalRendering
- scalePageToFit
- allowsInlineMediaPlayback
- allowsAirPlayMediaPayback
- allowsPictureInPictureMediaPlaback
- allowsBackForwardNavigationGestures
- allowsLinkPreview
- scrollsToTop
- disableContextMenu
- userAgent
- url
- data
- html
- title
- progress
- loading
- secure
- backForwardList

**Methods**:
- stopLoading
- reload
- goBack
- goForward
- canGoBack
- canGoForward
- evalJS

**Events**:
- message
- progress
- beforeload
- load
- redirect

WebView <-> App Communication
---------------
You can send data from the Web View to your native app by posting messages like this:
```javascript
window.webkit.messageHandlers.Ti.postMessage({foo: 'bar'},'*');
```
This will trigger the `message` event with the following event keys:
- url
- message
- name
- isMainFrame

For sending messages from the app to the Web View, use `evalJS` to call your JS methods like this:
```javascript
webView.evalJS('myJSMethod();');
```

Author
---------------
Hans Knoechel ([@hansemannnn](https://twitter.com/hansemannnn) / [Web](http://hans-knoechel.de))

License
---------------
Apache 2.0

Contributing
---------------
Code contributions are greatly appreciated, please submit a new [pull request](https://github.com/hansemannn/ti.wkwebview/pull/new/master)!
