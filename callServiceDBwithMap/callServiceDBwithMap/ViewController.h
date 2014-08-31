//
//  ViewController.h
//  callServiceDBwithMap
//
//  Created by sai on 24/08/14.
//  Copyright (c) 2014 sai infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface ViewController : UIViewController

{

    NSString*databasePath;
    NSString*databaseName;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tblContact;
@end
