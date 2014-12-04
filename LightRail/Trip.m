//
//  Trip.m
//  LightRail
//
//  Created by Ben Jisa on 12/3/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "Trip.h"

@implementation Trip

-(id) initWithCSVDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.tripID = dict[@"trip_id"];
        self.departureTime = dict[@"departure_time"];
        self.stopID = dict[@"stop_id"];
        self.stopSequence = dict[@"stop_sequence"];
    }
    return self;
}

@end