//
//  CustomWebViewController.m
//  VBXL
//
//  Created by Wim Vanhenden on 10/08/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//

#import "CustomWebViewController.h"


@implementation CustomWebViewController


-(void) startWebKit:(NSString*)incurl {
    NSString *urlAddress = incurl;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [myview loadRequest:requestObj];

}

-(void)configNavBar {
    
    //back button
    BackButton *btnBack = [[BackButton alloc] init];
    [btnBack addTarget:self action:@selector(backToHome)forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = customBarItem;
    [customBarItem release];
    
    [btnBack release];
    
}

-(void) webViewDidStartLoad:(UIWebView *)webView {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void) webViewDidFinishLoad:(UIWebView*)webview {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	myview.alpha=0;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0f];
	myview.alpha = 1;
	[UIView commitAnimations];
}

-(void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)configWebView {
    
    myview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height))];
    myview.alpha = 0;
    myview.delegate = self;
    [self.view addSubview:myview];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil anURL:(NSString*)incurl  {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myurl = incurl;
        
    }
    return self;
}

- (void)dealloc {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        
        NSString *mydomain = [NSString stringWithString:cookie.domain];
        NSRange aRange = [mydomain rangeOfString:@"booking.com"];
        if (aRange.location != NSNotFound) {
                [storage deleteCookie:cookie];
        } 
        
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	myview.delegate = nil;
    [myview release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavBar];
    
    [self configWebView];
    
    [self startWebKit:myurl];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
