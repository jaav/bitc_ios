//
//  LMRMapUtil.h
//  ProgrammaticMap
//
//  Created by Wim Vanhenden on 12/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapView.h"
#import "RMProjection.h"
#import "RMMercatorToScreenProjection.h"
#import "DataController.h"
#import "AppData.h"
#import "RMMarker.h"
#import "RMMarkerManager.h"

@interface LMRMapUtil : NSObject {
    
}

+(BOOL) isLocationWithinScreenRectWithLon:(float)lon andLat:(float)lat andMapView:(RMMapView*)mapView;
+(void) setMarkers:(NSMutableArray*)groups ForMap:(RMMapView*)mapView;



@end
