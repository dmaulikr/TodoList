//
//  TLViewController.m
//  Tasklist
//
//  Created by Jiangz on 12/10/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import "TLViewController.h"
#import "TLCustomCell.h"

@interface TLViewController ()

@end

@implementation TLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initMenuBar];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CustomCellReuseID"];
    
    // date time format
//    dateFormatArray = [[NSArray alloc] initWithObjects:
//                       @"12/31/13",
//                       @"31/12/13",
//                       @"12.31.13",
//                       @"31.12.13",
//                       @"12-31-13",
//                       @"31-12-13",
//                       @"Dec 31 2013",
//                       @"31 Dec 2013",
//                       nil];
    
    dateFormatArray = [[NSArray alloc] initWithObjects:
                        @"MM/dd/yy",
                        @"dd/MM/yy",
                        @"MM.dd.yy",
                        @"dd.MM.yy",
                        @"MM-dd-yy",
                        @"dd-MM-yy",
                        @"MMM dd yyyy",
                        @"dd MMM yyyy",
                       nil];
    
//    timeFormatArray = [[NSArray alloc] initWithObjects:
//                       @"1:30 pm",
//                       @"13:30",
//                       nil];
    timeFormatArray = [[NSArray alloc] initWithObjects:
                        @"h:mm a",
                        @"HH:mm",
                       nil];
    
    // swipe recognizer
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self tableView] addGestureRecognizer:recognizer];
    [recognizer release];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self tableView] addGestureRecognizer:recognizer];
    [recognizer release];
    
    // long press recognizer
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //second
    [self.tableView addGestureRecognizer:lpgr];
    
    [lpgr release];
    
    [self removeOldTasks];
    [self initNotification];
    
#ifdef LITE
    NSLog(@"lite version");
    [self addBannerView];
#else
    NSLog(@"paid version");
#endif
}

- (void) addBannerView
{
    
}

- (void) addSampleData
{
    NSDictionary *defaultTask = @{TASK_TITLEID: @"README task",
                                  TASK_TITLE: @"README task",
                                  TASK_DATE: [NSDate date],
                                  TASK_DESCRIPTION: @"Welcome to task list, a lightweight task list app where you can add new tasks, reorder tasks, and delete tasks. You can also toggle tasks between “complete” (green) to “in progress” (yellow) or “overdue” (red).\n\nMore advanced features soon.\n@lenli",
                                  TASK_COMPLETION: @NO
                                  };
    
    NSArray *defaultArray = @[defaultTask];
    
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 defaultArray, TASKLIST_OBJECT_KEY, nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

- (void) initNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSArray *allTaskList1 = [[NSUserDefaults standardUserDefaults] objectForKey:TASKLIST_OBJECT_KEY];
    
    for (NSDictionary *dictionary in allTaskList1) {
        LLTask *obj = [self taskObjectFromDictionary:dictionary];
        
        if (obj.isCompleted)
            continue;
        
        if ([self isDateGreaterThanDate:[NSDate date] and:obj.date])
            continue;
        
        if (obj.notification)
            [[UIApplication sharedApplication] scheduleLocalNotification:obj.notification];
    }
}

- (void) addNotificationForTask:(LLTask*) obj
{
    if (obj.isCompleted)
        return;
    
    if ([self isDateGreaterThanDate:[NSDate date] and:obj.date])
        return;
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = obj.date;
    localNotification.alertBody = [NSString stringWithFormat:@"%@", obj.title];
    localNotification.alertAction = @"View Detail";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.userInfo = [NSDictionary dictionaryWithObject:obj.titleid forKey:@"taskid"];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    obj.notification = localNotification;
}

