//
//  MapViewController.m
//  callServiceDBwithMap
//
//  Created by sai on 26/08/14.
//  Copyright (c) 2014 sai infotech. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "MkPointannotation.h"
#import "DetailAnnotation.h"
#import "ReturnDict.h"
#import "AnnotationView.h"
#import "DetailViewController.h"
DetailViewController*objDetail;


AppDelegate*objApp;
DetailAnnotation*_detailannotation;
@interface MapViewController ()
{
    int findTag;
}

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    objApp=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
     
    // Do any additional setup after loading the view.
    
    
    
//  MKCoordinateRegion region;
//	CLLocationDegrees maxLat = -90;
//	CLLocationDegrees maxLon = -180;
//	CLLocationDegrees minLat = 120;
//	CLLocationDegrees minLon = 150;
    
    for (int i=0; i<[objApp.arrData count]; i++) {
        ReturnDict*objReturn=[objApp.arrData objectAtIndex:i];
        CLLocationCoordinate2D coor;
        coor.latitude=[objReturn.strLat floatValue];
        coor.longitude=[objReturn.strLong floatValue];
        MkPointannotation*point=[[MkPointannotation alloc]initWithLatitude:coor.latitude Longitude:coor.longitude];
        point.tag=i+100;
        [self.mapView addAnnotation:point];
        [self.mapView setCenterCoordinate:coor animated:true];
        
//        CLLocation* currentLocation = (CLLocation*)objMK ;
//		if(currentLocation.coordinate.latitude > maxLat)
//			maxLat = currentLocation.coordinate.latitude;
//		if(currentLocation.coordinate.latitude < minLat)
//			minLat = currentLocation.coordinate.latitude;
//		if(currentLocation.coordinate.longitude > maxLon)
//			maxLon = currentLocation.coordinate.longitude;
//		if(currentLocation.coordinate.longitude < minLon)
//			minLon = currentLocation.coordinate.longitude;
//		
//		region.center.latitude     = (maxLat + minLat) / 2;
//		region.center.longitude    = (maxLon + minLon) / 2;
//		region.span.latitudeDelta  =  maxLat - minLat;
//		region.span.longitudeDelta = maxLon - minLon;
//        [self.mapView setRegion:region animated:YES];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MkPointannotation class]]) {
        if (_detailannotation) {
            [self.mapView removeAnnotation:_detailannotation];
            _detailannotation=nil;
        }
        _detailannotation=[[DetailAnnotation alloc]initWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
        MkPointannotation*pointObj=(MkPointannotation*)view.annotation;
        _detailannotation.tag=pointObj.tag;
        [self.mapView addAnnotation:_detailannotation];
        [self.mapView setCenterCoordinate:_detailannotation.coordinate animated:true];
    }
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (_detailannotation&&![view.annotation isKindOfClass:[_detailannotation class]]) {
        if (_detailannotation.coordinate.latitude==view.annotation.coordinate.latitude &&_detailannotation.coordinate.longitude==view.annotation.coordinate.longitude ) {
               [self.mapView removeAnnotation:_detailannotation];
        }
    }
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[_detailannotation class]]) {
        AnnotationView*view=[[AnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"detailannotation"];
        DetailAnnotation *anno = annotation;
        
        findTag=anno.tag-100;
        ReturnDict*objReturn=[objApp.arrData objectAtIndex:findTag];
        view.rightCalloutAccessoryView=[UIButton buttonWithType: UIButtonTypeDetailDisclosure];
        view.img.image=[UIImage imageWithContentsOfFile:objReturn.strPath];
        view.lblNmae.text=objReturn.strName;
        view.lblId.text=[NSString stringWithFormat:@"ID: %@",objReturn.strID];
        [view.btn addTarget:self action:@selector(callOff:) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }
    else if([annotation isKindOfClass:[MkPointannotation class]]) {
        MKAnnotationView*view=[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"pointannotation"];
        
        if (!view) {
            view=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pointannotation"];
            view.canShowCallout=NO;
            view.image=[UIImage imageNamed:@"icon_marker.png"];
            
            return view;
        }
        
    }
    return nil;
}
-(IBAction)callOff:(id)sender
{
    [self performSegueWithIdentifier:@"detail" sender:self];

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString*segueIdentifier=[segue identifier];
    if ([segueIdentifier isEqualToString:@"detail"]) {
        objDetail=[[DetailViewController alloc]init];
        objDetail=[segue destinationViewController];
        ReturnDict*objReturn=[objApp.arrData objectAtIndex:findTag];
        objDetail.objReturn=objReturn;
       
    }

}

@end
