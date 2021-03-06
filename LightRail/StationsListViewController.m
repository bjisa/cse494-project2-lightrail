//
//  StationsListViewController.m
//  LightRail
//
//  Created by Ben Jisa on 11/19/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "StationsListViewController.h"
#import "Stations.h"
#import "StationModel.h"
#import "StationDetailsViewController.h"
#import "StationModel.h"

@interface StationsListViewController ()

@property NSInteger selectedIndexPathRow;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selectedIndexPathRow = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewStationDetails"]) {
        Stations *stations = [Stations sharedStations];
        StationDetailsViewController *destination = segue.destinationViewController;
        destination.selectedStation = stations.stationlist[self.selectedIndexPathRow];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Stations *stations = [Stations sharedStations];
    return stations.stationlist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Stations *stations = [Stations sharedStations];
    StationModel *station = stations.stationlist[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = station.name;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPathRow = indexPath.row;
    [self performSegueWithIdentifier:@"viewStationDetails" sender:self];
}

@end
