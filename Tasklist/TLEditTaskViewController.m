//
//  TLEditTaskViewController.m
//  Tasklist
//
//  Created by jiang on 12/12/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import "TLEditTaskViewController.h"

@interface TLEditTaskViewController ()

@end

@implementation TLEditTaskViewController

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
    [_taskNameText setText:_taskObject.title];
    [_taskDescriptionText setText:_taskObject.description];
    [_dateTimePicker setDate:_taskObject.date];
    [_completeSwitch setOn:_taskObject.isCompleted];
    
    if (_taskObject.isCompleted)
        _statusLabel.text = @"Completed";
    else
        _statusLabel.text = @"Due";
    
    UIButton * btnSave = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnSave setFrame:CGRectMake(0, 0, 40, 40)];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont fontWithName:@"Avenir Heavy" size:16.0];
    [btnSave addTarget:self action:@selector(onSave:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = rightItem;
    
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
    self.navigationItem.title = @"Edit Task";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (IBAction)onBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissKeyboard {
    [_taskNameText resignFirstResponder];
    [_taskDescriptionText resignFirstResponder];
}

- (IBAction)onSave:(id)sender {
    if ([_taskNameText.text length]==0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Info"
                                                          message:@"Please input task name."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        [message release];
        return;
    }
    
    [self updateTask];
    [self.delegate didUpdateTask];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateTask
{
    self.taskObject.title = self.taskNameText.text;
    self.taskObject.description = self.taskDescriptionText.text;
    self.taskObject.date = self.dateTimePicker.date;
    self.taskObject.isCompleted = self.completeSwitch.isOn;
}

#pragma mark - UITextFieldDelegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.taskNameText resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.taskDescriptionText resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_taskNameText release];
    [_taskDescriptionText release];
    [_completeSwitch release];
    [_dateTimePicker release];
    [_statusLabel release];
    [super dealloc];
}

- (IBAction)onSwitchChange:(id)sender {
    if (_completeSwitch.isOn)
        _statusLabel.text = @"Completed";
    else
        _statusLabel.text = @"Due";
}
- (IBAction)onButton1:(id)sender {
    [_dateTimePicker setDate:[self getNextDateTime:@"0700"]];
}

- (IBAction)onButton2:(id)sender {
    [_dateTimePicker setDate:[self getNextDateTime:@"0000"]];
}

- (IBAction)onButton3:(id)sender {
    [_dateTimePicker setDate:[self getNextDateTime:@"1700"]];
}

- (IBAction)onButton4:(id)sender {
    [_dateTimePicker setDate:[self getNextDateTime:@"2100"]];
}

- (IBAction)onButton5:(id)sender {
    [_dateTimePicker setDate:[self getNextDateTime:@"now"]];
}

- (IBAction)onButton6:(id)sender {
    [_dateTimePicker setDate:[self getNextDateTime:@"+0020"]];
}

- (IBAction)onButton7:(id)sender {
    [_dateTimePicker setDate:[self getNextDateTime:@"+0100"]];
}

- (IBAction)onButton8:(id)sender {
    [_dateTimePicker setDate:[self getNextDateTime:@"+0300"]];
}

- (NSDate*) getNextDateTime:(NSString *)forTime
{
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:today];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    
    NSDate *today0 = [cal dateByAddingComponents:components toDate:today options:0];
    NSDateComponents *components0 = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:today0];
    
    NSDate *newday = today;
    
    if ([forTime isEqualToString:@"0700"]) {
        [components0 setHour:7];
        newday= [cal dateByAddingComponents:components0 toDate:today0 options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
        
        if ([self isDateGreaterThanDate:today and:newday]) {
            [components0 setHour:24+7];
            newday= [cal dateByAddingComponents:components0 toDate:today0 options:0];
        }
    }
    else if ([forTime isEqualToString:@"0000"]) {
        [components0 setHour:0];
        newday= [cal dateByAddingComponents:components0 toDate:today0 options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
        
        if ([self isDateGreaterThanDate:today and:newday]) {
            [components0 setHour:24+0];
            newday= [cal dateByAddingComponents:components0 toDate:today0 options:0];
        }
    }
    else if ([forTime isEqualToString:@"1700"]) {
        [components0 setHour:17];
        newday= [cal dateByAddingComponents:components0 toDate:today0 options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
        
        if ([self isDateGreaterThanDate:today and:newday]) {
            [components0 setHour:24+17];
            newday= [cal dateByAddingComponents:components0 toDate:today0 options:0];
        }
    }
    else if ([forTime isEqualToString:@"2100"]) {
        [components0 setHour:21];
        newday= [cal dateByAddingComponents:components0 toDate:today0 options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
        
        if ([self isDateGreaterThanDate:today and:newday]) {
            [components0 setHour:24+21];
            newday= [cal dateByAddingComponents:components0 toDate:today0 options:0];
        }
    }
    else if ([forTime isEqualToString:@"+0020"]) {
        newday = [NSDate dateWithTimeIntervalSinceNow:60*20];
    }
    else if ([forTime isEqualToString:@"+0100"]) {
        newday = [NSDate dateWithTimeIntervalSinceNow:60*60*1];
    }
    else if ([forTime isEqualToString:@"+0300"]) {
        newday = [NSDate dateWithTimeIntervalSinceNow:60*60*3];
    }
    
    return newday;
}

-(BOOL)isDateGreaterThanDate:(NSDate *)isDate and:(NSDate *)greaterThanDate
{
    NSTimeInterval firstDate = [isDate timeIntervalSince1970];
    NSTimeInterval secondDate = [greaterThanDate timeIntervalSince1970];
    
    if (firstDate > secondDate) return YES;
    else return NO;
    
}
@end
