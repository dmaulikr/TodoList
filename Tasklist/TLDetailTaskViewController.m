//
//  TLDetailTaskViewController.m
//  Tasklist
//
//  Created by jiang on 12/12/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import "TLDetailTaskViewController.h"

@interface TLDetailTaskViewController ()

@end

@implementation TLDetailTaskViewController

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
    [_taskNameLabel setText:_taskObject.title];
    [_taskDescriptionText setText:_taskObject.description];
    [_completionSwitch setOn:_taskObject.isCompleted];
    
    if (_taskObject.isCompleted)
        _completionLabel.text = @"Completed";
    else
        _completionLabel.text = @"Due";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateTimeFormat = [NSString stringWithFormat:@"'start at' %@ 'on' %@", self.strTimeFormat, self.strDateFormat];
    [formatter setDateFormat:dateTimeFormat];
    NSString *stringFromDate = [formatter stringFromDate:self.taskObject.date];
    [_taskDateLabel setText:stringFromDate];
    
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
    self.navigationItem.title = @"Detail Task";
}

- (IBAction)onBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_taskDescriptionText release];
    [_completionSwitch release];
    [_completionLabel release];
    [_taskNameLabel release];
    [_taskDateLabel release];
    [super dealloc];
}

- (IBAction)onCompletionSwitch:(id)sender {
    if (_completionSwitch.isOn) {
        _completionLabel.text = @"Completed";
    }
    else
        _completionLabel.text = @"Due";
    
    self.taskObject.isCompleted = _completionSwitch.isOn;
    [self.delegate updateCompletedSwitch:self.taskObject];
}
@end
