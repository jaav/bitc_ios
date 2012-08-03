//
//  VBXLViewController.m
//  VBXL
//
//  Created by Thomas Joos on 04/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VBXLViewController.h"
#import "BackButton.h"

#import "DownloadAllImages.h"

@implementation VBXLViewController
@synthesize vbxlHeaderView;
@synthesize subCategoryTableViewController;
@synthesize searchViewController;
@synthesize mapViewController;

@synthesize btnAroundMe;
@synthesize btnDoSee;
@synthesize btnEatDrink;
@synthesize btnNightLife;
@synthesize btnSleep;

@synthesize btnSearch;
@synthesize btnSettings;

#pragma mark - Memory Management

- (void)dealloc {
    
    [foreground release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [vbxlHeaderView release];
    [subCategoryTableViewController release];
    [searchViewController release];
    [mapViewController release];
    
    [btnAroundMe release];
    [btnDoSee release];
    [btnEatDrink release];
    [btnNightLife release];
    [btnSleep release];
    [btnSearch release];
    [btnSettings release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    self.btnAroundMe = nil;
    self.btnDoSee = nil;
    self.btnEatDrink = nil;
    self.btnNightLife = nil;
    self.btnSleep = nil;
    self.btnSearch = nil;
    self.btnSettings = nil;
    
    [super viewDidUnload];

}


- (void)didReceiveMemoryWarning {
    NSLog(@"mainview did recieve memory warning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle
- (void) viewWillAppear:(BOOL)animated {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
        [self.navigationController setNavigationBarHidden:NO animated:animated];    
        [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
        [vbxlHeaderView setRandomHeaderImage];
}

-(void) startTheApp {
        NSLog(@"app started");
        self.view.userInteractionEnabled = TRUE;
    
        [foreground removeFromSuperview];
        [foreground release];
    
        /*
        DownloadAllImages *down = [[DownloadAllImages alloc] init];
        [down setAllFolders];
        [down release];*/
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    NSLog(@"main view did load");
    
    //load header
    if(isPad)
        vbxlHeaderView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, 768, 206)];
    else
        vbxlHeaderView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, 320, 103)];
    [self.view addSubview:vbxlHeaderView];
    
    if(!foreground) {
        foreground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[DataController adjustedImageName:@"WaitScreen.png"]]];
        foreground.frame =self.view.bounds;
        [self.view addSubview:foreground];
          self.view.userInteractionEnabled = FALSE;
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTheApp) name:@"startheapp" object:nil];
    }
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Home Button Methods

-(IBAction)mainButtonClicked:(id)sender
{
    /* (UIButton *)sender */
    
    if (((UIButton *)sender) == self.btnAroundMe) {
        [self createMapView];
    }else {
        [self createListView:(UIButton *)sender];
    }
    
}   


-(IBAction)searchButtonClicked:(id)sender {
    [self createSearchView];
}


#pragma mark - Create View Methods
-(void)createListView:(UIButton *)fromButton {
    
    subCategoryTableViewController = [[SubCategoryTableViewController alloc] initWithNibName:[DataController adjustedNibName:@"SubCategoryTableViewController"] bundle:nil];
    
    [subCategoryTableViewController setDataSet:[self retrieveDataSet:fromButton]];
    
    subCategoryTableViewController.myTableView.backgroundColor = [UIColor clearColor];
    [subCategoryTableViewController setTitle:[self retrieveListTitle:fromButton]];
    
    [self.navigationController pushViewController:subCategoryTableViewController animated:YES];
    
    
    // release
    [subCategoryTableViewController release];
}


-(NSMutableArray *)retrieveDataSet:(UIButton *)fromButtonClicked {
    
    AppData *data = [AppData sharedInstance];
    if (fromButtonClicked == self.btnDoSee) {
        return data.subnavigationitemsdoandsee;
    }else if (fromButtonClicked == self.btnEatDrink) {
        return data.subnavigationitemseatanddrink;
    }else if (fromButtonClicked == self.btnNightLife) {
        return data.subnavigationitemsnightlife;
    }else if (fromButtonClicked == self.btnSleep) {
        return data.subnavigationitemssleep;
    }
    return nil;

}

-(NSString *)retrieveListTitle:(UIButton *)fromButtonClicked
{
    NSString *listTitle;
    
    if (fromButtonClicked == self.btnAroundMe) {
        listTitle = NSLocalizedString(@"AROUNDME", nil);
    }else if (fromButtonClicked == self.btnDoSee) {
        listTitle = NSLocalizedString(@"DOSEE", nil);
    }else if (fromButtonClicked == self.btnEatDrink) {
        listTitle = NSLocalizedString(@"EATDRINK", nil);
    }else if (fromButtonClicked == self.btnNightLife) {
        listTitle = NSLocalizedString(@"NIGHTLIFE", nil);
    }else if (fromButtonClicked == self.btnSleep) {
        listTitle = NSLocalizedString(@"SLEEP", nil);
    }
    
    return listTitle;
}

-(void)createMapView
{
    NSLog(@"create mapview");
    
    mapViewController = [[MapViewController alloc]initWithNibName:[DataController adjustedNibName:@"MapViewController"] bundle:nil];
    [mapViewController setTitle:[self retrieveListTitle:btnAroundMe]];    
    [self.navigationController pushViewController:mapViewController animated:YES];
    [mapViewController release];
}

-(void)createSearchView
{
    NSLog(@"create searchView");
    searchViewController = [[SearchViewController alloc]initWithNibName:[DataController adjustedNibName:@"SearchViewController"] bundle:nil];
    searchViewController.myTableView.backgroundColor = [UIColor clearColor];
    searchViewController.delegate = self;
    
    //[self.navigationController pushViewController:searchViewController animated:YES];
    [self.view addSubview:searchViewController.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDidStopSelector:@selector(searchViewLoaded)];
    searchViewController.view.alpha = 1;
    [UIView commitAnimations];
    
}

-(void)searchViewLoaded {
    [searchViewController release];
}

#pragma mark - SearchViewControllerDelegate Methods

- (void)searchItemClicked:(Item *)clickedItem {
    DetailPageViewController *detailpage = [[DetailPageViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageViewController"] bundle:nil item:clickedItem];
    [detailpage setTitle:clickedItem.title];
    [self.navigationController pushViewController:detailpage animated:YES];
    [detailpage release];
}

@end
