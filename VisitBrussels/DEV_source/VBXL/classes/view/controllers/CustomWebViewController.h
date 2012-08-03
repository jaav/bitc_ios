//
//  CustomWebViewController.h
//  VBXL
//
//  Created by Wim Vanhenden on 10/08/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackButton.h"

@interface CustomWebViewController : UIViewController <UIWebViewDelegate>{
    UIWebView *myview;
    NSString *myurl;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil anURL:(NSString*)incurl;

@end
