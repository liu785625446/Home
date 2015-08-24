//
//  AddSenceViewController.m
//  Home
//
//  Created by 刘军林 on 14-8-13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "AddSenceViewController.h"
#import "AddSenceCells.h"
#import "DeviceResource.h"
#import "SelectImgViewController.h"
#import "SelectWeekTableViewController.h"
#import "SenceDeviceViewController.h"
#import "Toast+UIView.h"
#import "Interface.h"
#import "Entity.h"
#import "Tool.h"
#import "FMDatabase.h"
#import "SenceEntity.h"
#import "ImageList.h"
#import "config.h"
#import "SenceEntityProcess.h"
#import "MSelectMusicViewController.h"

@interface AddSenceViewController ()

@end

@implementation AddSenceViewController

@synthesize senceName;
@synthesize timingWeek;
@synthesize timingStart;

@synthesize sence;

@synthesize isSave;
@synthesize add_1_or_update_2;

@synthesize datePicker;
@synthesize dateTool;
@synthesize dateView;

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
    [self.baseTableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    _senceEntityProcess = [[SenceEntityProcess alloc] init];
    if (!self.sence) {
        self.sence = [[Sence alloc] init];
        _device_list = [[NSMutableArray alloc] initWithCapacity:0];
    }else{
        [_senceEntityProcess synchronousSenceEntity:sence didSuccess:^{
            _device_list = [_senceEntityProcess findSenceEntityForSence:sence];
            [self.baseTableView reloadData];
        }didFail:^{
        }];
    }
    
    dateTool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.baseRect.size.width, 38.0f)];
    dateTool.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *cancelBar = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(cancelAction:)];
    UIBarButtonItem *sapce = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:Nil
                                                                           action:nil];
    UIBarButtonItem *doneBar = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(doneAction:)];
    [cancelBar setTintColor:[UIColor grayColor]];
    [doneBar setTintColor:[UIColor grayColor]];
    [dateTool setItems:[NSArray arrayWithObjects:cancelBar,sapce,doneBar ,nil]];
    
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,
                                                                     38.0,
                                                                     self.baseRect.size.width,
                                                                     216)];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 38.0, self.baseRect.size.width, 0.5)];
    [line setBackgroundColor:[UIColor grayColor]];
    line.alpha = 0.5;
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    self.dateView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             self.baseRect.size.height,
                                                             self.baseRect.size.width,
                                                             254)];
    self.datePicker.minimumDate = [NSDate date];
    if (self.sence.createTime > 0) {
        if (self.sence.senceType ==  SENCE_TYPE_TIMING) {
            NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:self.sence.senceDate];
            self.datePicker.date = date;
        }else{
            NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:self.sence.senceTime];
            self.datePicker.date = date;
        }
    }
    [self.dateView addSubview:self.dateTool];
    [self.dateView addSubview:self.datePicker];
    [self.dateView addSubview:line];
    [self.view addSubview:self.dateView];
    
    if (self.sence) {
        NSString *msg = [NSString stringWithFormat:@"%d",self.sence.senceIndex];
        [[Interface shareInterface:nil] writeFormatDataAction:@"34" didMsg:msg didCallBack:^(NSString *code) {
            NSArray *array = [code componentsSeparatedByString:@"&"];
            if ([[array objectAtIndex:1] intValue] != 1) {
                self.sence.senceMusic = [array objectAtIndex:2];
            }else{
                self.sence.senceMusic = @"";
            }
            [self.baseTableView reloadData];
        }];
    }
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.baseTableView reloadData];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.baseTableView setContentOffset:CGPointMake(0, -64)
                        animated:YES];
    [self.baseTableView reloadData];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self cancelAction:nil];
}

#pragma mark -
-(void) resignkeyBoard
{
    self.sence.senceName = self.senceName.text;
    [self.senceName resignFirstResponder];
}

-(IBAction)senceSwitchAction:(id)sender
{
    UISwitch *but = (UISwitch *)sender;

    if ([self checkConnectionStatus]) {
        [but setOn:!but.on animated:YES];
        return;
    }
    
    if (but == self.timingStart) {
        if (self.timingStart.isOn) {
            if (self.timingWeek) {
                if (self.timingWeek.isOn) {
                    self.sence.senceType = SENCE_TYPE_CYCLE;
                }else{
                    self.sence.senceType = SENCE_TYPE_TIMING;
                }
            }else{
                self.sence.senceType = SENCE_TYPE_TIMING;
            }
        }else{
            self.sence.senceType = SENCE_TYPE_DELAY;
        }
        [self.baseTableView reloadData];
    }else if (but == timingWeek) {
        self.datePicker.minimumDate = [NSDate date];
        if (self.timingWeek.isOn) {
//                    为周期的话，可以选择当前日期之前的时间
            self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
            self.sence.senceType = SENCE_TYPE_CYCLE;
        }else{
            self.sence.senceType = SENCE_TYPE_TIMING;
            self.sence.senceTime = [self getCurrentTime];
        }
        [self.baseTableView reloadData];
    }
}

