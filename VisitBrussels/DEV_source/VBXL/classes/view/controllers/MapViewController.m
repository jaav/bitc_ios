//
//  MapViewController.m
//  VBXL
//
//  Created by Thomas Joos on 14/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

//custom navbar shizzle
@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed:[DataController adjustedImageName:@"navBarBlue.png"]];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

@implementation MapViewController
@synthesize btnBack;
@synthesize rbtnDoSee;
@synthesize rbtnSleep;
@synthesize rbtnEatDrink;
@synthesize rbtnNightLife;
@synthesize subGroupDivider;
@synthesize subGroupsFilterView;
@synthesize arrowLeft;
@synthesize arrowRight;


#pragma mark - Init and Memory Management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"map recieved memory warning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    viewopenedfirsttime = TRUE;
    // Do any additional setup after loading the view from its nib.
    [self configNavBar];
    [self setRadioButtons];

    controller = [[CoreLocationController alloc] init];
	controller.delegate = self;

        //[controller.locMgr setDistanceFilter:kCLDistanceFilterNone];
        //[controller.locMgr setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [controller.locMgr startUpdatingLocation];
    
        //First set the map
    if(isPad)
        mapView = [[RMMapView alloc] initWithFrame:CGRectMake(9.0f, 185.0f, 750, 770)];
    else
        mapView = [[RMMapView alloc] initWithFrame:CGRectMake(9.0f, 135.0f, 302, 318)];
    mapView.delegate  = self;
    id <RMTileSource> tileSource = [[RMDBMapSource alloc] initWithPath:@"mapofbrussel.db"] ;
	RMMapContents *rmcontents = [[RMMapContents alloc] initWithView:mapView tilesource:tileSource]; 
	[rmcontents setTileSource:tileSource];
    [rmcontents setMinZoom:11.0f];
    [rmcontents setMaxZoom:17.0f];
    
    if(isPad)
        [rmcontents setZoom:13.0f];
    else
        [rmcontents setZoom:11.0f];
    
    
    //Set the map to the center of Brussels
    CLLocationCoordinate2D centerofBrussels;
    centerofBrussels.longitude = 4.35045;
    centerofBrussels.latitude  = 50.845902;
    [rmcontents setMapCenter:centerofBrussels];
    
        [self.view addSubview:mapView]; 
        [self setSubGroups];
    
         [super viewDidLoad];
    }

