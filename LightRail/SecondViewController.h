//
//  SecondViewController.h
//  LightRail
//
//  Created by Ben Jisa on 11/19/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationModel.h"
#import "Stations.h"
@import CoreLocation;
@import MapKit;

@interface SecondViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) MKPolyline *trainRoute;
@property (nonatomic, strong) MKPolylineView *polylineView;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) CLLocation* initialLocation;
@property (nonatomic, strong) NSString* direction;
@property (nonatomic) int numOfEastboundStops;

@end
