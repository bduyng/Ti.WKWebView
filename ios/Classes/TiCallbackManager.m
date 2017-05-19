//
//  TiCallbackManager.m
//  ti.wkwebview
//
//  Created by Hans Knöchel on 14.05.17.
//
//

#import "TiCallbackManager.h"

@implementation TiCallbackManager

+ (id)sharedInstance
{
    static dispatch_once_t onceToken = 0;
    
    __strong static id _sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (NSMutableDictionary<NSString *, KrollCallback *> *)callbacks
{
    if (_callbacks == nil) {
        _callbacks = [NSMutableDictionary dictionary];
    }
    
    return _callbacks;
}

- (BOOL)hasCallbackForName:(NSString *)name;
{
    return [self callbackForName:name] != nil;
}

- (KrollCallback *)callbackForName:(NSString *)name
{
    return [[self callbacks] objectForKey:name];
}

- (void)addCallback:(KrollCallback *)callback withName:(NSString *)name
{
    if ([[self callbacks] objectForKey:name]) {
        NSLog(@"[ERROR] Trying to add a callback for name '%@' that is already recognized.", name);
    }
    
    [[self callbacks] setObject:callback forKey:name];
}

- (void)removeCallbackWithName:(NSString *)name
{
    if (![[self callbacks] objectForKey:name]) {
        NSLog(@"[ERROR] Trying to remove a callback for name '%@' that is already removed.", name);
    }
    
    [[self callbacks] removeObjectForKey:name];
}

@end
