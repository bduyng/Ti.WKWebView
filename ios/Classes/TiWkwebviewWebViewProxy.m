/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2018 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiWkwebviewWebViewProxy.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiWkwebviewWebView.h"

@implementation TiWkwebviewWebViewProxy

@synthesize currentURL;

- (id)_initWithPageContext:(id<TiEvaluator>)context
{
  if (self = [super _initWithPageContext:context]) {
    [[self webView] registerNotificationCenter];
  }

  return self;
}

- (TiWkwebviewWebView *)webView
{
  return (TiWkwebviewWebView *)self.view;
}

- (void)fireEvent:(id)listener withObject:(id)obj remove:(BOOL)yn thisObject:(id)thisObject_
{
  TiThreadPerformOnMainThread(^{
    [[self webView] fireEvent:listener withObject:obj remove:yn thisObject:thisObject_];
  },
      NO);
}

- (TiHost *)host
{
  return [self _host];
}

- (void)setPageToken:(NSString *)pageToken
{
  if (_pageToken != nil) {
    [[self host] unregisterContext:(id<TiEvaluator>)self forToken:_pageToken];
    _pageToken = nil;
  }
  _pageToken = pageToken;
  [[self host] registerContext:self forToken:_pageToken];
}

- (void)refreshHTMLContent
{
  NSString *code = @"document.documentElement.outerHTML.toString()";

  // Refresh the "html" property async to be able to use the remote HTML content.
  // This should be deprecated asap, since it is an overhead that should be done using
  // webView.evalJS() within the app if required.
  [[[self webView] webView] evaluateJavaScript:code
                             completionHandler:^(id result, NSError *error) {
                               if (error != nil) {
                                 return;
                               }
                               [self replaceValue:result forKey:@"html" notification:NO];
                             }];
}

- (void)windowDidClose
{
  if (_pageToken != nil) {
    [[self host] unregisterContext:(id<TiEvaluator>)self forToken:_pageToken];
    _pageToken = nil;
  }
  NSNotification *notification = [NSNotification notificationWithName:kTiContextShutdownNotification object:self];
  WARN_IF_BACKGROUND_THREAD_OBJ;
  [[NSNotificationCenter defaultCenter] postNotification:notification];
  [super windowDidClose];
}

- (void)_destroy
{
  if (_pageToken != nil) {
    [[self host] unregisterContext:(id<TiEvaluator>)self forToken:_pageToken];
    _pageToken = nil;
  }
  [super _destroy];
}

#pragma mark - TiEvaluator Protocol

- (NSString *)basename
{
  return nil;
}

- (NSURL *)currentURL
{
  return nil;
}

- (void)setCurrentURL:(NSURL *)unused
{
}

- (void)evalFile:(NSString *)path
{
  NSURL *url_ = [path hasPrefix:@"file:"] ? [NSURL URLWithString:path] : [NSURL fileURLWithPath:path];

  if (![path hasPrefix:@"/"] && ![path hasPrefix:@"file:"]) {
    NSURL *root = [[self _host] baseURL];
    url_ = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", root, path]];
  }

  NSString *code = [NSString stringWithContentsOfURL:url_ encoding:NSUTF8StringEncoding error:nil];
  [[[self webView] webView] evaluateJavaScript:code
                             completionHandler:^(id _Nullablecresult, NSError *_Nullable error){
                             }];
}

- (NSString *)evalJSAndWait:(NSString *)code
{
  return [self evalJSSync:code];
}

- (void)evalJSWithoutResult:(NSString *)code
{
  [self evalJS:code];
}

- (BOOL)evaluationError
{
  return NO;
}

- (KrollContext *)krollContext
{
  return nil;
}

- (id)krollObjectForProxy:(id)proxy
{
  return nil;
}

- (id)preloadForKey:(id)key name:(id)name
{
  return nil;
}

- (id)registerProxy:(id)proxy
{
  return nil;
}

- (void)unregisterProxy:(id)proxy
{
}

- (BOOL)usesProxy:(id)proxy
{
  return NO;
}

#pragma mark - Public APIs

#pragma mark Getters

- (NSNumber *)disableBounce
{
  return @(![[[[self webView] webView] scrollView] bounces]);
}

- (NSNumber *)scrollsToTop
{
  return @([[[[self webView] webView] scrollView] scrollsToTop]);
}

- (NSNumber *)allowsBackForwardNavigationGestures
{
  return @([[[self webView] webView] allowsBackForwardNavigationGestures]);
}

- (NSString *)userAgent
{
  return [[[self webView] webView] customUserAgent];
}

- (NSString *)url
{
  return [[[[self webView] webView] URL] absoluteString];
}

- (NSString *)title
{
  return [[[self webView] webView] title];
}

- (NSNumber *)progress
{
  return @([[[self webView] webView] estimatedProgress]);
}

- (NSNumber *)secure
{
  return @([[[self webView] webView] hasOnlySecureContent]);
}

