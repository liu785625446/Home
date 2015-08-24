//
//  MSenceViewController.m
//  Home
//
//  Created by 刘军林 on 15/4/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MSenceViewController.h"
#import "MSenceCell.h"
#import "MSenceStartCell.h"
#import "SenceProcess.h"
#import "Sence.h"
#import "Interface.h"
#import "Tool.h"

@interface MSenceViewController ()

@property (nonatomic, strong) SenceProcess *senceProcess;

//当前展开启动row
@property (nonatomic, assign) NSInteger currentStartRow;

@property (nonatomic, assign) BOOL tapTimer;

@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) NSString *playMusicName;

@end

@implementation MSenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _senceProcess = [[SenceProcess alloc] init];
    _currentStartRow = -1;
    _playMusicName = @"";
    [[Interface shareInterface:nil] setSenceMusiceBlock:^(NSString *code) {
        NSLog(@"code");
        NSArray *array = [code componentsSeparatedByString:@"&"];
        if ([array count] == 3) {
            if ([[array objectAtIndex:1] intValue] == 0) {
                _isPlay = YES;
                _playMusicName = [array objectAtIndex:2];
            }else{
                _isPlay = NO;
            }
        }else{
            _isPlay = NO;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.baseTableView reloadData];
        });
    }];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.title = @"情景";
    [self synSenceData];
}

#pragma mark Action
-(void) synSenceData
{
    self.baseArray = [_senceProcess findAllSence];
    _currentStartRow = -1;
    [self.baseTableView reloadData];
    [_senceProcess synchronousSence:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.baseArray = [_senceProcess findAllSence];
            _currentStartRow = -1;
            [self.baseTableView reloadData];
        });
    } didFail:^{
        
    }];
}

-(IBAction)senceMusicStopAction:(id)sender
{
    [[Interface shareInterface:nil] writeFormatDataAction:@"26" didMsg:@"" didCallBack:^(NSString *code) {
        
    }];
}

-(IBAction) senceStartAction:(id)sender
{
    UIButton *but = (UIButton *)sender;
    
    if ([self checkConnectionStatus]) {
        return;
    }
    [Tool buttonAnimationImgAction:but didView:[but superview]];
    
    Sence *sence = [self.baseArray objectAtIndex:but.tag-1];
    NSString *msg = [NSString stringWithFormat:@"%d",sence.senceIndex];
    [[Interface  shareInterface:self] writeFormatDataAction:@"15"
                                                    didMsg:msg
                                               didCallBack:^(NSString *code){
                                                   NSArray *array = [code componentsSeparatedByString:@"&"];
                                                   if ([array count] > 0) {
                                                       NSString *codeStatus = [array objectAtIndex:0];
                                                       if ([codeStatus intValue] == 0) {
                                                           [self.baseTableView makeToast:S_SENCE_START_SUCCESS];
                                                       }else if ([codeStatus intValue] == 1) {
                                                           [self.baseTableView makeToast:S_SENCE_START_FAIL];
                                                       }else if ([codeStatus intValue] == 2) {
                                                           [self.baseTableView makeToast:S_SENCE_START_SUCCESS_DELAYING];
                                                       }else if ([codeStatus intValue] == 3) {
                                                           [self.baseTableView makeToast:S_DELAY_START_FAIL];
                                                       }else if ([codeStatus intValue] == 4) {
                                                           [self.baseTableView makeToast:S_LAST_TIME_DELAY_NO_COMPLETE];
                                                       }
                                                   }
                                               }];
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isPlay) {
        return 2;
    }else{
        return 1;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isPlay) {
        if (section == 0) {
            return 1;
        }
    }
    return [self.baseArray count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isPlay) {
        if (indexPath.section == 0) {
            return 60.0f;
        }
    }
    if (indexPath.row == _currentStartRow) {
//        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
        return 100.0f;
        
    }else{
        return 80.0f;
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isPlay) {
        if (indexPath.section == 0) {
            MSenceMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMusicIdentifier" forIndexPath:indexPath];
            cell.senceMusic.text = _playMusicName;
            
//            [cell.senceMusic sizeToFit];
//            cell.senceMusic.clipsToBounds = YES;
//            CGRect frame = cell.senceMusic.frame;
//            frame.origin.x = 50;
//            cell.senceMusic.frame = frame;
//            [UIView beginAnimations:@"testAnimation" context:NULL];
//            [UIView setAnimationDuration:5];
//            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//            [UIView setAnimationDelegate:self];
//            [UIView setAnimationRepeatAutoreverses:NO];
//            [UIView setAnimationRepeatCount:999999];
//            frame = cell.senceMusic.frame;
//            frame.origin.x = -frame.size.width;
//            cell.senceMusic.frame = frame;
//            [UIView commitAnimations];
            return cell;
        }
    }
    if (indexPath.row != _currentStartRow) {
        MSenceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSenceIdentifier" forIndexPath:indexPath];
        Sence *sence = [self.baseArray objectAtIndex:indexPath.row];
        if (indexPath.row + 1 == _currentStartRow) {
            cell.separatorInset = UIEdgeInsetsMake(0, cell.frame.size.width, 0, 0);
            cell.upImg.hidden = NO;
        }else{
            cell.separatorInset = tableView.separatorInset;
            cell.upImg.hidden = YES;
        }
        [cell setSence:sence];
        return cell;
    }else{
        MSenceStartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSenceSwitchIdentifier" forIndexPath:indexPath];
        cell.startBut.tag = indexPath.row;
        cell.separatorInset = UIEdgeInsetsMake(0, cell.frame.size.width, 0, 0);
        return cell;
    }
}

-(void ) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isPlay) {
        if (indexPath.section == 0) {
            return;
        }
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self selectSwitchAction:tableView IndexPath:indexPath];
}

-(void) selectSwitchAction:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    if (_tapTimer) { //点击响应时间
        return;
    }
    if (indexPath.row + 1 == _currentStartRow) { //收起start
        [self.baseArray removeObjectAtIndex:_currentStartRow];
        _currentStartRow = -1;
//        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
    }else{
        
        if (_currentStartRow > 0) {
            NSInteger temp = _currentStartRow;
            [self.baseArray removeObjectAtIndex:_currentStartRow];
            _currentStartRow = -1;
//            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:temp inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
            
            if (temp > indexPath.row) {
                _currentStartRow = indexPath.row + 1;
            }else{
                _currentStartRow = indexPath.row;
            }
            _tapTimer = YES;
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.baseArray insertObject:@"" atIndex:_currentStartRow];
//                [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_currentStartRow inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
                _tapTimer = NO;
//            });
        }else {
            _currentStartRow = indexPath.row + 1;
            [self.baseArray insertObject:@"" atIndex:_currentStartRow];
//            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_currentStartRow inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
