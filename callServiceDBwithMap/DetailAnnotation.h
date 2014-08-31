//
//  DetailAnnotation.h
//  callServiceDBwithMap
//
//  Created by sai on 29/08/14.
//  Copyright (c) 2014 sai infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DetailAnnotation : NSObject<MKAnnotation>

@property(nonatomic)CLLocationDegrees latitude;
@property(nonatomic)CLLocationDegrees longitude;
@property(nonatomic,assign)NSInteger tag;
-(id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

@end
