//
//  MBaseTableViewController.m
//  Home
//
//  Created by 刘军林 on 15/4/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseTableViewController.h"
#import "MonitorVideo.h"
#import "Interface.h"

@implementation MBaseTableViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.baseArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.baseTableView setSeparatorInset:UIEdgeInsetsMake(0, 75, 0, 0)];
}

-(BOOL) checkConnectionStatus
{
    if (![Interface shareInterface:nil].isConnection) {
        [MTopWarnView addTopWarnText:S_NETWORK_NO_DETECT_NETWORK_SETTINGS view:self.baseTableView];
        return YES;
    }else{
        return NO;
    }
}

//-(CGFloat) getMonitorHeight
//{
//    return 0.f;
//}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat ) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
