//
//  appointViewController.m
//  私练
//
//  Created by z on 15/1/27.
//  Copyright (c) 2015年 Unique. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import "appointViewController.h"
#import "Commonality.h"
#import "CLComment.h"
#import "HttpTool.h"
#import "LXActivity.h"
#import "Pingpp.h"
#import "HomeController.h"
#import "MainController.h"
#import "AppDelegate.h"
#import "PersonalCenterController.h"
#import "Message.h"
#import "TopView.h"
#import "priceList.h"
@interface appointViewController ()<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,LXActivityDelegate,UIAlertViewDelegate>
{
    UIButton *openClassButton;
    UIButton *openPickerButton;
    UIButton *openTimePickerButton;
    NSDictionary* requestdict;
    NSString *order_id;
    NSString *kUrl;
    BOOL ishuadong;
    BOOL isopenClass;
    int messageNumber;
    int messageHeight;
    int topImagetype;
    NSArray *messageArray;
    UIView *datePickerView;
    UILabel *dateLabel;
    UIDatePicker *datePicker;
    UIView *timePickerView;
    UILabel *timeLabel;
    UIPickerView *timePicker;
    UIImageView  *topimage;
    UIImageView *alertImageView;
    UILabel *classLabel;
    UIView *classPickView;
    UIPickerView *classPicker;
    NSDictionary *messageDict;
    UITextField *numberTextField;
    UITextField *nameTextField;
    UITextField *addressTextField;
    UIView *smallMessageView;
    TopView *topView;
    
    UIButton *openPersonButton;
    UILabel *personNumberLabel;
    UIPickerView *personNumberPicker;
}
@end

