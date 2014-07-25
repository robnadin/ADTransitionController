//
//  ADAppDelegate.m
//  ADTransitionController
//
//  Created by Pierre Felgines on 27/05/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import "ALAppDelegate.h"
#import "ADTransitionController.h"
#import "ALTransitionTestViewController.h"
#import "ADNavigationControllerDelegate.h"

@interface ALAppDelegate () {
    ADNavigationControllerDelegate * _navigationDelegate;
}

@end

@implementation ALAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Setup transitionController
    UIViewController * transitionController = self.window.rootViewController;
    _navigationDelegate = [[ADNavigationControllerDelegate alloc] init];
    ((UINavigationController *)transitionController).delegate = _navigationDelegate;

    // Setup appearance
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"ALNavigationBarBackground"] stretchableImageWithLeftCapWidth:1.0f topCapHeight:1.0f] forBarMetrics:UIBarMetricsDefault];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowOffset = CGSizeMake(-1.0f, 0);
    NSDictionary * navigationBarTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                   NSShadowAttributeName : shadow};
    [[UINavigationBar appearance] setTitleTextAttributes:navigationBarTextAttributes];


    [[UIToolbar appearance] setBackgroundImage:[[UIImage imageNamed:@"ALNavigationBarBackground"] stretchableImageWithLeftCapWidth:1.0f topCapHeight:1.0f] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];

    return YES;
}

@end
