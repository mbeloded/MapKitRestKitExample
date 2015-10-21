//
//  Place.m
//  sigmaSoftTask
//
//  Created by Michael Bielodied on 10/20/15.
//  Copyright © 2015 Michael Bielodied. All rights reserved.
//

#import "Place.h"

@implementation Place

@synthesize name, location, details;

-(NSArray *) convertToArray {
    NSMutableArray * placeInfoArray = [[NSMutableArray alloc] init];
    
    [placeInfoArray addObject:[NSString stringWithFormat:@"Venue name: %@", name]];
    
    if (location != nil) {
        [placeInfoArray addObjectsFromArray:[location convertToArray]];
    }
    
    if (details != nil) {
        [placeInfoArray addObjectsFromArray:[details convertToArray]];
    }
    
    return [placeInfoArray copy];
}

@end
