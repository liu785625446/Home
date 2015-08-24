//
//  MMessageViewController.m
//  Home
//
//  Created by 刘军林 on 15/4/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MRemoteViewController.h"
#import "AlarmInfos.h"
#import "AlarmInfosProcess.h"
#import "MMessageCell.h"
#import "MDeviceRemoteCell.h"

@interface MRemoteViewController ()

@property (nonatomic, strong) AlarmInfosProcess *alarmInfosProcess;

@end

@implementation MRemoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.title = @"遥控";
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 440.0f;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identy = @"MDeviceRemoteIdentifier";
    MDeviceRemoteCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:@"MDeviceRemoteCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identy];
        cell = [tableView dequeueReusableCellWithIdentifier:identy];
    }
    
    return cell;
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
