//
//  StationDetailsViewController.h
//  LightRail
//
//  Created by Joshua Baldwin on 11/23/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "StationModel.h"

@interface StationDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *time1Label;
@property (strong, nonatomic) IBOutlet UILabel *time2Label;
@property (strong, nonatomic) IBOutlet UILabel *time3Label;
@property (strong, nonatomic) IBOutlet UILabel *time4Label;
@property (strong, nonatomic) IBOutlet UILabel *time5Label;
@property (strong, nonatomic) IBOutlet UILabel *time6Label;

@property (strong, nonatomic) IBOutlet UISegmentedControl *directionSelector;

- (IBAction)directionChanged:(id)sender;

@property StationModel *selectedStation;

@end
