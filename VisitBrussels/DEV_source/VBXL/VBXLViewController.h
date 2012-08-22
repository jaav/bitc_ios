//
//  VBXLViewController.h
//  VBXL
//
//  Created by Thomas Joos on 04/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "SubCategoryTableViewController.h"
#import "MapViewController.h"
#import "DetailPageViewController.h"
#import "SearchViewController.h"
#import "AppData.h"

@interface VBXLViewController : UIViewController <SearchViewControllerDelegate> {
  
    HeaderView *vbxlHeaderView;
    
    SubCategoryTableViewController *subCategoryTableViewController;
    MapViewController *mapViewController;
    SearchViewController *searchViewController;
    
    IBOutlet UIButton *btnAroundMe;
    IBOutlet UIButton *btnDoSee;
    IBOutlet UIButton *btnEatDrink;
    IBOutlet UIButton *btnNightLife;
    IBOutlet UIButton *btnSleep;
    
    IBOutlet UIButton *btnSearch;
    IBOutlet UIButton *btnSettings;
    
    UIImageView *foreground;
    
    UIView *loadingView;
    UIProgressView *progress1;
    UILabel *label1;
    UIProgressView *progress2;
    UILabel *label2;
    
    UILabel *loadingTitleLabel;
}

@property(nonatomic,retain)HeaderView *vbxlHeaderView;
@property(nonatomic,retain)SubCategoryTableViewController *subCategoryTableViewController;
@property(nonatomic,retain)SearchViewController *searchViewController;
@property(nonatomic,retain)MapViewController *mapViewController;

@property(nonatomic,retain)IBOutlet UIButton *btnAroundMe;
@property(nonatomic,retain)IBOutlet UIButton *btnDoSee;
@property(nonatomic,retain)IBOutlet UIButton *btnEatDrink;
@property(nonatomic,retain)IBOutlet UIButton *btnNightLife;
@property(nonatomic,retain)IBOutlet UIButton *btnSleep;
@property(nonatomic,retain)IBOutlet UIButton *btnSearch;
@property(nonatomic,retain)IBOutlet UIButton *btnSettings;
@property(nonatomic,retain)IBOutlet UIView *loadingView;
@property(nonatomic,retain)IBOutlet UIProgressView *progress1;
@property(nonatomic,retain)IBOutlet UILabel *label1;
@property(nonatomic,retain)IBOutlet UIProgressView *progress2;
@property(nonatomic,retain)IBOutlet UILabel *label2;
@property(nonatomic,retain)IBOutlet UILabel *loadingTitleLabel;

-(IBAction)mainButtonClicked:(id)sender;
-(IBAction)searchButtonClicked:(id)sender;

-(void)createListView:(UIButton *)fromButton;
-(void)createMapView;
-(void)createSearchView;

-(NSString *)retrieveListTitle:(UIButton *)fromButtonClicked;
-(NSMutableArray *)retrieveDataSet:(UIButton *)fromButtonClicked;

@end
