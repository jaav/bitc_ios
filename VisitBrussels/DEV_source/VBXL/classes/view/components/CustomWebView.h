//
//  CustomWebView.h
//  TwoWayScrollingMechanics
//
//  Created by Wim Vanhenden on 16/08/10.
//  Copyright 2010 Little Miss Robot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface CustomWebView : UIView <UIWebViewDelegate, UIAlertViewDelegate> {
	int mycurrentorientation;
	UIWebView *myview;
	UINavigationBar *bar;
	NSString *internetReachability;
	NSTimer *repeatingTimer;
	BOOL gotInternet;
    
    NSString *myurl;
}
@property (assign) NSTimer *repeatingTimer;
- (id)initWithFrame:(CGRect)frame andURL:(NSString*)incurl;
- (BOOL)checkInternet;
- (void) startWebKit:(NSString*)incurl;
- (void) startTimer:(int)time;
- (void) stopTimer;
- (void) closeThisView: (id) sender;

@end
