//
//  HTTPAndCachingViewController.m
//  HTTPAndCaching
//
//  Created by Wim Vanhenden on 07/12/10.
//  Copyright 2010 Little Miss Robot. All rights reserved.
//

#import "HTTPAndCachingViewController.h"

@implementation HTTPAndCachingViewController


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// Use when fetching text data
	//NSString *responseString = [request responseString];
	
	// Use when fetching binary data
	//NSData *responseData = [request responseData];
	
	
	UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 250, 768, 1004)];
	
	NSString *urlAddress = NSHomeDirectory();
	
	NSString *s = 
	[NSString stringWithFormat:@"homeDir:\n"
	 @"%@\n"
	 @"tempDir:\n"
	 @"%@\n"
	 @"docDir:\n"
	 @"%@\n"
	 @"myFilePath:\n"
	 @"%@\n",
	 urlAddress,
	 urlAddress,
	 urlAddress,
	 urlAddress];	
	
	NSLog(@"%@",s);
	
	webView.scalesPageToFit = YES;
	
	NSURL *url = [NSURL fileURLWithPath:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[webView loadRequest:requestObj];
	
	[self.view addSubview:webView];
	
	

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSLog(@"%@",@"failed");
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	//set the position of the button
	button.frame = CGRectMake(100, 170, 100, 30);
	
	[button setTitle:@"Click Me!" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(buttonPressed) 
	 forControlEvents:UIControlEventTouchUpInside];	
	//add the button to the view
	[self.view addSubview:button];
	
	progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	progress.frame = CGRectMake(100, 100, progress.frame.size.width, progress.frame.size.height);
	[self.view addSubview:progress];

}
-(void)buttonPressed {
	NSLog(@"Button Pressed!");
    
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // Write out the contents of home directory to console
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);    
    
	request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://www.littlemissrobot.com/ugent/test.pdf"]];
	[request setDownloadCache:[ASIDownloadCache sharedCache]];
	[request setDownloadProgressDelegate:progress];
	[request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"test.pdf"]];
	[request setDelegate:self];
	[request startSynchronous];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
