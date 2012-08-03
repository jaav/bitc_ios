//
//  HeaderView.h
//  VBXL
//
//  Created by Thomas Joos on 04/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HeaderView : UIView {
 
    int headerNumber;
    
    UIImageView *headerView;
    UIImageView *logoView;
    NSArray *headerSet;
    
}

@property(nonatomic,retain)UIImageView *headerView;
@property(nonatomic,retain)UIImageView *logoView;
@property(nonatomic,retain)NSArray *headerSet;

- (void) setRandomHeaderImage;

@end
