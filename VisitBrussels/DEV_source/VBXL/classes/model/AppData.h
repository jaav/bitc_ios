//
//  AppData.h
//  VBXL
//
//  Created by Wim Vanhenden on 20/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>
#import "TBXML.h"

//PROD
//#define SERVER_URL @"http://visitbrussels.be/mobile"

//DEV
#define SERVER_URL @"http://bitcec2.wanabe.be/mobile"

@interface AppData : NSObject {
    NSMutableArray *groups;
    
    NSMutableArray *navigationtree;
    
    NSMutableArray *subnavigationitemsdoandsee;
    
    NSMutableArray *subnavigationitemseatanddrink;
    
    NSMutableArray *subnavigationitemsnightlife;
    
    NSMutableArray *subnavigationitemssleep;
    
    NSMutableArray *subnavigationallitems;
    
    NSString *rootpathfordownloadedxmls;
    
    NSString *rootpathforinitialdata;
    
    NSString *serverpathforxmls;
    
    NSString *rootpathforencryptedata;
    
    NSString *rootpathforimages;
    
    int currentgroup;
}

@property int currentgroup;

@property (nonatomic, retain) NSMutableArray * groups; 
@property (nonatomic, retain) NSMutableArray * navigationtree; 
@property (nonatomic, retain) NSMutableArray *subnavigationitemsdoandsee;
@property (nonatomic, retain) NSMutableArray *subnavigationitemseatanddrink;
@property (nonatomic, retain) NSMutableArray *subnavigationitemsnightlife;
@property (nonatomic, retain) NSMutableArray *subnavigationitemssleep;
@property (nonatomic, retain) NSMutableArray *subnavigationallitems;
@property (nonatomic, retain) NSString *rootpathfordownloadedxmls;
@property (nonatomic, retain) NSString *serverpathforxmls;
@property (nonatomic, retain) NSString *rootpathforinitialdata;
@property (nonatomic, retain) NSString *rootpathforencryptedata;
@property (nonatomic, retain) NSString *rootpathforimages;

+ (AppData*) sharedInstance;

-(void) setCurrentGroupBasedOnTitle:(NSString*)title;
-(NSString*) returnGroupNameBasedOnCurrentGroupIndex:(int)index;

@end
