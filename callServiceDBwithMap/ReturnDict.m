//
//  ReturnDict.m
//  callServiceDBwithMap
//
//  Created by sai on 26/08/14.
//  Copyright (c) 2014 sai infotech. All rights reserved.
//

#import "ReturnDict.h"

@implementation ReturnDict

-(id)initWithReturnDict:(NSDictionary *)dict
{
    NSLog(@"erterert %@",dict);
    if (self=[self init]) {
        _strID=[dict objectForKey:@"id"];
         _strName=[dict objectForKey:@"name"];
         _strLat=[dict objectForKey:@"lat"];
        _strLong=[dict objectForKey:@"long"];
        __strUrl=[dict objectForKey:@"imageurl"];
        _strPath=[dict objectForKey:@"imagepath"];
    }
    return self;
}
@end
