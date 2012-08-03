//
//  Services.m
//  VBXL
//
//  Created by Wim Vanhenden on 20/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89	
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import "Services.h"

static Services *_instance;
@implementation Services

@synthesize networkQueue;
@synthesize connectedcallback;
#pragma mark -
#pragma mark Singleton Methods

+ (Services*)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[self alloc] init];
            
            // Allocate/initialize any member variables of the singleton class here
            // example
			//_instance.member = @"";
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
    [networkQueue release];
    //do nothing
}

- (id)autorelease
{
    [networkQueue release];
    [connectedcallback release];
    return self;	
}

#pragma mark -
#pragma mark Custom Methods


- (void) checkIfConnectedToInternet {
    NSString *path;
    path = [NSString stringWithString: @"http://www.google.com"];
    NSURL *url = [NSURL URLWithString:path];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startSynchronous]; 
}

- (void) loadXMLBasedOnLanguage:(NSMutableArray*)incoming {
    
    //PREPARE DATA
    AppData *data = [AppData sharedInstance];
    NSString *preferredLang = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    //PREPARE THE DOWNLOAD QUEUE
    [[self networkQueue] cancelAllOperations];
    [self setNetworkQueue:[ASINetworkQueue queue]];
	[[self networkQueue] setDelegate:self];
	[[self networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
	[[self networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
	[[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
    
    //LOOP SET FILES, PATHS and ADD TO DOWNLOAD QUEUE
    for (int i=0; i<[incoming count]; i++) {
        
        NSString *filename = [NSString stringWithFormat:@"%@_%@",[incoming objectAtIndex:i], [preferredLang uppercaseString]];
        
        NSString *path = [NSString stringWithFormat:@"%@/%@.%@", data.serverpathforxmls, filename,@"xml"];
        
        NSURL *url = [NSURL URLWithString: [path stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        
        NSString *localfile = [NSString stringWithFormat:@"%@/%@.%@", data.rootpathfordownloadedxmls,filename,@"xml"];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [request setDownloadDestinationPath:localfile];
        
        [[self networkQueue] addOperation:request];
        
       
    }
    //START THE QUEUE
    [[self networkQueue] go];
}

#pragma mark -
#pragma mark Event Listeners

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// You could release the queue here if you wanted
	if ([[self networkQueue] requestsCount] == 0) {
        
		// Since this is a retained property, setting it to nil will release it
		// This is the safest way to handle releasing things - most of the time you only ever need to release in your accessors
		// And if you an Objective-C 2.0 property for the queue (as in this example) the accessor is generated automatically for you
		[self setNetworkQueue:nil]; 
	}
        
    if ([[request.originalURL absoluteString]isEqualToString:@"http://www.google.com"]) {
        if([request.responseStatusMessage isEqualToString:@"HTTP/1.1 200 OK"]){
          
            VBXLNotificationCenter *notif = [VBXLNotificationCenter sharedInstance];
            notif.connectednotifname = connectedcallback;
            [notif weAreConnectedToTheInternet:@"YES"];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	// You could release the queue here if you wanted
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
    if ([[request.originalURL absoluteString]isEqualToString:@"http://www.google.com"]) {
        VBXLNotificationCenter *notif = [VBXLNotificationCenter sharedInstance];
        notif.connectednotifname = connectedcallback;
        [notif weAreConnectedToTheInternet:@"NO"];
    }
}

- (void)queueFinished:(ASINetworkQueue *)queue {
	// You could release the queue here if you wanted
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil]; 
	}
    NSLog(@"All new files are downloaded...start parsing");
    VBXLNotificationCenter *notif = [VBXLNotificationCenter sharedInstance];
    [notif xmlfilesAreLoadedFromTheInternet];
}
@end
