//
//  MainCategoryTableViewController.h
//  VBXL
//
//  Created by Thomas Joos on 08/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackButton.h"
#import "POITableViewController.h"
#import "CustomAccessoryDisclosureArrow.h"

@interface SubCategoryTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    
    
    UITableView *myTableView;
    BackButton *btnBack;
    NSMutableArray *dataSet;
}

@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)NSMutableArray *dataSet;
@property(nonatomic,retain)BackButton *btnBack;

-(void)configNavBar;
-(void)configTableView;
-(NSString *)retrieveCellHighLight;


@end









