//
//  Services.h
//  VBXL
//
//  Created by Wim Vanhenden on 20/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ASIDownloadCache.h"

#import "AppData.h"
#import "VBXLNotificationCenter.h"
#import "DataController.h"
#import "DownloadImageOperation.h"

@interface Services : NSObject {
    ASINetworkQueue *networkQueue;
    NSString *connectedcallback;
    NSMutableArray *xmlArray;
    
    NSOperationQueue *operationQueue;
}

@property (retain) ASINetworkQueue *networkQueue;
@property (retain) NSString *connectedcallback;
@property (retain) NSMutableArray *xmlArray;

@property (readonly) NSOperationQueue *operationQueue;

- (void) loadXMLBasedOnLanguage:(NSMutableArray*)incoming;

- (void) checkIfConnectedToInternet;

+ (Services*) sharedInstance;

- (void)downloadImageStart:(NSDictionary *)dict;
- (void)downloadImageProgress:(NSDictionary *)dict;
- (void)downloadImageCompleteAll:(NSDictionary *)dict;

@end
