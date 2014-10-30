//
//  CTAButton.m
//  VBXL
//
//  Created by Thomas Joos on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CTAButton.h"


@implementation CTAButton

-(id)initWithImage:(NSString *)img andHighlightImage:(NSString *)imgPressed {
	
    if(self == [super init]) {
		// The default size for the red button is 49x30 pixels
		self.frame = CGRectMake(7, 7, 64, 30);
        
		// Center the text vertically and horizontally
		self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
		UIImage *image = [UIImage imageNamed:img];
		UIImage *imagePressed = [UIImage imageNamed:imgPressed];
        
		// Make a stretchable image from the original image
		UIImage *stretchImage = [image stretchableImageWithLeftCapWidth:15 topCapHeight:0.0];
        UIImage *stretchImagePressed = [imagePressed stretchableImageWithLeftCapWidth:15 topCapHeight:0.0];
		
		// Set the background to the stretchable image
		[self setBackgroundImage:stretchImage forState:UIControlStateNormal];
        [self setBackgroundImage:stretchImagePressed forState:UIControlStateHighlighted];
        		
		// Make the background color clear
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;
}

#pragma mark - RadioButton Methods

-(void)configSelectedState:(NSString *)selectedImg
{
    UIImage *image = [UIImage imageNamed:selectedImg];    
    // Make a stretchable image from the original image
    UIImage *stretchImage = [image stretchableImageWithLeftCapWidth:15 topCapHeight:0.0];    
    // Set the background to the stretchable image
    [self setBackgroundImage:stretchImage forState:UIControlStateSelected];
    [self setBackgroundImage:stretchImage forState:(UIControlStateHighlighted | UIControlStateSelected)];

}

-(void)turnOn
{
    
}

-(void)turnOff
{

}
@end
