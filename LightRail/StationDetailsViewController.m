//
//  StationDetailsViewController.m
//  LightRail
//
//  Created by Joshua Baldwin on 11/23/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "StationDetailsViewController.h"
#import "Constants.h"
#import "StationTimes.h"

@interface StationDetailsViewController ()

@property (nonatomic) Boolean eastbound;

@end

@implementation StationDetailsViewController

int const TrainTimeGreaterThanCurrentTime = 1;
int const TrainTimeLessThanCurrentTime = -1;
int const TrainTimeEqualToCurrentTime = 0;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Clear the text in the labels
    self.time1Label.text = @"";
    self.time2Label.text = @"";
    self.time3Label.text = @"";
    self.time4Label.text = @"";
    self.time5Label.text = @"";
    self.time6Label.text = @"";
    
    // DEBUG: Log the station ID
    //NSLog(@"Station ID = %@", self.selectedStation.stopID);
    
    // Get the next couple of times
    [self getNextCoupleTimes];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


// User modifies the direction selector
- (IBAction) directionChanged:(id)sender
{
    // Get the direction selected by the user
    NSString *currentDir = [self.directionSelector titleForSegmentAtIndex:self.directionSelector.selectedSegmentIndex];
    
    // Set the direction
    self.eastbound = ([currentDir caseInsensitiveCompare:DirectionWestbound] == NSOrderedSame);     // assume westbound
    
    // Log the direction selected by the user
    [self logDirection];
    
    // Reload the upcoming arrival times
    [self getNextCoupleTimes];
}


// Log the direction selected by the user
- (void) logDirection
{
    NSUserDefaults *prefs = [[NSUserDefaults alloc] init];
    [prefs setObject:(self.eastbound ? DirectionEastbound : DirectionWestbound) forKey:DirectionUserDefaultKey];
}

- (uint) getStationIDForDirection:(uint)direction
{
    // Get the correct stop_id_eastbound or stop_id_westbound
    NSString *path = [[NSBundle mainBundle] pathForResource:@"stops" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *stopArray = [NSArray arrayWithArray:[content componentsSeparatedByString:@"\n"]];
    
    //NSLog(@"StopString = %@", stopArray[self.selectedStation.stopID.intValue - 10001]);
    
    NSArray *temp = [stopArray[self.selectedStation.stopID.intValue - 10001] componentsSeparatedByString:@","];
    if (direction == EastboundDirectionID)
    {
        int value = [temp[0] intValue];
        return (value != 0) ? value : [temp[1] intValue];
    }
    else
    {
        int value = [temp[1] intValue];
        return (value != 0) ? value : [temp[0] intValue];
    }
}

// Determine the next couple times that a train will be arriving
- (void) getNextCoupleTimes
{
    // Get the current direction value
    NSString *currentDir = [self.directionSelector titleForSegmentAtIndex:self.directionSelector.selectedSegmentIndex];
    uint currentDirection = ([currentDir caseInsensitiveCompare:DirectionWestbound] == NSOrderedSame) ? WestboundDirectionID : EastboundDirectionID;
    [self logDirection];
    
    // Get array of arrival times
    NSLog(@"Getting arrival times...");
    StationTimes *stationTimes = [[StationTimes alloc] initWithStationID:[self getStationIDForDirection:currentDirection]];
    NSMutableArray *arrivalTimes = [[[NSArray alloc] initWithArray:[stationTimes getTrainArrivalTimesArray:currentDirection]] mutableCopy];
    
    // DEBUG: Print contents of array
    NSLog(@"Printing the arrival times found...");
    for (NSString *str in arrivalTimes)
    {
        NSLog(@"%@", str);
    }
    //NSLog(@"arrivalTimes.count = %lu", (unsigned long)arrivalTimes.count);
    
//    // Get current date and time
//    NSDate *today = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"HH:mm:ss"];    // Capitalized "HH" gets the current time in the 24-hour format that we want here
//    NSString *currentTime = [dateFormatter stringFromDate:today];
//    NSLog(@"Current Time: %@", currentTime);
    
    // Compare times
    Boolean isGreater = true;
    unsigned long i = arrivalTimes.count;
    i--;
    while (isGreater && i > 0)
    {
        isGreater = ([self compareToCurrentTime:arrivalTimes[i]] == TrainTimeGreaterThanCurrentTime);
        i--;
    }
    i++;
    i++;
    
    // Print the next 4 times into the data labels
    self.time1Label.text = [self formatTimeString:arrivalTimes[i % arrivalTimes.count]];
    i++;
    self.time2Label.text = [self formatTimeString:arrivalTimes[i % arrivalTimes.count]];
    i++;
    self.time3Label.text = [self formatTimeString:arrivalTimes[i % arrivalTimes.count]];
    i++;
    self.time4Label.text = [self formatTimeString:arrivalTimes[i % arrivalTimes.count]];
    i++;
    self.time5Label.text = [self formatTimeString:arrivalTimes[i % arrivalTimes.count]];
    i++;
    self.time6Label.text = [self formatTimeString:arrivalTimes[i % arrivalTimes.count]];
    i++;
    self.time7Label.text = [self formatTimeString:arrivalTimes[i % arrivalTimes.count]];
    i++;
    self.time8Label.text = [self formatTimeString:arrivalTimes[i % arrivalTimes.count]];
}


// Compare the times
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
        return TrainTimeGreaterThanCurrentTime;
    }
    else if ([train[0] intValue] < [current[0] intValue])
    {
        return TrainTimeLessThanCurrentTime;
    }
    // Comparison Step #2: Compare the minutes
    if ([train[1] intValue] > [current[1] intValue])
    {
        return TrainTimeGreaterThanCurrentTime;
    }
    else if ([train[1] intValue] < [current[1] intValue])
    {
        return TrainTimeLessThanCurrentTime;
    }
    // Comparison Step #3: Compare the seconds
    if ([train[2] intValue] > [current[2] intValue])
    {
        return TrainTimeGreaterThanCurrentTime;
    }
    else if ([train[2] intValue] < [current[2] intValue])
    {
        return TrainTimeLessThanCurrentTime;
    }
    
    // Train time and current time are equal
    return TrainTimeEqualToCurrentTime;
}

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
    
    return @"STUB";
}


@end