- (NSDictionary *)backForwardList
{
  WKBackForwardList *list = [[[self webView] webView] backForwardList];

  NSMutableArray *backList = [NSMutableArray arrayWithCapacity:list.backList.count];
  NSMutableArray *forwardList = [NSMutableArray arrayWithCapacity:list.forwardList.count];

  for (WKBackForwardListItem *item in list.backList) {
    [backList addObject:[TiWkwebviewWebViewProxy _dictionaryFromBackForwardItem:item]];
  }

  for (WKBackForwardListItem *item in list.forwardList) {
    [forwardList addObject:[TiWkwebviewWebViewProxy _dictionaryFromBackForwardItem:item]];
  }

  return @{
    @"currentItem" : [TiWkwebviewWebViewProxy _dictionaryFromBackForwardItem:[list currentItem]],
    @"backItem" : [TiWkwebviewWebViewProxy _dictionaryFromBackForwardItem:[list backItem]],
    @"forwardItem" : [TiWkwebviewWebViewProxy _dictionaryFromBackForwardItem:[list forwardItem]],
    @"backList" : backList,
    @"forwardList" : forwardList
  };
}

- (NSDictionary *)preferences
{
  return @{
    @"minimumFontSize" : NUMFLOAT([[[[[self webView] webView] configuration] preferences] minimumFontSize]),
    @"javaScriptEnabled" : NUMBOOL([[[[[self webView] webView] configuration] preferences] javaScriptEnabled]),
    @"javaScriptCanOpenWindowsAutomatically" : NUMBOOL([[[[[self webView] webView] configuration] preferences] javaScriptCanOpenWindowsAutomatically]),
  };
}

- (NSNumber *)selectionGranularity
{
  return @([[[[self webView] webView] configuration] selectionGranularity]);
}

- (NSNumber *)mediaTypesRequiringUserActionForPlayback
{
  return @([[[[self webView] webView] configuration] mediaTypesRequiringUserActionForPlayback]);
}

- (NSNumber *)suppressesIncrementalRendering
{
  return @([[[[self webView] webView] configuration] suppressesIncrementalRendering]);
}

- (NSNumber *)allowsInlineMediaPlayback
{
  return @([[[[self webView] webView] configuration] allowsInlineMediaPlayback]);
}

- (NSNumber *)allowsAirPlayMediaPlayback
{
  return @([[[[self webView] webView] configuration] allowsAirPlayForMediaPlayback]);
}

- (NSNumber *)allowsPictureInPictureMediaPlayback
{
  return @([[[[self webView] webView] configuration] allowsPictureInPictureMediaPlayback]);
}

- (NSArray<NSString *> *)allowedURLSchemes
{
  return _allowedURLSchemes;
}

- (NSNumber *)zoomLevel
{
  NSString *zoomLevel = [self evalJS:@[ @"document.body.style.zoom" ]];

  if (zoomLevel == nil || zoomLevel.length == 0) {
    return @(1.0);
  }

  return @([zoomLevel doubleValue]);
}

#pragma mark Setter

- (void)setAllowedURLSchemes:(NSArray *)schemes
{
  for (id scheme in schemes) {
    ENSURE_TYPE(scheme, NSString);
  }

  _allowedURLSchemes = schemes;
}

- (void)setHtml:(id)args
{
  [[self webView] setHtml_:args];
}

#pragma mark Methods

- (void)addUserScript:(id)args
{
  ENSURE_SINGLE_ARG(args, NSDictionary);

  NSString *source = [TiUtils stringValue:@"source" properties:args];
  WKUserScriptInjectionTime injectionTime = [TiUtils intValue:@"injectionTime" properties:args];
  BOOL mainFrameOnly = [TiUtils boolValue:@"mainFrameOnly" properties:args];

  WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:injectionTime forMainFrameOnly:mainFrameOnly];
  WKUserContentController *controller = [[[[self webView] webView] configuration] userContentController];
  [controller addUserScript:script];
}

- (void)removeAllUserScripts:(id)unused
{
  WKUserContentController *controller = [[[[self webView] webView] configuration] userContentController];
  [controller removeAllUserScripts];
}

- (void)addScriptMessageHandler:(id)value
{
  ENSURE_SINGLE_ARG(value, NSString);

  WKUserContentController *controller = [[[[self webView] webView] configuration] userContentController];
  [controller addScriptMessageHandler:[self webView] name:value];
}

- (void)removeScriptMessageHandler:(id)value
{
  ENSURE_SINGLE_ARG(value, NSString);

  WKUserContentController *controller = [[[[self webView] webView] configuration] userContentController];
  [controller removeScriptMessageHandlerForName:value];
}

- (NSNumber *)isLoading:(id)unused
{
  return NUMBOOL([[[self webView] webView] isLoading]);
}

- (void)stopLoading:(id)unused
{
  [[[self webView] webView] stopLoading];
}

- (void)reload:(id)unused
{
  [[[self webView] webView] reload];
}

