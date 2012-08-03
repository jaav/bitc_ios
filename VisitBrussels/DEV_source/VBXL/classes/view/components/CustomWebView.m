//
//  CustomWebView.m
//  TwoWayScrollingMechanics
//
//  Created by Wim Vanhenden on 16/08/10.
//  Copyright 2010 Little Miss Robot. All rights reserved.
//

#import "CustomWebView.h"

@implementation CustomWebView

@synthesize repeatingTimer;


-(void)animationIsIn {
    
    gotInternet = [self checkInternet];
    
    if ( gotInternet == 0) {
        [self startTimer:2];
        
    } else {
        [self startWebKit:myurl];
    }
    
    
}

- (id)initWithFrame:(CGRect)frame andURL:(NSString*)incurl{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        
        
        UIImageView *bgr = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height)];
        
        bgr.image = [UIImage imageNamed:@"bgClear.png"];
        bgr.backgroundColor = [UIColor redColor];
        
        [self addSubview:bgr];
    
        [bgr release];
        
		myurl = incurl;
        
        /*
		UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[indicator startAnimating];
		indicator.frame = CGRectMake(10, 10, 20, 20);
		[self addSubview:indicator];
		[indicator release];*/	
		
		myview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height)];
		myview.alpha = 0;
		myview.delegate = self;
		[self addSubview:myview];

		bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
		[self addSubview:bar];
		
		UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Terug" style:UIBarButtonItemStyleBordered target:self action:@selector(closeThisView:)];
		UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Browser"];
		item.leftBarButtonItem = rightButton;
		[bar pushNavigationItem:item animated:YES];
		[rightButton release];
		[item release];
        
        CGRect frameto = self.frame;
        
        CGRect framefrom = CGRectMake(0, self.frame.size.height, self.frame.size.width,self.frame.size.height);
		
        self.frame = framefrom;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationIsIn)];
        self.frame = frameto;
        [UIView commitAnimations];
    
	}
    return self;
}


-(void) startTimer:(int)time {
	[self stopTimer];
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:NO];
    self.repeatingTimer = timer;
}

-(void) stopTimer {
	[repeatingTimer invalidate];
    self.repeatingTimer = nil;
	[repeatingTimer release];
}

-(void)timerFireMethod:(NSTimer*)theTimer {
	[self stopTimer];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connectie" 
														message:@"Je bent niet verbonden met het internet"
													   delegate:self 
											  cancelButtonTitle:@"Ok" 
											  otherButtonTitles:nil, nil];
	
	alertView.delegate = self;
	[alertView show];
	[alertView release];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	[self closeThisView:nil];
}


-(void) startWebKit:(NSString*)incurl {
	 NSString *urlAddress = incurl;
	 NSURL *url = [NSURL URLWithString:urlAddress];
	 NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	 [myview loadRequest:requestObj];
	 //[urlAddress release];
}

-(void) webViewDidFinishLoad:(UIWebView*)webview {
	myview.delegate = nil;
	myview.alpha=0;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0f];
	myview.alpha = 1;
	[UIView commitAnimations];
}

- (void) closeThisView: (id) sender {
	[self stopTimer];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(someAnimationDidStop:)];
	self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width,self.frame.size.height);
	[UIView commitAnimations];
}

- (void) someAnimationDidStop:(id)sender {
    [UIView setAnimationDelegate:nil];
	[self removeFromSuperview];
}

-(BOOL)checkInternet{
	//Test for Internet Connection
	Reachability *r = [Reachability reachabilityWithHostName:@"finance.yahoo.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	myview.delegate = nil;
	[self stopTimer];
	[bar release];
	[myview release];	
    [super dealloc];
}

@end

