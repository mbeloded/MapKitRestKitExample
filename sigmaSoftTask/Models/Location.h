//
//  Location.h
//  sigmaSoftTask
//
//  Created by Michael Bielodied on 10/20/15.
//  Copyright © 2015 Michael Bielodied. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *crossStreet;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;

-(NSArray*) convertToArray;

@end
