//
//  TLAppDelegate.h
//  Tasklist
//
//  Created by Jiangz on 12/10/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLViewController;

@interface TLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TLViewController *viewController;
@property (strong, nonatomic) UINavigationController *rootNavController;

@end
