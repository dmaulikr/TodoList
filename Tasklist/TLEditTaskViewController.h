//
//  TLEditTaskViewController.h
//  Tasklist
//
//  Created by jiang on 12/12/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLTask.h"

@protocol LLEditTaskViewControllerDelegate <NSObject>
-(void)didUpdateTask;
@end

@interface TLEditTaskViewController : UIViewController

@property (strong, nonatomic) LLTask *taskObject;
@property (retain, nonatomic) id <LLEditTaskViewControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UITextField *taskNameText;
@property (retain, nonatomic) IBOutlet UITextView *taskDescriptionText;
@property (retain, nonatomic) IBOutlet UISwitch *completeSwitch;
@property (retain, nonatomic) IBOutlet UIDatePicker *dateTimePicker;
- (IBAction)onSwitchChange:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)onButton1:(id)sender;
- (IBAction)onButton2:(id)sender;
- (IBAction)onButton3:(id)sender;
- (IBAction)onButton4:(id)sender;
- (IBAction)onButton5:(id)sender;
- (IBAction)onButton6:(id)sender;
- (IBAction)onButton7:(id)sender;
- (IBAction)onButton8:(id)sender;

@end
