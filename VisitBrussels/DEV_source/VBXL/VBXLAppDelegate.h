//
//  VBXLAppDelegate.h
//  VBXL
//
//  Created by Thomas Joos on 04/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VBXLViewController;

@interface VBXLAppDelegate : NSObject <UIApplicationDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet VBXLViewController *viewController;

@end