- (void)repaint:(id)unused
{
  [self contentsWillChange];
}

- (void)goBack:(id)unused
{
  [[[self webView] webView] goBack];
}

- (void)goForward:(id)unused
{
  [[[self webView] webView] goForward];
}

- (NSNumber *)canGoBack:(id)unused
{
  return NUMBOOL([[[self webView] webView] canGoBack]);
}

- (NSNumber *)canGoForward:(id)unused
{
  return NUMBOOL([[[self webView] webView] canGoForward]);
}

- (NSNumber *)loading
{
  return @([[[self webView] webView] isLoading]);
}

- (void)startListeningToProperties:(id)args
{
  ENSURE_SINGLE_ARG(args, NSArray);

  for (id property in args) {
    ENSURE_TYPE(property, NSString);

    [[[self webView] webView] addObserver:self forKeyPath:property options:NSKeyValueObservingOptionNew context:NULL];
  }

  genericProperties = args;
}

- (void)stopListeningToProperties:(id)args
{
  ENSURE_SINGLE_ARG(args, NSArray);

  for (id property in args) {
    ENSURE_TYPE(property, NSString);

    [[[self webView] webView] removeObserver:self forKeyPath:property];
  }

  genericProperties = nil;
}

- (id)evalJS:(id)args
{
  NSString *code = nil;
  KrollCallback *callback = nil;

  ENSURE_ARG_AT_INDEX(code, args, 0, NSString);
  ENSURE_ARG_OR_NIL_AT_INDEX(callback, args, 1, KrollCallback);

  if (code == nil) {
    [self throwException:@"Missing JavaScript code"
               subreason:@"The required first argument is missinf and should contain a valid JavaScript string."
                location:CODELOCATION];
    return nil;
  }

  // If no argument is passed, return in sync (NOT recommended)
  if (callback == nil) {
    return [self evalJSSync:@[ code ]];
  }

  if ([TiUtils isIOS11OrGreater]) {
    TiThreadPerformOnMainThread(^{
      [self evaluateJavaScript:code WithCallback:callback];
    }, NO);
  }
  else {
    [self evaluateJavaScript:code WithCallback:callback];
  }

  return nil;
}

- (void)evaluateJavaScript:(NSString *)code WithCallback:(KrollCallback *)callback {
  [[[self webView] webView] evaluateJavaScript:code
                              completionHandler:^(id result, NSError *error) {
                                if (!callback) {
                                    return;
                                }
                                
                                NSMutableDictionary *event = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                                            @"result" : result ?: [NSNull null],
                                                                                                            @"success" : NUMBOOL(error == nil)
                                                                                                            }];
                                
                                if (error) {
                                    [event setObject:[error localizedDescription] forKey:@"error"];
                                }
                                
                                [callback call:[[NSArray alloc] initWithObjects:&event count:1] thisObject:self];
                              }];
}

- (NSString *)evalJSSync:(id)args
{
  NSString *code = nil;

  __block NSString *resultString = nil;
  __block BOOL finishedEvaluation = NO;

  ENSURE_ARG_AT_INDEX(code, args, 0, NSString);

  [[[self webView] webView] evaluateJavaScript:code
                             completionHandler:^(id result, NSError *error) {
                               resultString = NULL_IF_NIL(result);
                               finishedEvaluation = YES;
                             }];

  while (!finishedEvaluation) {
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
  }

  return resultString;
}

#if __IPHONE_11_0
- (void)takeSnapshot:(id)args
{
  if ([TiUtils isIOSVersionOrGreater:@"11.0"]) {
    DebugLog(@"[ERROR] The \"takeSnapshot\" method is only available on iOS 11 and later.");
    return;
  }

  KrollCallback *callback = (KrollCallback *)[args objectAtIndex:0];
  ENSURE_TYPE(callback, KrollCallback);

  [[[self webView] webView] takeSnapshotWithConfiguration:nil
                                        completionHandler:^(UIImage *snapshotImage, NSError *error) {
                                          if (error != nil) {
                                            [callback call:@[ @{ @"success" : NUMBOOL(NO), @"error" : error.localizedDescription } ] thisObject:self];
                                            return;
                                          }

                                          [callback call:@[ @{ @"success" : NUMBOOL(YES), @"snapshot" : [[TiBlob alloc] initWithImage:snapshotImage] } ] thisObject:self];
                                        }];
}
#endif

#pragma mark Utilities

+ (NSDictionary *)_dictionaryFromBackForwardItem:(WKBackForwardListItem *)item
{
  return @{ @"url" : item.URL.absoluteString, @"initialUrl" : item.initialURL.absoluteString, @"title" : item.title };
}

#pragma mark Generic KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  for (NSString *property in genericProperties) {
    if ([self _hasListeners:property] && [keyPath isEqualToString:property] && object == [[self webView] webView]) {
      [self fireEvent:property withObject:@{ @"value" : NULL_IF_NIL([[[self webView] webView] valueForKey:property]) }];
      return;
    }
  }

  [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
