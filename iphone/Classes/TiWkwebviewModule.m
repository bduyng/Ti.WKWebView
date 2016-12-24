/**
 * ti.wkwebview
 *
 * Created by Hans Knoechel
 * Copyright (c) 2016 Your Company. All rights reserved.
 */

#import "TiWkwebviewModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiWkwebviewModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"b63a2be9-04e3-4bb2-82ec-7c00978de132";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.wkwebview";
}

MAKE_SYSTEM_PROP(CREDENTIAL_PERSISTENCE_NONE, NSURLCredentialPersistenceNone);
MAKE_SYSTEM_PROP(CREDENTIAL_PERSISTENCE_FOR_SESSION, NSURLCredentialPersistenceForSession);
MAKE_SYSTEM_PROP(CREDENTIAL_PERSISTENCE_PERMANENT, NSURLCredentialPersistencePermanent);
MAKE_SYSTEM_PROP(CREDENTIAL_PERSISTENCE_SYNCHRONIZABLE, NSURLCredentialPersistenceSynchronizable);

@end
