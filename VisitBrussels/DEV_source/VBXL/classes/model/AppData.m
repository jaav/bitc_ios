//
//  AppData.m
//  VBXL
//
//  Created by Wim Vanhenden on 20/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89	
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import "AppData.h"

static AppData *_instance;
@implementation AppData

@synthesize groups;
@synthesize rootpathfordownloadedxmls;
@synthesize serverpathforxmls;
@synthesize rootpathforinitialdata;
@synthesize rootpathforencryptedata;
@synthesize subnavigationitemssleep;
@synthesize subnavigationitemsdoandsee;
@synthesize subnavigationitemsnightlife;
@synthesize subnavigationitemseatanddrink;
@synthesize subnavigationallitems;
@synthesize navigationtree;
@synthesize currentgroup;
@synthesize rootpathforimages;

#pragma mark -
#pragma mark Singleton Methods

+ (AppData*)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[self alloc] init];

            _instance.groups = [[NSMutableArray alloc] initWithObjects:@"TOP10",@"MONUMENT",@"MUSEUM",@"CULTURE",@"ATTRACTIONS",@"SHOPPING",@"MARKET", @"CONTEMPARCH",@"HOTEL",@"BnB",@"AUBERGE",@"BUDGET",@"CITYTRIP",@"RESTO",@"BAR",@"BREAKFAST",@"NIGHTCLUB",@"RESTO_NIGHT",@"LEISURE",@"LIVE_MUSIC",nil];
            
            _instance.subnavigationitemsdoandsee = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"NAVTOP10", nil),NSLocalizedString(@"NAVMONUMENTS", nil),NSLocalizedString(@"NAVMUSEUMS", nil),NSLocalizedString(@"NAVCULTURAL", nil),NSLocalizedString(@"NAVATTRACTIONS", nil),NSLocalizedString(@"NAVSHOPPING", nil),NSLocalizedString(@"NAVMARKETS", nil),NSLocalizedString(@"NAVCONTEMPARCH", nil),nil];
            
            _instance.subnavigationitemseatanddrink = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"NAVRESTO", nil),NSLocalizedString(@"NAVBARS", nil),NSLocalizedString(@"NAVBREAKFAST", nil),nil];
            
            _instance.subnavigationitemsnightlife = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"NAVNIGHTCLUBS", nil),NSLocalizedString(@"NAVRESTNIGHT", nil),NSLocalizedString(@"NAVLEISURE", nil),NSLocalizedString(@"NAVLIVEMUSIC", nil),nil];
            
            _instance.subnavigationitemssleep = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"NAVHOTELS", nil),NSLocalizedString(@"NAVBNB", nil),NSLocalizedString(@"NAVYOUTHHOSTELS", nil),NSLocalizedString(@"NAVBUDGET", nil),NSLocalizedString(@"NAVHOTELPACKS", nil),nil];
            
            _instance.subnavigationallitems = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"NAVTOP10", nil),NSLocalizedString(@"NAVMONUMENTS", nil),NSLocalizedString(@"NAVMUSEUMS",  nil),NSLocalizedString(@"NAVCULTURAL", nil),NSLocalizedString(@"NAVATTRACTIONS", nil),NSLocalizedString(@"NAVSHOPPING", nil),NSLocalizedString(@"NAVMARKETS", nil),NSLocalizedString(@"NAVCONTEMPARCH", nill),NSLocalizedString(@"NAVHOTELS", nil),NSLocalizedString(@"NAVBNB", nil),NSLocalizedString(@"NAVYOUTHHOSTELS", nil),NSLocalizedString(@"NAVBUDGET", nil),NSLocalizedString(@"NAVHOTELPACKS", nil),NSLocalizedString(@"NAVRESTO", nil),NSLocalizedString(@"NAVBARS", nil),NSLocalizedString(@"NAVBREAKFAST", nil),NSLocalizedString(@"NAVNIGHTCLUBS", nil),NSLocalizedString(@"NAVRESTNIGHT", nil),NSLocalizedString(@"NAVLEISURE", nil),NSLocalizedString(@"NAVLIVEMUSIC", nil),nil];
            
            _instance.navigationtree = [[NSMutableArray alloc] init];
            
            for (int i=0; i<[_instance.groups count]; i++) {
                NSMutableArray *array= [NSMutableArray arrayWithObjects:[_instance.groups objectAtIndex:i], [_instance.subnavigationallitems objectAtIndex:i],nil];
                [_instance.navigationtree addObject:array];
            }
            
            _instance.rootpathfordownloadedxmls = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0],@"xmls"];
            
            _instance.rootpathforimages = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0],@"images"];
            
            _instance.rootpathforencryptedata = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0],@"encdata"];
            
            _instance.serverpathforxmls = SERVER_URL;
            
            _instance.rootpathforinitialdata = [[NSBundle mainBundle] resourcePath];
            
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone

{	
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


-(void) setCurrentGroupBasedOnTitle:(NSString*)title {
    for (int i=0; i<[subnavigationallitems count]; i++) {
        if ([title isEqualToString:[subnavigationallitems objectAtIndex:i] ]) {
            currentgroup = i;
        }
    }
}

-(NSString*) returnGroupNameBasedOnCurrentGroupIndex:(int)index{
    
    return [groups objectAtIndex:index];
}


- (id)autorelease {
    [subnavigationallitems release];
    [navigationtree release];
    [subnavigationitemseatanddrink release];
    [subnavigationitemsdoandsee release];
    [subnavigationitemsnightlife release];
    [subnavigationitemssleep release];
    [groups release];
    [serverpathforxmls release];
    [rootpathforinitialdata release];
    [rootpathfordownloadedxmls release];
    [rootpathforencryptedata release];
    return self;
}

#pragma mark -
#pragma mark Custom Methods

@end
