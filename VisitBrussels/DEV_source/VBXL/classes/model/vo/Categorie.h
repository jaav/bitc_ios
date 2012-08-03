//
//  Categorie.h
//  VBXL
//
//  Created by Wim Vanhenden on 22/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Categorie : NSObject <NSCoding>{
    
    NSString        *group;
    NSString        *exporteddate;
    NSString        *language;
    NSMutableArray  *items;
    
}

@property (nonatomic, retain)  NSString             *group;
@property (nonatomic, retain)  NSString             *exporteddate;
@property (nonatomic, retain)  NSString             *language;
@property (nonatomic, retain)  NSMutableArray       *items;

@end
