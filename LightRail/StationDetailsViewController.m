//
//  StationDetailsViewController.m
//  LightRail
//
//  Created by Joshua Baldwin on 11/23/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "StationDetailsViewController.h"
#import "Constants.h"
#import "StationTimes.h"

@interface StationDetailsViewController ()

@property (nonatomic) Boolean eastbound;

@end

@implementation StationDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // DEBUG: Log the station ID
    NSLog(@"Station ID = %@", self.selectedStation.stopID);
    
    // Get the next couple of times
    [self getNextCoupleTimes];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


// User modifies the direction selector
- (IBAction) directionChanged:(id)sender
{
    // Set the direction
    if ([[self.directionSelector titleForSegmentAtIndex:self.directionSelector.selectedSegmentIndex] caseInsensitiveCompare:DirectionWestbound] == NSOrderedSame)
    {
        self.eastbound = false;
    }
    else if ([[self.directionSelector titleForSegmentAtIndex:self.directionSelector.selectedSegmentIndex] caseInsensitiveCompare:DirectionEastbound] == NSOrderedSame)
    {
        self.eastbound = true;
    }
    else    // Assume eastbound
    {
        self.eastbound = true;
    }
    
    // Log the direction selected by the user
    [self logDirection];
}


// Log the direction selected by the user
- (void) logDirection
{
    NSUserDefaults *prefs = [[NSUserDefaults alloc] init];
    if (self.eastbound)
    {
        [prefs setObject:DirectionEastbound forKey:DirectionUserDefaultKey];
    }
    else
    {
        [prefs setObject:DirectionWestbound forKey:DirectionUserDefaultKey];
    }
}

// Determine the next couple times that a train will be arriving
- (void) getNextCoupleTimes
{
    // Get array of arrival times
    NSLog(@"Getting arrival times...");
    StationTimes *stationTimes = [[StationTimes alloc] initWithStationID:self.selectedStation.stopID.intValue];
    NSArray *arrivalTimes = [[NSArray alloc] initWithArray:[stationTimes getTrainArrivalTimesArray:WestboundDirectionID]];
    for (NSString *str in arrivalTimes)
    {
        NSLog(@"%@", str);
    }
    NSLog(@"arrivalTimes.count = %lu", (unsigned long)arrivalTimes.count);
    
    // Get current date and time
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];    // Get the current time in 24-hour format
    
    // Display current time in 12HR/24HR (i.e. 11:25PM or 23:25) is formatted according to User Settings
    //[dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    
    NSString *currentTime = [dateFormatter stringFromDate:today];
    NSLog(@"Current Time: %@", currentTime);
    
}

@end
