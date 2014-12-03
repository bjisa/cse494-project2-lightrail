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

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Stations *stations = [Stations sharedStations];
    
    long tripID = [stations.currentStation doubleValue];
    
    Trip *trip = [[Trip alloc] initWithTripID:16927];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", tripID];
    cell.detailTextLabel.text = stations.currentTime;
    
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