- (void) removeNotificationForTask:(LLTask*) obj
{
    if (obj.notification){
        [[UIApplication sharedApplication] cancelLocalNotification:obj.notification];
        obj.notification = nil;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    // date time format
    int iDateFormat, iTimeFormat;
    
    NSString *strFormat = [[NSUserDefaults standardUserDefaults] objectForKey:DATE_FORMAT];
    
    if (strFormat)
        iDateFormat = [strFormat intValue];
    else
        iDateFormat = 0;
    
    _strDateFormat = [dateFormatArray objectAtIndex:iDateFormat];
    
    strFormat = [[NSUserDefaults standardUserDefaults] objectForKey:TIME_FORMAT];
    
    if (strFormat)
        iTimeFormat = [strFormat intValue];
    else
        iTimeFormat = 0;
    
    _strTimeFormat = [timeFormatArray objectAtIndex:iTimeFormat];
    
    // color setting
    NSDictionary *colorDic = [[NSUserDefaults standardUserDefaults] objectForKey:COLOR_SCHEME_OBJECT_KEY];
    [self loadColorFromDictionary:colorDic];
    self.tableView.backgroundColor = self.bgColor;
    
    switch (self.displayOption) {
        case TLTodayTasks:
            self.navigationItem.title = @"Today Tasks";
            break;
            
        case TLTomorrowTasks:
            self.navigationItem.title = @"Tomorrow Tasks";
            break;
            
        case TLAllTasks:
            self.navigationItem.title = @"All Tasks";
            break;
            
        default:
            break;
    }
    
    [self loadTasks];
    [self.tableView reloadData];
}

- (void) loadColorFromDictionary:(NSDictionary*)dictionary
{
    double text_color_r;
    double text_color_g;
    double text_color_b;
    
    double bg_color_r;
    double bg_color_g;
    double bg_color_b;
    
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
    
    self.textColor = [UIColor colorWithRed:text_color_r green:text_color_g blue:text_color_b alpha:1];
    self.bgColor = [UIColor colorWithRed:bg_color_r green:bg_color_g blue:bg_color_b alpha:1];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView: self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        
        if (indexPath != nil) {
            selectedIndex = indexPath.row;
            [self becomeFirstResponder];
            UIMenuItem *edit = [[[UIMenuItem alloc] initWithTitle:@"Edit" action:@selector(onMenuEditTask:)] autorelease];
            UIMenuItem *completed = [[[UIMenuItem alloc] initWithTitle:@"Completed" action:@selector(onMenuCompleted:)] autorelease];
            UIMenuItem *delete = [[[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(onMenuDelete:)] autorelease];
            
            UIMenuController *menu = [UIMenuController sharedMenuController];
            [menu setMenuItems:[NSArray arrayWithObjects:edit, completed, delete, nil]];
            [menu setTargetRect:[self.tableView rectForRowAtIndexPath:indexPath] inView:self.tableView];
            [menu setMenuVisible:YES animated:YES];
        }
    }
}

//- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//-(BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//    
//    if (action == @selector(customDelete:) ){
//        return YES;
//    }
//    
//    return NO;
//}
//
//- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//}

- (void)onMenuEditTask:(id)sender {
    TLEditTaskViewController *subvc = [[TLEditTaskViewController alloc] init];
    subvc.delegate = self;
    subvc.taskObject = self.taskObjects[selectedIndex];
    [self.navigationController pushViewController:subvc animated:YES];
}

-(void)didUpdateTask
{
    [self removeNotificationForTask:self.taskObjects[selectedIndex]];
    [self addNotificationForTask:self.taskObjects[selectedIndex]];
    [self updateTask:self.taskObjects[selectedIndex]];
    [self loadTasks];
    [self.tableView reloadData];
}

-(void)updateCompletedSwitch:(LLTask*) taskObj
{
    if (taskObj.isCompleted)
        [self removeNotificationForTask:taskObj];
    else
        [self addNotificationForTask:taskObj];
    
    [self updateTask:taskObj];
}

- (void)onMenuCompleted:(id)sender {
    LLTask *task = self.taskObjects[selectedIndex];
    task.isCompleted = YES;
    [self removeNotificationForTask:task];
    [self updateTask:task];
    [self loadTasks];
    [self.tableView reloadData];
}

- (void)onMenuDelete:(id)sender {
    [self removeNotificationForTask:self.taskObjects[selectedIndex]];
    [self removeTask:self.taskObjects[selectedIndex]];
    [self loadTasks];
    [self.tableView reloadData];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction != UISwipeGestureRecognizerDirectionRight)
        return;
    
    CGPoint p = [recognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath)
    {
        NSLog(@"swipe right");
        LLTask *task = self.taskObjects[indexPath.row];
        task.isCompleted = YES;
        [self removeNotificationForTask:task];
        [self updateTask:task];
        [self loadTasks];
        [self.tableView reloadData];
    }
}

