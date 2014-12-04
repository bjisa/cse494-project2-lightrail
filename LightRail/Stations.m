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

+(Stations *) sharedStations
{
    if (theStations == nil)
    {
        theStations = [[Stations alloc] init];
    }
    return theStations;
}

-(id) init
{
    self = [super init];
    if (self)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"stops" ofType:@"txt"];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        NSArray *items = [content componentsSeparatedByString:@"\n"];
        self.stationlist = [NSMutableArray new];
        
        for (NSString *item in items)
        {
            
            if (!([[item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                   isEqualToString:@""] ||
                  [[item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                   isEqualToString:@"stop_id_west,stop_id_east,stop_code,stop_name,stop_desc,stop_lat,stop_lon,zone_id,wheelchair_boarding"]))
            {
                //NSLog(@"item = %@", item);
                NSArray *station = [item componentsSeparatedByString:@","];
                NSMutableDictionary *stationdict = [NSMutableDictionary new];
                
                [stationdict setObject:station[2] forKey:@"stop_id"];
                [stationdict setObject:station[0] forKey:@"stop_id_east"];
                [stationdict setObject:station[1] forKey:@"stop_id_west"];
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

+ (StationModel *)getStation:(NSString *)stop_id {
    Stations *stations = [Stations sharedStations];
    for (StationModel *station in stations.stationlist) {
        if ([station.stopID isEqualToString:stop_id]){
            return station;
        }
    }
    return nil;
}

+ (StationModel *)getStationByStopID:(NSString *)stop_id {
    Stations *stations = [Stations sharedStations];
    for (StationModel *station in stations.stationlist) {
        if ([station.stopIDEastbound isEqualToString:stop_id] || [station.stopIDWestbound isEqualToString:stop_id]){
            return station;
        }
    }
    return nil;
}

@end
