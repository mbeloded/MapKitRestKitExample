//
//  PinView.m
//  sigmaSoftTask
//
//  Created by Michael Bielodied on 10/21/15.
//  Copyright © 2015 Michael Bielodied. All rights reserved.
//

#import "PinView.h"
#import "MapVC.h"

@interface PinView ()
@property (strong, nonatomic) UITapGestureRecognizer *singleTap;
@end

@implementation PinView

@synthesize owner, singleTap, placeObject;

-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
        
    }
    return self;
}

-(void) setOwner:(id) ownerObj {
    owner = ownerObj;
    [self.goBtn addTarget:self action:@selector(pinClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) setPlaceObject:(Place *)place {
    
    placeObject = place;
    
    self.pinNameLabel.text = placeObject.name;
    
    NSMutableString * locationValue = [[NSMutableString alloc] init];
    if (placeObject.location.address != nil && placeObject.location.address.length != 0) {
        [locationValue appendString:placeObject.location.address];
    }
    
    if (placeObject.location.city != nil && placeObject.location.city.length != 0) {
        if (locationValue.length > 0) {
            [locationValue appendString:@", "];
        }
        [locationValue appendString:placeObject.location.city];
    }
    
    self.pinLocationLabel.text = locationValue;

}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if (owner!=nil && [owner isKindOfClass:[MapVC class]]) {
        if ([owner respondsToSelector:@selector(pinClickAction:)]) {
            [owner pinClickAction:self];
        }
    }
}

- (void) pinClickAction:(id) sender {
    if (owner!=nil && [owner isKindOfClass:[MapVC class]]) {
        if ([owner respondsToSelector:@selector(pinClickAction:)]) {
            [owner pinClickAction:self];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
