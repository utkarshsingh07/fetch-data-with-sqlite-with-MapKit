//
//  MkPointannotation.m
//  callServiceDBwithMap
//
//  Created by sai on 26/08/14.
//  Copyright (c) 2014 sai infotech. All rights reserved.
//

#import "MkPointannotation.h"

@implementation MkPointannotation

@synthesize tag;
-(id)initWithLatitude:(CLLocationDegrees)latitude Longitude:(CLLocationDegrees)longitude
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
-(void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.latitude=coordinate.latitude;
    self.longitude=coordinate.longitude;

}




@end
