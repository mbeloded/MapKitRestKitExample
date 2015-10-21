//
//  Details.m
//  sigmaSoftTask
//
//  Created by Michael Bielodied on 10/20/15.
//  Copyright © 2015 Michael Bielodied. All rights reserved.
//

#import "Details.h"

@implementation Details

@synthesize checkins;
@synthesize tips;
@synthesize users;

-(NSArray*) convertToArray {
    NSMutableArray * detailsArray = [[NSMutableArray alloc] init];
    
    if (checkins != nil && [checkins isKindOfClass:[NSNull class]]) {
        [detailsArray addObject: [NSString stringWithFormat:@"Checkins : %@", checkins]];
    }
    
    if (tips != nil && [tips isKindOfClass:[NSNull class]]) {
        [detailsArray addObject: [NSString stringWithFormat:@"Tips : %@", tips]];
    }
    
    if (users != nil && [users isKindOfClass:[NSNull class]]) {
        [detailsArray addObject: [NSString stringWithFormat:@"Users : %@", users]];
    }
    
    return [detailsArray copy];
}

@end
