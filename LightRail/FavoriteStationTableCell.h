//
//  FavoriteStationTableCell.h
//  LightRail
//
//  Created by Amy Baldwin on 12/3/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteStationTableCell : UITableViewCell

@property NSString *nextEastTime;
@property NSString *nextWestTime;
@property (nonatomic, weak) IBOutlet UILabel *stationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *nextTimeLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *directionSelector;

- (IBAction)changeDirection:(id)sender;

@end
