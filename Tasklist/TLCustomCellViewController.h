//
//  TLCustomCellViewController.h
//  Tasklist
//
//  Created by jiang on 12/11/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLCustomCellViewController : UIViewController

@property (retain, nonatomic) NSString *strTitle;
@property (retain, nonatomic) NSString *strDescription;
@property (retain, nonatomic) UIImage *iconImage;

@property (retain, nonatomic) IBOutlet UILabel *titleText;
@property (retain, nonatomic) IBOutlet UILabel *descriptionText;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;

@end
