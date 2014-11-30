//
//  StationTimeTableViewController.m
//  LightRail
//
//  Created by Amy Baldwin on 11/30/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "StationTimeTableViewController.h"

@implementation StationTimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.times = [[NSMutableArray alloc] init];
}

#pragma mark - TableViewDelegation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.times.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *time = self.times[indexPath.row];
    cell.textLabel.text = time;
    
    return cell;
}

@end
