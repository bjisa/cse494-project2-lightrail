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
    // Get the direction selected by the user
    NSString *currentDir = [self.directionSelector titleForSegmentAtIndex:self.directionSelector.selectedSegmentIndex];
    
    // Set the direction
    self.eastbound = ([currentDir caseInsensitiveCompare:DirectionWestbound] == NSOrderedSame);     // assume westbound
    
    // Log the direction selected by the user
    [self logDirection];
    
    // Reload the upcoming arrival times
    [self getNextCoupleTimes];
}


// Log the direction selected by the user
- (void) logDirection
{
    NSUserDefaults *prefs = [[NSUserDefaults alloc] init];
    [prefs setObject:(self.eastbound ? DirectionEastbound : DirectionWestbound) forKey:DirectionUserDefaultKey];
}

- (uint) getStationIDForDirection:(uint)direction
{
    // Get the correct stop_id_eastbound or stop_id_westbound
    NSString *path = [[NSBundle mainBundle] pathForResource:@"stops" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *stopArray = [NSArray arrayWithArray:[content componentsSeparatedByString:@"\n"]];
    
    //NSLog(@"StopString = %@", stopArray[self.selectedStation.stopID.intValue - 10001]);
    
    NSArray *temp = [stopArray[self.selectedStation.stopID.intValue - 10001] componentsSeparatedByString:@","];
    if (direction == EastboundDirectionID)
    {
        int value = [temp[0] intValue];
        return (value != 0) ? value : [temp[1] intValue];
    }
    else
    {
        int value = [temp[1] intValue];
        return (value != 0) ? value : [temp[0] intValue];
    }
}

// Determine the next couple times that a train will be arriving
- (void) getNextCoupleTimes
{
    // Get the current direction value
    NSString *currentDir = [self.directionSelector titleForSegmentAtIndex:self.directionSelector.selectedSegmentIndex];
    uint currentDirection = ([currentDir caseInsensitiveCompare:DirectionWestbound] == NSOrderedSame) ? WestboundDirectionID : EastboundDirectionID;
    [self logDirection];
    
    // Get array of arrival times
    NSLog(@"Getting arrival times...");
    StationTimes *stationTimes = [[StationTimes alloc] initWithStationID:[self getStationIDForDirection:currentDirection]];
    NSMutableArray *arrivalTimes = [[[NSArray alloc] initWithArray:[stationTimes getTrainArrivalTimesArray:currentDirection]] mutableCopy];
    
    // DEBUG: Print contents of array
    NSLog(@"Printing the arrival times found...");
    for (NSString *str in arrivalTimes)
    {
        NSLog(@"%@", str);
    }
    //NSLog(@"arrivalTimes.count = %lu", (unsigned long)arrivalTimes.count);
    
    // Get current date and time
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];    // Capitalized "HH" gets the current time in the 24-hour format that we want here
    NSString *currentTime = [dateFormatter stringFromDate:today];
    NSLog(@"Current Time: %@", currentTime);
    
    // Compare times
    
    // Print the next 4 times
}


// Compare the times 



@end
