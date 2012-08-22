//
//  DownloadImageOperation.h
//  VBXL
//
//  Created by Michael Dihardja on 8/22/12.
//  Copyright (c) 2012 Little Miss Robot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Services.h"
#import "ASIHTTPRequest.h"

@interface DownloadImageOperation : NSOperation {
    NSArray *downloadArray;
}

@property(nonatomic, retain) NSArray *downloadArray;

-(id)initWithArray:(NSArray *)arr;

@end
