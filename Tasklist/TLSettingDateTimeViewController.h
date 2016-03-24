//
//  TLSettingDateTimeViewController.h
//  Tasklist
//
//  Created by jiang on 12/10/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLSettingDateTimeViewController : UIViewController
{
    NSArray *dateFormatArray;
    NSArray *timeFormatArray;
}

@property (retain, nonatomic) IBOutlet UIPickerView *dateFormater;
@property (retain, nonatomic) IBOutlet UIPickerView *timeFormater;

@end
