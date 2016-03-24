//
//  TLSettingListViewController.h
//  Tasklist
//
//  Created by jiang on 12/10/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLSettingListViewController : UIViewController
{
    double text_color_r;
    double text_color_g;
    double text_color_b;
    
    double bg_color_r;
    double bg_color_g;
    double bg_color_b;
}
@property (retain, nonatomic) IBOutlet UISlider *redSlider;
@property (retain, nonatomic) IBOutlet UISlider *greenSlider;
@property (retain, nonatomic) IBOutlet UISlider *blueSlider;
@property (retain, nonatomic) IBOutlet UILabel *sampleLabel;
@property (retain, nonatomic) IBOutlet UISegmentedControl *typeSegment;

- (IBAction)onSlideValueChanged:(id)sender;
- (IBAction)onSegmentChanged:(id)sender;

@end
