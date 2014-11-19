//
//  StationModel.h
//  LightRail
//
//  Created by Amy Baldwin on 11/19/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationModel : NSObject

@property NSString *stopID;
@property NSString *name;
@property NSString *latitude;
@property NSString *longitude;

-(id) initWithCSVDictionary:(NSDictionary *)dict;

@end
