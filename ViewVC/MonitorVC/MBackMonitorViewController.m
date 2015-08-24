//
//  MBackMonitorViewController.m
//  Home
//
//  Created by 刘军林 on 15/6/18.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBackMonitorViewController.h"
#import "MJRefresh.h"
#import "MonitorVideo.h"

#define PAGESIZE 50

@interface MBackMonitorViewController ()<MonitorVideoDelegate>
{
    MJRefreshFooterView *footer;
}

@property (nonatomic, strong) MonitorVideo *monitor;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) MJRefreshBaseView *mjBaseView;

@end

@implementation MBackMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 0;
    _monitor = [MonitorVideo shareMonitorVideo];
    _monitor.audioBut.hidden = YES;
    _monitor.reversalBut.hidden = YES;
    _monitor.isPanges = NO;
    _currentIndex = -1;
    _monitor.delegate = self;
    _topConstraint.constant = 64.f;
    _window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self showMyHUD:@"加载中"];
    self.baseArray = [[NSMutableArray alloc] initWithCapacity:0];
    [_monitor searchSDRecordFileList:_camerainfos.cameraNum pageIndex:_pageIndex++ pageSize:PAGESIZE];
    
    [self addRefreshHeadView];
    // Do any additional setup after loading the view.
}

-(void) addRefreshHeadView
{
    footer = [MJRefreshFooterView footer];
    footer.scrollView = self.baseTableView;
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        _mjBaseView = refreshView;
        [_monitor searchSDRecordFileList:_camerainfos.cameraNum pageIndex:_pageIndex++ pageSize:PAGESIZE];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshView endRefreshing];
            [self.baseTableView reloadData];
        });
    };
}

-(NSString *)getTimeFormatStr:(NSString *)strTime
{
    NSRange range = NSMakeRange(0, 14);
    NSMutableString *subTime = [NSMutableString stringWithString:[strTime substringWithRange:range]];
    
    [subTime insertString:@"-" atIndex:4];
    [subTime insertString:@"-" atIndex:7];
    [subTime insertString:@" " atIndex:10];
    [subTime insertString:@":" atIndex:13];
    [subTime insertString:@":" atIndex:16];
    
    return subTime;
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.baseArray count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self getTimeFormatStr:[self.baseArray objectAtIndex:indexPath.row]];
    if (_currentIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *recordFile = [self.baseArray objectAtIndex:indexPath.row];
    _currentIndex = indexPath.row;
    [self.baseTableView reloadData];
    [_monitor openBackPlayMonitor:_camerainfos.cameraNum RecordFile:recordFile];
}

#pragma mark -
#pragma mark MonitorVideoDelegate
-(void) searchSDCardRecordFileList:(NSMutableArray *)recordList
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([recordList count] > 0) {
            [self hideMyHUD];
            [self.baseArray addObjectsFromArray:recordList];
            [_mjBaseView endRefreshing];
            [self.baseTableView reloadData];
        }else{
            [self.baseTableView reloadData];
            [_mjBaseView endRefreshing];
        }
    });
}

-(void) openBackPlayAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _topConstraint.constant = [self getMonitorHeight];
        self.baseTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //    [[NSNotificationCenter defaultCenter] postNotificationName:MONITOR_OPEN_NOTIFIER object:nil];
        [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar];
        _monitor.backgroundColor = [UIColor blackColor];
        
        if (_monitor.isOpenMonitor) {
            [_monitor removeFromSuperview];
            [_window addSubview:_monitor];
            
            _monitor.monitorTop = [NSLayoutConstraint constraintWithItem:_monitor attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_window attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
            [_window addConstraint:_monitor.monitorTop];
            
            _monitor.monitorLeft = [NSLayoutConstraint constraintWithItem:_monitor attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_window attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.f];
            [_window addConstraint:_monitor.monitorLeft];
        }
    });
}

-(void) doubleTapAction
{
    float startX1 = (self.baseRect.size.height - self.baseRect.size.width) / 2;
    if (_monitor.frame.size.height > [self getMonitorHeight] + 5) { //横屏切竖屏
        if (_monitor.frame.size.height != [self getMonitorHeight]) {
            _monitor.transform = CGAffineTransformMakeRotation(0);
            _monitor.closeBut.hidden = NO;
            
            _monitor.monitorHeight.constant = [self getMonitorHeight];
            _monitor.monitorTop.constant = 0;
            _monitor.monitorLeft.constant = 0;
            _monitor.monitorRight.constant = self.baseRect.size.width;
        }
    }else{
        
        _monitor.transform = CGAffineTransformMakeRotation(M_PI / 2);
        _monitor.closeBut.hidden = YES;
        
        _monitor.monitorHeight.constant = self.baseRect.size.width;
        _monitor.monitorRight.constant = self.baseRect.size.height;
        if([Tool getVersion] >= 8.0)
        {
            _monitor.monitorTop.constant = startX1;
            _monitor.monitorLeft.constant = -startX1;
        }else{
            _monitor.monitorTop.constant = 0;
            _monitor.monitorLeft.constant = 0;
        }
    }
}

-(void) closeMonitorAction
{
    self.topConstraint.constant = 64;
    _currentIndex = -1;
//    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [_window setWindowLevel:UIWindowLevelNormal];
    [_monitor removeFromSuperview];
    [self.baseTableView reloadData];
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
