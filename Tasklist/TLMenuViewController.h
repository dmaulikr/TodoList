//
//  TLMenuViewController.h
//  Tasklist
//
//  Created by jiang on 12/10/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLMenuViewController : UIViewController

- (IBAction)onListAppearance:(id)sender;
- (IBAction)onDateTimeFormat:(id)sender;
- (IBAction)onUpgrade:(id)sender;

- (IBAction)onTodayTask:(id)sender;
- (IBAction)onTomorrowTask:(id)sender;
- (IBAction)onAllTask:(id)sender;

@end
