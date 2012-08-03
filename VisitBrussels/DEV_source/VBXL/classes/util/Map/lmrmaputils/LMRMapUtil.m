//
//  LMRMapUtil.m
//  ProgrammaticMap
//
//  Created by Wim Vanhenden on 12/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//

#import "LMRMapUtil.h"


@implementation LMRMapUtil

+(BOOL) isLocationWithinScreenRectWithLon:(float)lon andLat:(float)lat andMapView:(RMMapView*)mapView {
    
    CLLocationCoordinate2D location;
    location.longitude = lon;
    location.latitude  = lat;
    
    CGRect myrect =  [[[mapView contents] mercatorToScreenProjection] screenBounds];
    CGPoint anotherpoint = [mapView latLongToPixel:location];    
    
    if (   anotherpoint.x > myrect.origin.x
		&& anotherpoint.x < myrect.origin.x + myrect.size.width
		&& anotherpoint.y > myrect.origin.y
		&& anotherpoint.y < myrect.origin.y + myrect.size.height)
	{
		return YES;
	}
    
    return NO;
    
}

+(void) setMarkers:(NSMutableArray*)groups ForMap:(RMMapView*)mapView  {
    
    DataController *controller = [DataController sharedInstance];
   
    for (int i=0; i<[groups count]; i++) {
        
        NSMutableArray *maingroup = [[groups objectAtIndex:i] objectAtIndex:0];
        
        for (int j=0; j<[maingroup count]; j++) {
            NSMutableArray *myarr = [controller returnItemsBasedOnNavigationItem:[maingroup objectAtIndex:j]];
            
            for (int k=0; k<[myarr count]; k++) {
                Item *myitem = [myarr objectAtIndex:k];
                
                if ([myitem.latitude floatValue] && [myitem.longitude floatValue]) {
                    CLLocationCoordinate2D coord;
                    coord.longitude = [myitem.longitude floatValue];
                    coord.latitude  = [myitem.latitude floatValue];    
                    
                    if ([LMRMapUtil isLocationWithinScreenRectWithLon:[myitem.longitude floatValue] andLat:[myitem.latitude floatValue] andMapView:mapView]) {
                        
                        RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:[[groups objectAtIndex:i] objectAtIndex:1]]];
                        
                        [marker setData:myitem];
                        
                        [[mapView markerManager] addMarker:marker AtLatLong:coord];
                        
                        [marker release];
                    }

                }

            }
            
        }
        
    }
}

@end
