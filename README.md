# Ti.WKWebView [![Build Status](https://travis-ci.org/hansemannn/Ti.WKWebView.svg?branch=master)](https://travis-ci.org/hansemannn/Ti.WKWebView)

Summary
---------------
Ti.WKWebView is an open source project to support the `WKWebView` API with Titanium.

Requirements
---------------
- Titanium Mobile SDK 5.0.0.GA or later
- iOS 9 or later
- Xcode 7.0 or later

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
### API's

| Name | Example|
|------|--------|
| WebView | `WK.createWebView(args)` |
| ProcessPool | `WK.createProcessPool()` |

### WebView

#### Properties

| Name | Type |
|------|------|
| disableBounce | Boolean |
| suppressesIncrementalRendering | Boolean |
| scalePageToFit | Boolean |
| allowsInlineMediaPlayback | Boolean |
| allowsAirPlayMediaPayback | Boolean |
| allowsPictureInPictureMediaPlaback | Boolean |
| allowsBackForwardNavigationGestures | Boolean |
| allowsLinkPreview | Boolean |
| scrollsToTop | Boolean |
| disableContextMenu | Boolean |
| userAgent | String|
| url | String |
| data | Ti.Blob, Ti.File |
| html | Boolean |
| title | Boolean |
| progress | Double |
| backForwardList | Object |
| ignoreSslError | Boolean |
| mediaTypesRequiringUserActionForPlayback | AUDIOVISUAL_MEDIA_TYPE_* |
| preferences | Object<br/>- minimumFontSize (Double)<br/>- javaScriptEnabled (Boolean)<br/>- javaScriptCanOpenWindowsAutomatically (Boolean) |
| basicAuhentication | Object<br/>- username (String)<br/>- password (String)<br/>- persistence (CREDENTIAL_PERSISTENCE_*) |
| cachePolicy | CACHE_POLICY_* |
| timeout | Double |
| processPool | ProcessPool |

#### Methods

| Name | Parameter | Return |
|------|-----------|--------|
| stopLoading | - | Void |
| reload | - | Void |
| goBack | - | Void |
| goForward | - | Void |
| canGoBack | - | Boolean |
| canGoForward | - | Boolean |
| isLoading | - | Boolean |
| evalJS | Code (String), Callback (Function) | Void|
| startListeningToProperties | Properties (Array<String>) | Void |
| stopListeningToProperties | Properties (Array<String>) | Void |

#### Events

| Name | Properties |
|------|------------|
| message | name, body, url, isMainFrame |
| progress | value, url |
| beforeload | url, title |
| load | url, title |
| redirect | url, title |
| error | url, title, error |

#### Constants

| Name | Property |
|------|----------|
| CREDENTIAL_PERSISTENCE_NONE | basicAuthentication.persistence |
| CREDENTIAL_PERSISTENCE_FOR_SESSION | basicAuthentication.persistence |
| CREDENTIAL_PERSISTENCE_PERMANENT | basicAuthentication.persistence |
| CREDENTIAL_PERSISTENCE_SYNCHRONIZABLE | basicAuthentication.persistence |
| AUDIOVISUAL_MEDIA_TYPE_NONE | mediaTypesRequiringUserActionForPlayback |
| AUDIOVISUAL_MEDIA_TYPE_AUDIO | mediaTypesRequiringUserActionForPlayback |
| AUDIOVISUAL_MEDIA_TYPE_VIDEO | mediaTypesRequiringUserActionForPlayback |
| AUDIOVISUAL_MEDIA_TYPE_ALL | mediaTypesRequiringUserActionForPlayback |
| CACHE_POLICY_USE_PROTOCOL_CACHE_POLICY | cachePolicy |
| CACHE_POLICY_RELOAD_IGNORING_LOCAL_CACHE_DATA | cachePolicy |
| CACHE_POLICY_RETURN_CACHE_DATA_ELSE_LOAD | cachePolicy |
| CACHE_POLICY_RETURN_CACHE_DATA_DONT_LOAD | cachePolicy |

#### WebView <-> App Communication
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

### Process Pool

Use process pools to share cookies between cookies. Process pools do not take arguments, just pass the same 
reference to multiple web views. Example:
```js
var WK = require('ti.wkwebview');

var pool = WK.createProcessPool();

var firstWebView = WK.createWebView({
    processPool: pool
});

var secondWebView = WK.createWebView({
    processPool: pool
});
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
