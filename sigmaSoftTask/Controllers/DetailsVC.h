//
//  DetailsVC.h
//  sigmaSoftTask
//
//  Created by Michael Bielodied on 10/20/15.
//  Copyright © 2015 Michael Bielodied. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface DetailsVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) Place * placeObject;

@end
