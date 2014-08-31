//
//  ViewController.m
//  callServiceDBwithMap
//
//  Created by sai on 24/08/14.
//  Copyright (c) 2014 sai infotech. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ReturnDict.h"

AppDelegate*objApp;

#define queueDispath dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
#define serviceURL [NSURL URLWithString:@"http://www.apmocon.com/webservice/webservices.php?action=listIssue&userid=8&wardno=2&state=1&city=25&legitativeid=1&startlimit=0"]
@interface ViewController ()
@end

@implementation ViewController
@synthesize activityIndicator;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tblContact.hidden=true;
   
    objApp=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    objApp.arrData=[[NSMutableArray alloc]init];
    activityIndicator.center=self.view.center;
    activityIndicator.hidesWhenStopped=true;
    
 

    dispatch_async(queueDispath, ^{
        [activityIndicator startAnimating];
        ///// local
     
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"locations" withExtension:@"json"];

        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                             timeoutInterval:30.0];
        
        // Get the data
        NSURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
       
             [self performSelectorOnMainThread:@selector(FetchLocalData:) withObject:data waitUntilDone:true];
//        
//        NSData*data=[NSData dataWithContentsOfURL:serviceURL];
//        [self performSelectorOnMainThread:@selector(fetchData:) withObject:data waitUntilDone:true];
        
    });
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)FetchLocalData:(NSData*)data
{
    int count=[self getCountFromDB];
    if (data!=nil) {
        NSError* error;
         NSArray*arrData=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"dfddfggdfgdfd %@",arrData);
        NSLog(@"countofDB= %d countfromservice =%lu",count,(unsigned long)[arrData count]);
        if (count!=[arrData count]) {
            [self deleteImageFromLoacal ];
             [self setDBEmpty];
            for (int i=0; i<[arrData count]; i++) {
                
              NSString*strPath = [self getImagePathFromURL:[NSString stringWithFormat:@"%@",[[arrData objectAtIndex:i]valueForKey:@"imageurl"]]];
                NSLog(@"path of local image %@",strPath);
                [self insertDataIntoDB:[NSString stringWithFormat:@"%@",[[arrData objectAtIndex:i]valueForKey:@"id"]] :[NSString stringWithFormat:@"%@",[[arrData objectAtIndex:i]valueForKey:@"name"]] :[NSString stringWithFormat:@"%@",[[arrData objectAtIndex:i]valueForKey:@"lati"]] :[NSString stringWithFormat:@"%@",[[arrData objectAtIndex:i]valueForKey:@"longi"]]:[NSString stringWithFormat:@"%@",[[arrData objectAtIndex:i]valueForKey:@"imageurl"]]:strPath];
            }
            [self getDataFromDB];
        }else if(count>0)
        {
            [self getDataFromDB];
        }
    }
    else
    {
        // off line
        if(count>0)
        {
            [self getDataFromDB];
        }else
        {
            UIAlertView*alrt=[[UIAlertView alloc]initWithTitle:@"Note" message:@"operation could not be completed" delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles:nil, nil];
            [alrt show];
        }
    }
    [activityIndicator stopAnimating];
}

-(NSString *) getImagePathFromURL:(NSString *)fileURL {
    
    NSLog(@"pathLastt %@",[fileURL lastPathComponent]);
      NSString* path ;
    @autoreleasepool {
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
                UIImage *image =[UIImage imageWithData:data];
        if (image != nil)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *PhotoName=@"";
            PhotoName=@"manish";
            PhotoName= [PhotoName stringByAppendingFormat:@"_"];
            PhotoName= [PhotoName stringByAppendingString:[NSString stringWithFormat:@"%@",[fileURL lastPathComponent]]];
            
            path = [documentsDirectory stringByAppendingPathComponent:
                    PhotoName ];
            NSData* data = UIImagePNGRepresentation(image);
            [data writeToFile:path atomically:YES];
        }
    }
    return path;
}
#pragma mark Dtatbase Methods
-(int)getCountFromDB
{
 
    databaseName=@"localcontact.sqlite";
    NSArray*arrPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    
    NSString*strPath=[arrPath objectAtIndex:0];
    databasePath=[strPath stringByAppendingPathComponent:databaseName];
    [objApp checkAndCreate:databasePath :databaseName];
    
    int count;
    sqlite3*database;
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        NSString*strQuery=@"select count(*) from tblcontact";
        const char*query=[strQuery UTF8String];
        static sqlite3_stmt *compiledStatement;
    
        if (sqlite3_prepare_v2(database, query, -1, &compiledStatement, NULL)==SQLITE_OK) {
            
            while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
                count=sqlite3_column_int(compiledStatement, 0);
                
            }
            
        }
        sqlite3_finalize(compiledStatement);
       
    }
    sqlite3_close(database);
    return count;
}

-(void)deleteImageFromLoacal
{
    
    databaseName=@"localcontact.sqlite";
    NSArray*arrPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    
    NSString*strPath=[arrPath objectAtIndex:0];
    databasePath=[strPath stringByAppendingPathComponent:databaseName];
    [objApp checkAndCreate:databasePath :databaseName];
    
    
    sqlite3*database;
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        NSString*strQuery=@"select * from tblcontact";
        const char*query=[strQuery UTF8String];
        static sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2(database, query, -1, &compiledStatement, NULL)==SQLITE_OK) {
            
            while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString*strPathLocal=[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 5)];
                NSLog(@"deleted Path = %@",strPathLocal);
                if ([fileManager fileExistsAtPath:strPathLocal]) {
                     [fileManager removeItemAtPath: strPathLocal error:NULL];
                }
               
            }
           
            
        }
        
               sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
    
}


