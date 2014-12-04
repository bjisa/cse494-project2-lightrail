//
//  FavoriteStationTableCell.h
//  LightRail
//
//  Created by Amy Baldwin on 12/3/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteStationTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *stationName;
@property (nonatomic, weak) IBOutlet UILabel *timeRemaining;
@property (nonatomic, weak) IBOutlet UISegmentedControl *directionSelector;
- (IBAction)changeDirection:(id)sender;

@end
