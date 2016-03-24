//
//  TLViewController.h
//  Tasklist
//
//  Created by Jiangz on 12/10/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAddTaskViewController.h"
#import "TLMenuViewController.h"
#import "TLEditTaskViewController.h"
#import "TLDetailTaskViewController.h"

@interface TLViewController : UIViewController<LLAddTaskViewControllerDelegate, LLEditTaskViewControllerDelegate,LLDetailTaskViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    int         selectedIndex;
    NSArray     *dateFormatArray;
    NSArray     *timeFormatArray;
}

@property (nonatomic) int                   displayOption;
@property (strong, nonatomic) NSString    *strDateFormat;
@property (strong, nonatomic) NSString    *strTimeFormat;
@property (strong, nonatomic) UIColor       *bgColor;
@property (strong, nonatomic) UIColor       *textColor;

@property (strong, nonatomic) NSMutableArray *taskObjects;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
