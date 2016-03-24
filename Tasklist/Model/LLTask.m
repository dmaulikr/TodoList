//
//  LLTask.m
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import "LLTask.h"

@implementation LLTask

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.titleid = data[TASK_TITLEID];
        self.title = data[TASK_TITLE];
        self.description = data[TASK_DESCRIPTION];
        self.date = data[TASK_DATE];
        self.isCompleted = [ data[TASK_COMPLETION] boolValue];
        
        if (data[TASK_NOTIFICATION])
            self.notification = (UILocalNotification*)[NSKeyedUnarchiver unarchiveObjectWithData:data[TASK_NOTIFICATION]];
        else
            self.notification = nil;
    };
    return self;
}

- (id)init
{
    self = [self initWithData:nil];
    return self;
}

@end
