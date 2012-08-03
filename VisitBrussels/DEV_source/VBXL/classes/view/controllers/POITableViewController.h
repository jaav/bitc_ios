//
//  POITableViewController.h
//  VBXL
//
//  Created by Thomas Joos on 08/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackButton.h"
#import "CustomAccessoryDisclosureArrow.h"
#import "DetailPageViewController.h"
#import "DetailPageBBViewController.h"
#import "DetailPageCultureViewController.h"
#import "DetailViewBreakfastViewController.h"
#import "DetailPageCitytripsViewController.h"
#import "DetailPageWalksViewController.h"
#import "DetailPageRestoViewController.h"


#import "DataController.h"
#import "UIImageView+WebCache.h"


@interface POITableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    UITableView *myTableView;
    BackButton *btnBack;
    NSMutableArray *dataSet;
    NSString *highlightColor;
}

@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)NSMutableArray *dataSet;
@property(nonatomic,retain)BackButton *btnBack;
@property(nonatomic,retain)NSString *highlightColor;

-(void)configNavBar;
-(void)configTableView;
-(NSString *)retrieveCellHighLight;


@end

@interface SizableImageCell : UITableViewCell {
    int imagewidth;
    int imageheight;
    
}

@property int imagewidth;
@property int imageheight;

@end

