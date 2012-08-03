//
//  VBXLNotificationCenter.m
//  VBXL
//
//  Created by Wim Vanhenden on 25/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89	
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import "VBXLNotificationCenter.h"

static VBXLNotificationCenter *_instance;
@implementation VBXLNotificationCenter

@synthesize connectednotifname;

#pragma mark -
#pragma mark Singleton Methods

+ (VBXLNotificationCenter*)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[self alloc] init];
        
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

- (id)autorelease
{
    [connectednotifname release];
    return self;	
}

#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here

-(void) startApp {
    NSNotification* notification = [NSNotification notificationWithName:@"startheapp" object:nil];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void) xmlfilesAreLoadedFromTheInternet {
    NSNotification* notification = [NSNotification notificationWithName:@"doneloadingxmlfilesfrominternet" object:nil];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void) weAreConnectedToTheInternet:(NSString*)connected {    
    NSNotification* notification = [NSNotification notificationWithName:self.connectednotifname object:connected];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
