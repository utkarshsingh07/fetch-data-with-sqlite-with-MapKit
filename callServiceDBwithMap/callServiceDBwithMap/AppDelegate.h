//
//  AppDelegate.h
//  callServiceDBwithMap
//
//  Created by sai on 24/08/14.
//  Copyright (c) 2014 sai infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableArray*arrData;
}
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) NSMutableArray*arrData;
-(void)checkAndCreate:(NSString*)databasepath :(NSString*)databasname;
@end
