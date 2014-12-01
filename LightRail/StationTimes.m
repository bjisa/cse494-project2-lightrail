//
//  StationTimes.m
//  LightRail
//
//  Created by Joshua Baldwin on 11/23/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "StationTimes.h"
#import "StationStopDetails.h"

@implementation StationTimes

//static StationTimes *sharedStationTimes = nil;
//
//+ (StationTimes *) stationTimes:(int) stationID
//{
//    if (sharedStationTimes == nil)
//    {
//        sharedStationTimes = [[StationTimes alloc] initWithStationID:stationID];
//    }
//    return sharedStationTimes;
//}


- (id) initWithStationID:(long)stationID
{
    self = [super init];
    
    if (self)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"stop_times" ofType:@"txt"];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSArray *stopTimeDetails = [NSArray arrayWithArray:[content componentsSeparatedByString:@"\n"]];
        
        // DEBUG STATEMENTS
        //NSLog(@"Path: %@", path);
        //NSLog(@"Content:\n%@", content);
        NSLog(@"stopTimeDetails.count = %lu", (unsigned long)stopTimeDetails.count);
        
        // Copy the stations with the desired ID into the mutable array
        self.stationStopDetailsArray = [[NSMutableArray alloc] init];
        for (int i = 1; i < stopTimeDetails.count; i++)
        {
            // Add the station if it has the same stop ID as the stop ID requested by the user
            StationStopDetails *details = [[StationStopDetails alloc] initWithString:stopTimeDetails[i]];
            
            if (details.stop_id == stationID)
            {
                //NSLog(@"Adding station with stopID %li", details.stop_id);
                [self.stationStopDetailsArray addObject:details];
            }
        }
        
    }
    
    return self;
}


// Get a list of the train's arrival times
- (NSArray *) getTrainArrivalTimesArray
{
    // Collect all arrival times into an array
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (StationStopDetails *item in self.stationStopDetailsArray)
    {
        [array addObject:item.arrival_time];
    }
    
    // Fix hours lists that make no sense
    for (int i = 0; i < array.count; i++)
    {
        NSArray *temp = [NSArray arrayWithArray:[array[i] componentsSeparatedByString:@":"]];
        int hour = (int)[temp[0] integerValue] % 24;
        int minute = (int)[temp[1] integerValue] % 60;
        int second = (int)[temp[2] integerValue] % 60;
        array[i] = [NSString stringWithFormat:@"%02i:%02i:%02i", hour, minute, second];
    }
    
    // Sort the arrival times array
    [array sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    // Remove duplicate values
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithObjects:[array objectAtIndex:0], nil];
    for (int i = 1; i < [array count]; i++)
    {
        if (![[array objectAtIndex:i] isEqualToString:[array objectAtIndex:(i-1)]])
        {
            [newArray addObject:[array objectAtIndex:i]];
        }
    }
    
    // Remove stops with a tripID that does not have the desired direction
    
    
    
    
    // Return the processed array
    return [NSArray arrayWithArray:newArray];
}


// Get a list of the train's departure times
- (NSArray *) getTrainDepartureTimesArray
{
    // Collect all arrival times into an array
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (StationStopDetails *item in self.stationStopDetailsArray)
    {
        [array addObject:item.departure_time];
    }
    
    // Fix hours lists that make no sense
    for (int i = 0; i < array.count; i++)
    {
        NSArray *temp = [NSArray arrayWithArray:[array[i] componentsSeparatedByString:@":"]];
        int hour = (int)[temp[0] integerValue] % 24;
        int minute = (int)[temp[1] integerValue] % 60;
        int second = (int)[temp[2] integerValue] % 60;
        array[i] = [NSString stringWithFormat:@"%02i:%02i:%02i", hour, minute, second];
    }
    
    // Sort the departure times array
    [array sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    // Remove duplicate values
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithObjects:[array objectAtIndex:0], nil];
    for (int i = 1; i < [array count]; i++)
    {
        if (![[array objectAtIndex:i] isEqualToString:[array objectAtIndex:(i-1)]])
        {
            [newArray addObject:[array objectAtIndex:i]];
        }
    }
    
    // Remove stops with a tripID that does not have the desired direction
    
    
    
    
    // Return the processed array
    return [NSArray arrayWithArray:newArray];
}


@end
