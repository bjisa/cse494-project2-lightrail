//
//  FavoritesViewController.m
//  LightRail
//
//  Created by Ben Jisa on 11/19/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavoriteStationTableCell.h"
#import "Stations.h"
#import "StationDetailsViewController.h"
#import "Trip.h"

@interface FavoritesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *favoriteStations;
@property NSMutableArray *favoriteStationIDs;
@property NSInteger selectedIndexPathRow;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.favoriteStations = [[NSMutableArray alloc] init];
    self.favoriteStationIDs = [[NSMutableArray alloc] init];
    [self loadChecklistItems];
    
    self.selectedIndexPathRow = 0;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadTableViewData];
    [self.tableView reloadData];
    [self addMessageForEmptyTable];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self saveChecklistItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTableViewData {
    [self.favoriteStations removeAllObjects];
    [self.favoriteStationIDs removeAllObjects];
    [self loadChecklistItems];
    
    // Fill list with station models
    for (NSString *stopID in self.favoriteStationIDs) {
        StationModel *model = [Stations getStation:stopID];
        [self.favoriteStations addObject:model];
    }
    for (StationModel *station in self.favoriteStations) {
        NSLog(@"Favorite Stations in LoadTableViewData: %@, id: %@\n", station.name, station.stopID);
    }
}

- (void)deleteSavedStation:(NSInteger)index {
    [self.favoriteStationIDs removeObjectAtIndex:index];
    [self saveChecklistItems];
    [self loadTableViewData];
    [self.tableView reloadData];
    [self addMessageForEmptyTable];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    StationDetailsViewController *destination = segue.destinationViewController;
    destination.selectedStation = self.favoriteStations[self.selectedIndexPathRow];
}

#pragma mark - TableViewDelegation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.favoriteStations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *favoritesTableIdentifier = @"FavoriteStationTableCell";
    
    FavoriteStationTableCell *cell = (FavoriteStationTableCell *)[tableView dequeueReusableCellWithIdentifier:favoritesTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FavoriteStationTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    StationModel *station = self.favoriteStations[indexPath.row];
    cell.stationNameLabel.text = station.name;
    
    // Calculate time remaining until next train arrives.
    //cell.timeRemaining.text = @"15 minutes";
    
    Trip *nextEastTrip = [self getNextTrip:[station.stopIDEastbound doubleValue]];
    Trip *nextWestTrip = [self getNextTrip:[station.stopIDWestbound doubleValue]];
    
    NSString *eastTime = [self formatTimeString:nextEastTrip.departureTime];
    cell.nextEastTime = eastTime;
    NSString *westTime = [self formatTimeString:nextWestTrip.departureTime];
    cell.nextWestTime = westTime;
    
    cell.nextTimeLabel.text = eastTime;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (void)addMessageForEmptyTable
{
    // http://www.appcoda.com/pull-to-refresh-uitableview-empty/
    if (self.favoriteStations.count == 0)
    {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
 
        messageLabel.text = @"You have no favorite stations.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
 
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        self.tableView.backgroundView.hidden = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPathRow = indexPath.row;
    [self performSegueWithIdentifier:@"viewDetails" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support swipe to delete.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteSavedStation:indexPath.row];
    }
}

#pragma mark - NSCoding

- (NSString *)documentsDirectory
{
    return [@"~/Documents" stringByExpandingTildeInPath];
}

- (NSString *)dataFilePath
{
    NSLog(@"%@",[self documentsDirectory]);
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Favorites.plist"];
    
}

- (void)saveChecklistItems
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.favoriteStationIDs forKey:@"favorites"];
    
    [archiver finishEncoding];
    
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadChecklistItems
{
    NSString *path = [self dataFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        self.favoriteStationIDs = [unarchiver decodeObjectForKey:@"favorites"];
        
        [unarchiver finishDecoding];
    }
}






- (Trip *) getNextTrip:(double)stopID {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"stop_times" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *items = [content componentsSeparatedByString:@"\n"];
    
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
            
            if (tripID == [station[0] doubleValue] && [self compareToCurrentTime:station[2]] == 1 && stopID == [station[3] doubleValue]) {
                [stationdict setObject:station[0] forKey:@"trip_id"];
                [stationdict setObject:station[2] forKey:@"departure_time"];
                [stationdict setObject:station[3] forKey:@"stop_id"];
                [stationdict setObject:station[6] forKey:@"stop_sequence"];
                
                Trip * newTrip = [[Trip alloc] initWithCSVDictionary:stationdict];
                return newTrip;
            }
            
        }
    }
    
    return nil;
    
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










@end