-(IBAction)saveSenceAction:(id)sender
{
    if ([self checkConnectionStatus]) {
        return;
    }
    if ([self.senceName.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入情景名称!"];
        return;
    }
    
    if ([_device_list count] == 0) {
        [self.view makeToast:@"请配置情景设备!"];
        return;
    }
    
    if ([Tool checkFormatStr:self.senceName.text]) {
        [Tool showMyAlert:S_FORMAT_ERROR];
        return;
    }
    
    if (![Interface shareInterface:nil].isConnection) {
        [MTopWarnView addTopWarnText:S_NETWORK_NO_DETECT_NETWORK_SETTINGS view:self.baseTableView];
        return;
    }
    
    if (self.sence.senceIndex == 0) {
        self.sence.senceIndex = -1;
    }
    NSString *msg = [NSString stringWithFormat:@"%d&%@&%d&%d&%d&%lld&%lld&%d&%@",self.sence.senceIndex,self.senceName.text,self.sence.senceIcon,self.sence.senceType,self.sence.delayTime,self.sence.senceDate*1000,self.sence.senceTime*1000,self.sence.senceWeek,self.sence.senceMusic];
    
    [Tool showMyHUD:@"加载中"];
    [[Interface shareInterface:self] writeFormatDataAction:@"11"
                                                    didMsg:msg
                                               didCallBack:^(NSString *code){
                                                   
                                                   NSLog(@"code:%@",code);
                                                   
                                                   NSArray *tempArray = [code componentsSeparatedByString:@"@"];
                                                   if ([tempArray count] > 2) {
                                                       if (sence.senceIndex == -1) { //添加
                                                           [self addSenceDevice:code];
                                                       }else{
                                                           [Tool showSuccessHUD:@"修改成功"];
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                       }
                                                   }else{
                                                       if (sence.senceIndex == -1) {
                                                           [Tool showFailHUD:@"添加失败"];
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                       }else{
                                                           [Tool showFailHUD:@"修改失败"];
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                       }
                                                   }
                                                   
                                                   NSArray *array = [code componentsSeparatedByString:@"&"];
                                                   if ([array count] == 2) {
                                                       NSString *codeStatus = [array objectAtIndex:1];
                                                       
                                                       if ([codeStatus intValue] == 0) { //添加成功
                                                           
                                                            [self addSenceDevice:code];
                                                       }else if ([codeStatus intValue] == 1) //添加失败
                                                       {
                                                           [Tool showFailHUD:@"添加失败"];
                                                       }else if ([codeStatus intValue] == 3) //修改成功
                                                       {
                                                           [Tool showSuccessHUD:@"修改成功"];
                                                       }else if ([codeStatus intValue] == 2) //修改失败
                                                       {
                                                           [Tool showFailHUD:@"修改失败"];
                                                       }
                                                       [self.navigationController popViewControllerAnimated:YES];
                                                   }
    }];
}

//情景保存成功后添加情景设备
-(void) addSenceDevice:(NSString *)code
{
    NSArray *array = [code componentsSeparatedByString:@"@"];
    if ([array count] >= 2) {
        self.sence.senceIndex = [[array objectAtIndex:1] intValue];
        NSString *msg = @"";
        int i=0;
        int numberPage =  _device_list.count / 10;
        int remainder = _device_list.count % 10;
        if (remainder > 0) {
            numberPage ++;
        }
        int currentPage = 1;
        for (SenceEntity *senceEntity in _device_list) {
            if ([msg isEqualToString:@""]) {
                msg = [NSString stringWithFormat:@"%@&%d&%d&%d&%@@%d@%d@%d@%d@%d@%d@%d@%d",BOX_ID_VALUE, numberPage, currentPage, sence.senceIndex,senceEntity.entityId,senceEntity.entityLineNum,senceEntity.entityRemoteIndex,senceEntity.state,senceEntity.arcPower,senceEntity.arcMode, senceEntity.arcTemp, senceEntity.arcFan, senceEntity.arcFanMode];
            }else{
                msg = [NSString stringWithFormat:@"%@,%@@%d@%d@%d@%d@%d@%d@%d@%d",msg,senceEntity.entityId,senceEntity.entityLineNum,senceEntity.entityRemoteIndex,senceEntity.state,senceEntity.arcPower,senceEntity.arcMode, senceEntity.arcTemp, senceEntity.arcFan, senceEntity.arcFanMode];
            }
            i++;
            if (i==10 || i== _device_list.count) {
                currentPage ++;
                [[Interface shareInterface:nil] writeFormatDataAction:@"13" didMsg:msg didCallBack:^(NSString *code) {
                    if (![code isEqualToString:@"1"]) {
                        [_senceEntityProcess synchronousSenceEntity:sence didSuccess:^{
                            [self.navigationController popViewControllerAnimated:YES];
                            [self showSuccessHUD:@"添加成功"];
                        } didFail:^{
                            
                        }];
                    }
                }];
                msg = @"";
            }
        }
    }
}

-(void)cancelAction:(id)sender
{
    CGRect rect = [UIScreen mainScreen].bounds;
    self.baseTableView.scrollEnabled = YES;
    [UIView animateWithDuration:0.1
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            
                            [self.baseTableView setContentOffset:CGPointMake(0, offsetHeight)
                                                animated:YES];
                            [self.dateView setFrame:CGRectMake(0,
                                                               rect.size.height,
                                                               self.dateView.frame.size.width,
                                                               self.dateView.frame.size.height)];
                            
                        }completion:nil];
}

