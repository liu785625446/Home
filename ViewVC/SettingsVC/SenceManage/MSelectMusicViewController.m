//
//  MSelectMusicViewController.m
//  Home
//
//  Created by 刘军林 on 15/7/7.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MSelectMusicViewController.h"
#import "Interface.h"
#import "MJRefresh.h"

@interface MSelectMusicViewController ()

@property (nonatomic, assign) NSInteger page;

@end

@implementation MSelectMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    NSString *musicPage = [NSString stringWithFormat:@"%d",_page ++];
    [[Interface shareInterface:nil] writeFormatDataAction:@"33" didMsg:musicPage didCallBack:^(NSString *code) {
        
        NSArray *array = [code componentsSeparatedByString:@"&"];
        if ([array count] >= 3) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i=2 ; i<[array count]-1; i++) {
                [arr addObject:[array objectAtIndex:i]];
            }
            [self.baseArray addObjectsFromArray:arr];
            [self.baseTableView reloadData];
        }
    }];
    
    [self.baseTableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    MJRefreshFooterView *header = [MJRefreshFooterView footer];
    header.scrollView = self.baseTableView;
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        NSString *musicPage = [NSString stringWithFormat:@"%d",_page ++];
        [[Interface shareInterface:nil] writeFormatDataAction:@"33" didMsg:musicPage didCallBack:^(NSString *code) {
            NSArray *array = [code componentsSeparatedByString:@"&"];
            if ([array count] >= 3) {
                NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
                for (int i=2 ; i<[array count]-1; i++) {
                    [arr addObject:[array objectAtIndex:i]];
                }
                [self.baseArray addObjectsFromArray:arr];
                [self.baseTableView reloadData];
                [refreshView endRefreshing];
            }else{
                [self.baseTableView reloadData];
                [refreshView endRefreshing];
            }
        }];
    };

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.baseArray count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.textLabel.text = [self.baseArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    if ([cell.textLabel.text isEqualToString:_sence.senceMusic]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _sence.senceMusic = [self.baseArray objectAtIndex:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
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