@implementation appointViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"订单信息"];
    BackView *backView = [[BackView alloc] initWithbacktitle:@"返回" viewController:self];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(changeIsHaveYES) name:@"ishaveyes" object:nil];
    
    NSNotificationCenter *nc1 = [NSNotificationCenter defaultCenter];
    [nc1 addObserver:self selector:@selector(changeIsHaveNO) name:@"ishaveno" object:nil];
    
    [self setView];
}
-(void)setView
{
    if (self.isShop) {
         messageArray    = @[@"课程",@"姓名",@"电话",@"日期",@"时间",@"人数"];
    } else {
        if (self.class_id != 2) {
            messageArray    = @[@"姓名",@"电话",@"日期",@"时间",@"人数",@"地址"];
        } else {
            messageArray    = @[@"课程",@"姓名",@"电话",@"日期",@"时间",@"人数",@"地址"];
        }
    }
    
    alertImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - viewHeight/3.9235)/2, viewHeight/3.335 - viewHeight/15.512 , viewHeight/3.9235, viewHeight/15.512)];
    [self.view addSubview:alertImageView];
    
     //顶部视图
    topImagetype = self.isShop ? 5 : self.class_id;
    topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight/3.335) imageTypeWith:topImagetype ClassNumberWith:self.personNumber showClassNumberWith:NO];
    [self.view addSubview:topView];
   
    
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), viewWidth, viewHeight - CGRectGetMaxY(topView.frame) - NavigationBar_Height)];
    messageView.userInteractionEnabled = YES;
    [self.view addSubview:messageView];
    
    UIPanGestureRecognizer *tapLeftDouble  = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapLeftDouble)];
    [messageView addGestureRecognizer:tapLeftDouble];
    
    openTimePickerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    openPickerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    openPersonButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    messageNumber = (int)messageArray.count + 1;
    messageHeight = messageView.bounds.size.height/messageNumber;
    for (int a = 0; a < messageNumber-1; a++) {
        
        smallMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, a*messageHeight, viewWidth, messageHeight)];
        smallMessageView.userInteractionEnabled = YES;
        
        [messageView addSubview:smallMessageView];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,smallMessageView.bounds.size.height + 0.5, viewWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        [smallMessageView addSubview:line];
        
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/51.308,(smallMessageView.bounds.size.height - viewHeight/33.35)/2, viewHeight/16.675, viewHeight/33.35)];
        messageLabel.text = messageArray[a];
        
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.font = [UIFont fontWithName:FONT size:viewHeight/51.308];
        [smallMessageView addSubview:messageLabel];
        
        if (self.class_id != 2 && !self.isShop) {
            if (a == 0 || a == 1 || a == 5) {
                UITextField *messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight)];
                messageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                messageTextField.textAlignment = 2;
                messageTextField.tag = a+10;
                messageTextField.delegate = self;
                messageTextField.textColor = [UIColor whiteColor];
                messageTextField.font  = [UIFont fontWithName:FONT size:Adaptive(17)];
                [smallMessageView addSubview:messageTextField];
                if (a == 0) {
                    messageTextField.text = self.userinfo_name;
                }
                else if (a == 1) {
                    messageTextField.keyboardType = UIKeyboardTypeDecimalPad;
                    messageTextField.text = self.userinfo_number;
                }
                else{
                    NSLog(@"接收地址 %@",self.userinfo_address);
                    messageTextField.text = self.userinfo_address;
                }
                
            }
            if (a == 2) {
                openPickerButton.frame = CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight);
                [openPickerButton addTarget:self action:@selector(openPicker) forControlEvents:UIControlEventTouchUpInside];
                [smallMessageView addSubview:openPickerButton];
                
                dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight)];
                dateLabel.textColor = [UIColor whiteColor];
                dateLabel.textAlignment = 2;
                dateLabel.font = [UIFont fontWithName:FONT size:Adaptive(17)];
                [smallMessageView addSubview:dateLabel];
                
            }
            if (a == 3) {
                
                openTimePickerButton.frame = CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight);
                openTimePickerButton.tag = 57;
                [openTimePickerButton addTarget:self action:@selector(openTimePicker) forControlEvents:UIControlEventTouchUpInside];
                [smallMessageView addSubview:openTimePickerButton];
                
                timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight)];
                timeLabel.textColor = [UIColor whiteColor];
                timeLabel.textAlignment = 2;
                timeLabel.font = [UIFont fontWithName:FONT size:Adaptive(17)];
                [smallMessageView addSubview:timeLabel];
            }
            if (a == 4) {
                openPersonButton.frame = CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight);
                [openPersonButton addTarget:self action:@selector(openPerson) forControlEvents:UIControlEventTouchUpInside];
                [smallMessageView addSubview:openPersonButton];
                
                personNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight)];
                personNumberLabel.textColor = [UIColor whiteColor];
                personNumberLabel.textAlignment = 2;
                personNumberLabel.font = [UIFont fontWithName:FONT size:viewHeight/37.056];
                [smallMessageView addSubview:personNumberLabel];
            }
        }
        else
        {
            if (a == 0) {
                openClassButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                openClassButton.frame = CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight);
                [openClassButton addTarget:self action:@selector(openClass) forControlEvents:UIControlEventTouchUpInside];
                [smallMessageView addSubview:openClassButton];
                
                classLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight)];
                classLabel.textColor = [UIColor whiteColor];
                classLabel.textAlignment = 2;
                classLabel.font = [UIFont fontWithName:FONT size:Adaptive(17)];
                [smallMessageView addSubview:classLabel];
                
            }
            
            if (a == 1 || a == 2 || a == 6) {
                UITextField *messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight)];
                messageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                messageTextField.textAlignment = 2;
                messageTextField.tag = a+9;
                messageTextField.delegate = self;
                messageTextField.textColor = [UIColor whiteColor];
                messageTextField.font  = [UIFont fontWithName:FONT size:Adaptive(17)];
                [smallMessageView addSubview:messageTextField];
                if (a == 1) {
                    messageTextField.text = self.userinfo_name;
                }
                else if (a == 2) {
                    messageTextField.keyboardType = UIKeyboardTypeDecimalPad;
                    messageTextField.text = self.userinfo_number;
                }
                else{
                    messageTextField.text = self.userinfo_address;
                }
            }
            if (a == 3) {
                openPickerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                openPickerButton.frame = CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight);
                [openPickerButton addTarget:self action:@selector(openPicker) forControlEvents:UIControlEventTouchUpInside];
                [smallMessageView addSubview:openPickerButton];
                
                dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight)];
                dateLabel.textColor = [UIColor whiteColor];
                dateLabel.textAlignment = 2;
                dateLabel.font = [UIFont fontWithName:FONT size:Adaptive(17)];
                [smallMessageView addSubview:dateLabel];
                
            }
            
            if (a == 4) {
                openTimePickerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                openTimePickerButton.frame = CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight);
                [openTimePickerButton addTarget:self action:@selector(openTimePicker) forControlEvents:UIControlEventTouchUpInside];
                [smallMessageView addSubview:openTimePickerButton];
                
                timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight)];
                timeLabel.textColor = [UIColor whiteColor];
                timeLabel.textAlignment = 2;
                timeLabel.font = [UIFont fontWithName:FONT size:Adaptive(17)];
                [smallMessageView addSubview:timeLabel];
            }
            if (a == 5) {
                openPersonButton.frame = CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight);
                [openPersonButton addTarget:self action:@selector(openPerson) forControlEvents:UIControlEventTouchUpInside];
                [smallMessageView addSubview:openPersonButton];
                
                personNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageHeight)];
                personNumberLabel.textColor = [UIColor whiteColor];
                personNumberLabel.textAlignment = 2;
                personNumberLabel.font = [UIFont fontWithName:FONT size:viewHeight/37.056];
                [smallMessageView addSubview:personNumberLabel];
            }
        }
    }
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureButton.frame = CGRectMake(0, messageView.bounds.size.height - messageHeight-viewHeight/133.4, viewWidth, messageHeight + viewHeight/133.4);
    sureButton.backgroundColor = [UIColor orangeColor];
    [sureButton setTitle:@"下单" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(payMoney) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont fontWithName:FONT size:viewHeight/37.056];
    [messageView addSubview:sureButton];
    
    
}
#pragma mark -- ClassPicker
-(void)openClass
{
    
    if (!isopenClass) {
        //nameTextField交互性关闭
        [(UITextField *)[self.view viewWithTag:10] setUserInteractionEnabled:NO];
        //numberTextField交互性关闭
        [(UITextField *)[self.view viewWithTag:11] setUserInteractionEnabled:NO];
        classPickView = [[UIView alloc] initWithFrame:CGRectMake(0,viewHeight - NavigationBar_Height - viewHeight/2.6055,viewWidth,viewHeight/2.6055)];
        classPickView.backgroundColor = [UIColor whiteColor];
        classPickView.userInteractionEnabled = YES;
        [self.view addSubview:classPickView];
        
        UIButton *sureClassButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sureClassButton.frame = CGRectMake(0, 0, viewWidth, viewHeight/16.675);
        sureClassButton.backgroundColor = [UIColor orangeColor];
        [sureClassButton addTarget:self action:@selector(sureClass) forControlEvents:UIControlEventTouchUpInside];
        [sureClassButton setTintColor:[UIColor whiteColor]];
        [sureClassButton setTitle:@"完成" forState:UIControlStateNormal];
        sureClassButton.titleLabel.font = [UIFont fontWithName:FONT size:viewHeight/41.6875];
        [classPickView addSubview:sureClassButton];
        
        classPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sureClassButton.frame), viewWidth, viewHeight/3.088)];
        classPicker.delegate   = self;
        classPicker.dataSource = self;
        classPicker.tag = 100;
        [classPickView addSubview:classPicker];
        isopenClass = !isopenClass;
    }
    
}
-(void)sureClass
{
    //nameTextField交互性打开
    [(UITextField *)[self.view viewWithTag:10] setUserInteractionEnabled:YES];
    //numberTextField交互性打开
    [(UITextField *)[self.view viewWithTag:11] setUserInteractionEnabled:YES];
    
    [classPickView removeFromSuperview];
     isopenClass = !isopenClass;
}
#pragma mark -- DatePicker
-(void)openPicker
{
    //class交互性关闭
    openClassButton.userInteractionEnabled = NO;
    //nameTextField交互性关闭
    [(UITextField *)[self.view viewWithTag:10] setUserInteractionEnabled:NO];
    //numberTextField交互性关闭
    [(UITextField *)[self.view viewWithTag:11] setUserInteractionEnabled:NO];
    ishuadong = NO;
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0,viewHeight - NavigationBar_Height - viewHeight/2.6055,viewWidth,viewHeight/2.6055)];
    datePickerView.backgroundColor = [UIColor whiteColor];
    datePickerView.userInteractionEnabled = YES;
    [self.view addSubview:datePickerView];
    
    UIButton *sureDateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureDateButton.frame = CGRectMake(0, 0, viewWidth, viewHeight/16.675);
    sureDateButton.backgroundColor = [UIColor orangeColor];
    [sureDateButton addTarget:self action:@selector(sureDate) forControlEvents:UIControlEventTouchUpInside];
    [sureDateButton setTintColor:[UIColor whiteColor]];
    [sureDateButton setTitle:@"完成" forState:UIControlStateNormal];
    sureDateButton.titleLabel.font = [UIFont fontWithName:FONT size:viewHeight/41.6875];
    [datePickerView addSubview:sureDateButton];
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sureDateButton.frame), viewWidth, viewHeight/3.088)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventValueChanged];
    [datePickerView addSubview:datePicker];
}
-(void)changeDate
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [formatter stringFromDate:datePicker.date];
    dateLabel.text = dateString;
    ishuadong = YES;
}
-(void)sureDate
{
    //class交互性打开
    openClassButton.userInteractionEnabled = YES;
    //nameTextField交互性打开
    [(UITextField *)[self.view viewWithTag:10] setUserInteractionEnabled:YES];
    //numberTextField交互性打开
    [(UITextField *)[self.view viewWithTag:11] setUserInteractionEnabled:YES];
    if (ishuadong == NO) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateString = [formatter stringFromDate:date];
        dateLabel.text = dateString;
        
    }
    [datePickerView removeFromSuperview];
}

