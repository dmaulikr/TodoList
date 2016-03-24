//
//  TLCustomCellViewController.m
//  Tasklist
//
//  Created by jiang on 12/11/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import "TLCustomCellViewController.h"

@interface TLCustomCellViewController ()

@end

@implementation TLCustomCellViewController

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
    [_titleText setText:_strTitle];
    [_descriptionText setText:_strDescription];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_imageView setImage:_iconImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_titleText release];
    [_descriptionText release];
    [_imageView release];
    [super dealloc];
}
@end
