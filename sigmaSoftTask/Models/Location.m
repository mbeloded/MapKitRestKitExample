//
//  Location.m
//  sigmaSoftTask
//
//  Created by Michael Bielodied on 10/20/15.
//  Copyright © 2015 Michael Bielodied. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize address;
@synthesize city;
@synthesize crossStreet;

-(NSArray*) convertToArray {
    NSMutableArray * locationArray = [[NSMutableArray alloc] init];
    
    if (address != nil && address.length > 0) {
        [locationArray addObject: [NSString stringWithFormat:@"Address : %@", address]];
    }
    
    if (city != nil && city.length > 0) {
        [locationArray addObject: [NSString stringWithFormat:@"City : %@", city]];
    }
    
    if (crossStreet != nil && crossStreet.length > 0) {
        [locationArray addObject: [NSString stringWithFormat:@"Cross street : %@", crossStreet]];
    }
    
    return [locationArray copy];
}

@end
