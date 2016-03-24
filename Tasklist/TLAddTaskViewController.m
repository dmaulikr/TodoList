//
//  TLAddTaskViewController.m
//  Tasklist
//
//  Created by jiang on 12/10/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import "TLAddTaskViewController.h"

@interface TLAddTaskViewController ()

@end

@implementation TLAddTaskViewController

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceNow:60*20];
    [_datePicker setDate:newDate];
}

-(void)dismissKeyboard {
    [_taskNameText resignFirstResponder];
    [_taskDetailText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_taskNameText release];
    [_taskDetailText release];
    [_datePicker release];
    [super dealloc];
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
    
    LLTask *newTask = [self getTaskObject];
    [self.delegate didAddTask:newTask];
}

- (IBAction)onCancel:(id)sender {
    [self.delegate didCancel];
}

- (IBAction)onButton1:(id)sender {
    [_datePicker setDate:[self getNextDateTime:@"0700"]];
}

- (IBAction)onButton2:(id)sender {
    [_datePicker setDate:[self getNextDateTime:@"0000"]];
}

- (IBAction)onButton3:(id)sender {
    [_datePicker setDate:[self getNextDateTime:@"1700"]];
}

- (IBAction)onButton4:(id)sender {
    [_datePicker setDate:[self getNextDateTime:@"2100"]];
}

- (IBAction)onButton5:(id)sender {
    [_datePicker setDate:[self getNextDateTime:@"now"]];
}

- (IBAction)onButton6:(id)sender {
    [_datePicker setDate:[self getNextDateTime:@"+0020"]];
}

- (IBAction)onButton7:(id)sender {
    [_datePicker setDate:[self getNextDateTime:@"+0100"]];
}

- (IBAction)onButton8:(id)sender {
    [_datePicker setDate:[self getNextDateTime:@"+0300"]];
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

#pragma mark - UITextFieldDelegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.taskNameText resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField selectAll:self];
}

#pragma mark - UITextViewDelegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.taskDetailText resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}

#pragma mark - Helper Methods
- (LLTask *)getTaskObject
{
    LLTask *newTask = [[LLTask alloc] init];
    newTask.titleid = [[NSDate date] description];
    newTask.title = self.taskNameText.text;
    newTask.description = self.taskDetailText.text;
    newTask.date = self.datePicker.date;
    newTask.isCompleted = NO;
    
    return newTask;
}
@end