-(void)insertDataIntoDB:(NSString*)strID :(NSString*)strName :(NSString*)strLat :(NSString *)strLong :(NSString *)strImageurl :(NSString*)strimagepath
{

    databaseName=@"localcontact.sqlite";
    NSArray*arrPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    
    NSString*strPath=[arrPath objectAtIndex:0];
    databasePath=[strPath stringByAppendingPathComponent:databaseName];
    [objApp checkAndCreate:databasePath :databaseName];
      sqlite3*database;
      if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
          static sqlite3_stmt*compiledStatment;
          sqlite3_exec(database, [[NSString stringWithFormat:@"insert into tblcontact(id,name,lat,long,imageurl,imagepath) values ('%@','%@','%@','%@','%@','%@')",strID,strName,strLat,strLong,strImageurl,strimagepath] UTF8String], NULL, NULL, NULL);
          sqlite3_finalize(compiledStatment);
      }
    NSLog(@"dataInsertinDb");
    sqlite3_close(database);

}
-(void)setDBEmpty
{

    databaseName=@"localcontact.sqlite";
    NSArray*arrPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    
    NSString*strPath=[arrPath objectAtIndex:0];
    databasePath=[strPath stringByAppendingPathComponent:databaseName];
    [objApp checkAndCreate:databasePath :databaseName];
    sqlite3*database;
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        NSString*strQuery=@"delete from tblcontact";
        const char*query=[strQuery UTF8String];
        static sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2(database, query, -1, &compiledStatement, NULL)==SQLITE_OK) {
            
            while (sqlite3_step(compiledStatement)==SQLITE_DONE) {
                
                
            }
            
        }
        sqlite3_finalize(compiledStatement);
        NSLog(@"tableEmpty");
    }
    sqlite3_close(database);
}
-(void)getDataFromDB
{

    databaseName=@"localcontact.sqlite";
    NSArray*arrPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    
    NSString*strPath=[arrPath objectAtIndex:0];
    databasePath=[strPath stringByAppendingPathComponent:databaseName];
    [objApp checkAndCreate:databasePath :databaseName];
    sqlite3*database;
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK){
        NSString*strQuery=@"select * from tblcontact order by id";
        const char*query=[strQuery UTF8String];
        static sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2(database, query, -1, &compiledStatement, NULL)==SQLITE_OK) {
            NSMutableDictionary*dictTemp=[[NSMutableDictionary alloc]init];
            while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
                [dictTemp setValue:[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 0)] forKey:@"id"];
                 [dictTemp setValue:[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 1)] forKey:@"name"];
                 [dictTemp setValue:[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 2)] forKey:@"lat"];
                 [dictTemp setValue:[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 3)] forKey:@"long"];
                [dictTemp setValue:[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 4)] forKey:@"imageurl"];
                [dictTemp setValue:[NSString stringWithUTF8String:(char*)sqlite3_column_text(compiledStatement, 5)] forKey:@"imagepath"];

                
                [self setObjectValue:dictTemp];
            }
              
            
           
        }
        sqlite3_finalize(compiledStatement);
    }
     self.tblContact.hidden=false;
    [self.tblContact reloadData];
    sqlite3_close(database);
}
-(void)setObjectValue:(NSDictionary*)dictData
{
    ReturnDict*objreturnDict=[[ReturnDict alloc]initWithReturnDict:dictData];
    [objApp.arrData addObject:objreturnDict];
    
}
#pragma mark Tableview Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [objApp.arrData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //static NSString*cellIdentifier=@"cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    //cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    ReturnDict*objDict=[objApp.arrData objectAtIndex:indexPath.row];
    UILabel*lblId=(UILabel*)[cell.contentView viewWithTag:100];
    lblId.text=[NSString stringWithFormat:@"ID: %@",objDict.strID];
    UILabel*lblNumber=(UILabel*)[cell.contentView viewWithTag:200];
    UIImageView*imgView=(UIImageView*)[cell.contentView viewWithTag:1000];
    imgView.image=[UIImage imageWithContentsOfFile:objDict.strPath];
    lblNumber.text=objDict.strName;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//-(void)fetchData:(NSData*)data
//{
//    int count=[self getCountFromDB];
//    if (data!=nil) {
//        NSError* error;
//       NSDictionary*dictData=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        NSArray*arrData=[dictData objectForKey:@"W"];
//         NSLog(@"countofDB= %d countfromservice =%lu",count,[arrData count]-1);
//        if (count!=[arrData count]-1) {
//            [self setDBEmpty];
//            for (int i=1; i<[arrData count]; i++) {
//                [self insertDataIntoDB:[NSString stringWithFormat:@"%@",[[arrData objectAtIndex:i]valueForKey:@"id"]] :[NSString stringWithFormat:@"%@",[[arrData objectAtIndex:i]valueForKey:@"name"]] :[NSString stringWithFormat:@"%@",[[arrData objectAtIndex:i]valueForKey:@"mobile_no"]] :[NSString stringWithFormat:@"%@",[[arrData objectAtIndex:i]valueForKey:@"status"]]:[NSString stringWithFormat:@"%@",[[arrData objectAtIndex:i]valueForKey:@"user_image"]]];
//            }
//            [self getDataFromDB];
//        }else if(count>0)
//        {
//         [self getDataFromDB];
//        }
//
//    }
//    else
//    {
//       if(count>0)
//        {
//            [self getDataFromDB];
//        }else
//        {
//        UIAlertView*alrt=[[UIAlertView alloc]initWithTitle:@"Note" message:@"operation could not be completed" delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles:nil, nil];
//        [alrt show];
//        }
//    }
//    [activityIndicator stopAnimating];
//}

@end
