//
//  LLTask.h
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLTask : NSObject
@property (strong, nonatomic) NSString *titleid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL isCompleted;
@property (strong, nonatomic) UILocalNotification *notification;

-(id)initWithData:(NSDictionary *)data;

@end
