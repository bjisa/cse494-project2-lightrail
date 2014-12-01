//
//  TripAnalyzer.h
//  LightRail
//
//  Created by Joshua Baldwin on 11/30/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TripModel.h"

@interface TripAnalyzer : NSObject

- (int) getTripDirection:(long) tripID;


@end
