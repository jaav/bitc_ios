//
//  DetailPageViewController.h
//  VBXL
//
//  Created by Thomas Joos on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackButton.h"
#import "CTAButton.h"
#import "Item.h"
#import "UIImageView+WebCache.h"
#import "DetailPageMapViewController.h"
#import "CustomWebViewController.h"
#import "DeHTMLFormatter.h"

@interface DetailPageRestoViewController : UIViewController {
    
    
    IBOutlet UILabel *poiTitle;
    IBOutlet UILabel *poiAdress;
    IBOutlet UILabel *poiCity;
    IBOutlet UILabel *poiCuisine;
    
    IBOutlet UITextView *textview;
    
    IBOutlet UIImageView *imageView;
    
    IBOutlet UIImageView *star1;
    IBOutlet UIImageView *star2;
    IBOutlet UIImageView *star3;
    IBOutlet UIImageView *star4;
    IBOutlet UIImageView *star5;
    IBOutlet UIImageView *star6;
    
    IBOutlet UIScrollView *scrollView;
    
    Item *myitem;
    BackButton *btnBack;
    CTAButton *btnSite;
    CTAButton *btnMap;
    CTAButton *btnCall;
    
}

@property(nonatomic, retain) IBOutlet UILabel *poiTitle;
@property(nonatomic, retain) IBOutlet UILabel *poiAdress;
@property(nonatomic, retain) IBOutlet UILabel *poiCity;
@property(nonatomic, retain) IBOutlet UILabel *poiCuisine;

@property(nonatomic, retain) IBOutlet UIImageView *star1;
@property(nonatomic, retain) IBOutlet UIImageView *star2;
@property(nonatomic, retain) IBOutlet UIImageView *star3;
@property(nonatomic, retain) IBOutlet UIImageView *star4;
@property(nonatomic, retain) IBOutlet UIImageView *star5;
@property(nonatomic, retain) IBOutlet UIImageView *star6;

@property(nonatomic, retain) BackButton *btnBack;
@property(nonatomic, retain) CTAButton *btnSite;
@property(nonatomic, retain) CTAButton *btnMap;
@property(nonatomic, retain) CTAButton *btnCall;
@property(nonatomic, retain) Item *myitem;


-(id)initWithNibNameAndItem:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil item:(Item *)item;
-(void)configNavBar;
-(void)setDetailContent;



@end
