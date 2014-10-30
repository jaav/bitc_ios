//
//  BackButton.m
//  Jupiler Bartender
//
//  Created by Thomas Joos on 07/06/10.
//  Copyright 2010 Gladiator. All rights reserved.
//

#import "BackButton.h"

@implementation BackButton


-(id)init {
	if(self == [super init]) {
		
		// The default size for the red button is 49x30 pixels
		self.frame = CGRectMake(7, 7, 64, 30.0);

		// Center the text vertically and horizontally
		self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        		
		UIImage *image = [UIImage imageNamed:@"btnBack.png"];
		UIImage *imagePressed = [UIImage imageNamed:@"btnBackPressed.png"];

		// Make a stretchable image from the original image
		UIImage *stretchImage = [image stretchableImageWithLeftCapWidth:15 topCapHeight:0.0];
        UIImage *stretchImagePressed = [imagePressed stretchableImageWithLeftCapWidth:15 topCapHeight:0.0];
		
		// Set the background to the stretchable image
		[self setBackgroundImage:stretchImage forState:UIControlStateNormal];
        [self setBackgroundImage:stretchImagePressed forState:UIControlStateHighlighted];
		
		// Make the background color clear
		self.backgroundColor = [UIColor clearColor];
        
        // Set the font properties
        [self setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        self.titleLabel.shadowOffset = CGSizeMake(0, -1);
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:(99.0 / 255.0) green:(123.0 / 255.0) blue:(141 / 255.0) alpha: 1] forState:UIControlStateHighlighted];
        // R: 99 G: 123 B: 141
        
        //set copy
        [self setTitle:NSLocalizedString(@"BTNBACK", nil) forState:UIControlStateNormal];
        
        
	}
	
	return self;
}

@end