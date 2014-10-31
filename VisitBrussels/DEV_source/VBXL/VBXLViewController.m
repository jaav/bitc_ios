//
//  VBXLViewController.m
//  VBXL
//
//  Created by Thomas Joos on 04/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VBXLViewController.h"
#import "BackButton.h"

@interface VBXLViewController() {
    int maxItem;
    int currentIndex;
}

@end

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
@synthesize loadingView, progress1, progress2, label1, label2, loadingTitleLabel;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDownloadImageInit:) name:@"downloadImageInit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDownloadImageStart:) name:@"downloadImageStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDownloadImageProgress:) name:@"downloadImageProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDownloadImageCompleteAll:) name:@"downloadImageCompleteAll" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTheApp) name:@"startheapp" object:nil];
    
    if(!foreground) {
        foreground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[DataController adjustedImageName:@"WaitScreen.png"]]];
        foreground.frame =self.view.bounds;
        [self.view addSubview:foreground];
          self.view.userInteractionEnabled = FALSE;
        
        DataController *datacontroller = [DataController sharedInstance];
        [datacontroller controlDataStartUp];
        
    }
    
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Notification handler

-(void)handleDownloadImageInit:(NSNotification *)notif  {
    NSDictionary *userInfo = [notif userInfo];
    
    int total = [[userInfo objectForKey:@"totalItem"] intValue];
    
    if(total>=0) {
        maxItem = total;
        currentIndex = 0;
        
        loadingTitleLabel.text = NSLocalizedString(@"DOWNLOADIMAGE", nil);
        [label1 setHidden:NO];
        [label2 setHidden:NO];
        [progress1 setHidden:NO];
        [progress2 setHidden:NO];
        
        label1.text = [NSString stringWithFormat:@"%d / %d",currentIndex, maxItem];
        [progress1 setProgress:0.0];
    } else {
        loadingTitleLabel.text = NSLocalizedString(@"DOWNLOADXML", nil);
        label1.text = @"";
        label2.text = @"";
        [progress1 setProgress:0.0];
        [progress2 setProgress:0.0];
        
        [label1 setHidden:YES];
        [label2 setHidden:YES];
        [progress1 setHidden:YES];
        [progress2 setHidden:YES];
        loadingView.frame = self.view.bounds;
        [self.view addSubview:loadingView];
        [self.view bringSubviewToFront:loadingView];
    }
}

-(void)handleDownloadImageStart:(NSNotification *)notif  {
    NSDictionary *userInfo = [notif userInfo];
    NSString *fileName = [userInfo objectForKey:@"currentImage"];
    
    currentIndex++;
    
    label1.text = [NSString stringWithFormat:@"%d / %d",currentIndex, maxItem];
    [progress1 setProgress:1.0*currentIndex/maxItem];
    
    label2.text = fileName;
    [progress2 setProgress:0.0];
}

-(void)handleDownloadImageProgress:(NSNotification *)notif  {
    NSDictionary *userInfo = [notif userInfo];
    int progressInPercent = [[userInfo objectForKey:@"currentProgress"] intValue];
    
    [progress2 setProgress:progressInPercent/100.0];
}

-(void)handleDownloadImageCompleteAll:(NSNotification *)notif  {
    //NSDictionary *userInfo = [notif userInfo];
    
    [loadingView removeFromSuperview];
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
    
    self.subCategoryTableViewController = [[SubCategoryTableViewController alloc] initWithNibName:[DataController adjustedNibName:@"SubCategoryTableViewController"] bundle:nil];
    
    [subCategoryTableViewController setDataSet:[self retrieveDataSet:fromButton]];
    
    subCategoryTableViewController.myTableView.backgroundColor = [UIColor clearColor];
    [subCategoryTableViewController setTitle:[self retrieveListTitle:fromButton]];
    
    [self.navigationController pushViewController:subCategoryTableViewController animated:YES];
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
    
    self.mapViewController = [[MapViewController alloc] initWithNibName:[DataController adjustedNibName:@"MapViewController"] bundle:nil];
    [mapViewController setTitle:[self retrieveListTitle:btnAroundMe]];    
    [self.navigationController pushViewController:mapViewController animated:YES];
}

-(void)createSearchView
{
    NSLog(@"create searchView");
    searchViewController = [[SearchViewController alloc]initWithNibName:[DataController adjustedNibName:@"SearchViewController"] bundle:nil];
    searchViewController.myTableView.backgroundColor = [UIColor clearColor];
    searchViewController.delegate = self;
    searchViewController.view.frame = self.view.bounds;
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

}

#pragma mark - SearchViewControllerDelegate Methods

- (void)searchItemClicked:(Item *)clickedItem {
    DetailPageViewController *detailpage = [[DetailPageViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageViewController"] bundle:nil item:clickedItem];
    [detailpage setTitle:clickedItem.title];
    [self.navigationController pushViewController:detailpage animated:YES];
}

@end