-(void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction != UISwipeGestureRecognizerDirectionLeft)
        return;
    
    CGPoint p = [recognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath)
    {
        NSLog(@"swipe left");
        LLTask *task = self.taskObjects[indexPath.row];
        
        if (task.isCompleted==NO)
            return;
        
        task.isCompleted = NO;
        [self addNotificationForTask:task];
        [self updateTask:task];
        [self loadTasks];
        [self.tableView reloadData];
    }
}

-(LLTask *)taskObjectFromDictionary:(NSDictionary *)dictionary
{
    LLTask *taskObject = [[LLTask alloc] initWithData:dictionary];
    return taskObject;
}

- (NSMutableArray *)taskObjects
{
    if (!_taskObjects) {
        _taskObjects = [[NSMutableArray alloc] init];
    }
    return _taskObjects;
}

- (void) initMenuBar
{
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:NAVBAR_COLOR_R green:NAVBAR_COLOR_G blue:NAVBAR_COLOR_B alpha:1.0f];
        self.navigationController.navigationBar.translucent = NO;
    }else {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:NAVBAR_COLOR_R green:NAVBAR_COLOR_G blue:NAVBAR_COLOR_B alpha:1.0f];
    }
    
    UIButton * btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMenu setFrame:CGRectMake(0, 0, 50, 30)];
    [btnMenu setTitle:@"Menu" forState:UIControlStateNormal];
    [btnMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnMenu.titleLabel.font = [UIFont fontWithName:@"Avenir Heavy" size:16.0];
    [btnMenu addTarget:self action:@selector(onMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton * btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAdd setFrame:CGRectMake(0, 15, 13, 14)];
    [btnAdd setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(onAdd:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],UITextAttributeTextColor,
//      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
//      UITextAttributeTextShadowColor,
//      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
//      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Avenir Heavy" size:18.0],
      UITextAttributeFont,
      nil]];
}

- (IBAction)onAdd:(UIBarButtonItem *)sender {
    TLAddTaskViewController *subvc = [[[TLAddTaskViewController alloc] init] autorelease];
    subvc.delegate = self;
//    [self.navigationController pushViewController:subvc animated:YES];
    [self.navigationController presentViewController:subvc animated:YES completion:nil];
}

