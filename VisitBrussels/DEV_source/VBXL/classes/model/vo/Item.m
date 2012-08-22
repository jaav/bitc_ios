//
//  Item.m
//  VBXL
//
//  Created by Wim Vanhenden on 22/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//

#import "Item.h"


@implementation Item

@synthesize parentgroup,address,body,city,email,fax,latitude,longitude,phone,title,website,smallimage,id_item,zipcode,positionlist,fromdate,todate,cuisines,price,ranking, imagefilename,bigimage,bigimagefilename;

- (void)dealloc
{
    [parentgroup release];
    [imagefilename release];
    [fromdate release];
    [todate release];
    [cuisines release];
    [address release];
    [body release];
    [city release];
    [email release];
    [fax release];
    [latitude release];
    [longitude release];
    [phone release];
    [title release];
    [website release];
    [smallimage release];
    [bigimage release];
    [bigimagefilename release];
    [price release];
    
    [super dealloc];
}


#define kParentGroup    @"ParentGroup"
#define kAddress        @"Address"
#define kBody           @"Body"
#define kCity           @"City"
#define kEmail          @"Email"
#define kFax            @"Fax"
#define kLatitude       @"Latitude"
#define kLongitute      @"Longitude"
#define kPhone          @"Phone"
#define kTitle          @"Title"
#define kWebsite        @"Website"
#define kSmallImage     @"SmallImage"
#define kBigImage       @"BigImage"
#define kImageFileName  @"ImageFileName"
#define kBigImageFileName  @"BigImageFileName"
#define kId_item        @"Id_item"
#define kZipcode        @"Zipcode"
#define kPositionlist   @"Positionlist"

#define kFromDate       @"FromDate"
#define kToDate         @"ToDate"
#define kCuisines       @"Cuisines"
#define kPrice          @"Price"
#define kRanking        @"Ranking"


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:parentgroup           forKey:kParentGroup]; 
    [encoder encodeObject:address               forKey:kAddress];
    [encoder encodeObject:body                  forKey:kBody];
    [encoder encodeObject:city                  forKey:kCity];
    [encoder encodeObject:email                 forKey:kEmail];
    [encoder encodeObject:fax                   forKey:kFax];
    [encoder encodeObject:latitude              forKey:kLatitude];
    [encoder encodeObject:longitude             forKey:kLongitute];
    [encoder encodeObject:phone                 forKey:kPhone];
    [encoder encodeObject:title                 forKey:kTitle];
    [encoder encodeObject:website               forKey:kWebsite];
    [encoder encodeObject:smallimage            forKey:kSmallImage];
    [encoder encodeObject:bigimage            forKey:kBigImage];
    [encoder encodeObject:imagefilename         forKey:kImageFileName];
    [encoder encodeObject:bigimagefilename         forKey:kBigImageFileName];
    [encoder encodeInt:id_item                  forKey:kId_item];
    [encoder encodeInt:zipcode                  forKey:kZipcode];
    [encoder encodeInt:positioninlist           forKey:kPositionlist];
    [encoder encodeObject:fromdate              forKey:kFromDate];
    [encoder encodeObject:todate                forKey:kToDate];
    [encoder encodeObject:cuisines              forKey:kCuisines];
    [encoder encodeObject:price                 forKey:kPrice];
    [encoder encodeInt:ranking                  forKey:kRanking];

}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    self.parentgroup =              [decoder decodeObjectForKey:kParentGroup];
    self.address =                  [decoder decodeObjectForKey:kAddress];
    self.body =                     [decoder decodeObjectForKey:kBody];
    self.city =                     [decoder decodeObjectForKey:kCity];
    self.email =                    [decoder decodeObjectForKey:kEmail];
    self.fax =                      [decoder decodeObjectForKey:kFax];
    self.latitude =                 [decoder decodeObjectForKey:kLatitude];
    self.longitude =                [decoder decodeObjectForKey:kLongitute];
    self.phone =                    [decoder decodeObjectForKey:kPhone];
    self.title =                    [decoder decodeObjectForKey:kTitle];
    self.website =                  [decoder decodeObjectForKey:kWebsite];
    self.smallimage =               [decoder decodeObjectForKey:kSmallImage];
    self.bigimage   =               [decoder decodeObjectForKey:kBigImage];
    self.imagefilename =            [decoder decodeObjectForKey:kImageFileName];
    self.id_item =                  [decoder decodeIntForKey:kId_item];
    self.zipcode =                  [decoder decodeIntForKey:kZipcode];
    self.positionlist =             [decoder decodeIntForKey:kPositionlist];
    self.fromdate =                 [decoder decodeObjectForKey:kFromDate];
    self.todate =                   [decoder decodeObjectForKey:kToDate];
    self.cuisines =                 [decoder decodeObjectForKey:kCuisines];
    self.price =                    [decoder decodeObjectForKey:kPrice];
    self.ranking =                  [decoder decodeIntForKey:kRanking];
    self.bigimagefilename =         [decoder decodeObjectForKey:kBigImageFileName];
    
    return self;
}

-(NSString *)bigImageCacheFilePath  {
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:bigimagefilename];
}

-(NSString *)imageCacheFilePath {
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:imagefilename];
}

@end