-(void)doneAction:(id)sender
{
    CGRect rect = [UIScreen mainScreen].bounds;
    self.baseTableView.scrollEnabled = YES;
    if (self.datePicker.datePickerMode == UIDatePickerModeDate) {
        
        self.sence.senceDate = [self getCurrentDate];
        self.sence.senceTime = [self getCurrentTime];
        
    }else if (self.datePicker.datePickerMode == UIDatePickerModeTime) {
        
        self.sence.senceTime = [self getCurrentTime];
        self.sence.senceDate = [self getCurrentDate];
    }
    
    [UIView animateWithDuration:0.1
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            
                            [self.baseTableView setContentOffset:CGPointMake(0, offsetHeight)
                                                animated:YES];
                            [self.dateView setFrame:CGRectMake(0,
                                                               rect.size.height,
                                                               self.dateView.frame.size.width,
                                                               self.dateView.frame.size.height)];
                            
                        }completion:nil];
    [self.baseTableView reloadData];
}

-(NSTimeInterval ) getCurrentTime
{
    NSTimeInterval time = [self.datePicker.date timeIntervalSince1970];
    return time;
}

-(NSTimeInterval ) getCurrentDate
{
    NSTimeInterval time = [self.datePicker.date timeIntervalSince1970];
    return time;
}

#pragma mark -
#pragma mark SenceSliderCellDelegate
-(void) sliderValueChanged:(int)index
{
    self.sence.delayTime = index;
}

#pragma mark -
#pragma mark SelectImgDelegate
-(void) selectImg:(NSString *)image
{
    self.sence.senceIcon = [image intValue];
    [self.baseTableView reloadData];
}

