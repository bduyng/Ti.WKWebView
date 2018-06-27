/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2018 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiEvaluator.h"
#import "TiViewProxy.h"

@interface TiWkwebviewWebViewProxy : TiViewProxy <TiEvaluator> {
  NSMutableArray<NSString *> *genericProperties;
  NSArray *_allowedURLSchemes;
  NSString *_pageToken;
}

- (void)refreshHTMLContent;
- (void)setPageToken:(NSString *)pageToken;

@end
