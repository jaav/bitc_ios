//
//  SearchViewController.h
//  VBXL
//
//  Created by Thomas Joos on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackButton.h"
#import "CustomAccessoryDisclosureArrow.h"
#import "DetailPageViewController.h"
#import "DataController.h"

//delegate to return amount entered by the user
@protocol SearchViewControllerDelegate <NSObject>
@optional
- (void)searchItemClicked:(Item *)clickedItem;
@end


@interface SearchViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate, UISearchBarDelegate>
{
	UITableView                 *myTableView;
    NSArray						*listContent;			// The master content.
	NSMutableArray				*filteredListContent;	// The content filtered as a result of a search.
    BackButton                  *btnBack;
	
	UISearchDisplayController	*searchDisplayController;
    
    id <SearchViewControllerDelegate> delegate;

}

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) UISearchDisplayController	*searchDisplayController;
@property (nonatomic, retain) BackButton *btnBack;
@property (nonatomic,assign) id delegate;



-(void)configTableView;
-(void)configNavBar;

@end
