//
//  Trip.h
//  LightRail
//
//  Created by Ben Jisa on 12/3/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StationStopDetails.h"

@interface Trip : NSObject

@property (nonatomic, strong) NSMutableArray *tripDetailsArray;

- (id) initWithTripID:(long)tripID;

@end
