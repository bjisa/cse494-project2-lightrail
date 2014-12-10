//
//  SecondViewController.m
//  LightRail
//
//  Created by Ben Jisa on 11/19/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *arrivingAtLabel;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.direction = @"Eastbound";
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 200;
    [self.locationManager startUpdatingLocation];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    self.mapView.showsUserLocation = YES;
    [self addTrainPath];
}

- (void)addTrainPath {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    Stations *stations = [Stations sharedStations];
    
    //MKMapPoint* mappoints = malloc(sizeof(MKMapPoint) * stations.stationlist.count);
    //CLLocationCoordinate2D* pathcoordinates = malloc(sizeof(CLLocationCoordinate2D) * stations.stationlist.count);
    
    int numOfEastboundStops = 0;
    for (int i = 0; i < stations.stationlist.count; i++){
        StationModel *station = stations.stationlist[i];
        if ([station.stopIDEastbound intValue] != 0) {
            numOfEastboundStops++;
        }
    }
    self.numOfEastboundStops = numOfEastboundStops;
    
    MKMapPoint* mappoints = malloc(sizeof(MKMapPoint) * numOfEastboundStops);
    CLLocationCoordinate2D* pathcoordinates = malloc(sizeof(CLLocationCoordinate2D) * numOfEastboundStops);
    
    MKMapPoint* westboundMappoints = malloc(sizeof(MKMapPoint) * (stations.stationlist.count - numOfEastboundStops));
    CLLocationCoordinate2D* westboundPathcoordinates = malloc(sizeof(CLLocationCoordinate2D) * (stations.stationlist.count - numOfEastboundStops + 2));
    
    int i_eastbound = 0, i_westbound = 1;
    for (int i = 0; i < stations.stationlist.count; i++){
        StationModel *station = stations.stationlist[i];
        // Route
        
        // Eastbound - Jefferson (12-16), Westbound - Washington (29-33)
        
        if ([station.stopIDEastbound intValue] == 0){ // westbound
            westboundPathcoordinates[i_westbound] = CLLocationCoordinate2DMake([station.latitude doubleValue], [station.longitude doubleValue]);
            westboundMappoints[i_westbound] = MKMapPointForCoordinate(westboundPathcoordinates[i_westbound]);
            
            if (i_westbound == 1) { // Add the stop before east/westbound split to two stations
                StationModel *station = stations.stationlist[i-1];
                westboundPathcoordinates[0] = CLLocationCoordinate2DMake([station.latitude doubleValue], [station.longitude doubleValue]);
                westboundMappoints[0] = MKMapPointForCoordinate(westboundPathcoordinates[0]);
            }
            else if (i_westbound == stations.stationlist.count - numOfEastboundStops) { // Add the stop where it merges back
                /*StationModel *station = stations.stationlist[i+1];
                 westboundPathcoordinates[i_westbound+1] = CLLocationCoordinate2DMake([station.latitude doubleValue], [station.longitude doubleValue]);
                 westboundMappoints[i_westbound+1] = MKMapPointForCoordinate(westboundPathcoordinates[0]);*/
            }
            
            MKPointAnnotation *stationAnnotation = [[MKPointAnnotation alloc] init];
            stationAnnotation.coordinate = westboundPathcoordinates[i_westbound];
            stationAnnotation.title = station.name;
            [self.mapView addAnnotation:stationAnnotation];
            
            i_westbound++;
        }
        else if ([station.stopIDEastbound intValue] != 0) {
            pathcoordinates[i_eastbound] = CLLocationCoordinate2DMake([station.latitude doubleValue], [station.longitude doubleValue]);
            mappoints[i_eastbound] = MKMapPointForCoordinate(pathcoordinates[i]);
            
            // Adding stations annotations
            
            MKPointAnnotation *stationAnnotation = [[MKPointAnnotation alloc] init];
            stationAnnotation.coordinate = pathcoordinates[i_eastbound];
            stationAnnotation.title = station.name;
            [self.mapView addAnnotation:stationAnnotation];
            
            i_eastbound++;
        }
    }
    
    //[self.locationManager startUpdatingLocation];
    
    //CLLocationCoordinate2D currentCoordinate = self.locationManager.location.coordinate;
    
    // Forming polyline and adding to map
    
    MKPolyline *trainRoute = [MKPolyline polylineWithPoints:mappoints count:numOfEastboundStops];
    self.trainRoute = trainRoute;
    //[self.mapView addOverlay:trainRoute];
    
    //MKPolyline *westboundTrainRoute = [MKPolyline polylineWithPoints:westboundMappoints count:(stations.stationlist.count - numOfEastboundStops + 2)];
    //[self.mapView addOverlay:westboundTrainRoute];
    
    //NSArray *overlays = [NSArray arrayWithObjects:trainRoute, westboundTrainRoute, nil];
    //[self.mapView addOverlays:overlays];
    
    //[self zoomToPolyline:self.mapView polyLine:trainRoute animated:YES];
    
    /*for (int i = 0; i < trainRoute.pointCount; i++) {
        NSLog(@"i: %d, point x: %f, y: %f", i, trainRoute.points[0].x, trainRoute.points[0].y);
    }*/
    
    // Just zoom to the 12th station for now since we don't have the polyline :/
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(pathcoordinates[12], 30000.0, 30000.0);
    [self.mapView setRegion:region animated:YES];
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    self.polylineView = [[MKPolylineView alloc] initWithPolyline:self.trainRoute];
    self.polylineView.lineWidth = 5;
    self.polylineView.strokeColor = [UIColor blueColor];
    
    return self.polylineView;
}

