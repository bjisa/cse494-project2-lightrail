//
//  StationTimes.h
//  LightRail
//
//  Created by Joshua Baldwin on 11/23/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StationStopDetails.h"
#import "TripAnalyzer.h"

@interface StationTimes : NSObject

@property (nonatomic, strong) NSMutableArray *stationStopDetailsArray;

// Create a Singleton of the station times
//+ (StationTimes *) stationTimes:(long)stationID;

// Create a new array of station times for a given station
- (id) initWithStationID:(long)stationID;

// Get an array of arrival times for a station
- (NSArray *) getTrainArrivalTimesArray: (int) direction;

// Get an array of departure times for a station
- (NSArray *) getTrainDepartureTimesArray: (int) direction;


@end
