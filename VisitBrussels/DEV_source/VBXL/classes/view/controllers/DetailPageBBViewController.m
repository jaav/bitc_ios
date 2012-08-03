//
//  DetailPageBBViewController.m
//  VBXL
//
//  Created by Thomas Joos on 17/08/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//

#import "DetailPageBBViewController.h"

//custom navbar shizzle
@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed: @"navBarBlue.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end


@implementation DetailPageBBViewController

@synthesize poiTitle;
@synthesize poiAdress;
@synthesize poiCity;
@synthesize poiPrice;


@synthesize myitem;
@synthesize btnBack;
@synthesize btnMap;
@synthesize btnSite;
@synthesize btnCall;



- (NSString *) stripTags:(NSString *)str
{
    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSString *tempText = nil;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:&tempText];
        
        if (tempText != nil)
            [html appendString:tempText];
        
        [scanner scanUpToString:@">" intoString:NULL];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + 1];
        
        tempText = nil;
    }
    
    return html;
}


#pragma mark - Init and Memory Management Methods

-(id)initWithNibNameAndItem:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil item:(Item *)item
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.myitem = item;
    }
    return self;
}

- (void)dealloc
{
    [scrollView release];
    [textview release];
    [imageView release];
    
    [self.poiTitle release];
    [self.poiAdress release];
    [self.poiCity release];
    [self.poiPrice release];
    [self.myitem release];
    [self.btnBack release];
    [btnCall release];
    [btnMap release];
    [btnSite release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self.poiTitle release];
    [self.poiAdress release];
    [self.poiCity  release];
    [self.poiPrice release];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavBar];
    [self setDetailContent];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Config Methods
-(void)configNavBar {
    //back button
    btnBack = [[BackButton alloc] init];
    [btnBack addTarget:self action:@selector(backToHome)forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    [customBarItem release];
}

-(void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setDetailContent {
    
    NSLog(@"set detail content for bnb");
    NSLog(@"price: %i", self.myitem.price);
    
    scrollView.backgroundColor = [UIColor clearColor];
    
    self.poiTitle.text = self.myitem.title;
    self.poiAdress.text = self.myitem.address;
    self.poiCity.text = self.myitem.city;
    self.poiPrice.text = [NSString stringWithFormat:@"%@ %i%@", NSLocalizedString(@"PRICEFROM", nil), self.myitem.price, NSLocalizedString(@"EACHNIGHT", nil)];
    
    textview.text = [self stripTags:self.myitem.body];
    
    CGRect frame = textview.frame;
    frame.size.height = textview.contentSize.height;
    textview.frame = frame;
    
    int scrollHeight = 310 + textview.frame.size.height;
    
    if(scrollHeight > 436) {
        [scrollView setContentSize:CGSizeMake(320, scrollHeight)]; 
    }
    else{
        [scrollView setContentSize:CGSizeMake(320, 416)]; 
    }
    
    [imageView setImageWithURL:[NSURL URLWithString:self.myitem.smallimage]
              placeholderImage:[UIImage imageNamed:@"imagePlaceholder.png"]];
    
    if (myitem.latitude != NULL) {
        btnMap = [[CTAButton alloc] initWithImage:@"btnMap" andHighlightImage:@"btnMapPressed"];
        [btnMap addTarget:self action:@selector(gotoMap)forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btnMap];
        btnMap.frame = CGRectMake(20, imageView.frame.origin.y+imageView.frame.size.height+15, 64, 30);
    }
    
    if (![myitem.website isEqualToString:@""] && myitem.website != NULL) {
        
        btnSite = [[CTAButton alloc] initWithImage:@"btnSite" andHighlightImage:@"btnSitePressed"];
        [btnSite addTarget:self action:@selector(gotoSite)forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btnSite];
        btnSite.frame = CGRectMake(95, imageView.frame.origin.y+imageView.frame.size.height+15, 64, 30);
    }
    
    if (![myitem.phone isEqualToString:@""] && myitem.phone != NULL) {
        btnCall = [[CTAButton alloc] initWithImage:@"btnCall" andHighlightImage:@"btnCallPressed"];
        [btnCall addTarget:self action:@selector(callMe)forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btnCall];
        btnCall.frame = CGRectMake(170, imageView.frame.origin.y+imageView.frame.size.height+15, 64, 30);
    }
    
}

-(void)gotoMap
{
    DetailPageMapViewController *detailpage = [[DetailPageMapViewController alloc] initWithNibName:@"DetailPageMapViewController" bundle:nil andItem:self.myitem];
    [detailpage setTitle:self.title];
    [self.navigationController pushViewController:detailpage animated:YES];
    [detailpage release];
    
}

-(void)gotoSite {
    
    NSString *myurl = [NSString stringWithString:myitem.website];
    NSRange aRange = [myurl rangeOfString:@"booking"];
    if (aRange.location == NSNotFound) {
    } else {
        
        myurl = [myurl stringByReplacingOccurrencesOfString:@"www." withString:@"m."];
    }
    
    CustomWebViewController *webview = [[CustomWebViewController alloc] initWithNibName:@"CustomWebViewController" bundle:nil anURL:myurl];
    [webview setTitle:@"Browser"];
    [self.navigationController pushViewController:webview animated:YES];
    [webview release];
}

-(void)callMe {
    
    NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",myitem.phone];
    NSURL *phoneURL = [NSURL URLWithString: [phoneStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    [[UIApplication sharedApplication] openURL:phoneURL];
    [phoneStr release];
}

@end
