//
//  MapViewController.h
//  VBXL
//
//  Created by Thomas Joos on 14/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackButton.h"
#import "CTAButton.h"
#import "SubGroupButton.h"
#import "DataController.h"

#import "DetailPageViewController.h"

#import "RMMapView.h"
#import "RMDBMapSource.h"
#import "RMMarkerManager.h"
#import "LMRMapUtil.h"
#import "POITableViewController.h"

#import "CoreLocationController.h"

@interface MapViewController : UIViewController <RMMapViewDelegate,CoreLocationControllerDelegate> {
 
    BackButton *btnBack;
    
    CTAButton *rbtnDoSee;
    CTAButton *rbtnEatDrink;
    CTAButton *rbtnSleep;
    CTAButton *rbtnNightLife;

    RMMapView *mapView;
    UIImageView *subGroupDivider;
    UIImageView *arrowLeft;
    UIImageView *arrowRight;
    UIScrollView *subGroupsFilterView;
    
    CoreLocationController *controller;
    
    BOOL viewopenedfirsttime;
    
    CLLocationCoordinate2D currentLocation;
    
    UITextView *debuglabel;
    UITextView *locationdebuglabel;
    
}

@property(nonatomic,retain) BackButton *btnBack;
@property(nonatomic,retain) CTAButton *rbtnDoSee;
@property(nonatomic,retain) CTAButton *rbtnEatDrink;
@property(nonatomic,retain) CTAButton *rbtnSleep;
@property(nonatomic,retain) CTAButton *rbtnNightLife;
@property(nonatomic,retain) UIImageView *subGroupDivider;
@property(nonatomic,retain) UIImageView *arrowLeft;
@property(nonatomic,retain) UIImageView *arrowRight;
@property(nonatomic,retain) UIScrollView *subGroupsFilterView;

-(void) configNavBar;
-(void) setRadioButtons;
-(void) setMarkers;
-(void) setSubGroups;



@end
