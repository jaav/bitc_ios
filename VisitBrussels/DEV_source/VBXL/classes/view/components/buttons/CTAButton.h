//
//  CTAButton.h
//  VBXL
//
//  Created by Thomas Joos on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CTAButton : UIButton {
	BOOL landscape;

}
-(id)initWithImage:(NSString *)img andHighlightImage:(NSString *)imgPressed;
-(void)configSelectedState:(NSString *)selectedImg;
@end