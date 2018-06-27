//
//  TiCallbackManager.h
//  ti.wkwebview
//
//  Created by Hans Knöchel on 14.05.17.
//
//

#import <Foundation/Foundation.h>

#import "TiBase.h"
#import "TiHost.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Manage Kroll-callback used to enable WebView-wide event handling.
 */
@interface TiCallbackManager : NSObject {
  @private
  /**
     * Data structure used to store the callbacks.
     */
  NSMutableDictionary<NSString *, KrollCallback *> *_callbacks;
}

/**
 * Shared instance used to access the callback-manager without having different instance.
 */
+ (id)sharedInstance;

/**
 * Adds a new callback to the data structure.
 *
 * @param callback The callback passed to the data structure.
 * @param name The name of the callback. This will be used to trigger and receive events.
 */
- (void)addCallback:(KrollCallback *)callback withName:(NSString *)name;

/**
 * Validates whether or not a callback exists for the specified name.
 *
 * @param name The name of the callback to validate.
 * @return __YES__ if there is a callback for the specified name, __NO__ otherwise.
 */
- (BOOL)hasCallbackForName:(NSString *)name;

/**
 * Returns a callback specified by it's name.
 *
 * @param name The name to receive the depending callback of.
 * @return The callback specified by it's name.
 */
- (KrollCallback *)callbackForName:(NSString *)name;

/**
 * Removes an existing callback from the data structure.
 *
 * @param callback The callback to be removed from the data structure.
 * @param name The name of the callback to remove.
 */
- (void)removeCallbackWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
