//
//  DownloadImageOperation.m
//  VBXL
//
//  Created by Michael Dihardja on 8/22/12.
//  Copyright (c) 2012 Little Miss Robot. All rights reserved.
//

#import "DownloadImageOperation.h"

@implementation DownloadImageOperation

@synthesize downloadArray;

-(id)initWithArray:(NSArray *)arr   {
    if(self=[super init])   {
        self.downloadArray = [NSArray arrayWithArray:arr];
    }
    
    return self;
}

-(void)main {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSLog(@"download image start");
    
    ASIHTTPRequest *request;
    
    for(NSString *url in downloadArray) {
        [[Services sharedInstance] performSelectorOnMainThread:@selector(downloadImageStart:) withObject:[NSDictionary dictionaryWithObject:[url lastPathComponent] forKey:@"currentImage"] waitUntilDone:YES];
        
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDownloadDestinationPath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[url lastPathComponent]]];
        [request setDownloadProgressDelegate:self];
        [request setDelegate:self];
        [request setTimeOutSeconds:50];
        [request startSynchronous];
        
        /*if([request error])    {
            
        }*/
        
    }
    
    [[Services sharedInstance] performSelectorOnMainThread:@selector(downloadImageCompleteAll:) withObject:dict waitUntilDone:YES];
}

- (void)setProgress:(float)progress
{
    int progressInPercent = [[NSNumber numberWithFloat:progress * 100] intValue];
    [[Services sharedInstance] performSelectorOnMainThread:@selector(downloadImageProgress:) withObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:progressInPercent] forKey:@"currentProgress"] waitUntilDone:YES]; 
}

@end
