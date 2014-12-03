//
//  TripAnalyzer.m
//  LightRail
//
//  Created by Joshua Baldwin on 11/30/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "TripAnalyzer.h"

@interface TripAnalyzer()

@property NSMutableArray *fileDetails;

@end

@implementation TripAnalyzer


- (id) init
{
    self = [super init];
    if (self)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"trips" ofType:@"txt"];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        self.fileDetails = [NSMutableArray arrayWithArray:[content componentsSeparatedByString:@"\n"]];
        
        // Remove the first entry since it will be invalid
        if (self.fileDetails.count > 0)
        {
            [self.fileDetails removeObjectAtIndex:0];
        }
        
        // DEBUG STATEMENTS
        //NSLog(@"Inside TripAnalyzer init");
        //NSLog(@"Path: %@", path);
        //NSLog(@"Content:\n%@", content);
        //NSLog(@"self.fileDetails.count = %lu", (unsigned long)self.fileDetails.count);
    }
    return self;
}

- (uint) getTripDirection:(long) tripID
{
    if (self)
    {
        // DEBUG STATEMENTS
        //NSLog(@"Inside TripAnalyzer.getTripDirection(tripID)");
        
        // Binary Search
        return [self performBinarySearch:tripID];
    }
    
    // Direction was not found
    //NSLog(@"Direction  NOT found, assuming direction = %i", UnknownDirectionID);
    return UnknownDirectionID;
}


- (uint) performBinarySearch:(long) tripID
{
    //NSLog(@"Performing Binary Search, tripID = %li", tripID);
    
    // Set the initial minValue and maxValue to search entire array
    long minValue = 0;
    long maxValue = self.fileDetails.count - 1;
    
    // Search while [minValue, maxValue] is not empty
    while (minValue < maxValue)
    {
        // Calculate the midpoint for roughly equal partitions
        long midpoint = minValue +((maxValue - minValue)/2);
        
        // Instantiate a new TripModel
        TripModel *tripModel = [[TripModel alloc] initWithString:self.fileDetails[midpoint]];
        
        // Perform 3-way comparison
        if (tripModel.trip_id == tripID)        // midpoint points to the location of the tripId we wanted
        {
            // Key was found at the array index midpoint, return direction_id
            //NSLog(@"Direction found, returning = %i", tripModel.direction_id);
            return tripModel.direction_id;
        }
        else if (tripModel.trip_id < tripID)    // midpoint is too low
        {
            // Search the upper subarray
            minValue = midpoint + 1;
        }
        else                                    // midpoint is too high
        {
            // Search the lower subarray
            maxValue = midpoint - 1;
        }
    }
    
    // Direction was not found
    //NSLog(@"Direction NOT found, returning direction = %i", UnknownDirectionID);
    return UnknownDirectionID;
}


- (int) performLinearSearch:(long) tripID
{
    //NSLog(@"Performing Linear Search, tripID = %li", tripID);
    
    // Initialize searching parameters
    Boolean found = false;
    long i = 1;
    TripModel *tripModel;
    
    // Loop through the array
    while (!found && i < self.trips.count)
    {
        tripModel = [[TripModel alloc] initWithString:self.fileDetails[i]];
        (tripModel.trip_id == tripID) ? found = true : i++;
    }
    
    if (found)
    {
        //NSLog(@"Direction found, returning = %i", tripModel.direction_id);
        return tripModel.direction_id;
    }
    
    // Direction was not found
    //NSLog(@"Direction NOT found, returning direction = %i", UnknownDirectionID);
    return UnknownDirectionID;
}


@end
