//
//  FavoritesViewController.m
//  LightRail
//
//  Created by Ben Jisa on 11/19/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Stations.h"
#import "StationDetailsViewController.h"

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    StationModel *station = self.favoriteStations[indexPath.row];
    //NSString *stopID = self.favoriteStationIDs[indexPath.row];
    cell.textLabel.text = station.name;

    return cell;
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

@end
