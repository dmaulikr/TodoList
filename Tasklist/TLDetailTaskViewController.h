//
//  TLDetailTaskViewController.h
//  Tasklist
//
//  Created by jiang on 12/12/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLTask.h"

@protocol LLDetailTaskViewControllerDelegate <NSObject>
-(void)updateCompletedSwitch:(LLTask*) taskObj;
@end

@interface TLDetailTaskViewController : UIViewController

@property (retain, nonatomic) LLTask *taskObject;
@property (retain, nonatomic) id <LLDetailTaskViewControllerDelegate> delegate;

@property (retain, nonatomic) NSString    *strDateFormat;
@property (retain, nonatomic) NSString    *strTimeFormat;

@property (retain, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (retain, nonatomic) IBOutlet UITextView *taskDescriptionText;
@property (retain, nonatomic) IBOutlet UILabel *taskDateLabel;
@property (retain, nonatomic) IBOutlet UISwitch *completionSwitch;
@property (retain, nonatomic) IBOutlet UILabel *completionLabel;

- (IBAction)onCompletionSwitch:(id)sender;

@end
