//
//  StationTimeTableViewController.h
//  LightRail
//
//  Created by Amy Baldwin on 11/30/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationTimeTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *directionSelector;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *times;

@end
