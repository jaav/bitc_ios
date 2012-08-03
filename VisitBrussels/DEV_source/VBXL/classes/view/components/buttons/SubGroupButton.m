//
//  SubGroupButton.m
//  VBXL
//
//  Created by Thomas Joos on 31/08/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//

#import "SubGroupButton.h"


@implementation SubGroupButton


-(id) init{
    return [self initWithTitle:@"no title"];
}

-(id)initWithTitle:(NSString *)title
{
   if ((self = [super init])) {
       /*self = [UIButton buttonWithType:UIButtonTypeCustom];*/
       
       self.backgroundColor = [UIColor clearColor];
       [self setTitle:title forState:UIControlStateNormal];
       UIFont *myFont = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
       CGSize size = [self.titleLabel.text sizeWithFont:myFont];
       self.frame = CGRectMake(10, 0, size.width+10, 40);
       self.titleLabel.font = myFont;
       
       [self setTitleColor:[UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:0.15] forState:UIControlStateNormal];
       [self setTitleColor:[UIColor colorWithRed:(216.0/255.0) green:(130.0/255.0) blue:(191/255.0) alpha:1] forState:UIControlStateSelected];
       //[self setTitleColor:[UIColor colorWithRed:(106.0/255.0) green:(12.0/255.0) blue:(79/255.0) alpha:1] forState:UIControlStateHighlighted];
       
       self.selected = FALSE;
   }
    return self; 
    
}

- (void)dealloc
{
    [super dealloc];
}


@end
