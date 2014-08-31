//
//  MkPointannotation.h
//  callServiceDBwithMap
//
//  Created by sai on 26/08/14.
//  Copyright (c) 2014 sai infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ReturnDict.h"

@interface MkPointannotation : MKPointAnnotation<MKAnnotation>

@property(nonatomic,assign)NSInteger tag;
@property(nonatomic)  CLLocationDegrees latitude;
@property(nonatomic)  CLLocationDegrees longitude;
-(id)initWithLatitude:(CLLocationDegrees)latitude Longitude:(CLLocationDegrees)longitude;
@end
