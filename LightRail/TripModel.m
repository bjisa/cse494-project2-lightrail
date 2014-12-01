//
//  TripModel.m
//  LightRail
//
//  Created by Joshua Baldwin on 11/30/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "TripModel.h"

@implementation TripModel

-(id) initWithString:(NSString *)details
{
    self = [super init];
    if (self)
    {
        NSArray *items = [details componentsSeparatedByString:@","];
        @try
        {
            self.route_id = (uint)[items[0] integerValue];
            self.service_id = (uint)[items[1] integerValue];
            self.trip_id = (long)[items[2] integerValue];
            self.trip_headsign = [items[3] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            self.direction_id = (uint)[items[4] integerValue];
            self.block_id = (long)[[items[5] stringByReplacingOccurrencesOfString:@"\"" withString:@""] integerValue];
            self.shape_id = (long)[items[6] integerValue];
        }
        @catch (NSException *exception)
        {
            self.route_id = 0;
            self.service_id = 0;
            self.trip_id = 0;
            self.trip_headsign = nil;
            self.direction_id = 0;
            self.block_id = 0;
            self.shape_id = 0;
        }
        @finally
        {
            ;
        }
    }
    
    return self;
}



@end
