    //
    //  DetailPageMapViewController.m
    //  VBXL
    //
    //  Created by Wim Vanhenden on 29/07/11.
    //  Copyright 2011 Little Miss Robot. All rights reserved.
    //

#import "DetailPageMapViewController.h"
#import "DetailPageViewController.h"
#import "DetailPageBBViewController.h"
#import "DetailPageCultureViewController.h"
#import "DetailViewBreakfastViewController.h"
#import "DetailPageCitytripsViewController.h"
#import "DetailPageWalksViewController.h"
#import "DetailPageRestoViewController.h"



@implementation DetailPageMapViewController
@synthesize myitem;
@synthesize arrowLeft;
@synthesize arrowRight;

#pragma mark privates


-(void) setItemLocation {
        //location
    CLLocationCoordinate2D firstLocation;
    firstLocation.longitude = [myitem.longitude floatValue];
    firstLocation.latitude  = [myitem.latitude floatValue];
    
    RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"marker-blue.png"]];
    
    [[mapView markerManager] addMarker:marker AtLatLong:firstLocation];
    
    [marker release];
}

-(void) setMarkers {
    
    
    [[mapView markerManager] removeMarkers];
    
    AppData *data = [AppData sharedInstance];
    NSMutableArray *thisarr = [[NSMutableArray alloc] init];
    
    if([rbtnDoSee isSelected]) {
        NSMutableArray *selectedsubs = [[NSMutableArray alloc] init];
        
        for(UIView *subview in [subGroupsFilterView subviews]) {
            if([subview isKindOfClass:[SubGroupButton class]]) {
                SubGroupButton *tempbutt = (SubGroupButton*) subview;
                if ([tempbutt isSelected]) {
                    [selectedsubs addObject:[[tempbutt titleLabel] text]];
                }
            }
        }
        
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:selectedsubs,@"pinDoSee@2x.png" ,nil];
        [thisarr addObject:arr];
        
        [selectedsubs release];
    }
    
    if([rbtnEatDrink isSelected]) {
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:data.subnavigationitemseatanddrink,@"pinEatDrink@2x.png" ,nil];
        [thisarr addObject:arr];
    }
    
    if([rbtnNightLife isSelected]) {
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:data.subnavigationitemsnightlife,@"pinNightLife@2x.png" ,nil];
        [thisarr addObject:arr];
    }
    
    if([rbtnSleep isSelected]) {
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:data.subnavigationitemssleep,@"pinSleep@2x.png" ,nil];
        [thisarr addObject:arr];
    }
    
    
    [LMRMapUtil setMarkers:thisarr ForMap:mapView];
    [thisarr release];    
    [self setItemLocation];
    
}
- (void) tapOnMarker: (RMMarker*) marker onMap: (RMMapView*) map {
    
    Item *item = (Item*)marker.data;
    
    if (item.title) {
        
        
        if ([item.parentgroup isEqualToString:@"BnB"]) {
            DetailPageBBViewController *detailpage = [[DetailPageBBViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageBBViewController"] bundle:nil item:item];
            [detailpage setTitle:item.title];
            [self.navigationController pushViewController:detailpage animated:YES];
            [detailpage release]; 
        }else if ([item.parentgroup isEqualToString:@"CULTURE"]) {
            DetailPageCultureViewController *detailpage = [[DetailPageCultureViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageCultureViewController"] bundle:nil item:item];
            [detailpage setTitle:item.title];
            [self.navigationController pushViewController:detailpage animated:YES];
            [detailpage release]; 
        }else if ([item.parentgroup isEqualToString:@"BREAKFAST"]) {
            DetailViewBreakfastViewController *detailpage = [[DetailViewBreakfastViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageBreakfastViewController"] bundle:nil item:item];
            [detailpage setTitle:item.title];
            [self.navigationController pushViewController:detailpage animated:YES];
            [detailpage release]; 
        }else if ([item.parentgroup isEqualToString:@"CITYTRIP"]) {
            DetailPageCitytripsViewController *detailpage = [[DetailPageCitytripsViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageCitytripsViewController"] bundle:nil item:item];
            [detailpage setTitle:item.title];
            [self.navigationController pushViewController:detailpage animated:YES];
            [detailpage release]; 
        }else if ([item.parentgroup isEqualToString:@"WALK"]) {
            DetailPageWalksViewController *detailpage = [[DetailPageWalksViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageWalksViewController"] bundle:nil item:item];
            [detailpage setTitle:item.title];
            [self.navigationController pushViewController:detailpage animated:YES];
            [detailpage release]; 
        }else if ([item.parentgroup isEqualToString:@"OG_TOUR"]) {
            DetailPageWalksViewController *detailpage = [[DetailPageWalksViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageWalksViewController"] bundle:nil item:item];
            [detailpage setTitle:item.title];
            [self.navigationController pushViewController:detailpage animated:YES];
            [detailpage release]; 
        }else if ([item.parentgroup isEqualToString:@"RESTO"]) {
            DetailPageRestoViewController *detailpage = [[DetailPageRestoViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageRestoViewController"] bundle:nil item:item];
            [detailpage setTitle:item.title];
            [self.navigationController pushViewController:detailpage animated:YES];
            [detailpage release]; 
        }else{
            DetailPageViewController *detailpage = [[DetailPageViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageViewController"] bundle:nil item:item];
            [detailpage setTitle:item.title];
            [self.navigationController pushViewController:detailpage animated:YES];
            [detailpage release];
        }
    }
}

-(void) afterMapTouch:(RMMapView *)map {
    [self setMarkers];
}

-(void)setRadioButtons {
    
    rbtnDoSee = [[CTAButton alloc] initWithImage:NSLocalizedString(@"RBTNDOSEE", nil) andHighlightImage:NSLocalizedString(@"RBTNDOSEE", nil)];
    rbtnEatDrink = [[CTAButton alloc] initWithImage:NSLocalizedString(@"RBTNEATDRINK", nil) andHighlightImage:NSLocalizedString(@"RBTNEATDRINK", nil)];
    rbtnNightLife = [[CTAButton alloc] initWithImage:NSLocalizedString(@"RBTNNIGHTLIFE", nil) andHighlightImage:NSLocalizedString(@"RBTNNIGHTLIFE", nil)];
    rbtnSleep = [[CTAButton alloc] initWithImage:NSLocalizedString(@"RBTNSLEEP", nil) andHighlightImage:NSLocalizedString(@"RBTNSLEEP", nil)];
    
    [rbtnDoSee configSelectedState:NSLocalizedString(@"RBTNDOSEEPRESSED", nil)];
    [rbtnEatDrink configSelectedState:NSLocalizedString(@"RBTNEATDRINKPRESSED", nil)];
    [rbtnNightLife configSelectedState:NSLocalizedString(@"RBTNNIGHTLIFEPRESSED", nil)];
    [rbtnSleep configSelectedState:NSLocalizedString(@"RBTNSLEEPPRESSED", nil)];
    
    [rbtnDoSee addTarget:self action:@selector(setRadioButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [rbtnEatDrink addTarget:self action:@selector(setRadioButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [rbtnNightLife addTarget:self action:@selector(setRadioButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [rbtnSleep addTarget:self action:@selector(setRadioButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    int originX = 19;
    int diffX = 76;
    
    if(isPad){
        originX = 242;
    }
    
    rbtnDoSee.frame = CGRectMake(originX, 16, 58, 55);
    rbtnEatDrink.frame = CGRectMake(originX+diffX, 16, 58, 55);
    rbtnNightLife.frame = CGRectMake(originX+2*diffX, 16, 58, 55);
    rbtnSleep.frame = CGRectMake(originX+3*diffX, 16, 58, 55);
    
    [self.view addSubview:rbtnDoSee];
    [self.view addSubview:rbtnEatDrink];
    [self.view addSubview:rbtnNightLife];
    [self.view addSubview:rbtnSleep];
    
}


-(void) slideSubMenuDoAndSee:(BOOL)hide {
    
    if (hide) {
        [UIView animateWithDuration:0.3
         
                         animations:^{ 
                             if(isPad)
                                 mapView.frame = CGRectMake(9.0f, 82.0f, 750, 850);
                             else
                                 mapView.frame = CGRectMake(9.0f, 82.0f, 302, 318);
                             subGroupDivider.alpha = 0;
                             subGroupsFilterView.alpha = 0;
                             arrowRight.alpha = 0;
                             arrowLeft.alpha = 0;
                         }
         
                         completion:^(BOOL  completed){
                         }
         ];
        
    } else {
        [UIView animateWithDuration:0.3
         
                         animations:^{ 
                             if(isPad)
                                 mapView.frame = CGRectMake(9.0f, 120.0f, 750, 850);
                             else
                                 mapView.frame = CGRectMake(9.0f, 120.0f, 302, 318);
                             subGroupDivider.alpha = 1;
                             subGroupsFilterView.alpha = 1;
                             arrowLeft.alpha = 1;
                             arrowRight.alpha = 1;
                         }
         
                         completion:^(BOOL  completed){
                         }
         ];
    }
    
}


-(void)setRadioButtonSelected:(UIButton *)sender {
    if (sender.selected == YES) {
        [sender setSelected:NO];
        
            //check if subgroup needs to hide
        if (sender == rbtnDoSee) {
            [self slideSubMenuDoAndSee:TRUE];
        }
        
    } else {
        [sender setSelected:YES];
        
            //check if subgroup needs to show
        if (sender == rbtnDoSee) {
            [self slideSubMenuDoAndSee:FALSE];
        }
    }
    [self setMarkers];
}   


-(void)gotoGoogleMaps {
    
    Services *serv = [Services sharedInstance];
    serv.connectedcallback = internetcallback;
    [serv checkIfConnectedToInternet];
}


-(void) connectYes:(NSNotification*)notif {
  
    if ([notif.object isEqualToString:@"YES"]) {
      
        UIApplication *app = [UIApplication sharedApplication];
        NSString *theurl;
        
            theurl = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",controller.locMgr.location.coordinate.latitude, controller.locMgr.location.coordinate.longitude,[myitem.latitude floatValue],[myitem.longitude floatValue]];
       
        
        NSURL *url = [[NSURL alloc] initWithString: theurl];
        
        [app openURL:url];
        
        [url release];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CONINTITLE", nil) message:NSLocalizedString(@"CONINMESSAGE", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}



-(void)configRoute {
        //set route button
    CTAButton  *btnList = [[CTAButton alloc] initWithImage:@"btnRouteMapView" andHighlightImage:@"btnRouteMapViewPressed"];
    [btnList addTarget:self action:@selector(gotoGoogleMaps)forControlEvents:UIControlEventTouchUpInside];
        //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnList];
    self.navigationItem.rightBarButtonItem = customBarItemRight;
    [customBarItemRight release];
    [btnList release];

    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andItem:(Item*)incitem {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
        self.myitem = incitem;
        
        internetcallback = [NSString stringWithString:(NSString*)[DeHTMLFormatter genRandStringLength:20]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectYes:) name:internetcallback object:nil];
        
        controller = [[CoreLocationController alloc] init];
        [controller.locMgr startUpdatingLocation];

    }
    return self;
}

- (void)dealloc {
    
    if (self.navigationItem.rightBarButtonItem) {
        
        CTAButton *button = (CTAButton*) self.navigationItem.rightBarButtonItem.customView;
        
        [button removeTarget:self action:@selector(gotoGoogleMaps) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:internetcallback object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [controller.locMgr stopUpdatingHeading];
    [controller release];
    [rbtnDoSee release];
    [rbtnSleep release];
    [rbtnEatDrink release];
    [rbtnNightLife release];
    [mapView release];
    [self.myitem release];
    [btnBack release];
    
    [subGroupDivider release];
    [subGroupsFilterView release];
    [arrowLeft release];
    [arrowRight release];
        //[internetcallback release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
        // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
        // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    
    
    [self configRoute];
    [self configNavBar];
    
        //location
    CLLocationCoordinate2D firstLocation;
    firstLocation.longitude = [myitem.longitude floatValue];
    firstLocation.latitude  = [myitem.latitude floatValue];
    
    if(isPad)
        mapView = [[RMMapView alloc] initWithFrame:CGRectMake(9.0f, 82.0f, 750, 850)];
    else
        mapView = [[RMMapView alloc] initWithFrame:CGRectMake(9.0f, 82.0f, 302, 318)];
    mapView.delegate = self;
    id <RMTileSource> tileSource = [[RMDBMapSource alloc] initWithPath:@"mapofbrussel.db"] ;
    
	RMMapContents *rmcontents = [[RMMapContents alloc] initWithView:mapView tilesource:tileSource]; 
	
	[rmcontents setTileSource:tileSource];
    
    [rmcontents setMinZoom:12.0f];
    [rmcontents setMaxZoom:17.0f];
    [rmcontents setZoom:16.0f];
    
    [rmcontents setMapCenter:firstLocation];
    
    RMMarkerManager *manager = [[RMMarkerManager alloc] initWithContents:[mapView contents]];
    
    RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"marker-blue.png"]];
    
    [manager addMarker:marker AtLatLong:firstLocation];
    [rmcontents release];
    
    [tileSource release];
    [manager release];
    
    [marker release];
    
    [self.view addSubview:mapView];
    
    [self setRadioButtons];
    
    
    //subgroups dosee + divider
    
    subGroupDivider = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, 301, 2)];
    subGroupDivider.image = [UIImage imageNamed:@"aroundMeSubDivider.png"];
    [self.view addSubview:subGroupDivider];
    subGroupDivider.alpha = 0;
    
    AppData *data = [AppData sharedInstance];
    
    arrowLeft = [[UIImageView alloc] initWithFrame:CGRectMake(10, 95, 17, 12)];
    arrowLeft.image = [UIImage imageNamed:@"arrowDoSeeFilterLeft"];
    [self.view addSubview:arrowLeft];
    arrowLeft.alpha = 0;
    
    if(isPad)
        arrowRight = [[UIImageView alloc] initWithFrame:CGRectMake(741, 95, 17, 12)];
    else
        arrowRight = [[UIImageView alloc] initWithFrame:CGRectMake(293, 95, 17, 12)];
    arrowRight.image = [UIImage imageNamed:@"arrowDoSeeFilterRight"];
    [self.view addSubview:arrowRight];
    arrowRight.alpha = 0;
    
    if(isPad)
        subGroupsFilterView = [[UIScrollView alloc]initWithFrame:CGRectMake(30, 80, 708, 40)];
    else
        subGroupsFilterView = [[UIScrollView alloc]initWithFrame:CGRectMake(30, 80, 260, 40)];
    [subGroupsFilterView setContentSize:CGSizeMake(800, 40)];
    subGroupsFilterView.backgroundColor = [UIColor clearColor];
    subGroupsFilterView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:subGroupsFilterView];
    subGroupsFilterView.alpha = 0;
    
    int takenWidth = 0;
    for(int i = 0; i<[data.subnavigationitemsdoandsee count];i++)
        {
            // add to a view   
        SubGroupButton *myButton = [[SubGroupButton alloc] initWithTitle:[data.subnavigationitemsdoandsee objectAtIndex:i]];
        
        myButton.frame = CGRectMake(takenWidth, 0, myButton.frame.size.width, myButton.frame.size.height);
        takenWidth = takenWidth + myButton.frame.size.width + 20;
        
        if (i==1) {
            myButton.selected = TRUE;
        }
        [subGroupsFilterView addSubview:myButton];
        [myButton addTarget:self action:@selector(subGroupClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [myButton release];
        }
    
    [subGroupsFilterView setContentSize:CGSizeMake(takenWidth + 10, 40)];
    
  
    [super viewDidLoad];
    
}

-(void)subGroupClicked:(id)sender {
    
    SubGroupButton *buttonClicked = (SubGroupButton *)sender; 
    
    if (buttonClicked.selected == TRUE) {
        buttonClicked.selected = FALSE;
    }else{
        buttonClicked.selected = TRUE;
    }
    
    [self setMarkers];
    
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

-(void)backToHome {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
