//
//  DetailViewCell.m
//  sigmaSoftTask
//
//  Created by Michael Bielodied on 10/21/15.
//  Copyright © 2015 Michael Bielodied. All rights reserved.
//

#import "DetailViewCell.h"

@implementation DetailViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
