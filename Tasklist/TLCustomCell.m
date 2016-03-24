//
//  TLCustomCell.m
//  Tasklist
//
//  Created by jiang on 12/11/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import "TLCustomCell.h"

@implementation TLCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [super dealloc];
}
@end