-(void) setSubGroups {
    //subgroups dosee + divider
    
    int multiplier = isPad?2:1;
    
    subGroupDivider = [[UIImageView alloc] initWithFrame:CGRectMake(10, 120, 301, 2)];
    subGroupDivider.image = [UIImage imageNamed:@"aroundMeSubDivider.png"];
    [self.view addSubview:subGroupDivider];
    self.subGroupDivider.alpha = 0;
    AppData *data = [AppData sharedInstance];
    
    if(isPad)
        arrowLeft = [[UIImageView alloc] initWithFrame:CGRectMake(10, 185, 17*multiplier, 12*multiplier)];
    else
        arrowLeft = [[UIImageView alloc] initWithFrame:CGRectMake(10, 140, 17*multiplier, 12*multiplier)];
    
    arrowLeft.image = [UIImage imageNamed:[DataController adjustedImageName:@"arrowDoSeeFilterLeft.png"]];
    [self.view addSubview:arrowLeft];
    arrowLeft.alpha = 0;
    
    if(isPad)
        arrowRight = [[UIImageView alloc] initWithFrame:CGRectMake(721, 185, 17*multiplier, 12*multiplier)];
    else
        arrowRight = [[UIImageView alloc] initWithFrame:CGRectMake(293, 140, 17, 12)];
    arrowRight.image = [UIImage imageNamed:[DataController adjustedImageName:@"arrowDoSeeFilterRight.png"]];
    [self.view addSubview:arrowRight];
    arrowRight.alpha = 0;
    
    if(isPad)
        self.subGroupsFilterView = [[UIScrollView alloc]initWithFrame:CGRectMake(44, 180, 678, 40)];
    else
        self.subGroupsFilterView = [[UIScrollView alloc]initWithFrame:CGRectMake(30, 127, 260, 40)];
    
    [subGroupsFilterView setContentSize:CGSizeMake(800, 40)];
    subGroupsFilterView.backgroundColor = [UIColor clearColor];
    subGroupsFilterView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:subGroupsFilterView];
    
    self.subGroupsFilterView.alpha = 0;
    
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
        [self.subGroupsFilterView addSubview:myButton];
        [myButton addTarget:self action:@selector(subGroupClicked:) forControlEvents:UIControlEventTouchUpInside];

        }
    
    [subGroupsFilterView setContentSize:CGSizeMake(takenWidth + 10, 40)];
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
-(NSMutableArray*) returnMarkersItemsOnScreen {
    
    NSArray *myarr  = [[mapView markerManager] markersWithinScreenBounds];
    NSMutableArray *returnarr = [[NSMutableArray alloc] init ];
    for (int i=0; i<[myarr count]; i++) {
        Item *myitem = (Item*)[[myarr objectAtIndex:i] data];
        
        if (myitem.title) {
        
            [returnarr addObject:myitem];
        }
    }
    
    return returnarr;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Config methods
-(void)configNavBar {
    //back button
    btnBack = [[BackButton alloc] init];
    [btnBack addTarget:self action:@selector(backToHome)forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
}

-(void) removeListButton {
    if (self.navigationItem.rightBarButtonItem) {
         
        CTAButton *button = (CTAButton*) self.navigationItem.rightBarButtonItem.customView;
        
        [button removeTarget:self action:@selector(showList) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void) showList {
    POITableViewController *poiViewController = [[POITableViewController alloc] initWithNibName:[DataController adjustedNibName:@"POITableViewController"] bundle:nil];
    [self.navigationController pushViewController:poiViewController animated:YES];
    
    [poiViewController setDataSet:  [self returnMarkersItemsOnScreen]];
}

-(void) setListButton {
    
    //list button
    CTAButton  *btnList = [[CTAButton alloc] initWithImage:@"btnList" andHighlightImage:@"btnListPressed"];
    [btnList addTarget:self action:@selector(showList)forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnList];
    self.navigationItem.rightBarButtonItem = customBarItemRight;
}

-(void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setRadioButtons
{
    //buttons
    
    rbtnDoSee = [[CTAButton alloc] initWithImage:[DataController adjustedImageName:NSLocalizedString(@"RBTNDOSEE", nil)] andHighlightImage:[DataController adjustedImageName:NSLocalizedString(@"RBTNDOSEE", nil)]];
    rbtnEatDrink = [[CTAButton alloc] initWithImage:[DataController adjustedImageName:NSLocalizedString(@"RBTNEATDRINK", nil)] andHighlightImage:[DataController adjustedImageName:NSLocalizedString(@"RBTNEATDRINK", nil)]];
    rbtnNightLife = [[CTAButton alloc] initWithImage:[DataController adjustedImageName:NSLocalizedString(@"RBTNNIGHTLIFE", nil)] andHighlightImage:[DataController adjustedImageName:NSLocalizedString(@"RBTNNIGHTLIFE", nil)]];
    rbtnSleep = [[CTAButton alloc] initWithImage:[DataController adjustedImageName:NSLocalizedString(@"RBTNSLEEP", nil)] andHighlightImage:[DataController adjustedImageName:NSLocalizedString(@"RBTNSLEEP", nil)]];
    
    [rbtnDoSee configSelectedState:[DataController adjustedImageName:NSLocalizedString(@"RBTNDOSEEPRESSED", nil)]];
    [rbtnEatDrink configSelectedState:[DataController adjustedImageName:NSLocalizedString(@"RBTNEATDRINKPRESSED", nil)]];
    [rbtnNightLife configSelectedState:[DataController adjustedImageName:NSLocalizedString(@"RBTNNIGHTLIFEPRESSED", nil)]];
    [rbtnSleep configSelectedState:[DataController adjustedImageName:NSLocalizedString(@"RBTNSLEEPPRESSED", nil)]];
    
    [rbtnDoSee addTarget:self action:@selector(setRadioButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [rbtnEatDrink addTarget:self action:@selector(setRadioButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [rbtnNightLife addTarget:self action:@selector(setRadioButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [rbtnSleep addTarget:self action:@selector(setRadioButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    int originX = 19;
    int diffX = 76;
    
    if(isPad){
        originX = 100;
        diffX = 152;
    }
    
    int multiplier = isPad?2:1;
    
    rbtnDoSee.frame = CGRectMake(originX, 72, 58*multiplier, 55*multiplier);
    rbtnEatDrink.frame = CGRectMake(originX+diffX, 72, 58*multiplier, 55*multiplier);
    rbtnNightLife.frame = CGRectMake(originX+2*diffX, 72, 58*multiplier, 55*multiplier);
    rbtnSleep.frame = CGRectMake(originX+3*diffX, 72, 58*multiplier, 55*multiplier);
    
    [self.view addSubview:rbtnDoSee];
    [self.view addSubview:rbtnEatDrink];
    [self.view addSubview:rbtnNightLife];
    [self.view addSubview:rbtnSleep];
    
}

- (void) tapOnMarker: (RMMarker*) marker onMap: (RMMapView*) map {
    
    Item *item = (Item*)marker.data;
    
    if (item.title) {
   
    if ([item.parentgroup isEqualToString:@"BnB"]) {
        DetailPageBBViewController *detailpage = [[DetailPageBBViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageBBViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }else if ([item.parentgroup isEqualToString:@"CULTURE"]) {
        DetailPageCultureViewController *detailpage = [[DetailPageCultureViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageCultureViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }else if ([item.parentgroup isEqualToString:@"BREAKFAST"]) {
        DetailViewBreakfastViewController *detailpage = [[DetailViewBreakfastViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageBreakfastViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }else if ([item.parentgroup isEqualToString:@"CITYTRIP"]) {
        DetailPageCitytripsViewController *detailpage = [[DetailPageCitytripsViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageCitytripsViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }else if ([item.parentgroup isEqualToString:@"WALK"]) {
        DetailPageWalksViewController *detailpage = [[DetailPageWalksViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageWalksViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }else if ([item.parentgroup isEqualToString:@"OG_TOUR"]) {
        DetailPageWalksViewController *detailpage = [[DetailPageWalksViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageWalksViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }else if ([item.parentgroup isEqualToString:@"RESTO"]) {
        DetailPageRestoViewController *detailpage = [[DetailPageRestoViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageRestoViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }else{
        DetailPageViewController *detailpage = [[DetailPageViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }
    }

}

-(void) afterMapTouch:(RMMapView *)map {
    [self setMarkers];
}

-(void) setItemLocation {
        //location
        //check current location

    currentLocation.longitude = controller.locMgr.location.coordinate.longitude;
    currentLocation.latitude  = controller.locMgr.location.coordinate.latitude;
    
    RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"marker-blue.png"]];
    
    [[mapView markerManager] addMarker:marker AtLatLong:currentLocation];
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
        
        /*if(isPad)
            [thisarr addObject:[NSMutableArray arrayWithObjects:selectedsubs,@"pinDoSee_iPad@2x.png" ,nil]];
        else*/
            [thisarr addObject:[NSMutableArray arrayWithObjects:selectedsubs,@"pinDoSee@2x.png" ,nil]];
    }
    
    if([rbtnEatDrink isSelected]) {
        /*if(isPad)
            [thisarr addObject:[NSMutableArray arrayWithObjects:data.subnavigationitemseatanddrink,@"pinEatDrink_iPad@2x.png" ,nil]];
        else*/
            [thisarr addObject:[NSMutableArray arrayWithObjects:data.subnavigationitemseatanddrink,@"pinEatDrink@2x.png" ,nil]];
    }
    
    if([rbtnNightLife isSelected]) {
        /*if(isPad)
            [thisarr addObject:[NSMutableArray arrayWithObjects:data.subnavigationitemsnightlife,@"pinNightLife_iPad@2x.png" ,nil]];
        else*/
            [thisarr addObject:[NSMutableArray arrayWithObjects:data.subnavigationitemsnightlife,@"pinNightLife@2x.png" ,nil]];
    }
    
    if([rbtnSleep isSelected]) {
        /*if(isPad)
            [thisarr addObject:[NSMutableArray arrayWithObjects:data.subnavigationitemssleep,@"pinSleep_iPad@2x.png" ,nil]];
        else*/
            [thisarr addObject:[NSMutableArray arrayWithObjects:data.subnavigationitemssleep,@"pinSleep@2x.png" ,nil]];
    }
    
    if ([thisarr count] >0) {
        [self setListButton];
    } else {
        [self removeListButton];
    }
    
    [LMRMapUtil setMarkers:thisarr ForMap:mapView];
    [self setItemLocation];
}


-(void) slideSubMenuDoAndSee:(BOOL)hide {
    
    if (hide) {
        [UIView animateWithDuration:0.3
         
                         animations:^{
                             if(isPad)
                                 mapView.frame = CGRectMake(9.0f, 185.0f, 750, 770);
                             else
                                 mapView.frame = CGRectMake(9.0f, 135.0f, 302, 318);
                             
                             subGroupDivider.alpha = 0;
                             self.subGroupsFilterView.alpha = 0;
                             arrowLeft.alpha = 0;
                             arrowRight.alpha = 0;
                         }
         
                         completion:^(BOOL  completed){
                         }
         ];

    } else {
        [UIView animateWithDuration:0.3
         
                         animations:^{ 
                             if(isPad)
                                 mapView.frame = CGRectMake(9.0f, 225.0f, 750, 770);
                             else
                                 mapView.frame = CGRectMake(9.0f, 165.0f, 302, 318);
                             subGroupDivider.alpha = 1;
                             self.subGroupsFilterView.alpha = 1;
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
        if (sender == self.rbtnDoSee) {
            [self slideSubMenuDoAndSee:TRUE];
        }
        
    } else {
        [sender setSelected:YES];
        
        //check if subgroup needs to show
        if (sender == self.rbtnDoSee) {
            [self slideSubMenuDoAndSee:FALSE];
        }
    }
    [self setMarkers];
}


-(void) initializeMap {
        //check current location
    
    currentLocation.longitude = controller.locMgr.location.coordinate.longitude;
    currentLocation.latitude  = controller.locMgr.location.coordinate.latitude;
    
    //currentLocation.latitude = 50.8424;
    //currentLocation.longitude = 4.3625;
    
    if(![LMRMapUtil isLocationWithinScreenRectWithLon:currentLocation.longitude andLat:currentLocation.latitude andMapView:mapView]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"INBRUTITLE", nil) message:NSLocalizedString(@"INBRUMESSAGE", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [[mapView contents] setZoom:16.0f];
        [[mapView contents] setMapCenter:currentLocation];
        [self setMarkers];
    }
}

- (void)locationUpdate:(CLLocation *)location {
    
    if (viewopenedfirsttime) {
        
        viewopenedfirsttime = FALSE;
        
        [self initializeMap];
               
       /* debuglabel = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        debuglabel.scrollEnabled = YES;
        debuglabel.alpha = 0.3f;
            //debuglabel.text = @"debug";
        [self.view addSubview:debuglabel];
        
        locationdebuglabel = [[UITextView alloc] initWithFrame:CGRectMake(0, 150, 350, 200)];
        locationdebuglabel.scrollEnabled = YES;
        locationdebuglabel.alpha = 0.3f;
            //locationdebuglabel.text = [NSString stringWithFormat:@"currentloc long:%f lat:%f",currentLocation.longitude,currentLocation.latitude];
        [self.view addSubview:locationdebuglabel];*/
    
            //[controller.locMgr stopUpdatingLocation];
            //[controller.locMgr stopMonitoringSignificantLocationChanges];
    
    } else {
        /*
        NSLog(@"update");
        CLLocationCoordinate2D newlocation;
        newlocation.longitude = controller.locMgr.location.coordinate.longitude;
        newlocation.latitude = controller.locMgr.location.coordinate.latitude;
        
            //currentLocation.longitude = controller.locMgr.location.coordinate.longitude;
            //currentLocation.latitude  = controller.locMgr.location.coordinate.latitude;
        
       CLLocation *loconenew = [[[CLLocation alloc] initWithLatitude:newlocation.latitude longitude:newlocation.longitude] autorelease];
        
          CLLocation *lococurr = [[[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude] autorelease];
        
        CLLocationDistance distance = [loconenew distanceFromLocation:lococurr];
        
        NSNumber *number = [[NSNumber alloc] initWithDouble:distance];
    
        debuglabel.text = [NSString stringWithFormat:@"%@\ndistance: %f",debuglabel.text,[number doubleValue]];
        
        locationdebuglabel.text = [NSString stringWithFormat:@"currentloc long:%f lat:%f\nnewloc long:%f lat:%f",currentLocation.longitude,currentLocation.latitude, newlocation.longitude, newlocation.latitude];
        [self.view addSubview:locationdebuglabel];
        
            //[[mapView contents] setMapCenter:currentLocation];
            //[self setMarkers];
        */
        
    }
}


- (void)locationError:(NSError *)error {
}


@end
