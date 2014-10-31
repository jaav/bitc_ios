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
@synthesize xmlArray, operationQueue;
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

#pragma mark -
#pragma mark Custom Methods


- (void) checkIfConnectedToInternet {
    NSString *path = @"http://www.google.com";
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
    
    self.xmlArray = [NSMutableArray array];
    
    //LOOP SET FILES, PATHS and ADD TO DOWNLOAD QUEUE
    for (int i=0; i<[incoming count]; i++) {
        
        NSString *filename = [NSString stringWithFormat:@"%@_%@",[incoming objectAtIndex:i], [preferredLang uppercaseString]];
        
        NSString *path = [NSString stringWithFormat:@"%@/%@.%@", data.serverpathforxmls, filename,@"xml"];
        
        NSURL *url = [NSURL URLWithString: [path stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        
        NSString *localfile = [NSString stringWithFormat:@"%@/%@.%@", data.rootpathfordownloadedxmls,filename,@"xml"];
        [xmlArray addObject:localfile];
        
        //NSLog(@"Path = %@",path);
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
//        [request setDownloadCache:[ASIDownloadCache sharedCache]];
//        [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
//        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [request setDownloadDestinationPath:localfile];
        
        [[self networkQueue] addOperation:request];
        
       
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:-1] forKey:@"totalItem"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadImageInit" object:nil userInfo:dict];
    
    //START THE QUEUE
    [[self networkQueue] go];
}

#pragma mark -
#pragma mark Event Listeners

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// You could release the queue here if you wanted
	/*if ([[self networkQueue] requestsCount] == 0) {
        
		// Since this is a retained property, setting it to nil will release it
		// This is the safest way to handle releasing things - most of the time you only ever need to release in your accessors
		// And if you an Objective-C 2.0 property for the queue (as in this example) the accessor is generated automatically for you
		[self setNetworkQueue:nil]; 
	}*/
        
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
	/*if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}*/
    
    NSLog(@"request error : %@",[request error]);
    
    if ([[request.originalURL absoluteString]isEqualToString:@"http://www.google.com"]) {
        VBXLNotificationCenter *notif = [VBXLNotificationCenter sharedInstance];
        notif.connectednotifname = connectedcallback;
        [notif weAreConnectedToTheInternet:@"NO"];
    }
}

- (void)queueFinished:(ASINetworkQueue *)queue {
	// You could release the queue here if you wanted
    
    if(queue==[self networkQueue])  {
        if ([queue requestsCount] == 0) {
            [self setNetworkQueue:nil]; 
        }
        
        DataController *data = [DataController sharedInstance];
        NSMutableArray *downloadArray = [NSMutableArray array];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSMutableArray *existList = [NSMutableArray array];
        
        int totalItem = 0;
        
        for(NSString *str in xmlArray)  {
            
            //NSLog(@"file %@ exist = %d",str,[fileManager fileExistsAtPath:str]);
            
            NSURL *url = [NSURL fileURLWithPath:str];
            TBXML *tbxml =[TBXML tbxmlWithURL:url];
            TBXMLElement *root = tbxml.rootXMLElement;
            
            if (root) {
                Categorie *obj = [data parseXML:root];
                totalItem += [obj.items count];
                for(Item *item in obj.items)    {
                    NSArray *fileComponent = [item.imagefilename componentsSeparatedByString:@"."];
                    NSArray *bigfileComponent = [item.bigimagefilename componentsSeparatedByString:@"."];
                    
                    if(item.smallimage && ![item.smallimage isEqualToString:@""])  {
                        if(![fileManager fileExistsAtPath:[item imageCacheFilePath]]&&![[NSBundle mainBundle] pathForResource:[fileComponent objectAtIndex:0] ofType:[fileComponent objectAtIndex:1]])
                            [downloadArray addObject:item.smallimage];
                        else    {
                            [existList addObject:item.smallimage];
                        }
                    }
                    
                    if(item.bigimage && ![item.bigimage isEqualToString:@""])    {
                        if(![fileManager fileExistsAtPath:[item bigImageCacheFilePath]]&&![[NSBundle mainBundle] pathForResource:[bigfileComponent objectAtIndex:0] ofType:[bigfileComponent objectAtIndex:1]])
                            [downloadArray addObject:item.bigimage];
                        else {
                            [existList addObject:item.bigimage];
                        }
                    }
                }
            }
        }
        
        NSLog(@"Total Item = %d, Total download = %d",totalItem,[downloadArray count]);
        
        if([existList count]>0) {
            NSLog(@"Exist : %@",existList);
        }
        
        if([downloadArray count]>0) {
            if(!operationQueue) {
                operationQueue = [[NSOperationQueue alloc] init];
                [operationQueue setMaxConcurrentOperationCount:10];
            }
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSNumber numberWithInt:[downloadArray count]] forKey:@"totalItem"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadImageInit" object:nil userInfo:dict];
            
            DownloadImageOperation *op = [[DownloadImageOperation alloc] initWithArray:downloadArray];
            [operationQueue addOperation:op];
        } else {
            [self downloadImageCompleteAll:[NSDictionary dictionary]];
        }
    }
}

- (void)downloadImageStart:(NSDictionary *)dict {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadImageStart" object:nil userInfo:dict];
}

- (void)downloadImageProgress:(NSDictionary *)dict  {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadImageProgress" object:nil userInfo:dict];
}

- (void)downloadImageCompleteAll:(NSDictionary *)dict   {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadImageCompleteAll" object:nil userInfo:dict];
    
    NSLog(@"All new files are downloaded...start parsing");
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"doneloadingxmlfilesfrominternet" object:nil]];
}

@end
