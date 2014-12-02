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
- (NSArray *) getTrainArrivalTimesArray: (int) direction
{
    // Collect all arrival times into an array
    //NSLog(@"Performing trip analysis");
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *lastTime = [NSString new];
    for (StationStopDetails *item in self.stationStopDetailsArray)
    {
        item.arrival_time = [item.arrival_time stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![item.arrival_time isEqualToString:lastTime])
        {
            lastTime = item.arrival_time;
            [array addObject:item.arrival_time];
        }
    }
    
    // Proceed if we get data in our array
    if (array.count > 0)
    {
        // Fix hours lists that make no sense
        //NSLog(@"Fixing hours list");
        for (int i = 0; i < array.count; i++)
        {
            NSArray *temp = [NSArray arrayWithArray:[array[i] componentsSeparatedByString:@":"]];
            int hour = (int)[temp[0] integerValue] % 24;
            int minute = (int)[temp[1] integerValue] % 60;
            int second = (int)[temp[2] integerValue] % 60;
            array[i] = [NSString stringWithFormat:@"%02i:%02i:%02i", hour, minute, second];
        }
        
        // Sort the arrival times array
        //NSLog(@"Sorting the array");
        [array sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        // Remove duplicate values
        //NSLog(@"Removing duplicate values");
        NSMutableArray *newArray = [[NSMutableArray alloc] initWithObjects:[array objectAtIndex:0], nil];
        //NSLog(@"Instantiated newArray");
        for (int i = 1; i < array.count; i++)
        {
            if (![[array objectAtIndex:i] isEqualToString:[array objectAtIndex:(i-1)]])
            {
                [newArray addObject:[array objectAtIndex:i]];
            }
        }
        
        // Return the processed array
        //NSLog(@"Returning the processed array");
        return [NSArray arrayWithArray:newArray];
    }
    else
    {
        // There are no values in the array
        return nil;
    }
}


// Get a list of the train's departure times
- (NSArray *) getTrainDepartureTimesArray: (int) direction
{
    // Collect all arrival times into an array
    //NSLog(@"Performing trip analysis");
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *lastTime = [NSString new];
    for (StationStopDetails *item in self.stationStopDetailsArray)
    {
        item.departure_time = [item.departure_time stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![item.departure_time isEqualToString:lastTime])
        {
            lastTime = item.departure_time;
            [array addObject:item.departure_time];
        }
    }
    
    // Proceed if we get data in our array
    if (array.count > 0)
    {
        // Fix hours lists that make no sense
        //NSLog(@"Fixing hours list");
        for (int i = 0; i < array.count; i++)
        {
            NSArray *temp = [NSArray arrayWithArray:[array[i] componentsSeparatedByString:@":"]];
            int hour = (int)[temp[0] integerValue] % 24;
            int minute = (int)[temp[1] integerValue] % 60;
            int second = (int)[temp[2] integerValue] % 60;
            array[i] = [NSString stringWithFormat:@"%02i:%02i:%02i", hour, minute, second];
        }
        
        // Sort the arrival times array
        //NSLog(@"Sorting the array");
        [array sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        // Remove duplicate values
        //NSLog(@"Removing duplicate values");
        NSMutableArray *newArray = [[NSMutableArray alloc] initWithObjects:[array objectAtIndex:0], nil];
        //NSLog(@"Instantiated newArray");
        for (int i = 1; i < array.count; i++)
        {
            if (![[array objectAtIndex:i] isEqualToString:[array objectAtIndex:(i-1)]])
            {
                [newArray addObject:[array objectAtIndex:i]];
            }
        }
        
        // Return the processed array
        //NSLog(@"Returning the processed array");
        return [NSArray arrayWithArray:newArray];
    }
    else
    {
        // There are no values in the array
        return nil;
    }
}


@end
