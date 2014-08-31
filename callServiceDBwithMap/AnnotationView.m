//
//  AnnotationView.m
//  callServiceDBwithMap
//
//  Created by sai on 29/08/14.
//  Copyright (c) 2014 sai infotech. All rights reserved.
//

#import "AnnotationView.h"
#import "ReturnDict.h"
#import "AppDelegate.h"
#import "DetailAnnotation.h"
AppDelegate*objApp;
@implementation AnnotationView

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
     self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    // Instantiate the nib content without any reference to it.
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomCallOut" owner:self options:nil];
    
    // Find the view among nib contents (not too hard assuming there is only one view in it).
   UIView *plainView = [nibContents lastObject];
    // Some hardcoded layout.
//    CGSize padding = (CGSize){ 22.0, 22.0 };
//    plainView.frame = (CGRect){padding.width, padding.height, plainView.frame.size};
    
    
    
    
    
    // Add to the view hierarchy (thus retain).
    
   //  objApp=[[UIApplication sharedApplication]delegate];
     //DetailAnnotation*_detailannotation=annotation;
   //  ReturnDict*objReturn=[objApp.arrData objectAtIndex:_detailannotation.tag-100];
    
//    UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
//    img.image=[UIImage imageWithContentsOfFile:objReturn.strPath];
    self.centerOffset=CGPointMake(0, -80);
    self.frame=CGRectMake(0, 0, 200, 100);
  //  plainView.frame=self.frame;

    self.backgroundColor=[UIColor whiteColor];
    //[self addSubview:img];
  [self addSubview:plainView];
    return self;
}
@end
