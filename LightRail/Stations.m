//
//  Stations.m
//  LightRail
//
//  Created by Ben Jisa on 11/19/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "Stations.h"
#import "StationModel.h"

@implementation Stations

static Stations *theStations = nil;

+(Stations *) sharedStations {
    
    if (theStations == nil)
    {
        theStations = [[Stations alloc] init];
    }
    
    return theStations;
    
}

-(id) init {
    
    self = [super init];
    
    if (self)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"stops" ofType:@"txt"];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        NSArray *items = [content componentsSeparatedByString:@"\n"];
        self.stationlist = [NSMutableArray new];
        
        for (NSString *item in items) {
            
            if (![[item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
            {
                NSLog(@"item = %@", item);
                NSArray *station = [item componentsSeparatedByString:@","];
                NSMutableDictionary *stationdict = [NSMutableDictionary new];
                
                [stationdict setObject:station[2] forKey:@"stop_id"];
                [stationdict setObject:station[3] forKey:@"name"];
                [stationdict setObject:station[5] forKey:@"latitude"];
                [stationdict setObject:station[6] forKey:@"longitude"];
                
                StationModel * newStation = [[StationModel alloc] initWithCSVDictionary:stationdict];
                [self.stationlist addObject:newStation];
            }
        }
    }
    return self;
}

@end
