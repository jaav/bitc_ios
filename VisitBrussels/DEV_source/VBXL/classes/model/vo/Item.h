//
//  Item.h
//  VBXL
//
//  Created by Wim Vanhenden on 22/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Item : NSObject <NSCoding> {
    NSInteger           id_item;
    
    NSString            *parentgroup;
    NSString            *title;
    NSString            *smallimage;
    NSString            *bigimage;
    NSString            *imagefilename;
    NSString            *bigimagefilename;
    NSString            *body;
    NSString            *address;
    NSString            *city;
    NSInteger           zipcode;
    NSString            *phone;
    NSString            *fax;
    NSString            *email;
    NSString            *website;
    NSDecimalNumber     *latitude;
    NSDecimalNumber     *longitude;
    NSInteger           positioninlist;
    NSString            *price;
    NSString            *fromdate;
    NSString            *todate;
    NSInteger           ranking;
    
    NSMutableArray      *cuisines;
    
}

@property (nonatomic, retain) NSString                  *parentgroup;
@property (nonatomic, retain) NSString                  *title;
@property (nonatomic, retain) NSString                  *smallimage;
@property (nonatomic, retain) NSString            *bigimage;
@property (nonatomic, retain) NSString                  *imagefilename;
@property (nonatomic, retain) NSString            *bigimagefilename;
@property (nonatomic, retain) NSString                  *body;
@property (nonatomic, retain) NSString                  *address;
@property (nonatomic, retain) NSString                  *city;
@property (nonatomic, retain) NSString                  *phone;
@property (nonatomic, retain) NSString                  *fax;
@property (nonatomic, retain) NSString                  *email;
@property (nonatomic, retain) NSString                  *website;
@property (nonatomic, retain) NSString                  *fromdate;
@property (nonatomic, retain) NSString                  *todate;
@property (nonatomic, retain) NSDecimalNumber           *latitude;
@property (nonatomic, retain) NSDecimalNumber           *longitude;
@property (nonatomic, retain) NSString                  *price;

@property (nonatomic, retain) NSMutableArray            *cuisines;

@property NSInteger id_item;
@property NSInteger positionlist;
@property NSInteger zipcode;
@property NSInteger ranking;



@end
