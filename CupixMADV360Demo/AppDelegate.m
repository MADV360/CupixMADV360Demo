//
//  AppDelegate.m
//  CupixMADV360Demo
//
//  Created by QiuDong on 2018/6/26.
//  Copyright © 2018年 QiuDong. All rights reserved.
//

// Ref: https://www.jianshu.com/p/116c1b3f1c11
// Ref: http://clang.llvm.org/docs/Modules.html#module-map-file
// Ref: https://stackoverflow.com/questions/35229149/interacting-with-c-classes-from-swift

#import "AppDelegate.h"

/*
 <option uid="14" msgID="5169" name="曝光補償" type="slider" jsonParamKey="still_ev">
 <param uid="-6" msgID="-6" name="-3" />
 <param uid="-5" msgID="-5" name="-2.5" />
 <param uid="-4" msgID="-4" name="-2" />
 <param uid="-3" msgID="-3" name="-1.5" />
 <param uid="-2" msgID="-2" name="-1" />
 <param uid="-1" msgID="-1" name="-0.5" />
 <param uid="0" msgID="0" name="0" />
 <param uid="1" msgID="1" name="0.5" />
 <param uid="2" msgID="2" name="1" />
 <param uid="3" msgID="3" name="1.5" />
 <param uid="4" msgID="4" name="2" />
 <param uid="5" msgID="5" name="2.5" />
 <param uid="6" msgID="6" name="3" />
 </option>
// MVCameraClient - (void)setSettingOption:(int)optionUID paramUID:(int)paramUID
// {"param":"3","msg_id":5169,"btwifi":2,"token":1}
//*/

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Create root viewController in this way will get better GPU performance:
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController* rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"CameraView"];
    rootViewController.view.frame = [[UIScreen mainScreen] bounds];
    [self.window addSubview:rootViewController.view];
    
    [self.window makeKeyAndVisible];
    [self.window layoutSubviews];
    self.window.rootViewController = rootViewController;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
