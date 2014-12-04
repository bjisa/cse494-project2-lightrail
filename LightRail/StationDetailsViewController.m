//
//  StationDetailsViewController.m
//  LightRail
//
//  Created by Joshua Baldwin on 11/23/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "StationDetailsViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "StationTimes.h"
#import "Stations.h"

@interface StationDetailsViewController ()

@property (nonatomic) Boolean eastbound;
@property Boolean firstLoad;
@property NSMutableArray *favoriteStations;
@property NSString *nextTime;

- (IBAction)addToFavorites:(id)sender;
- (IBAction)boardNext:(id)sender;

@end

@implementation StationDetailsViewController

int const TrainTimeGreaterThanCurrentTime = 1;
int const TrainTimeLessThanCurrentTime = -1;
int const TrainTimeEqualToCurrentTime = 0;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.firstLoad = true;
    
    // Clear the text in the labels
    self.time1Label.text = @"";
    self.time2Label.text = @"";
    self.time3Label.text = @"";
    self.time4Label.text = @"";
    self.time5Label.text = @"";
    self.time6Label.text = @"";
    self.time7Label.text = @"";
    self.time8Label.text = @"";
    
    // Get the next couple of times
    [self getNextCoupleTimes];
    
    // Fill favorite stations array
    self.favoriteStations = [[NSMutableArray alloc] init];
    [self loadChecklistItems];
    
    // Detect if the station is a favorite station
    Boolean inFavorites = [self isStationIDInFavorites:self.selectedStation.stopID];
    NSLog(@"viewDidLoad inFavorites = %@", (inFavorites ? @"true" : @"false"));
    
    // Update the click button
    [self changeButtonView:inFavorites];
    
    NSLog(@"Selected Station id: %@", self.selectedStation.stopID);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self saveChecklistItems];
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
    self.eastbound = ([currentDir caseInsensitiveCompare:DirectionWestbound] == NSOrderedSame);     // assume westbound if final direction unknown
    
    // Log the direction selected by the user
    [self logDirection];
    
    // Reload the upcoming arrival times
    [self getNextCoupleTimes];
}


// Log the direction selected by the user
- (void) logDirection
{
    //NSLog(@"Current Direction = %@", (self.eastbound ? DirectionEastbound : DirectionWestbound));
    NSUserDefaults *prefs = [[NSUserDefaults alloc] init];
    [prefs setObject:(self.eastbound ? DirectionEastbound : DirectionWestbound) forKey:DirectionUserDefaultKey];
}


