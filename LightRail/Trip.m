//
//  Trip.m
//  LightRail
//
//  Created by Ben Jisa on 12/3/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "Trip.h"

@implementation Trip

- (id) initWithTripID:(long)tripID
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
        //NSLog(@"stopTimeDetails.count = %lu", (unsigned long)stopTimeDetails.count);
        
        // Copy the stations with the desired ID into the mutable array
        self.tripDetailsArray = [[NSMutableArray alloc] init];
        for (int i = 1; i < stopTimeDetails.count; i++)
        {
            // Add the station if it has the same trip ID as the trip ID requested by the user
            StationStopDetails *details = [[StationStopDetails alloc] initWithString:stopTimeDetails[i]];
            
            if (details.trip_id == tripID)
            {
                //NSLog(@"Adding station with tripID %li", details.trip_id);
                [self.tripDetailsArray addObject:details];
            }
        }
    }
    return self;
}

@end
