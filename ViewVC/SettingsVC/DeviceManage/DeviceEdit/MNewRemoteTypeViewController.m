//
//  MNewRemoteTypeViewController.m
//  Home
//
//  Created by 刘军林 on 15/8/7.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MNewRemoteTypeViewController.h"
#import "FMDatabase.h"
#import "MNewDeviceType.h"
#import "MNewRemoteBrandViewController.h"

@interface MNewRemoteTypeViewController ()

@property (nonatomic, strong) NSMutableArray *deviceList;

@end

@implementation MNewRemoteTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _deviceList = [[NSMutableArray alloc] initWithCapacity:0];
    [self.baseTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self p_loadDatabaseDevice];
    // Do any additional setup after loading the view.
}

-(void) p_loadDatabaseDevice
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"remote_data.db" ofType:nil];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        
        if (![db open]) {
            NSLog(@"新版红外遥控信息数据库打开失败！");
        }else {
            NSLog(@"新版红外遥控信息数据库打开成功!");
            
            NSString *sql = @"select * from control_type";
            FMResultSet *set = [db executeQuery:sql];
            while ([set next]) {
                MNewDeviceType *device = [[MNewDeviceType alloc] init];
                [_deviceList addObject:[device objectForSet:set]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.baseTableView reloadData];
            });
        }
    });
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_deviceList count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    
    MNewDeviceType *deviceType = [_deviceList objectAtIndex:indexPath.row];
    cell.textLabel.text = deviceType.name_ch;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"MNewBrandTypeIdentifier" sender:indexPath];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    if ([segue.identifier isEqualToString:@"MNewBrandTypeIdentifier"]) {
        MNewRemoteBrandViewController *remoteBrand = segue.destinationViewController;
        remoteBrand.deviceType = [_deviceList objectAtIndex:indexPath.row];
        remoteBrand.entityId = _entityId;
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
