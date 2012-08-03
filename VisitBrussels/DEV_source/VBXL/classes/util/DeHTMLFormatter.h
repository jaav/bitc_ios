//
//  DeHTMLFormatter.h
//  VBXL
//
//  Created by Wim Vanhenden on 17/08/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DeHTMLFormatter : NSObject {
    
}
+ (NSString *) stripTags:(NSString *)str;
+ (NSString *) stripGoogleAnalytics:(NSString *)str;
+ (NSString *) replaceSpecialCharacters:(NSString *)str;

+ (NSString *) reformatURLForBookingDotCom:(NSString *)str;
+ (NSString *) genRandStringLength: (int) len;

@end
