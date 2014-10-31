//
//  VBXLNotificationCenter.h
//  VBXL
//
//  Created by Wim Vanhenden on 25/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>

@interface VBXLNotificationCenter : NSObject {
    NSString *connectednotifname;
}

+ (VBXLNotificationCenter*) sharedInstance;


@property(nonatomic,retain) NSString *connectednotifname;

-(void) weAreConnectedToTheInternet:(NSString*)connected;
@end
