#ifdef FB_IOS_GLUE
#include <QString>
#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#ifdef QFACEBOOK_SDK_4
#include "PluginFacebook/PluginFacebook.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#else
#import "FacebookSDK/FacebookSDK.h"
#endif

#ifdef SDKBOX_ADMOB
#include "PluginAdmob/PluginAdMob.h"
#endif

/**
 * Workaround to register the delegate methods needed for google authorization.
 */
@interface QIOSApplicationDelegate : UIResponder <UIApplicationDelegate>
@end
@interface QAppDelegate
- (void)applicationDidFinishLaunching:(UIApplication *)application;
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void) applicationDidBecomeActive:(UIApplication *)application;
@end

@implementation QIOSApplicationDelegate (QAppDelegate)

- (void) applicationDidBecomeActive:(UIApplication *)application {
    //    [super applicationDidBecomeActive:application:application];
    [FBSDKAppEvents activateApp];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
#ifdef QFACEBOOK_SDK_4
    else if([[FBSDKApplicationDelegate sharedInstance] application:application openURL:url
                                                 sourceApplication:sourceApplication
                                                        annotation:annotation]){
        qDebug("Handled Facebook SDK4 Signin");
        return YES;
    }
#else
    else if([FBAppCall handleOpenURL:url sourceApplication:sourceApplication]){
        qDebug("Handled Facebook Signin");
        return YES;
    }
#endif
    else if([application openURL:url]){
        return NO;
    }else{
        return NO;
    }
}
-(void)applicationDidFinishLaunching:(UIApplication *)application {
    Q_UNUSED(application)
    sdkbox::PluginFacebook::init();
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if([[FBSDKApplicationDelegate sharedInstance] application:application
                                didFinishLaunchingWithOptions:launchOptions]){
        return YES;
    }
    return YES;
}
@end

#endif
