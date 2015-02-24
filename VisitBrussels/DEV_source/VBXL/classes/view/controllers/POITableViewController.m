//
//  POITableViewController.m
//  VBXL
//
//  Created by Thomas Joos on 08/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "POITableViewController.h"
//custom navbar shizzle
@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed: @"navBarBlue.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

@implementation POITableViewController

@synthesize myTableView;
@synthesize btnBack;
@synthesize dataSet;
@synthesize highlightColor;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    DataController *datacont = [DataController sharedInstance];
    self.dataSet = [datacont returnItemsBasedOnNavigationItem:self.title];
    
    AppData *data = [AppData sharedInstance];
    [data setCurrentGroupBasedOnTitle:self.title];

    
    [self configTableView];
    [self configNavBar];
    [super viewDidLoad];
}


- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Config Methods
-(void)configTableView {
    int i = 1;
    if([self isIPhone4]){
        i = 3;
    }
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - (self.navigationController.navigationBar.frame.size.height * i))];
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
}

-(void)backToHome {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)retrieveCellHighLight {
    NSString *highlight = @"";
    if (self.title == NSLocalizedString(@"AROUNDME", nil)) {
        highlight = @"tblViewHighLightGreeb.png";
    }else if (self.title == NSLocalizedString(@"DO&SEE", nil)) {
        highlight = @"tblViewHighLightOrange.png";
    }else if (self.title == NSLocalizedString(@"EAT&DRINK", nil)) {
        highlight = @"tblViewHighLightPurple.png";
    }else if (self.title == NSLocalizedString(@"NIGHTLIFE", nil)) {
        highlight = @"tblViewHighLightBrown.png";
    }else if (self.title == NSLocalizedString(@"SLEEP", nil)) {
        highlight = @"tblViewHighLightBlue.png";
    }
    return highlight;    
}


#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSet count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppData *data = [AppData sharedInstance];
    
    static NSString *CellIdentifier = @"Cell";
    
    SizableImageCell *cell = (SizableImageCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SizableImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        if ([[data returnGroupNameBasedOnCurrentGroupIndex:[data currentgroup]] isEqualToString:@"RESTO"] ||
            [[data returnGroupNameBasedOnCurrentGroupIndex:[data currentgroup]] isEqualToString:@"SHOPPING"] ||
            [[data returnGroupNameBasedOnCurrentGroupIndex:[data currentgroup]] isEqualToString:@"CITYTRIP"]) {
            cell.imageheight = isPad?120:60;
            cell.imagewidth =  isPad?120:60;
        } else {
            cell.imageheight =  isPad?120:60;
            cell.imagewidth =  isPad?244:122;
        }
    }
    

    
    // Configure the cell...
    Item *item = nil;
    item = [self.dataSet objectAtIndex:indexPath.row];
 
    cell.textLabel.text = item.title;
    
    if ([item.parentgroup isEqualToString:@"CULTURE"]) {
            //date parsing
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYYMMdd"];
            
            NSDate *fromDate = [formatter dateFromString:item.fromdate];
            NSDate *toDate = [formatter dateFromString:item.todate];        
            
            //[formatter setDateFormat:@"EEEE MMMM d, YYYY"];
            [formatter setDateFormat:@"dd/MM/YYYY"];
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",[formatter stringFromDate:fromDate], [formatter stringFromDate:toDate]];
    }
    
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:isPad?30:15]];
    cell.textLabel.textColor = [UIColor colorWithRed:(62.0 / 255.0) green:(62.0 / 255.0) blue:(62.0 / 255.0) alpha: 1];
    
    CGRect textFrame = cell.textLabel.frame;
    textFrame.size.width = 320;
    [cell.textLabel setFrame:textFrame];
    
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:highlightColor]];
    
    if (![item.imagefilename isEqualToString:@""] && item.imagefilename != NULL) {
        
        UIImage *myimage = [UIImage imageNamed:item.imagefilename];
        
        if(myimage) {
            [cell.imageView setImage:myimage];
        } else {
            NSURL *myurl = [NSURL URLWithString:item.smallimage];
            [cell.imageView setImageWithURL:myurl placeholderImage:[UIImage imageNamed:@"imagePlaceholder"]];
        }
    } else {
              if ([[data returnGroupNameBasedOnCurrentGroupIndex:[data currentgroup]] isEqualToString:@"RESTO"] || [[data returnGroupNameBasedOnCurrentGroupIndex:[data currentgroup]] isEqualToString:@"SHOPPING"] || [[data returnGroupNameBasedOnCurrentGroupIndex:[data currentgroup]] isEqualToString:@"CITYTRIP"]) {
                   [cell.imageView setImage:[UIImage imageNamed:@"imagePlaceHolder60x60.png"]];
              } else {
                   [cell.imageView setImage:[UIImage imageNamed:@"imagePlaceholder.png"]];
              }
    }

    CustomAccessoryDisclosureArrow *accessory = [CustomAccessoryDisclosureArrow accessoryWithColor:cell.textLabel.textColor];
    accessory.highlightedColor = [UIColor whiteColor];
    cell.accessoryView =accessory;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return isPad?120:60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    // Navigation logic may go here. Create and push another view controller.
    Item *item = nil;
    item = [self.dataSet objectAtIndex:indexPath.row];
    
    
    if ([item.parentgroup isEqualToString:@"BnB"]) {
        DetailPageBBViewController *detailpage = [[DetailPageBBViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageBBViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }else if ([item.parentgroup isEqualToString:@"CULTURE"]) {
        DetailPageCultureViewController *detailpage = [[DetailPageCultureViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageCultureViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }else if ([item.parentgroup isEqualToString:@"BREAKFAST"]) {
        DetailViewBreakfastViewController *detailpage = [[DetailViewBreakfastViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageBreakfastViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }else if ([item.parentgroup isEqualToString:@"CITYTRIP"]) {
        DetailPageCitytripsViewController *detailpage = [[DetailPageCitytripsViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageCitytripsViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }else if ([item.parentgroup isEqualToString:@"WALK"]) {
        DetailPageWalksViewController *detailpage = [[DetailPageWalksViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageWalksViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }else if ([item.parentgroup isEqualToString:@"OG_TOUR"]) {
        DetailPageWalksViewController *detailpage = [[DetailPageWalksViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageWalksViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }else if ([item.parentgroup isEqualToString:@"RESTO"]) {
        DetailPageRestoViewController *detailpage = [[DetailPageRestoViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageRestoViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }else{
        DetailPageViewController *detailpage = [[DetailPageViewController alloc] initWithNibNameAndItem:[DataController adjustedNibName:@"DetailPageViewController"] bundle:nil item:item];
        [detailpage setTitle:item.title];
        [self.navigationController pushViewController:detailpage animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)isIPhone5{
    if ([[UIScreen mainScreen] bounds].size.height==568)
        return YES;
    return NO;
}

-(BOOL)isIPhone4{
    if ([[UIScreen mainScreen] bounds].size.height==480)
        return YES;
    return NO;
}

@end



@implementation SizableImageCell

@synthesize imagewidth,imageheight;

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0,0,imagewidth,imageheight);
    self.textLabel.frame = CGRectMake(imagewidth+10,
                                      self.textLabel.frame.origin.y,
                                      [[UIScreen mainScreen] bounds].size.width - (imagewidth+10) - 30,
                                      self.textLabel.frame.size.height);
}
@end
