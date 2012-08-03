//
//  CustomAccessoryDisclosureArrow.h
//  VBXL
//
//  Created by Thomas Joos on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomAccessoryDisclosureArrow : UIControl
{
	UIColor *_accessoryColor;
	UIColor *_highlightedColor;
}

@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;

+ (CustomAccessoryDisclosureArrow *)accessoryWithColor:(UIColor *)color;

@end
