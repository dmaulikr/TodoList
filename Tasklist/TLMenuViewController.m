//
//  TLMenuViewController.m
//  Tasklist
//
//  Created by jiang on 12/10/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import "TLMenuViewController.h"
#import "TLSettingDateTimeViewController.h"
#import "TLSettingListViewController.h"
#import "TLViewController.h"

@interface TLMenuViewController ()

@end

@implementation TLMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    UIButton * btnBackImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBackImage setFrame:CGRectMake(0, 12, 10, 20)];
    [btnBackImage setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    
    UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(5, 7, 50, 30)];
    [btnBack setTitle:@"Back" forState:UIControlStateNormal];
    [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnBack.titleLabel.font = [UIFont fontWithName:@"Avenir Heavy" size:16.0];
    [btnBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [subview addSubview:btnBackImage];
    [subview addSubview:btnBack];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:subview];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],UITextAttributeTextColor,
      [UIFont fontWithName:@"Avenir Heavy" size:18.0],
      UITextAttributeFont,
      nil]];
    self.navigationItem.title = @"Menu";
    
}

- (IBAction)onBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onListAppearance:(id)sender {
    TLSettingListViewController *subview = [[[TLSettingListViewController alloc] init] autorelease];
    [self.navigationController pushViewController:subview animated:YES];
}

- (IBAction)onDateTimeFormat:(id)sender {
    TLSettingDateTimeViewController *subview = [[[TLSettingDateTimeViewController alloc] init] autorelease];
    [self.navigationController pushViewController:subview animated:YES];
}

- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}

- (IBAction)onUpgrade:(id)sender {
    NSLog(@"upgrade button taped");
}

- (IBAction)onTodayTask:(id)sender {
    TLViewController *backvc = (TLViewController*)[self backViewController];
    backvc.displayOption = TLTodayTasks;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTomorrowTask:(id)sender {
    TLViewController *backvc = (TLViewController*)[self backViewController];
    backvc.displayOption = TLTomorrowTasks;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAllTask:(id)sender {
    TLViewController *backvc = (TLViewController*)[self backViewController];
    backvc.displayOption = TLAllTasks;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
