//
//  DetailPageBBViewController.h
//  VBXL
//
//  Created by Thomas Joos on 17/08/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackButton.h"
#import "CTAButton.h"
#import "Item.h"
#import "UIImageView+WebCache.h"
#import "DetailPageMapViewController.h"
#import "CustomWebViewController.h"
#import "DeHTMLFormatter.h"
@interface DetailPageCultureViewController : UIViewController {
    
    IBOutlet UILabel *poiTitle;
    IBOutlet UILabel *poiAdress;
    IBOutlet UILabel *poiCity;
    IBOutlet UILabel *poiFromDate;
    IBOutlet UILabel *poiToDate;
    
    IBOutlet UITextView *textview;
    
    IBOutlet UIImageView *imageView;
    
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
@property(nonatomic, retain) IBOutlet UILabel *poiFromDate;
@property(nonatomic, retain) IBOutlet UILabel *poiToDate;

@property(nonatomic, retain) BackButton *btnBack;
@property(nonatomic, retain) CTAButton *btnSite;
@property(nonatomic, retain) CTAButton *btnMap;
@property(nonatomic, retain) CTAButton *btnCall;
@property(nonatomic, retain) Item *myitem;


-(id)initWithNibNameAndItem:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil item:(Item *)item;
-(void)configNavBar;
-(void)setDetailContent;



@end
