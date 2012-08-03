//
//  Categories.h
//  VBXL
//
//  Created by Wim Vanhenden on 22/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>
#import "Categorie.h"
#import "Categories.h"
#import "Item.h"

@interface CategoriesHolder : NSObject {
    Categories *categories;
}

@property (nonatomic,retain) Categories *categories;

+ (CategoriesHolder*) sharedInstance;

- (void) outputCategorieForCurrentLanguageByGroup:(NSString *)group;
- (void) replaceCategorie:(Categorie*)incat forGroup:(NSString*)group;

@end
