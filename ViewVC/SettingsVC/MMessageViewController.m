//
//  MMessageViewController.m
//  Home
//
//  Created by 刘军林 on 15/6/5.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MMessageViewController.h"
#import "AlarmInfos.h"
#import "AlarmInfosProcess.h"
#import "MMessageCell.h"

@interface MMessageViewController ()

@property (nonatomic, strong) AlarmInfosProcess *alarmInfosProcess;

@end

@implementation MMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _alarmInfosProcess = [[AlarmInfosProcess alloc] init];
    [self.baseTableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self synAlarmInfosData];
    // Do any additional setup after loading the view.
}

#pragma mark Action
-(void) synAlarmInfosData
{
    self.baseArray = [_alarmInfosProcess findUnReadAlarmInfos];
    [self.baseTableView reloadData];
    [_alarmInfosProcess synchronousAlarmInfos:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.baseArray = [_alarmInfosProcess findUnReadAlarmInfos];
            [self.baseTableView reloadData];
        });
    } didFail:^{
        
    }];
}

-(IBAction)doneAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)cleanAllMessage:(id)sender
{
    [_alarmInfosProcess logoReadAlarmInfos];
    [self synAlarmInfosData];
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.baseArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMessageIdentifier" forIndexPath:indexPath];
    AlarmInfos *alarmInfos = [self.baseArray objectAtIndex:indexPath.row];
    [cell setAlarmInfo:alarmInfos];
    return cell;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AlarmInfos *alarmInfos = [self.baseArray objectAtIndex:indexPath.row];
        [_alarmInfosProcess logoReadAlarmInfosForId:alarmInfos.alarmIndex];
        [self.baseArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.baseTableView reloadData];
    }
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
