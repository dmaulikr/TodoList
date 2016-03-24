//
//  TLAddTaskViewController.h
//  Tasklist
//
//  Created by jiang on 12/10/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLTask.h"

@protocol LLAddTaskViewControllerDelegate
-(void)didCancel;
-(void)didAddTask:(LLTask *)task;
@end

@interface TLAddTaskViewController : UIViewController

@property (retain, nonatomic) id <LLAddTaskViewControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UITextField *taskNameText;
@property (retain, nonatomic) IBOutlet UITextView *taskDetailText;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)onSave:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onButton1:(id)sender;
- (IBAction)onButton2:(id)sender;
- (IBAction)onButton3:(id)sender;
- (IBAction)onButton4:(id)sender;
- (IBAction)onButton5:(id)sender;
- (IBAction)onButton6:(id)sender;
- (IBAction)onButton7:(id)sender;
- (IBAction)onButton8:(id)sender;

@end