// Determine the next couple times that a train will be arriving
- (void) getNextCoupleTimes
{
    // Get the current direction value
    NSString *currentDir = [self.directionSelector titleForSegmentAtIndex:self.directionSelector.selectedSegmentIndex];
    uint currentDirection = (([currentDir caseInsensitiveCompare:DirectionWestbound] == NSOrderedSame) ? WestboundDirectionID : EastboundDirectionID);
    [self logDirection];
    
    // Get array of arrival times and load the directions if the direction value that we have is not equal to 0
    //NSLog(@"Getting arrival times...");
    uint stationID = [self getStationIDForDirection:currentDirection];
    StationTimes *stationTimes = [[StationTimes alloc] initWithStationID:stationID];
    NSArray *arrivalTimes = [[NSArray alloc] initWithArray:[stationTimes getTrainArrivalTimesArray:currentDirection]];
    
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
    
    self.nextTime = arrivalTimes[i % arrivalTimes.count];
    
    // Format and print the next 4 times into the data labels
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


// Get the station ID from the stop ID for the direction specified
- (uint) getStationIDForDirection:(uint)direction
{
    // Get the correct stop_id_eastbound or stop_id_westbound
    NSString *path = [[NSBundle mainBundle] pathForResource:@"stops" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *stopArray = [NSMutableArray arrayWithArray:[content componentsSeparatedByString:@"\n"]];
    //    if ([[stopArray[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
    //        isEqualToString:@"stop_id_west,stop_id_east,stop_code,stop_name,stop_desc,stop_lat,stop_lon,zone_id,wheelchair_boarding"])
    //    {
    //        [stopArray removeObject:0];
    //    }
    
    NSArray *temp = [stopArray[self.selectedStation.stopID.intValue - 10001] componentsSeparatedByString:@","];
    if (direction == EastboundDirectionID)
    {
        int value = [temp[0] intValue];
        return ([self checkDirection:value]) ? value : [temp[1] intValue];
    }
    else
    {
        int value = [temp[1] intValue];
        return ([self checkDirection:value]) ? value : [temp[0] intValue];
    }
}


// Check the direction value found earlier to verify that it is not equal to 0
- (Boolean) checkDirection:(uint)value
{
    if (value == 0)
    {
        // Show popup if not first load
        if (!self.firstLoad)
        {
            [[[UIAlertView alloc] initWithTitle:@"Unidirectional Light Rail Stop"
                                        message:[NSString
                                                 stringWithFormat:@"Sorry, this light rail stop only heads %@.",
                                                 ((self.eastbound) ? DirectionEastbound.lowercaseString : DirectionWestbound.lowercaseString)]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
            // Preselect the correct option in the chooser
            [self.directionSelector setSelectedSegmentIndex:((self.eastbound)? 0 : 1)];
            self.eastbound = !self.eastbound;
            [self logDirection];
        }
        else
        {
            self.firstLoad = false;
        }
        
        return false;
    }
    return true;
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

- (BOOL)isStationIDInFavorites:(NSString *)stop_id
{
    for (NSString *stopID in self.favoriteStations)
    {
        if ([stopID isEqualToString:stop_id])
        {
            return YES;
        }
    }
    return NO;
}

// Callback invoked when the user clicks "Add To Favorites" / "Remove From Favorites" button
- (IBAction)addToFavorites:(id)sender
{
    // Add/Remove the station to/from favorites
    [self addOrRemoveStationFromFavorites:self.selectedStation.stopID flipDirections:true];
}


// Add or remove a station with a known StopID from favorites
- (Boolean) addOrRemoveStationFromFavorites:(NSString *)stationStopID flipDirections:(Boolean) flip
{
    @try
    {
        // Case 1: Station ID is currently in favorites and needs to be removed
        Boolean inFavorites = [self isStationIDInFavorites:stationStopID];
        if (inFavorites)
        {
            if (flip)
            {
                // Remove the station from the list of favorites
                [self.favoriteStations removeObject:stationStopID];
                NSLog(@"%@\n", self.favoriteStations);
                
                // Show message that station was saved to favorites
                [self displayFavoritesPopup:@"Removed From Favorites"];
            }
        }
        // Case 2: Station ID is not currently in the favorites and needs to be added
        else
        {
            if (flip)
            {
                // Add the station to the list of favorites
                [self.favoriteStations addObject:stationStopID];
                NSLog(@"%@\n", self.favoriteStations);
                
                // Show message that station was saved to favorites
                [self displayFavoritesPopup:@"Added to Favorites"];
            }
        }
        
        // Change the button text and background color
        [self changeButtonView:!inFavorites];
    }
    @catch (NSException *exception)
    {
        return false;
    }
    @finally
    {
        return true;
    }
}

// Show "In Favorites" popup
- (void) displayFavoritesPopup:(NSString *)message
{
    // Show message that station was saved to favorites
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    // Remove the message after a 1 second delay
    [hud hide:YES afterDelay:1];
}

// Modify the text of the button to adjust "Add to Favorites" / "Remove From Favorites"
- (void) changeButtonView:(Boolean)inFavorites
{
    NSLog(@"ChangeButtonView inFavorites = %@", (inFavorites ? @"true" : @"false"));
    
    if (inFavorites)
    {
        [self.addToFavoritesButton setTitle:@"Remove From Favorites" forState:UIControlStateNormal];
        [self.addToFavoritesButton setBackgroundColor:[UIColor redColor]];
    }
    else
    {
        [self.addToFavoritesButton setTitle:@"Add To Favorites" forState:UIControlStateNormal];
        [self.addToFavoritesButton setBackgroundColor:[UIColor greenColor]];
    }
}

- (IBAction)boardNext:(id)sender {
    Stations *stations = [Stations sharedStations];
    
    uint direction = [self getStationIDForDirection:self.eastbound];
    
    stations.currentStation = [NSString stringWithFormat:@"%d",direction];
    stations.currentTime = self.nextTime;
    
    [self displayFavoritesPopup:@"Train set."];
}

#pragma mark - NSCoding

- (NSString *)documentsDirectory
{
    return [@"~/Documents" stringByExpandingTildeInPath];
}

- (NSString *)dataFilePath
{
    //NSLog(@"%@",[self documentsDirectory]);
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Favorites.plist"];
}

- (void)saveChecklistItems
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.favoriteStations forKey:@"favorites"];
    [archiver finishEncoding];
    
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadChecklistItems
{
    NSString *path = [self dataFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        self.favoriteStations = [unarchiver decodeObjectForKey:@"favorites"];
        
        [unarchiver finishDecoding];
    }
}

@end
