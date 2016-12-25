/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiWkwebviewModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import <WebKit/WebKit.h>

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

MAKE_SYSTEM_PROP(CREDENTIAL_PERSISTENCE_NONE, NSURLCredentialPersistenceNone);
MAKE_SYSTEM_PROP(CREDENTIAL_PERSISTENCE_FOR_SESSION, NSURLCredentialPersistenceForSession);
MAKE_SYSTEM_PROP(CREDENTIAL_PERSISTENCE_PERMANENT, NSURLCredentialPersistencePermanent);
MAKE_SYSTEM_PROP(CREDENTIAL_PERSISTENCE_SYNCHRONIZABLE, NSURLCredentialPersistenceSynchronizable);

MAKE_SYSTEM_UINTEGER(AUDIOVISUAL_MEDIA_TYPE_NONE, WKAudiovisualMediaTypeNone);
MAKE_SYSTEM_UINTEGER(AUDIOVISUAL_MEDIA_TYPE_AUDIO, WKAudiovisualMediaTypeAudio);
MAKE_SYSTEM_UINTEGER(AUDIOVISUAL_MEDIA_TYPE_VIDEO, WKAudiovisualMediaTypeVideo);
MAKE_SYSTEM_UINTEGER(AUDIOVISUAL_MEDIA_TYPE_ALL, WKAudiovisualMediaTypeAll);

@end
