    //
    //  DetailPageMapViewController.h
    //  VBXL
    //
    //  Created by Wim Vanhenden on 29/07/11.
    //  Copyright 2011 Little Miss Robot. All rights reserved.
    //

#import <UIKit/UIKit.h>
#import "BackButton.h"
#import "Item.h"
#import "CTAButton.h"
#import "RMMapView.h"
#import "RMDBMapSource.h"
#import "RMMarkerManager.h"
#import "RMMarker.h"
#import "LMRMapUtil.h"
#import "AppData.h"
#import "CoreLocationController.h"
#import "SubGroupButton.h"



@interface DetailPageMapViewController : UIViewController <RMMapViewDelegate> {
    
    BackButton *btnBack;
    Item *myitem;
    RMMapView *mapView;
    
    CTAButton *rbtnDoSee;
    CTAButton *rbtnEatDrink;
    CTAButton *rbtnSleep;
    CTAButton *rbtnNightLife;
    
    CoreLocationController *controller;
    
    UIImageView *subGroupDivider;
    UIScrollView *subGroupsFilterView;

    UIImageView *arrowLeft;
    UIImageView *arrowRight;
    
    NSString *internetcallback;

}

@property (nonatomic,retain) Item *myitem;
@property(nonatomic,retain) UIImageView *arrowLeft;
@property(nonatomic,retain) UIImageView *arrowRight;

- (void)configNavBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andItem:(Item*)incitem;

@end
