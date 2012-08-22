//
//  DataController.h
//  VBXL
//
//  Created by Wim Vanhenden on 25/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>
#import "CategoriesHolder.h"
#import "Categorie.h"
#import "Item.h"
#import "NSDate-Utilities.h"
#import "AppData.h"
#import "VBXLNotificationCenter.h"
#import "Services.h"

#define isPad (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface DataController : NSObject <UIAlertViewDelegate> {

}

+ (DataController*) sharedInstance;

- (void) controlDataStartUp;
- (NSMutableArray *) returnItemsBasedOnNavigationItem:(NSString*)navitem;
- (NSMutableArray*) returnAllItems;
- (void) checkForOutdatedFiles;
- (Categorie *) parseXML:(TBXMLElement*)root;

+(NSString *)adjustedNibName:(NSString *)nib;
+(NSString *)adjustedImageName:(NSString *)imageName;

@end