#pragma mark -
#pragma mark SelectWeekDelegate
-(void) SelectWeekValue:(int)week
{
    self.sence.senceWeek = week;
    [self.baseTableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
//    添加／修改
    if (self.sence.senceIndex == 0) {
        return 2;
    }
    return 3;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        if (sence.senceType == SENCE_TYPE_DELAY) {
            return 5;
        }else{
            return 7;
        }
    }else{
        return 1;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 60.0f;
    }
    return 50.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sence.senceType == SENCE_TYPE_DELAY) {
        
        if (indexPath.section == 0) {
            
            SenceNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceName"
                                                                  forIndexPath:indexPath];
            self.senceName = cell.senceName;
            self.senceName.text = self.sence.senceName;
            self.senceName.inputAccessoryView = toolbar;
            return cell;
            
        }else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                SenceImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceImg"
                                                                     forIndexPath:indexPath];
                [cell.imageView setImage:[UIImage imageNamed:[DeviceResource getDefaultImage:self.sence.senceIcon]]];
                return cell;
            }else if (indexPath.row == 1) {
             
                SenceSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceSelect" forIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                if ([self.sence.senceMusic isEqualToString:@""]) {
                    cell.textLabel.text = @"请设置情景音乐";
                }else{
                    cell.textLabel.text = self.sence.senceMusic;
                }
                return cell;
                
            }else if (indexPath.row == 2) {
                SenceSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceSwitch"
                                                                        forIndexPath:indexPath];
                cell.senceLabel.text = @"启动定时";
                self.timingStart = cell.senceSwitch;
                
                if (sence.senceType == SENCE_TYPE_DELAY) {
                    [self.timingStart setOn:NO];
                }else{
                    [self.timingStart setOn:YES];
                }
                
                return cell;
            }else if (indexPath.row == 3) {
                SenceSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceSlider"
                                                                        forIndexPath:indexPath];
                cell.delegate = self;
                [cell.filter setAnimateIndex:sence.delayTime];
                return cell;
            }else{
                SenceSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceSelect" forIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                cell.textLabel.text = [NSString stringWithFormat:@"配置情景设备(已关联%d个设备)",[_device_list count]];
                return cell;
            }
            
        }else{
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeleteCell"
                                                                    forIndexPath:indexPath];
            return cell;
            
        }
        
    }else{
        
        if (indexPath.section == 0) {
            SenceNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceName"
                                                                  forIndexPath:indexPath];
            self.senceName = cell.senceName;
            self.senceName.text = self.sence.senceName;
            self.senceName.inputAccessoryView = toolbar;
            return cell;
            
        }else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                
                SenceImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceImg"
                                                                     forIndexPath:indexPath];
                [cell.imageView setImage:[UIImage imageNamed:[DeviceResource getDefaultImage:self.sence.senceIcon]]];
                return cell;
                
            }else if (indexPath.row == 1) {
                SenceSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceSelect" forIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                if ([self.sence.senceMusic isEqualToString:@""]) {
                    cell.textLabel.text = @"请设置情景音乐";
                }else{
                    cell.textLabel.text = self.sence.senceMusic;
                }
                return cell;

            }
            else if (indexPath.row == 2){
                
                SenceSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceSwitch"
                                                                        forIndexPath:indexPath];
                cell.senceLabel.text = @"启动定时";
                self.timingStart = cell.senceSwitch;
                if (sence.senceType == SENCE_TYPE_DELAY) {
                    [self.timingStart setOn:NO];
                }else{
                    [self.timingStart setOn:YES];
                }
                return cell;
                
            }else if (indexPath.row == 3) {
                
                SenceSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceSwitch"
                                                                        forIndexPath:indexPath];
                cell.senceLabel.text = @"启动周期";
                if (!timingWeek) {
                    timingWeek = cell.senceSwitch;
                    if (self.sence.senceType == SENCE_TYPE_CYCLE) {
                        [timingWeek setOn:YES];
                    }else{
                        [timingWeek setOn:NO];
                    }
                }else{
                    cell.senceSwitch = timingWeek;
                    if (timingWeek.isOn) {
                        self.sence.senceType = SENCE_TYPE_CYCLE;
                    }else{
                        self.sence.senceType = SENCE_TYPE_TIMING;
                    }
                }
                return cell;
                
            }else  if(indexPath.row ==4){
                    
                    SenceLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceLabel"
                                                                           forIndexPath:indexPath];
                    if (self.sence.senceType == SENCE_TYPE_CYCLE) {
                        cell.senceKey.text = @"设置周";
                        cell.senceValue.text = [self.sence getWeekStr];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.senceKey.text = @"设置日期";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        NSLog(@"%ld",self.sence.senceDate);
                        cell.senceValue.text = [Tool  getDateForTimeIntervale:self.sence.senceDate];
                    }
                    
                    return cell;
            }else if (indexPath.row == 5) {
                    SenceLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceLabel"
                                                                           forIndexPath:indexPath];
                    cell.senceKey.text = @"设置时间";
                    cell.senceValue.text = [Tool getTimeForTimeIntervale:self.sence.senceTime];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
            }else{
                SenceSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceSelect" forIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                cell.textLabel.text = [NSString stringWithFormat:@"配置情景设备(已关联%d个设备)",[_device_list count]];
                return cell;
            }
        }else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeleteCell"
                                                                    forIndexPath:indexPath];
            return cell;
        }
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.baseTableView reloadData];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"selectImg" sender:nil];
        }else if (indexPath.row == 1){
            [self performSegueWithIdentifier:@"SelectMusicIdentifier" sender:nil];
        }else if (indexPath.row == 4) {
            if (self.sence.senceType == SENCE_TYPE_DELAY) {
                [self performSegueWithIdentifier:@"EditSenceDevice" sender:nil];
            }else if(self.sence.senceType == SENCE_TYPE_TIMING){
                
                self.datePicker.datePickerMode = UIDatePickerModeDate;
                [UIView animateWithDuration:0.2
                                      delay:0.2
                                    options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                        self.baseTableView.scrollEnabled = NO;
                                        
                                        CGRect rect = [UIScreen mainScreen].bounds;
                                        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                        int height = cell.frame.origin.y + cell.frame.size.height - self.baseTableView.contentOffset.y;
                                        int offY = rect.size.height - self.dateView.frame.size.height;
                                        
                                        if (offY < height) {
                                            offsetHeight = self.baseTableView.contentOffset.y;
                                            [self.baseTableView setContentOffset:CGPointMake(0, self.baseTableView.contentOffset.y - offY + height) animated:YES];
                                        }else{
                                            offsetHeight = self.baseTableView.contentOffset.y;
                                        }
                                        [self.dateView setFrame:CGRectMake(0,
                                                                           rect.size.height - self.dateView.frame.size.height,
                                                                           self.dateView.frame.size.width,
                                                                           self.dateView.frame.size.height)];
                                        
                                    }completion:nil];

            }else{
                [self performSegueWithIdentifier:@"SelectWeek" sender:nil];
            }
        }else if (indexPath.row == 5) {
            self.datePicker.datePickerMode = UIDatePickerModeTime;
            
            [UIView animateWithDuration:0.2
                                  delay:0.2
                                options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                    self.baseTableView.scrollEnabled = NO;
                                    
                                    CGRect rect = [UIScreen mainScreen].bounds;
                                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                    int height = cell.frame.origin.y + cell.frame.size.height - self.baseTableView.contentOffset.y;
                                    int offY = rect.size.height - self.dateView.frame.size.height;
                                    
                                    if (offY < height) {
                                        offsetHeight = self.baseTableView.contentOffset.y;
                                        [self.baseTableView setContentOffset:CGPointMake(0, self.baseTableView.contentOffset.y - offY + height) animated:YES];
                                    }else{
                                        offsetHeight = self.baseTableView.contentOffset.y;
                                    }
                                    [self.dateView setFrame:CGRectMake(0,
                                                                       rect.size.height - self.dateView.frame.size.height,
                                                                       self.dateView.frame.size.width,
                                                                       self.dateView.frame.size.height)];
                                }completion:nil];
        }else if(indexPath.row == 6) {
            [self performSegueWithIdentifier:@"EditSenceDevice" sender:nil];
        }
    }
    if (indexPath.section == 2) {
        if ([self checkConnectionStatus]) {
            return;
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"删除情景"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [sheet showInView:self.view];
    }
}

