//
//  DetailAnnotation.m
//  callServiceDBwithMap
//
//  Created by sai on 29/08/14.
//  Copyright (c) 2014 sai infotech. All rights reserved.
//

#import "DetailAnnotation.h"

@implementation DetailAnnotation
@synthesize tag;
-(id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    if (self=[super init]) {
        self.latitude=latitude;
        self.longitude=longitude;
        
    }
    return self;
}
-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coor;
    coor.latitude=self.latitude;
    coor.longitude=self.longitude;
    return coor;
}
@end
