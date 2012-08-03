//
//  MainCategoryTableViewController.m
//  VBXL
//
//  Created by Thomas Joos on 08/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubCategoryTableViewController.h"

//custom navbar shizzle
@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed: @"navBarBlue.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end


@implementation SubCategoryTableViewController


@synthesize myTableView;
@synthesize btnBack;
@synthesize dataSet;

#pragma mark - Memory Management
- (void)dealloc
{
    [dataSet release];
    [btnBack release];
    [myTableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [self configTableView];
    [self configNavBar];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Config Methods
-(void)configTableView {
    
    self.myTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height)-(self.navigationController.navigationBar.frame.size.height))] autorelease];
    [self.myTableView setBackgroundColor:[UIColor clearColor]];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
        
}
-(void)configNavBar {
    
    //back button
    btnBack = [[BackButton alloc] init];
    [btnBack addTarget:self action:@selector(backToHome)forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = customBarItem;
    [customBarItem release];
}

-(void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)retrieveCellHighLight
{
    NSString *highlight;
    
    if (self.title == NSLocalizedString(@"AROUNDME", nil)) {
        highlight = @"tblViewHighLightGreeb.png";
    }else if (self.title == NSLocalizedString(@"DOSEE", nil)) {
        highlight = @"tblViewHighLightPurple.png";
    }else if (self.title == NSLocalizedString(@"EATDRINK", nil)) {
        highlight = @"tblViewHighLightGreen.png";
    }else if (self.title == NSLocalizedString(@"NIGHTLIFE", nil)) {
        highlight = @"tblViewHighLightBlueNL.png";
    }else if (self.title == NSLocalizedString(@"SLEEP", nil)) {
        highlight = @"tblViewHighLightBlue.png";
    }
    
    return highlight;    
}


#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return isPad?88:44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSet count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    int row = [indexPath row];
    cell.textLabel.text = [dataSet objectAtIndex:row];
    
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:isPad?30:15]];
    cell.textLabel.textColor = [UIColor colorWithRed:(62.0 / 255.0) green:(62.0 / 255.0) blue:(62.0 / 255.0) alpha: 1];
    
    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[self retrieveCellHighLight]]] autorelease];
    CustomAccessoryDisclosureArrow *accessory = [CustomAccessoryDisclosureArrow accessoryWithColor:cell.textLabel.textColor];
    accessory.highlightedColor = [UIColor whiteColor];
    cell.accessoryView =accessory;

    return cell;
}
/*
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       
    // Navigation logic may go here. Create and push another view controller    
    POITableViewController *poiViewController = [[POITableViewController alloc] initWithNibName:[DataController adjustedNibName:@"POITableViewController"] bundle:nil];
    int row = [indexPath row];
    [poiViewController setTitle:[dataSet objectAtIndex:row]];
    poiViewController.highlightColor = [self retrieveCellHighLight];
    [self.navigationController pushViewController:poiViewController animated:YES];
    [poiViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     
}

@end
