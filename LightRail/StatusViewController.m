//
//  StatusViewController.m
//  LightRail
//
//  Created by Ben Jisa on 12/3/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "StatusViewController.h"
#import "Stations.h"
#import "StationModel.h"
#import "Trip.h"

@interface StatusViewController ()

@property NSMutableArray* stopsList;

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getTripSchedule];
    [self.tableView reloadData];

}

- (void) viewDidAppear:(BOOL)animated {
    
    [self getTripSchedule];
    [self.tableView reloadData];
}

- (void) getTripSchedule {
    
    Stations *stations = [Stations sharedStations];
    
    long stopID = [stations.currentStation doubleValue];
    NSString *nextTime = [NSString stringWithFormat:@"%@", stations.currentTime];
    
    
    // ====================================
    // Make array of next stops for a trip
    // ====================================
    NSString *path = [[NSBundle mainBundle] pathForResource:@"stop_times" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *items = [content componentsSeparatedByString:@"\n"];
    self.stopsList = [NSMutableArray new];
    
    double tripID = 0;
    
    BOOL foundTripID = NO;
    
    // Figure out what the tripID is
    
    
        for (NSString *item in items)
        {
            if (!foundTripID) {
                if (!([[item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                       isEqualToString:@""] ||
                      [[item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                       isEqualToString:@"stop_id_west,stop_id_east,stop_code,stop_name,stop_desc,stop_lat,stop_lon,zone_id,wheelchair_boarding"]))
                {
                    //NSLog(@"item = %@", item);
                    
                    NSArray *station = [item componentsSeparatedByString:@","];
                    
                    if (stopID == [station[3] doubleValue] && [self compareToCurrentTime:station[2]] == 1) {
                        
                        tripID = [station[0] doubleValue];
                        
                        foundTripID = YES;
                    }
                    
                }
            }
        }
    
    // The tripID is the tripID of first element in stopsList
    
    
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
            
            if (tripID == [station[0] doubleValue] && [self compareToCurrentTime:station[2]] == 1) {
                [stationdict setObject:station[0] forKey:@"trip_id"];
                [stationdict setObject:station[2] forKey:@"departure_time"];
                [stationdict setObject:station[3] forKey:@"stop_id"];
                [stationdict setObject:station[6] forKey:@"stop_sequence"];
                
                Trip * newTrip = [[Trip alloc] initWithCSVDictionary:stationdict];
                [self.stopsList addObject:newTrip];
            }
            
        }
    }
    
}

- (int) compareToCurrentTime:(NSString *)trainTime
{
    // Get current time
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];    // Capitalized "HH" gets the current time in the 24-hour format that we want here
    NSString *currentTime = [dateFormatter stringFromDate:today];
    //NSLog(@"Current Time: %@", currentTime);
    
    // Remove possible whitespace from trainTime
    trainTime = [trainTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Split times into arrays
    NSArray *train = [trainTime componentsSeparatedByString:@":"];
    NSArray *current = [currentTime componentsSeparatedByString:@":"];
    
    // Comparison Step #1: Compare the hours
    if ([train[0] intValue] > [current[0] intValue])
    {
        return 1;
    }
    else if ([train[0] intValue] < [current[0] intValue])
    {
        return -1;
    }
    // Comparison Step #2: Compare the minutes
    if ([train[1] intValue] > [current[1] intValue])
    {
        return 1;
    }
    else if ([train[1] intValue] < [current[1] intValue])
    {
        return -1;
    }
    // Comparison Step #3: Compare the seconds
    if ([train[2] intValue] > [current[2] intValue])
    {
        return 1;
    }
    else if ([train[2] intValue] < [current[2] intValue])
    {
        return -1;
    }
    
    // Train time and current time are equal
    return 0;
}

// Format the time string into either 12 hour or 24 hour time format depending on the user's preferences
- (NSString *) formatTimeString:(NSString *)str
{
    // Determine if the user wants a 12 hour clock or a 24 hour clock
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    Boolean is24hour = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    //NSLog(@"User wants a 24 hour clock? %@",(is24hour ? @"YES" : @"NO"));
    
    // Return the correct time style
    if (is24hour)
    {
        return str;
    }
    else
    {
        NSArray *train = [str componentsSeparatedByString:@":"];
        int hour = [train[0] intValue];
        int minute = [train[1] intValue];
        int second = [train[2] intValue];
        if (hour > 12)          // PM
        {
            hour = hour % 12;
            return [NSString stringWithFormat:@"%i:%02i:%02i PM", hour, minute, second];
        }
        else if (hour == 0)     // AM right after midnight
        {
            hour = 12;
            return [NSString stringWithFormat:@"%i:%02i:%02i AM", hour, minute, second];
        }
        else if (hour == 12)    // PM at about noonish
        {
            return [NSString stringWithFormat:@"%i:%02i:%02i PM", hour, minute, second];
        }
        else                    // AM
        {
            return [NSString stringWithFormat:@"%i:%02i:%02i AM", hour, minute, second];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stopsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Trip * newTrip = self.stopsList[indexPath.row];
    
    
    StationModel *model = [Stations getStationByStopID:newTrip.stopID];
    
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = [self formatTimeString:newTrip.departureTime];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