-(void)zoomToPolyline: (MKMapView*)map polyLine: (MKPolyline*)polyLine
             animated:(BOOL)animated
{
    [map setVisibleMapRect:[self.trainRoute boundingMapRect] edgePadding:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0) animated:animated];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // Notify the user
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Unable to obtain current location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // if the new location is not nil
    if (newLocation != nil) {
        Stations *stations = [Stations sharedStations];
        
        // Get the closest station by distance regardless of direction/next stop
        int minDistanceElement = -1;
        double minDistance = 100000000000000;
        for (int i = 0; i < stations.stationlist.count; i++){
            StationModel *station = stations.stationlist[i];
            double distance = sqrt(pow(([station.latitude doubleValue] - newLocation.coordinate.latitude), 2) + pow(([station.longitude doubleValue] - newLocation.coordinate.longitude), 2));
            if (distance < minDistance) {
                minDistanceElement = i;
                minDistance = distance;
            }
        }
        StationModel *closestStation = stations.stationlist[minDistanceElement];
        //NSLog([NSString stringWithFormat:@"Current location: %d, %d", (double)newLocation.coordinate.latitude, (double)newLocation.coordinate.longitude]);
        // Get the direction we are going
        //NSLog(@"distance: %f; lat: %f, lon: %f", minDistance, (double)newLocation.coordinate.latitude, (double)newLocation.coordinate.longitude);
        //NSString *direction = @"";
        double longitudeDifference = newLocation.coordinate.longitude - oldLocation.coordinate.longitude;
        double latitudeDifference = newLocation.coordinate.latitude - oldLocation.coordinate.latitude; // For determining direction when we are traveling straight north/south
        
        NSLog(@"##########################");
        NSLog(@"Old lat: %f, lon: %f", (double)oldLocation.coordinate.latitude, (double)oldLocation.coordinate.longitude);
        NSLog(@"New lat: %f, lon: %f", (double)newLocation.coordinate.latitude, (double)newLocation.coordinate.longitude);
        NSLog(@"Difference lat %f, lon: %f, ", latitudeDifference, longitudeDifference);
        
        if (fabs(longitudeDifference) > 0.0001) { // If the longtitude difference is big enough, check whether we are going east or west
            if (longitudeDifference < 0)
                self.direction = @"Westbound";
            else if (longitudeDifference > 0)
                self.direction = @"Eastbound";
        }
        else { // If the longtitude difference is too low, use latitude
            if (latitudeDifference > 0)
                self.direction = @"Westbound";
            else if (latitudeDifference < 0)
                self.direction = @"Eastbound";
        }
        NSLog(@"Direction: %@", self.direction);
        
        double lonFromStation = [closestStation.longitude doubleValue] - newLocation.coordinate.longitude;
        double latFromStation = [closestStation.longitude doubleValue] - newLocation.coordinate.longitude;
        NSLog(@"Fabs(lonFromStation): %f, fabs(latFromStation): %f", fabs(lonFromStation), fabs(latFromStation));
        StationModel *nextStation;
        if (fabs(lonFromStation) < 1 || fabs(latFromStation) < 1) {
            if ([self.direction isEqualToString:@"Eastbound"]) {
                if (fabs(longitudeDifference) > 0.0001) {
                    if ( (lonFromStation < 0)) {
                        if (minDistanceElement < stations.stationlist.count) {
                            nextStation = stations.stationlist[minDistanceElement+1];
                        }
                        else
                            nextStation = stations.stationlist[minDistanceElement];
                    }
                    else
                        nextStation = closestStation;
                }
                else { // We check with latitude
                    if ( (latFromStation > 0)) {
                        if (minDistanceElement < stations.stationlist.count) {
                            nextStation = stations.stationlist[minDistanceElement+1];
                        }
                        else
                            nextStation = stations.stationlist[minDistanceElement];
                    }
                }
            }
            else { // if Westbound
                if ( (lonFromStation < 0)) {
                    nextStation = closestStation;
                }
                else {
                    if (minDistanceElement > 0) {
                        nextStation = stations.stationlist[minDistanceElement-1];
                    }
                    else
                        nextStation = stations.stationlist[0];
                }
            }
            
            NSLog(@"Closest station: %@", closestStation.name);
            NSLog(@"Difference from closest lat %f, lon: %f, ", latFromStation, lonFromStation);
            if (nextStation != nil) {
                NSLog(@"Next station: %@", nextStation.name);
            }
            self.arrivingAtLabel.text = [NSString stringWithFormat:@"Direction: %@\nNext station: %@", self.direction, nextStation.name];
            
        }
        else {
            self.arrivingAtLabel.text = @"Not within distance";
        }
    }
}

@end
