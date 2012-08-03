//
//  HTTPAndCachingAppDelegate.h
//  HTTPAndCaching
//
//  Created by Wim Vanhenden on 07/12/10.
//  Copyright 2010 Little Miss Robot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTPAndCachingViewController;

@interface HTTPAndCachingAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    HTTPAndCachingViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HTTPAndCachingViewController *viewController;

@end

