//
//  StationModel.m
//  LightRail
//
//  Created by Amy Baldwin on 11/19/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "StationModel.h"

@implementation StationModel

-(id) initWithCSVDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.stopID = dict[@"stop_id"];
        self.name = dict[@"name"];
        self.latitude = dict[@"latitude"];
        self.longitude = dict[@"longitude"];
    }
    return self;
}

@end
