//
//  HTTPAndCachingViewController.h
//  HTTPAndCaching
//
//  Created by Wim Vanhenden on 07/12/10.
//  Copyright 2010 Little Miss Robot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface HTTPAndCachingViewController : UIViewController {
	ASIHTTPRequest *request;
	UIProgressView *progress;
}

@end

