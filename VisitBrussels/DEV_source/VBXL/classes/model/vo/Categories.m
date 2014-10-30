#import "Categories.h"


@implementation Categories
@synthesize categories;

- (id)init {
    self = [super init];
    if (self) {
        categories = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#define kCategories        @"Categories"

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:categories               forKey:kCategories];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    self.categories =                  [decoder decodeObjectForKey:kCategories];
    return self;
}



@end
