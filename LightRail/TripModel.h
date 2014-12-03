//
//  TripModel.h
//  LightRail
//
//  Created by Joshua Baldwin on 11/30/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripModel : NSObject

@property uint route_id;
@property uint service_id;
@property long trip_id;
@property NSString *trip_headsign;
@property uint direction_id;
@property long block_id;
@property long shape_id;

-(id) initWithString:(NSString *)details;


@end
