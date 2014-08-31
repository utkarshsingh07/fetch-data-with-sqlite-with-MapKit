//
//  ReturnDict.h
//  callServiceDBwithMap
//
//  Created by sai on 26/08/14.
//  Copyright (c) 2014 sai infotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnDict : NSObject

@property(readonly)NSString*strID;
@property(readonly)NSString*strName;
@property(readonly)NSString*strLat;
@property(readonly)NSString*strLong;
@property(readonly)NSString*_strUrl;
@property(readonly)NSString*strPath
;

-(id)initWithReturnDict:(NSDictionary*)dict;

@end
