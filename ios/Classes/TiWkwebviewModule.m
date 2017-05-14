/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <WebKit/WebKit.h>

#import "TiWkwebviewModule.h"
#import "TiWkwebviewProcessPoolProxy.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import "TiCallbackManager.h"

#define MAKE_SYSTEM_UINTEGER(name,map) \
-(NSNumber*)name \
{\
return [NSNumber numberWithUnsignedInteger:map];\
}\

@implementation TiWkwebviewModule

#pragma mark Internal

- (id)moduleGUID
{
	return @"b63a2be9-04e3-4bb2-82ec-7c00978de132";
}

- (NSString *)moduleId
{
	return @"ti.wkwebview";
}

- (TiWkwebviewProcessPoolProxy *)createProcessPool:(id)args
{
    return [[TiWkwebviewProcessPoolProxy alloc] _initWithPageContext:[self pageContext]];
}

- (void)startup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPassCallback:) name:@"TiEventCallback" object:nil];
    
    [super startup];
}

- (void)fireEvent:(id)args
{
    NSString *name = [args objectAtIndex:0];
    NSDictionary *payload = [args objectAtIndex:1];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TiFireEvent" object:nil userInfo:@{@"name": name, @"payload": payload}];
}

- (void)addEventListener:(NSArray *)args
{
    NSString *name = [args objectAtIndex:0];
    KrollCallback *callback = [args objectAtIndex:1];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TiAddEventListener" object:nil userInfo:@{@"name": name, @"callback": callback}];
}

- (void)removeEventListener:(NSArray *)args
{
    NSString *name = [args objectAtIndex:0];
    KrollCallback *callback = [args objectAtIndex:1];
    
    [[TiCallbackManager sharedInstance] removeCallbackWithName:name];
}

- (void)didPassCallback:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSDictionary *payload = [userInfo objectForKey:@"payload"];
    NSString *name = [userInfo objectForKey:@"name"];
    
    KrollCallback *callback = [[TiCallbackManager sharedInstance] callbackForName:name];
        
    [callback call:@[payload] thisObject:self];
}

MAKE_SYSTEM_PROP(CREDENTIAL_PERSISTENCE_NONE, NSURLCredentialPersistenceNone);
MAKE_SYSTEM_PROP(CREDENTIAL_PERSISTENCE_FOR_SESSION, NSURLCredentialPersistenceForSession);
MAKE_SYSTEM_PROP(CREDENTIAL_PERSISTENCE_PERMANENT, NSURLCredentialPersistencePermanent);
MAKE_SYSTEM_PROP(CREDENTIAL_PERSISTENCE_SYNCHRONIZABLE, NSURLCredentialPersistenceSynchronizable);

MAKE_SYSTEM_UINTEGER(AUDIOVISUAL_MEDIA_TYPE_NONE, WKAudiovisualMediaTypeNone);
MAKE_SYSTEM_UINTEGER(AUDIOVISUAL_MEDIA_TYPE_AUDIO, WKAudiovisualMediaTypeAudio);
MAKE_SYSTEM_UINTEGER(AUDIOVISUAL_MEDIA_TYPE_VIDEO, WKAudiovisualMediaTypeVideo);
MAKE_SYSTEM_UINTEGER(AUDIOVISUAL_MEDIA_TYPE_ALL, WKAudiovisualMediaTypeAll);

MAKE_SYSTEM_PROP(CACHE_POLICY_USE_PROTOCOL_CACHE_POLICY, NSURLRequestUseProtocolCachePolicy)
MAKE_SYSTEM_PROP(CACHE_POLICY_RELOAD_IGNORING_LOCAL_CACHE_DATA, NSURLRequestReloadIgnoringLocalCacheData)
MAKE_SYSTEM_PROP(CACHE_POLICY_RETURN_CACHE_DATA_ELSE_LOAD, NSURLRequestReturnCacheDataElseLoad)
MAKE_SYSTEM_PROP(CACHE_POLICY_RETURN_CACHE_DATA_DONT_LOAD, NSURLRequestReturnCacheDataDontLoad)

MAKE_SYSTEM_PROP(SELECTION_GRANULARITY_DYNAMIC, WKSelectionGranularityDynamic);
MAKE_SYSTEM_PROP(SELECTION_GRANULARITY_CHARACTER, WKSelectionGranularityCharacter);

@end