#pragma mark -- TimePicker
-(void)openTimePicker
{
    //class交互性关闭
    openClassButton.userInteractionEnabled = NO;
    //nameTextField交互性关闭
    [(UITextField *)[self.view viewWithTag:10] setUserInteractionEnabled:NO];
    //numberTextField交互性关闭
    [(UITextField *)[self.view viewWithTag:11] setUserInteractionEnabled:NO];
    timePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - NavigationBar_Height - viewHeight/2.6055, viewWidth, viewHeight/2.6055)];
    timePickerView.backgroundColor = [UIColor whiteColor];
    timePickerView.userInteractionEnabled = YES;
    [self.view addSubview:timePickerView];
    
    UIButton *sureTimeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureTimeButton.frame = CGRectMake(0, 0, viewWidth, viewHeight/16.675);
    sureTimeButton.backgroundColor = [UIColor orangeColor];
    [sureTimeButton addTarget:self action:@selector(sureTime) forControlEvents:UIControlEventTouchUpInside];
    [sureTimeButton setTintColor:[UIColor whiteColor]];
    [sureTimeButton setTitle:@"完成" forState:UIControlStateNormal];
    sureTimeButton.titleLabel.font = [UIFont fontWithName:FONT size:viewHeight/41.6875];
    [timePickerView addSubview:sureTimeButton];
    
    timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sureTimeButton.frame), viewWidth, viewHeight/3.088)];
    timePicker.delegate   = self;
    timePicker.dataSource = self;
    timePicker.tag = 200;
    [timePickerView addSubview:timePicker];
}
-(void)sureTime
{
    //class交互性打开
    openClassButton.userInteractionEnabled = YES;
    //nameTextField交互性打开
    [(UITextField *)[self.view viewWithTag:10] setUserInteractionEnabled:YES];
    //numberTextField交互性打开
    [(UITextField *)[self.view viewWithTag:11] setUserInteractionEnabled:YES];
    
    [timePickerView removeFromSuperview];
}
#pragma mark -- ClassPicker
-(void)openPerson
{
    //class交互性关闭
    openClassButton.userInteractionEnabled = NO;
    //nameTextField交互性关闭
    [(UITextField *)[self.view viewWithTag:10] setUserInteractionEnabled:NO];
    //numberTextField交互性关闭
    [(UITextField *)[self.view viewWithTag:11] setUserInteractionEnabled:NO];

    classPickView = [[UIView alloc] initWithFrame:CGRectMake(0,viewHeight - NavigationBar_Height - viewHeight/2.6055,viewWidth,viewHeight/2.6055)];
    classPickView.backgroundColor = [UIColor whiteColor];
    classPickView.userInteractionEnabled = YES;
    [self.view addSubview:classPickView];
    
    UIButton *sureClassButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureClassButton.frame = CGRectMake(0, 0, viewWidth, viewHeight/16.675);
    sureClassButton.backgroundColor = [UIColor orangeColor];
    [sureClassButton addTarget:self action:@selector(surePerson) forControlEvents:UIControlEventTouchUpInside];
    [sureClassButton setTintColor:[UIColor whiteColor]];
    [sureClassButton setTitle:@"完成" forState:UIControlStateNormal];
    sureClassButton.titleLabel.font = [UIFont fontWithName:FONT size:viewHeight/41.6875];
    [classPickView addSubview:sureClassButton];
    
    personNumberPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sureClassButton.frame), viewWidth, viewHeight/3.088)];
    personNumberPicker.delegate   = self;
    personNumberPicker.dataSource = self;
    personNumberPicker.tag = 300;
   
    [classPickView addSubview:personNumberPicker];
    
}
-(void)surePerson
{
    //nameTextField交互性打开
    [(UITextField *)[self.view viewWithTag:10] setUserInteractionEnabled:YES];
    //numberTextField交互性打开
    [(UITextField *)[self.view viewWithTag:11] setUserInteractionEnabled:YES];
    
    [classPickView removeFromSuperview];
   
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 200) {
        return self.dateArray.count;
    } else if (pickerView.tag == 100){
        return  self.course.count;
    } else {
        
        return self.price_list.count;
       
    }
}
// 设置某一列中的某一行的标题
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 200) {
        NSString *title = [self.dateArray objectAtIndex:row];
        return title;
    }else if (pickerView.tag == 100){
        Message *message = [self.course objectAtIndex:row];
        return message.name;
    } else {
        priceList *price = [self.price_list objectAtIndex:row];
        return price.price_name;
    }
}
// 选中某一列中的某一行时会调用
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 200) {
        timeLabel.text = [self.dateArray objectAtIndex:row];
    } else if (pickerView.tag == 100) {
        Message *message = [self.course objectAtIndex:row];
        classLabel.text = message.name;
        self.func_id = message.func_id;
        self.course_time = message.course_time;
    } else {
        priceList *price = [self.price_list objectAtIndex:row];
        self.rmb = price.price_rmb;
        self.price_number = price.price_num;
        personNumberLabel.text = price.price_name;
    }
}

