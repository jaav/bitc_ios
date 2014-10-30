//
//  Categorie.m
//  VBXL
//
//  Created by Wim Vanhenden on 22/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//

#import "Categorie.h"

@implementation Categorie
@synthesize items,group,language,exporteddate;


- (id)init {
    self = [super init];
    if (self) {
        items = [[NSMutableArray alloc] init];
    }
    return self;
}

#define kItems        @"Items"
#define kGroup        @"Group"
#define kLanguage     @"Language"
#define kExportDate   @"ExportDate"

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:items               forKey:kItems];
    [encoder encodeObject:group               forKey:kGroup];
    [encoder encodeObject:language            forKey:kLanguage];
    [encoder encodeObject:exporteddate        forKey:kExportDate];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    self.items =                  [decoder decodeObjectForKey:kItems];
    self.group =                  [decoder decodeObjectForKey:kGroup];
    self.language =               [decoder decodeObjectForKey:kLanguage];
    self.exporteddate =           [decoder decodeObjectForKey:kExportDate];
   
    return self;
}


@end
