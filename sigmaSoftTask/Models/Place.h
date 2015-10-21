//
//  Place.h
//  sigmaSoftTask
//
//  Created by Michael Bielodied on 10/20/15.
//  Copyright © 2015 Michael Bielodied. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Details.h"

@interface Place : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) Details  *details;

@end
