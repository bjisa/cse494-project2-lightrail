//
//  StopDetails.h
//  LightRail
//
//  Created by Joshua Baldwin on 11/23/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationStopDetails : NSObject

@property long trip_id;
@property NSString *arrival_time;
@property NSString *departure_time;
@property long stop_id;
@property int stop_sequence;
@property int pickup_type;
@property int drop_off_type;
@property double shape_dist_traveled;

-(id) initWithString:(NSString *)details;

@end
