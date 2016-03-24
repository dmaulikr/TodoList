//
//  TLSettingListViewController.m
//  Tasklist
//
//  Created by jiang on 12/10/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import "TLSettingListViewController.h"

@interface TLSettingListViewController ()

@end

@implementation TLSettingListViewController

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
    self.navigationItem.title = @"Appearance";

    NSDictionary *colorDic = [[NSUserDefaults standardUserDefaults] objectForKey:COLOR_SCHEME_OBJECT_KEY];
    [self loadColorFromDictionary:colorDic];
    
    [self previewColor];
    [self initSliderValues:0];
}

- (IBAction)onBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) loadColorFromDictionary:(NSDictionary*)dictionary
{
    if (!dictionary) {
        text_color_r = 0;
        text_color_g = 0;
        text_color_b = 0;
        
        bg_color_r = 1;
        bg_color_g = 1;
        bg_color_b = 1;
        return;
    }
    
    text_color_r = [dictionary[TEXT_RED_COLOR] doubleValue];
    text_color_g = [dictionary[TEXT_GREEN_COLOR] doubleValue];
    text_color_b = [dictionary[TEXT_BLUE_COLOR] doubleValue];
    
    bg_color_r = [dictionary[BG_RED_COLOR] doubleValue];
    bg_color_g = [dictionary[BG_GREEN_COLOR] doubleValue];
    bg_color_b = [dictionary[BG_BLUE_COLOR] doubleValue];
}

- (IBAction)onSave:(id)sender {
    NSDictionary *colorAsDictionary = @{TEXT_RED_COLOR: [NSString stringWithFormat:@"%.3f", text_color_r],
                                        TEXT_GREEN_COLOR: [NSString stringWithFormat:@"%.3f", text_color_g],
                                        TEXT_BLUE_COLOR: [NSString stringWithFormat:@"%.3f", text_color_b],
                                        BG_RED_COLOR: [NSString stringWithFormat:@"%.3f", bg_color_r],
                                        BG_GREEN_COLOR: [NSString stringWithFormat:@"%.3f", bg_color_g],
                                        BG_BLUE_COLOR: [NSString stringWithFormat:@"%.3f", bg_color_b]
                                             };
    
    [[NSUserDefaults standardUserDefaults] setObject:colorAsDictionary forKey:COLOR_SCHEME_OBJECT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Info"
                                                      message:@"Color setting has been changed."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    [message release];
}

- (void) previewColor
{
    _sampleLabel.backgroundColor = [UIColor colorWithRed:bg_color_r green:bg_color_g blue:bg_color_b alpha:1];
    _sampleLabel.textColor = [UIColor colorWithRed:text_color_r green:text_color_g blue:text_color_b alpha:1];
}

- (void) initSliderValues:(int) choice // 0: text,  1: background
{
    if (choice==0) {
        _redSlider.value = text_color_r;
        _greenSlider.value = text_color_g;
        _blueSlider.value = text_color_b;
    }
    else
    {
        _redSlider.value = bg_color_r;
        _greenSlider.value = bg_color_g;
        _blueSlider.value = bg_color_b;
    }
}

- (void) saveSliderValues:(int) choice // 0: text,  1: background
{
    if (choice==0) {
        text_color_r = _redSlider.value;
        text_color_g = _greenSlider.value;
        text_color_b = _blueSlider.value;
    }
    else
    {
        bg_color_r = _redSlider.value;
        bg_color_g = _greenSlider.value;
        bg_color_b = _blueSlider.value;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_redSlider release];
    [_greenSlider release];
    [_blueSlider release];
    [_sampleLabel release];
    [_typeSegment release];
    [super dealloc];
}

- (IBAction)onSlideValueChanged:(id)sender {
    [self previewColor];
    [self saveSliderValues:_typeSegment.selectedSegmentIndex];
}

- (IBAction)onSegmentChanged:(id)sender {
    [self initSliderValues:_typeSegment.selectedSegmentIndex];
}
@end