- (IBAction)onMenu:(UIBarButtonItem *)sender {
    TLMenuViewController *subvc = [[[TLMenuViewController alloc] init] autorelease];
#ifdef LITE
    subvc = [[[TLMenuViewController alloc] initWithNibName:@"TLMenuViewController_lite" bundle:nil] autorelease];
#endif
    
    [self.navigationController pushViewController:subvc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.taskObjects count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellReuseID";
    TLCustomCell *cell = (TLCustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.cellItemTitleLabel.textColor = cell.cellItemDescLabel.textColor = self.textColor;
    LLTask *task = self.taskObjects[indexPath.row];
    
    [cell.cellItemTitleLabel setText:task.title];

    if (task.isCompleted) {
        [cell.cellItemDescLabel setText:@"Completed"];
        cell.cellItemTitleLabel.alpha = 0.3;
        cell.cellItemDescLabel.alpha = 0.3;
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *dateTimeFormat = [NSString stringWithFormat:@"'start at' %@ 'on' %@", self.strTimeFormat, self.strDateFormat];
        [formatter setDateFormat:dateTimeFormat];
        NSString *stringFromDate = [formatter stringFromDate:task.date];
        [cell.cellItemDescLabel setText:stringFromDate];
        cell.cellItemTitleLabel.alpha = 1;
        cell.cellItemDescLabel.alpha = 1;
    }
    
    cell.cellItemImageView.image = (task.isCompleted) ? [UIImage imageNamed:@"checked_checkbox.png"] : [UIImage imageNamed:@"unchecked_checkbox.png"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TLDetailTaskViewController *subvc = [[TLDetailTaskViewController alloc] init];
    subvc.delegate = self;
    subvc.taskObject = self.taskObjects[indexPath.row];
    subvc.strDateFormat = self.strDateFormat;
    subvc.strTimeFormat = self.strTimeFormat;
    [self.navigationController pushViewController:subvc animated:YES];
}

-(BOOL)isDateGreaterThanDate:(NSDate *)isDate and:(NSDate *)greaterThanDate
{
    NSTimeInterval firstDate = [isDate timeIntervalSince1970];
    NSTimeInterval secondDate = [greaterThanDate timeIntervalSince1970];
    
    if (firstDate >= secondDate) return YES;
    else return NO;
    
}

#pragma mark -- LLAddTaskViewControllerDelegate
- (void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddTask:(LLTask *)task
{
    [self addNotificationForTask:task];
    [self addTask:task];
    [self loadTasks];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) addTask:(LLTask*)newobj
{
    NSArray *allTaskList1 = [[NSUserDefaults standardUserDefaults] objectForKey:TASKLIST_OBJECT_KEY];
    NSMutableArray *allTaskList2 = [[NSMutableArray alloc] init];
    
    for (NSDictionary *obj in allTaskList1) {
        if ([obj[TASK_TITLEID] isEqualToString:newobj.titleid])
        {
            NSLog(@"logic error: add task");
            continue;
        }
        
        [allTaskList2 addObject:obj];
    }
    
    [allTaskList2 addObject:[self taskObjectAsAPropertyList:newobj]];
    
    [[NSUserDefaults standardUserDefaults] setObject:allTaskList2 forKey:TASKLIST_OBJECT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void) removeTask:(LLTask*)newobj
{
    NSArray *allTaskList1 = [[NSUserDefaults standardUserDefaults] objectForKey:TASKLIST_OBJECT_KEY];
    NSMutableArray *allTaskList2 = [[NSMutableArray alloc] init];
    
    for (NSDictionary *obj in allTaskList1) {
        if ([obj[TASK_TITLEID] isEqualToString:newobj.titleid])
            continue;
        
        [allTaskList2 addObject:obj];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:allTaskList2 forKey:TASKLIST_OBJECT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) updateTask:(LLTask*)newobj
{
    NSArray *allTaskList1 = [[NSUserDefaults standardUserDefaults] objectForKey:TASKLIST_OBJECT_KEY];
    NSMutableArray *allTaskList2 = [[NSMutableArray alloc] init];
    
    for (NSDictionary *obj in allTaskList1) {
        if ([obj[TASK_TITLEID] isEqualToString:newobj.titleid]) {
            [allTaskList2 addObject:[self taskObjectAsAPropertyList:newobj]];
        }
        else
            [allTaskList2 addObject:obj];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:allTaskList2 forKey:TASKLIST_OBJECT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) loadTasks
{
    for (LLTask *obj in self.taskObjects)
        [obj release];
    
    [self.taskObjects removeAllObjects];
    
    NSArray *allTaskList = [[NSUserDefaults standardUserDefaults] objectForKey:TASKLIST_OBJECT_KEY];
    
    for (NSDictionary *dictionary in allTaskList) {
        LLTask *taskObject = [self taskObjectFromDictionary:dictionary];
        switch (self.displayOption) {
            case TLTodayTasks:
                if ([[self whatDate:taskObject.date] isEqualToString:@"Today"]) {
                    [self.taskObjects addObject:taskObject];
                }
                break;
                
            case TLTomorrowTasks:
                if ([[self whatDate:taskObject.date] isEqualToString:@"Tomorrow"]) {
                    [self.taskObjects addObject:taskObject];
                }
                break;
                
            case TLAllTasks:
                if (![[self whatDate:taskObject.date] isEqualToString:@"Yesterday"]) {
                    [self.taskObjects addObject:taskObject];
                }
                break;
                
            default:
                NSLog(@"loadTasks: default (weird error)");
                break;
        }
    }
}

- (void) removeOldTasks
{
    NSArray *allTaskList1 = [[NSUserDefaults standardUserDefaults] objectForKey:TASKLIST_OBJECT_KEY];
    NSMutableArray *allTaskList2 = [[NSMutableArray alloc] init];
    
    for (NSDictionary *obj in allTaskList1) {
        if ([[self whatDate:obj[TASK_DATE]] isEqualToString:@"Yesterday"]) {
            continue;
        }
        [allTaskList2 addObject:obj];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:allTaskList2 forKey:TASKLIST_OBJECT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//- (void) removeOldTasks
//{
//    NSArray *allTaskList = [[NSUserDefaults standardUserDefaults] objectForKey:TASKLIST_OBJECT_KEY];
//    NSMutableArray *allTaskObjects = [[NSMutableArray alloc] init];
//    
//    for (NSDictionary *dictionary in allTaskList) {
//        LLTask *taskObject = [self taskObjectFromDictionary:dictionary];
//        
//        if ([[self whatDate:taskObject.date] isEqualToString:@"Yesterday"]) {
//            continue;
//        }
//        [allTaskObjects addObject:taskObject];
//    }
//    
//    NSMutableArray *taskList = [[NSMutableArray alloc] init];
//    
//    for (LLTask *taskObject in allTaskObjects) {
//        [taskList addObject:[self taskObjectAsAPropertyList:taskObject]];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:taskList forKey:TASKLIST_OBJECT_KEY];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

- (NSString*) whatDate:(NSDate *)isDate
{
    NSDate *today = [NSDate date];
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:86400];
    
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *tomorrowString = [[tomorrow description] substringToIndex:10];
    NSString *isDateString = [[isDate description] substringToIndex:10];
    
    if ([isDateString isEqualToString:todayString])
        return @"Today";
    else if ([isDateString isEqualToString:tomorrowString])
        return @"Tomorrow";
    else if ([isDateString isEqualToString:yesterdayString])
        return @"Yesterday";
    
    if ([self isDateGreaterThanDate:yesterday and:isDate])
        return @"Yesterday";
    
    return @"Future";
}

-(NSDictionary *)taskObjectAsAPropertyList:(LLTask *)taskObject
{
    NSData *notiData = [NSKeyedArchiver archivedDataWithRootObject:taskObject.notification];
    NSDictionary *taskObjectAsDictionary = @{TASK_TITLEID: taskObject.titleid,
                                             TASK_TITLE: taskObject.title,
                                             TASK_DESCRIPTION: taskObject.description,
                                             TASK_DATE: taskObject.date,
                                             TASK_COMPLETION: taskObject.isCompleted ? @"YES" : @"NO",
                                             TASK_NOTIFICATION: notiData
                                             };

    return taskObjectAsDictionary;
}

//-(void)updateCompletionStatusOfTask:(LLTask *)task forIndexPath:(NSIndexPath *)indexPath isCompleted:(BOOL)bComp
//{
//    [self updateCompletionStatusOfTask:task forIndex:indexPath.row isCompleted:bComp];
//}
//
//-(void)updateCompletionStatusOfTask:(LLTask *)task forIndex:(int)row isCompleted:(BOOL)bComp
//{
//    NSMutableArray *taskList = [[[NSUserDefaults standardUserDefaults] objectForKey:TASKLIST_OBJECT_KEY] mutableCopy];
//    if (!taskList) taskList = [[NSMutableArray alloc] init];
//    
//    [taskList removeObjectAtIndex:row];
//    
//    task.isCompleted = bComp;   // Toggle BOOL
//    [taskList insertObject:[self taskObjectAsAPropertyList:task] atIndex:row];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:taskList forKey:TASKLIST_OBJECT_KEY];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
