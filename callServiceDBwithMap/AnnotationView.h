//
//  AnnotationView.h
//  callServiceDBwithMap
//
//  Created by sai on 29/08/14.
//  Copyright (c) 2014 sai infotech. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface AnnotationView : MKAnnotationView
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lblNmae;
@property(nonatomic ,retain)UIView*contentView;
@property (weak, nonatomic) IBOutlet UILabel *lblId;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