#pragma  mark -- PayMoney
-(void)payMoney
{
    alertImageView.alpha = 1;
    alertImageView.frame = CGRectMake((viewWidth - viewHeight/3.9235)/2, CGRectGetMaxY(topView.frame) - viewHeight/15.512 , viewHeight/3.9235, viewHeight/15.512);
    
    NSString *timeString = [timeLabel.text substringToIndex:2];
    NSString *string = [NSString stringWithFormat:@"%@ %@:00:00",dateLabel.text,timeString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH:mm:ss"];
    NSDate *date1 = [dateFormatter dateFromString:string];
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[date1 timeIntervalSince1970]];
    
    
    if (self.class_id !=2 && !self.isShop) {
        Message *message = [self.course objectAtIndex:0];
        self.func_id = message.func_id;
        self.course_time = message.course_time;
    }
    nameTextField = (UITextField *)[self.view viewWithTag:10];
    numberTextField = (UITextField *)[self.view viewWithTag:11];
    addressTextField = (UITextField *)[self.view viewWithTag:15];
    [addressTextField resignFirstResponder];
    if (self.isShop) {
        if (nameTextField.text.length == 0|| numberTextField.text.length == 0|| classLabel.text.length == 0||timeLabel.text.length == 0||dateLabel.text.length == 0 || personNumberLabel.text.length == 0)
        {
            
            [self alertImageWithImageName:@"alert_all"];
            return;
        }
    }
    if (self.class_id != 2 && !self.isShop) {
        
        if (nameTextField.text.length == 0|| numberTextField.text.length == 0||addressTextField.text.length == 0||timeLabel.text.length == 0||dateLabel.text.length == 0 || personNumberLabel.text.length == 0)
        {
            
            [self alertImageWithImageName:@"alert_all"];
            return;
        }
    }
    if (self.class_id  == 2 && !self.isShop)
    {
        if (nameTextField.text.length == 0|| numberTextField.text.length == 0||addressTextField.text.length == 0||timeLabel.text.length == 0||dateLabel.text.length == 0||classLabel.text.length == 0|| personNumberLabel.text.length == 0)
        {
            
            [self alertImageWithImageName:@"alert_all"];
            return;
        }
        
    }
    //检查所有信息是否有误
    
    BOOL kongge = [appointViewController isValidateKongge:nameTextField.text];
    if (!kongge) {
        [self alertImageWithImageName:@"alert_name"];
        return;
        
    }
    BOOL number = [appointViewController isValidateTelNumber:numberTextField.text];
    if (!number) {
        
        [self alertImageWithImageName:@"alert_telephone"];
        return;
    }
    if (!self.isShop) {
        BOOL addresskongge = [appointViewController isValidateKongge:addressTextField.text];
        if (!addresskongge) {
            
            [self alertImageWithImageName:@"alert_address"];
            return;
        }

    }
    if (!self.isShop) {
         messageDict = @{@"func_id":self.func_id,@"course_type":@"1",@"number":numberTextField.text,@"name":nameTextField.text,@"address":addressTextField.text,@"time":timeSp,@"course_num":self.price_number};
    } else {
         messageDict = @{@"func_id":self.func_id,@"course_type":@"2",@"number":numberTextField.text,@"name":nameTextField.text,@"time":timeSp,@"course_num":self.price_number};
        NSLog(@"参数 %@",messageDict);
    }
    
    
    NSLog(@" 是不是vip会员的第一次课 %@",self.vip_cards);
    
    if ([self.vip_cards isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"尊敬的Vip用户,您是首次购买我们的课程,将完全免费,请确认是否订课" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 741;
        
        [alert show];
    }else{
        NSString *url = [NSString stringWithFormat:@"%@api/?method=gdcourse.get_order",BASEURL];
        [HttpTool postWithUrl:url params:messageDict contentType: CONTENTTYPE success:^(id responseObject)
         {
             NSLog(@"下单res  %@",responseObject);
             
             NSDictionary *dict = [responseObject objectForKey:@"data"];
             order_id = [dict objectForKey:@"order_id"];
             
             
             if ([[responseObject objectForKey:@"rc"] intValue] == 0) {
                 NSArray *shareButtonImageNameArray = [[NSArray alloc] init];
                 
                 shareButtonImageNameArray = @[@"pay_weixin2",@"pay_yinlian2",@"pay_zhifubao2"];
                 NSLog(@"self.price_number %@",self.price_number);
                 LXActivity *lxActivity = [[LXActivity alloc] initWithTitle:self.rmb time:self.course_time delegate:self discont:self.discont  youhuijuan:self.youhuijuan classNumber:self.price_number isFirst:self.isFirst cancelButtonTitle:@"" ShareButtonTitles:nil withShareButtonImagesName:shareButtonImageNameArray];
                 [lxActivity showInView:self.view];
             }else{
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 [alert show];
             }
         }fail:^(NSError *error){
             NSLog(@"error   %@",error);
         }];
    }
}

-(void)changeIsHaveYES
{
    self.ishave = @"1";
}
-(void)changeIsHaveNO
{
    self.ishave = @"0";
}
#pragma mark - LXActivityDelegate

- (void)didClickOnImageIndex:(int)imageIndex
{
    if (imageIndex == 4) {
        return;
    } else {
        if (self.ishave) {
            kUrl = [NSString stringWithFormat:@"%@charge/?gd_money=%@",BASEURL,self.ishave];
        } else {
            kUrl = [NSString stringWithFormat:@"%@charge/",BASEURL];
        }
        switch (imageIndex) {
            case 2:
            {
                requestdict = @{
                                @"channel" : @"alipay",
                                @"course_num"  :self.price_number,
                                @"order_no":order_id,
                                @"subject":self.func_id,
                                };
            }
                break;
            case 1:
            {
                requestdict = @{
                                @"channel" : @"upacp",
                                @"course_num"  :self.price_number,
                                @"order_no":order_id,
                                @"subject":self.func_id,
                                };
            }
                break;
            case 0:
            {
                requestdict = @{
                                @"channel" : @"wx",
                                @"course_num"  :self.price_number,
                                @"order_no":order_id,
                                @"subject":self.func_id,
                                };
            }
                break;
                
            default:
                break;
        }
        appointViewController * __weak weakSelf = self;
        
        [HttpTool postWithUrl:kUrl params:requestdict contentType:CONTENTTYPE success:^(id responseObject) {
            NSLog(@"response   %@",responseObject );
            if ([responseObject objectForKey:@"rc"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                
                [alert show];
                
            }else{
                NSData* data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                NSString* charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"charge = %@", charge);
                
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error)
                                    {
                                        NSLog(@"completion block: %@", result);
                                        if (error == nil)
                                        {
                                            MainController *home = [MainController new];
                                            AppDelegate *app = [UIApplication sharedApplication].delegate;
                                            app.window.rootViewController = home;
                                            
                                            NSLog(@"PingppError is nil");
                                        }else{
                                            NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                                        }
                                    }];
                               });
                
            }
        } fail:^(NSError *error) {
            NSLog(@"error  %@",error);
        }];
        
    }
}
//是否是有效的正则表达式
+(BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strExpression];
    return [predicate evaluateWithObject:strDestination];
}
//验证电话号码
+(BOOL)isValidateTelNumber:(NSString *)number
{
    NSString *strRegex = @"[0-9]{11,11}";
    
    BOOL rt = [self isValidateRegularExpression:number byExpression:strRegex];
    
    return rt;
}
//验特殊字符
+(BOOL)isValidateKongge:(NSString *)kongge
{
    NSString *strRegex = @"^[A-Za-z0-9\u4E00-\u9FA5_-]+$";
    
    BOOL rt = [self isValidateRegularExpression:kongge byExpression:strRegex];
    
    return rt;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 10) {
        NSLog(@"课程点击关闭");
        //class交互性关闭
        openClassButton.userInteractionEnabled = NO;
    }
    if (textField.tag == 11) {
        //data交互性关闭
        openPickerButton.userInteractionEnabled = NO;
        //class交互性关闭
        openClassButton.userInteractionEnabled = NO;
        //time交互性关闭
        openTimePickerButton.userInteractionEnabled = NO;
    }
    if (textField.tag == 15) {
        //class交互性关闭
        openClassButton.userInteractionEnabled = NO;
        //data交互性关闭
        openPickerButton.userInteractionEnabled = NO;
        //time交互性关闭
        openTimePickerButton.userInteractionEnabled = NO;
        //person交互性关闭
        openPersonButton.userInteractionEnabled = NO;
        //nameTextField交互性关闭
        [(UITextField *)[self.view viewWithTag:10] setUserInteractionEnabled:NO];
        //numberTextField交互性关闭
        [(UITextField *)[self.view viewWithTag:11] setUserInteractionEnabled:NO];
    }
    
    
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    CGRect rootpoint = [textField.superview convertRect:textField.bounds toView:app.window];
    
    CGFloat offset = viewHeight - (rootpoint.origin.y + textField.frame.size.height+258);
    if (offset<=0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    alertImageView.alpha = 1;
    alertImageView.frame = CGRectMake((viewWidth - viewHeight/3.9235)/2, CGRectGetMaxY(topView.frame) - viewHeight/15.512 , viewHeight/3.9235, viewHeight/15.512);
    if (textField.tag == 10 )
    {
        //class交互性打开
        openClassButton.userInteractionEnabled = YES;
        BOOL kongge = [appointViewController isValidateKongge:textField.text];
        if (!kongge) {
            [self alertImageWithImageName:@"alert_name"];
        }
    }else if (textField.tag == 11) {
        //data交互性打开
        openPickerButton.userInteractionEnabled = YES;
        //class交互性打开
        openClassButton.userInteractionEnabled = YES;
        //time交互性打开
        openTimePickerButton.userInteractionEnabled = YES;
        BOOL number = [appointViewController isValidateTelNumber:textField.text];
        if (!number) {
            
            [self alertImageWithImageName:@"alert_telephone"];
        }
    }
    else if  (textField.tag == 15 )
    {
        //class交互性打开
        openClassButton.userInteractionEnabled = YES;
        //data交互性打开
        openPickerButton.userInteractionEnabled = YES;
        //time交互性打开
        openTimePickerButton.userInteractionEnabled = YES;
        //person交互性打开
        openPersonButton.userInteractionEnabled = YES;
        //nameTextField交互性打开
        [(UITextField *)[self.view viewWithTag:10] setUserInteractionEnabled:YES];
        //numberTextField交互性打开
        [(UITextField *)[self.view viewWithTag:11] setUserInteractionEnabled:YES];
        BOOL kongge = [appointViewController isValidateKongge:textField.text];
        if (!kongge) {
            
            [self alertImageWithImageName:@"alert_address"];
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 66.0;
        self.view.frame = frame;
    }];
    
    return YES;
}
-(void)alertImageWithImageName:(NSString *)imageName
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//调用系统震动
    [alertImageView setImage:[UIImage imageNamed:imageName]];
    [UIView animateWithDuration:.4  animations:^{
        alertImageView.frame = CGRectMake((viewWidth - viewHeight/3.9235)/2, CGRectGetMaxY(topView.frame) , viewHeight/3.9235, viewHeight/15.512);
    } completion:^(BOOL finished) {
        
        [NSThread sleepForTimeInterval:1.0f];
        [UIView animateWithDuration:.4  animations:^{
            alertImageView.alpha = 0;
        } completion:^(BOOL finished) {
        }];
    }];
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex %ld",(long)buttonIndex);
    switch (alertView.tag) {
            
        case 741:
        {
            if (buttonIndex == 1) {
                NSString *url = [NSString stringWithFormat:@"%@api/?method=gdcourse.get_order",BASEURL];
                
                NSLog(@"messageDict %@",messageDict);
                [HttpTool postWithUrl:url params:messageDict contentType: CONTENTTYPE success:^(id responseObject)
                 {
                     NSLog(@" vip第一次订课Res  %@",responseObject);
                     
                     //如果res中有msg这个key 就弹出提示框显示内容
                     if ([[responseObject allKeys] containsObject:@"msg"]) {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                         alert.tag = 852;
                         [alert show];
                         
                     }
                 }
                fail:^(NSError *error)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接错误，正在排查中...." delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                     
                     [alert show];
                     
                 }];
            }
            break;
        case 852:
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        default:
            break;
        }
    }
}
-(void)tapLeftDouble
{
    [self.view endEditing:YES];
}
@end
