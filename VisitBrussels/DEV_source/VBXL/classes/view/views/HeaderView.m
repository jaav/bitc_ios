//
//  HeaderView.m
//  VBXL
//
//  Created by Thomas Joos on 04/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HeaderView.h"
#import "DataController.h"

@implementation HeaderView
@synthesize headerView;
@synthesize logoView;
@synthesize headerSet;


#pragma mark - Memory Management

- (void)dealloc
{
    [headerView release];
    [logoView release];
    [headerSet release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //set data
        headerSet = [[NSArray alloc] initWithObjects:
                     [DataController adjustedImageName:@"header1.png"],
                     [DataController adjustedImageName:@"header2.png"],
                     [DataController adjustedImageName:@"header3.png"],
                     [DataController adjustedImageName:@"header4.png"],
                     [DataController adjustedImageName:@"header5.png"], nil];
        
        //set  random header
        headerView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        logoView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.size.height, frame.size.width, isPad?92:46)];
        [self addSubview:headerView];
        [self addSubview:logoView];
        [self setRandomHeaderImage];
        
        logoView.image = [UIImage imageNamed:[DataController adjustedImageName:@"vbxlHeaderLogo.png"]];
        
    }
    return self;
}

- (void) setRandomHeaderImage
{
    
    int newheaderNumber = (arc4random()%4); //Generates Number from 0 to 4
    
    if (newheaderNumber == headerNumber) {
        [self setRandomHeaderImage];
    }else{
        headerNumber = newheaderNumber;
        headerView.image = [UIImage imageNamed:[headerSet objectAtIndex:headerNumber]];
    }
}




@end
