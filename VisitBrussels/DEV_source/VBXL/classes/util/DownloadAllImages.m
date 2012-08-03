//
//  DownloadAllImages.m
//  VBXL
//
//  Created by Wim Vanhenden on 17/08/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//

#import "DownloadAllImages.h"


@implementation DownloadAllImages


-(void) setAllFolders {
    
    DataController *cont = [DataController sharedInstance];
    NSMutableArray *items= [cont returnAllItems];
    
    AppData *data = [AppData sharedInstance];
    [[NSFileManager defaultManager] createDirectoryAtPath:data.rootpathforimages withIntermediateDirectories:YES attributes:nil error:nil];
    
    for (int i=0; i<[data.navigationtree count]; i++) {

            NSString *newpath = [NSString stringWithFormat:@"%@/%@",data.rootpathforimages,[[data.navigationtree objectAtIndex:i] objectAtIndex:0]];
            [[NSFileManager defaultManager] createDirectoryAtPath:newpath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    
    for (int i=0; i<[items count]; i++) {
        
        Item *myitem = [items objectAtIndex:i];
    
        if (![myitem.smallimage isEqualToString:@""] && myitem.smallimage != NULL) {
        
        NSURL *url = [NSURL URLWithString: [myitem.smallimage stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        
        NSString *localfile = [NSString stringWithFormat:@"%@/%@/%@", data.rootpathforimages,myitem.parentgroup,[url lastPathComponent]];
        
        NSLog(@"wim says: %@",myitem.smallimage);
        NSLog(@"-------------------------------");
            
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDownloadDestinationPath:localfile];
        [request startSynchronous];
        
        
        }
    }
    
}

@end
