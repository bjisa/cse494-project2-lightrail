//
//  FavoriteStationTableCell.m
//  LightRail
//
//  Created by Amy Baldwin on 12/3/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "FavoriteStationTableCell.h"

@implementation FavoriteStationTableCell

@synthesize stationNameLabel = _stationNameLabel;
@synthesize nextTimeLabel = _nextTimeLabel;
@synthesize directionSelector = _directionSelector;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changeDirection:(id)sender 
{
    if (self.directionSelector.selectedSegmentIndex == 0)
    {
        self.nextTimeLabel.text = [[self.nextEastTime substringToIndex:[self.nextEastTime rangeOfString:@":" options:NSBackwardsSearch].location] stringByAppendingString:[self.nextEastTime substringFromIndex:[self.nextEastTime rangeOfString:@" "].location]];
        //NSLog(@"Next East time = %@", self.nextEastTime);
    }
    else
    {
        self.nextTimeLabel.text = [[self.nextWestTime substringToIndex:[self.nextWestTime rangeOfString:@":" options:NSBackwardsSearch].location] stringByAppendingString:[self.nextEastTime substringFromIndex:[self.nextWestTime rangeOfString:@" "].location]];
        //NSLog(@"Next West time = %@", self.nextWestTime);
    }
}

@end
