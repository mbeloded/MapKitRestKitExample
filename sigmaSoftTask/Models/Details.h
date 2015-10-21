//
//  Details.h
//  sigmaSoftTask
//
//  Created by Michael Bielodied on 10/20/15.
//  Copyright © 2015 Michael Bielodied. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Details : NSObject

@property (nonatomic, strong) NSNumber *checkins;
@property (nonatomic, strong) NSNumber *tips;
@property (nonatomic, strong) NSNumber *users;

-(NSArray*) convertToArray;

@end
