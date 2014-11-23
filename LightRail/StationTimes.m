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


- (id) initWithStationID:(int)stationID
{
    self = [super init];
    
    if (self)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"stop-times" ofType:@"txt"];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        NSArray *stopTimeDetails = [content componentsSeparatedByString:@"\n"];
        self.stationStopDetailsArray = [[NSMutableArray alloc] init];
        
        for (int i = 1; i < self.stationStopDetailsArray.count; i++)
        {
            // Add the station if it has the same stop ID as the stop ID requested by the user
            StationStopDetails *details = [[StationStopDetails alloc] initWithString:stopTimeDetails[i]];
            
            if (details.stop_id == stationID)
            {
                [self.stationStopDetailsArray addObject:details];
            }
        }
    }
    
    return self;
}


// Get a list of the train's arrival times
- (NSArray *) getTrainArrivalTimesArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (StationStopDetails *item in self.stationStopDetailsArray)
    {
        [array addObject:item.arrival_time];
    }
    return [NSArray arrayWithArray:array];
}


// Get a list of the train's departure times
- (NSArray *) getTrainDepartureTimesArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (StationStopDetails *item in self.stationStopDetailsArray)
    {
        [array addObject:item.departure_time];
    }
    return [NSArray arrayWithArray:array];
}


@end
