//
//  StopDetails.m
//  LightRail
//
//  Created by Joshua Baldwin on 11/23/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "StationStopDetails.h"

@implementation StationStopDetails

-(id) initWithString:(NSString *)details
{
    self = [super init];
    if (self)
    {
        NSArray *items = [details componentsSeparatedByString:@","];
        @try
        {
            self.trip_id = (long)[items[0] integerValue];
            self.arrival_time = items[1];
            self.departure_time = items[2];
            self.stop_id = (long)[items[3] integerValue];
            self.stop_sequence = (int)[items[4] integerValue];
            self.pickup_type = (int)[items[5] integerValue];
            self.drop_off_type = (int)[items[6] integerValue];
            self.shape_dist_traveled = (double)[items[7] doubleValue];
        }
        @catch (NSException *exception)
        {
            self.trip_id = 0;
            self.arrival_time = nil;
            self.departure_time = nil;
            self.stop_id = 0;
            self.stop_sequence = 0;
            self.pickup_type = 0;
            self.drop_off_type = 0;
            self.shape_dist_traveled = 0;
        }
        @finally
        {
            ;
        }
    }
    return self;
}


@end
