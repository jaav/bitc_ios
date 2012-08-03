//
//  Categories.m
//  VBXL
//
//  Created by Wim Vanhenden on 22/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89	
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import "CategoriesHolder.h"

static CategoriesHolder *_instance;
@implementation CategoriesHolder
@synthesize categories;

#pragma mark -
#pragma mark Singleton Methods

+ (CategoriesHolder*)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[self alloc] init];
            _instance.categories = [[Categories alloc] init];
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone {	
    @synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [super allocWithZone:zone];			
            return _instance;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    [categories release];
    return self;	
}



#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here

-(void) replaceCategorie:(Categorie*)incat forGroup:(NSString*)group {
    NSString *preferredLang = [[[NSLocale preferredLanguages] objectAtIndex:0] uppercaseString];
    
    for (int i=0; i<[[categories.categories objectForKey:preferredLang] count]; i++) {
        if ([[[[categories.categories objectForKey:preferredLang] objectAtIndex:i] group] isEqualToString:group]) {
           
            [[[categories.categories objectForKey:preferredLang] objectAtIndex:i] setGroup:incat.group];
            [[[categories.categories objectForKey:preferredLang] objectAtIndex:i] setExporteddate:incat.exporteddate];
            [[[categories.categories objectForKey:preferredLang] objectAtIndex:i] setLanguage:incat.language];
            [[[categories.categories objectForKey:preferredLang] objectAtIndex:i] setItems:incat.items];
        }
    }
}

-(void) outputCategorieForCurrentLanguageByGroup:(NSString *)group {
    NSString *preferredLang = [[[NSLocale preferredLanguages] objectAtIndex:0] uppercaseString];
    for (int i=0; i<[[categories.categories objectForKey:preferredLang] count]; i++) {
        Categorie *mycategorie = [[categories.categories objectForKey:preferredLang] objectAtIndex:i];
        if([mycategorie.group isEqualToString:group]){
            NSLog(@"categorie group: %@",mycategorie.group);
            NSLog(@"categorie exportdate: %@",mycategorie.exporteddate);
            NSLog(@"categorie language: %@",mycategorie.language);
            for (int j=0; j<[mycategorie.items count]; j++) {
                Item *item = [mycategorie.items objectAtIndex:j];
                NSLog(@"item: %i", item.id_item);
            }
            NSLog(@"------------------------------------------------\n");
        }
    }
}

@end
