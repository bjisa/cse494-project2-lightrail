//
//  Stations.h
//  LightRail
//
//  Created by Ben Jisa on 11/19/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StationModel.h"

@interface Stations : NSObject
@property (nonatomic, strong) NSMutableArray *stationlist;

+ (Stations*) sharedStations;
+ (StationModel *) getStation:(NSString *)stop_id;

@end
