//
//  SearchViewController.m
//  VBXL
//
//  Created by Thomas Joos on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"

//custom navbar shizzle
@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed: @"navBarBlue.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

@implementation SearchViewController
@synthesize myTableView;
@synthesize listContent;
@synthesize filteredListContent;
@synthesize searchDisplayController;
@synthesize btnBack;
@synthesize delegate;


#pragma mark - Memory Management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.alpha = 0.0;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    
    
    [self configTableView];
    [self configNavBar];
	
    self.filteredListContent = [[NSMutableArray alloc] init];
    DataController *cont  = [DataController sharedInstance];
    
    self.listContent = [cont returnAllItems];
    
	UISearchBar *mySearchBar = [[UISearchBar alloc] init];
	mySearchBar.delegate = self;
	[mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[mySearchBar sizeToFit];
	
    self.myTableView.tableHeaderView = mySearchBar;
    
    [self.myTableView.tableHeaderView setFrame:CGRectMake(0, 20, 320, 40)];
	
	searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
	[self setSearchDisplayController:searchDisplayController];
	[searchDisplayController setDelegate:self];
	[searchDisplayController setSearchResultsDataSource:self];
    [searchDisplayController setActive:YES animated:NO];
    
	[self.myTableView reloadData];
	self.myTableView.scrollEnabled = YES;
    
    [mySearchBar becomeFirstResponder];
    
    
}


- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	NSIndexPath *tableSelection = [self.myTableView indexPathForSelectedRow];
	[self.myTableView deselectRowAtIndexPath:tableSelection animated:NO];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Config Methods
-(void)configTableView
{
    CGRect destFrame = self.view.bounds;
    destFrame.origin.y+=20.0f;
    destFrame.size.height -=20.0f;
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.myTableView setBackgroundColor:[UIColor clearColor]];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
}

-(void)configNavBar
{
    
    //back button
    btnBack = [[BackButton alloc] init];
    [btnBack addTarget:self action:@selector(backToHome)forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = customBarItem;
}

-(void)backToHome
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDidStopSelector:@selector(searchViewUnLoaded)];
    self.view.alpha = 0;
    [UIView commitAnimations];
}

-(void)searchViewUnLoaded
{
    [self.view removeFromSuperview];
}

#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.filteredListContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{	
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
    Item *item = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        item = [self.filteredListContent objectAtIndex:indexPath.row];
    }

	cell.textLabel.text = item.title;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    Item *item = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        item = [self.filteredListContent objectAtIndex:indexPath.row];
        
    }
    
    //Is anyone listening
    if([delegate respondsToSelector:@selector(searchItemClicked:)])
    {
        //send the delegate function with the amount entered by the user
        //[delegate amountEntered:[amountTextField.text intValue]];
        [delegate searchItemClicked:item];
    }else
    {
        NSLog(@"no one listening");
    }
    
    [self.myTableView.tableHeaderView resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self backToHome];
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
	
	// Update the filtered array based on the search text and scope.	 
	[self.filteredListContent removeAllObjects];// First clear the filtered array.
    
    // Search the main list for names that contains the characters of searchText
    for (Item *poi in listContent) {
        
        NSRange range = [poi.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            [self.filteredListContent addObject:poi];
        }
        
    }
    
}

#pragma mark -
#pragma mark UISearchDisplayControllerDelegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString scope:
    [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
    [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
	
    //Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
	[self.searchDisplayController.searchResultsTableView setDelegate:self];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    [self backToHome];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self backToHome];
}


@end
