//
//  FavoriteStationTableCell.m
//  LightRail
//
//  Created by Amy Baldwin on 12/3/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "FavoriteStationTableCell.h"

@implementation FavoriteStationTableCell

@synthesize stationName = _stationName;
@synthesize timeRemaining = _timeRemaining;
@synthesize directionSelector = _directionSelector;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