#pragma mark UIActionSheet
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *msg = [NSString stringWithFormat:@"%@&%d",BOX_ID_VALUE,self.sence.senceIndex];
        
        [Tool showMyHUD:@"删除中"];
        [[Interface shareInterface:self] writeFormatDataAction:@"12" didMsg:msg didCallBack:^(NSString *code){
            [Tool showSuccessHUD:@"删除成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"selectImg"]) {
        
        UINavigationController *nav = segue.destinationViewController;
        SelectImgViewController *selectImg = [[nav viewControllers] objectAtIndex:0];
        selectImg.type = _SENCEICON;
        selectImg.delegate = self;
        
    }else if ([segue.identifier isEqualToString:@"SelectWeek"]) {
        
        UINavigationController *nav = segue.destinationViewController;
        SelectWeekTableViewController *week = [[nav viewControllers] objectAtIndex:0];
        week.delegate = self;
        week.week = self.sence.senceWeek;
    }else if ([segue.identifier isEqualToString:@"EditSenceDevice"]) {
        
        SenceDeviceViewController *senceDevice = segue.destinationViewController;
        senceDevice.selectDevice_list = _device_list;
        senceDevice.senceDelegate = self;
        senceDevice.sence = self.sence;
        
    }else if ([segue.identifier isEqualToString:@"SelectMusicIdentifier"]){
        MSelectMusicViewController *selectMusic = segue.destinationViewController;
        selectMusic.sence = self.sence;
        [self.baseTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
