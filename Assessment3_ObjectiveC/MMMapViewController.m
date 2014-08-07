//
//  MMMapViewController.m
//  Assessment3_ObjectiveC
//
//  Created by Kevin McQuown on 8/5/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MMMapViewController.h"
#import <MapKit/MapKit.h>

@interface MMMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (nonatomic, strong) MKPointAnnotation *currentLocationAnnotation;

@end

@implementation MMMapViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = [self.currentStation objectForKey:@"stationName"];
    self.currentLocationAnnotation = [[MKPointAnnotation alloc] init];
    CGFloat longitude = [[self.currentStation objectForKey:@"longitude"] floatValue];
    CGFloat latitude = [[self.currentStation objectForKey:@"latitude"] floatValue];
    self.currentLocationAnnotation.coordinate = CLLocationCoordinate2DMake(latitude,longitude);
    [self.myMapView addAnnotation:self.currentLocationAnnotation];
    [self.myMapView showAnnotations:self.myMapView.annotations animated:YES];

}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation !=self.myMapView.userLocation) {
        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        pin.canShowCallout = YES;
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        if (annotation == self.currentLocationAnnotation) {
            pin.image = [UIImage imageNamed:@"divvy"];
        }else{
            pin.image = [UIImage imageNamed:@"currentLocation"];
        }
        return  pin;
    }else{
        return  nil;
    }

}

@end
