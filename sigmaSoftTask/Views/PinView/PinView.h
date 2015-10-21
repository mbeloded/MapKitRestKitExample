//
//  PinView.h
//  sigmaSoftTask
//
//  Created by Michael Bielodied on 10/21/15.
//  Copyright © 2015 Michael Bielodied. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface PinView : UIView

@property (nonatomic, weak) id owner;
@property (nonatomic, weak) Place * placeObject;
@property (weak, nonatomic) IBOutlet UIImageView *placeIcon;
@property (weak, nonatomic) IBOutlet UILabel *pinNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *goBtn;

@end
