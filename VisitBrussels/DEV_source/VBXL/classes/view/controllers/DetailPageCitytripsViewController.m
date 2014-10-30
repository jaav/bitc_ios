//
//  DetailPageViewController.m
//  VBXL
//
//  Created by Thomas Joos on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailPageCitytripsViewController.h"

//custom navbar shizzle
@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed: @"navBarBlue.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

@implementation DetailPageCitytripsViewController
@synthesize poiTitle;
@synthesize poiAdress;
@synthesize poiCity;


@synthesize myitem;
@synthesize btnBack;
@synthesize btnMap;
@synthesize btnSite;
@synthesize btnCall;

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
}

-(void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setDetailContent {
    
    scrollView.backgroundColor = [UIColor clearColor];
    
    self.poiTitle.text = self.myitem.title;
    self.poiAdress.text = self.myitem.address;
    self.poiCity.text = [NSString stringWithFormat:@"%i %@",self.myitem.zipcode,self.myitem.city];
    
    NSString *texttoparse = self.myitem.body;
    texttoparse = [DeHTMLFormatter stripTags:texttoparse];
    texttoparse = [DeHTMLFormatter stripGoogleAnalytics:texttoparse];
    texttoparse = [DeHTMLFormatter replaceSpecialCharacters:texttoparse];

    textview.text = texttoparse;
    
    NSDictionary *options = @{ NSFontAttributeName: textview.font };
    CGRect frame = textview.frame;
    CGRect boundingRect = [textview.text boundingRectWithSize:CGSizeMake(285.0, NSIntegerMax)
                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                   attributes:options context:nil];
    frame.size.height = boundingRect.size.height + 44;
    [textview setFrame:frame];
    
    if(isPad){
        int scrollHeight = textview.frame.origin.y + textview.frame.size.height;
        
        if(scrollHeight > self.view.frame.size.height) {
            [scrollView setContentSize:CGSizeMake(768, scrollHeight)];
        }
    }else{
        int scrollHeight = 100 + textview.frame.size.height;
        
        if(scrollHeight > 436) {
            [scrollView setContentSize:CGSizeMake(320, scrollHeight)];
        }
        else{
            [scrollView setContentSize:CGSizeMake(320, 416)];
        }
    }
    
    if(isPad && ![self.myitem.bigimagefilename isEqualToString:@""] && self.myitem.bigimagefilename != NULL){
        UIImage *myimage = [UIImage imageNamed:self.myitem.bigimagefilename];
        if(myimage) {
            //take local image
            [imageView setImage:myimage];
        } else {
            myimage = [UIImage imageWithContentsOfFile:[self.myitem bigImageCacheFilePath]];
            
            if(myimage){
                [imageView setImage:myimage];
            }else{
                //download image
                NSURL *myurl = [NSURL URLWithString:self.myitem.bigimage];
                [imageView setImageWithURL:myurl placeholderImage:[UIImage imageNamed:@"imagePlaceholder"]];
            }
        }
    }
    else if (![self.myitem.imagefilename isEqualToString:@""] && self.myitem.imagefilename != NULL) {
        UIImage *myimage = [UIImage imageNamed:self.myitem.imagefilename];
        if(myimage) {
            //take local image
            [imageView setImage:myimage];
        } else {
            myimage = [UIImage imageWithContentsOfFile:[self.myitem imageCacheFilePath]];
            
            if(myimage){
                [imageView setImage:myimage];
            }else{
                //download image
                NSURL *myurl = [NSURL URLWithString:self.myitem.smallimage];
                [imageView setImageWithURL:myurl placeholderImage:[UIImage imageNamed:@"imagePlaceholder"]];
            }
        }
    } else {
        NSLog(@"no image found");
        [imageView setImage:[UIImage imageNamed:@"imagePlaceholder.png"]];
    }

    
    //cta buttons
    NSMutableArray *btnArray = [[NSMutableArray alloc] init];

    if (![myitem.website isEqualToString:@""] && myitem.website != NULL) {
        
        btnSite = [[CTAButton alloc] initWithImage:@"btnSite" andHighlightImage:@"btnSitePressed"];
        [btnSite addTarget:self action:@selector(gotoSite)forControlEvents:UIControlEventTouchUpInside];
        [btnArray addObject:btnSite];
    }
    
    if (![myitem.phone isEqualToString:@""] && myitem.phone != NULL) {
        btnCall = [[CTAButton alloc] initWithImage:@"btnCall" andHighlightImage:@"btnCallPressed"];
        [btnCall addTarget:self action:@selector(callMe)forControlEvents:UIControlEventTouchUpInside];
        [btnArray addObject:btnCall];
    }
    
    for (int i=0; i<[btnArray count]; i++) {
        UIButton *theButton = [btnArray objectAtIndex:i];
        [scrollView addSubview:theButton];
        if(!isPad)
            theButton.frame = CGRectMake((20+(i*75)), self.poiTitle.frame.origin.y+35, 64, 30);
        else
            theButton.frame = CGRectMake((20+(i*75)), self.poiTitle.frame.origin.y+55, 64, 30);
    }
}


-(void)gotoSite {
    
    CustomWebViewController *webview = [[CustomWebViewController alloc] initWithNibName:[DataController adjustedNibName:@"CustomWebViewController"] bundle:nil anURL: [DeHTMLFormatter reformatURLForBookingDotCom:myitem.website]];
    [webview setTitle:@"Browser"];
    [self.navigationController pushViewController:webview animated:YES];

}

-(void)callMe {
    
    NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",myitem.phone];
    NSURL *phoneURL = [NSURL URLWithString: [phoneStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    [[UIApplication sharedApplication] openURL:phoneURL];
}

@end
