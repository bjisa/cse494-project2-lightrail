//
//  StationsListViewController.h
//  LightRail
//
//  Created by Ben Jisa on 11/19/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationModel.h"

@interface StationsListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property(strong,nonatomic) StationModel *stationModel;
@end
