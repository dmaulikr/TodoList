//
//  TLSettingDateTimeViewController.m
//  Tasklist
//
//  Created by jiang on 12/10/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import "TLSettingDateTimeViewController.h"

@interface TLSettingDateTimeViewController ()

@end

@implementation TLSettingDateTimeViewController

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
    
    dateFormatArray = [[NSArray alloc] initWithObjects:
                       @"12/31/13",
                       @"31/12/13",
                       @"12.31.13",
                       @"31.12.13",
                       @"12-31-13",
                       @"31-12-13",
                       @"Dec 31 2013",
                       @"31 Dec 2013",
                       nil];
    
    timeFormatArray = [[NSArray alloc] initWithObjects:
                       @"1:30 pm",
                       @"13:30",
                       nil];
    
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
    self.navigationItem.title = @"Date/Time";
    
    int iDateFormat, iTimeFormat;
    
    NSString *strFormat = [[NSUserDefaults standardUserDefaults] objectForKey:DATE_FORMAT];
    
    if (strFormat)
        iDateFormat = [strFormat intValue];
    else
        iDateFormat = 0;
    
    strFormat = [[NSUserDefaults standardUserDefaults] objectForKey:TIME_FORMAT];
    
    if (strFormat)
        iTimeFormat = [strFormat intValue];
    else
        iTimeFormat = 0;
    
    [_dateFormater selectRow:iDateFormat inComponent:0 animated:NO];
    [_timeFormater selectRow:iTimeFormat inComponent:0 animated:NO];
}

- (IBAction)onSave:(id)sender {
    NSString *strDateFormatIndex = [NSString stringWithFormat:@"%d", [_dateFormater selectedRowInComponent:0]];
    NSString *strTimeFormatIndex = [NSString stringWithFormat:@"%d", [_timeFormater selectedRowInComponent:0]];
    
    [[NSUserDefaults standardUserDefaults] setObject:strDateFormatIndex forKey:DATE_FORMAT];
    [[NSUserDefaults standardUserDefaults] setObject:strTimeFormatIndex forKey:TIME_FORMAT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Info"
                                                      message:@"Date time format setting has been changed."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    [message release];
}

- (IBAction)onBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag==0)
        return [dateFormatArray count];
    else
        return [timeFormatArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (pickerView.tag==0)
        return dateFormatArray[row];
    else
        return timeFormatArray[row];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_dateFormater release];
    [_timeFormater release];
    [super dealloc];
}
@end
