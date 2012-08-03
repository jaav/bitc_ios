//
//  DeHTMLFormatter.m
//  VBXL
//
//  Created by Wim Vanhenden on 17/08/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//

#import "DeHTMLFormatter.h"
#include <stdlib.h>

@implementation DeHTMLFormatter


+ (NSString *) stripTags:(NSString *)str
{
    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSString *tempText = nil;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:&tempText];
        
        if (tempText != nil)
            [html appendString:tempText];
        
        [scanner scanUpToString:@">" intoString:NULL];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + 1];
        
        tempText = nil;
    }
    return (NSString*)html;
}

+ (NSString *) stripGoogleAnalytics:(NSString *)str{
    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSString *tempText = nil;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"try {" intoString:&tempText];
        
        if (tempText != nil)
            [html appendString:tempText];
        
        [scanner scanUpToString:@"{}" intoString:NULL];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + 1];
        
        tempText = nil;
    }
    return (NSString*)html;
}


+ (NSString *) replaceSpecialCharacters:(NSString *)str {
    
    str = [str stringByReplacingOccurrencesOfString:@"&#160;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&euro;" withString:@"€"];
    str = [str stringByReplacingOccurrencesOfString:@"&oelig;" withString:@"œ"];
    str = [str stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"'"];
    str = [str stringByReplacingOccurrencesOfString:@"&#9679;" withString:@"●"];
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    
    return str;
}

+ (NSString *) reformatURLForBookingDotCom:(NSString *)str {
    
    NSString *myurl = [NSString stringWithString:str];
    NSRange aRange = [myurl rangeOfString:@"booking"];
    if (aRange.location == NSNotFound) {
        
        return str;
    } else {
        
            myurl = [myurl stringByReplacingOccurrencesOfString:@"www." withString:@"m."];
        
            myurl = [NSString stringWithFormat:@"%@?aid=342665",myurl];
            
            //DEBUGGING HOTELS 
            //myurl = @"http://m.booking.com/hotel/be/euro-capital-brussels.html?aid=342665";
            
        return myurl;
        
    }
    
    return nil;
    
}




+(NSString *) genRandStringLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%c", [letters characterAtIndex: rand()%[letters length]]];
    }
         
    return randomString;
}


@end
