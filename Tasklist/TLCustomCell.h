//
//  TLCustomCell.h
//  Tasklist
//
//  Created by jiang on 12/11/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLCustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cellItemImageView;
@property (strong, nonatomic) IBOutlet UILabel *cellItemTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *cellItemDescLabel;
@end
