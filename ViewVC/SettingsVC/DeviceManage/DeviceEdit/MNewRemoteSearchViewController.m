//
//  MNewRemoteSearchViewController.m
//  Home
//
//  Created by 刘军林 on 15/8/19.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MNewRemoteSearchViewController.h"
#import "MNewDeviceType.h"
#import "MNewBrand.h"
#import "Interface.h"
#import "MNewRemotePreviewViewController.h"

@interface MNewRemoteSearchViewController ()

@property (nonatomic, weak) IBOutlet UILabel *remoteType;
@property (nonatomic, weak) IBOutlet UILabel *remoteBrand;

@property (nonatomic, weak) IBOutlet UIButton *searchBut;
@property (nonatomic, weak) IBOutlet UIButton *lastBut;
@property (nonatomic, weak) IBOutlet UIButton *nextBut;
@property (nonatomic, weak) IBOutlet UIButton *previewBut;

@property (nonatomic, weak) IBOutlet UITextField *serialNumber;

@end

@implementation MNewRemoteSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _remoteType.text = _deviceType.name_ch;
    _remoteBrand.text = _brand.brand_ch;
    
    // Do any additional setup after loading the view.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Interface shareInterface:nil] writeFormatDataAction:@"37" didMsg:@"" didCallBack:^(NSString *code) {
    }];
}

#pragma action
-(IBAction)p_searchAction:(id)sender
{
    UIButton *but = (UIButton *)sender;
    but.selected = !but.selected;
    
    if (but.selected) {
        _lastBut.enabled = NO;
        _nextBut.enabled = NO;
        _previewBut.enabled = NO;
        
        [but setTitle:@"停止搜索" forState:UIControlStateNormal];
        [but setTitle:@"停止搜索" forState:UIControlStateHighlighted];
        [but setTitle:@"停止搜索" forState:UIControlStateSelected];
        
        NSString *msg = [NSString stringWithFormat:@"%@&%@&%@",_entityId,_deviceType.control_type,_brand.brand_ch];
        [[Interface shareInterface:nil] writeFormatDataAction:@"36" didMsg:msg didCallBack:^(NSString *code) {
            NSLog(@"code:%@",code);
            if ([code intValue] == 2) {
                [MTopWarnView addTopWarnText:@"当前系统正在匹配，请稍候再试!" view:self.view];
                _lastBut.enabled = YES;
                _nextBut.enabled = YES;
                _previewBut.enabled = YES;
                
                but.selected = NO;
                
                [but setTitle:@"开始搜索" forState:UIControlStateNormal];
                [but setTitle:@"开始搜索" forState:UIControlStateHighlighted];
                [but setTitle:@"开始搜索" forState:UIControlStateSelected];
                return ;
            }
            NSArray *array = [code componentsSeparatedByString:@"&"];
            NSString *number = [array objectAtIndex:[array count]-1];
            if (![number isEqualToString:@"END"]) {
                _serialNumber.text = number;
            }
            [[Interface shareInterface:nil] writeFormatDataAction:@"38" didMsg:@"" didCallBack:^(NSString *code) {
            }];
        }];
    }else{
        _lastBut.enabled = YES;
        _nextBut.enabled = YES;
        _previewBut.enabled = YES;
        
        [but setTitle:@"开始搜索" forState:UIControlStateNormal];
        [but setTitle:@"开始搜索" forState:UIControlStateHighlighted];
        [but setTitle:@"开始搜索" forState:UIControlStateSelected];
        
        [[Interface shareInterface:nil] writeFormatDataAction:@"37" didMsg:@"" didCallBack:^(NSString *code) {
        }];
    }
}

-(IBAction)p_lastAction:(id)sender
{
    if ([_serialNumber.text intValue] >0) {
        _serialNumber.text = [NSString stringWithFormat:@"%d",[_serialNumber.text intValue] - 1];
    }
    NSString *msg = [NSString stringWithFormat:@"%@&%@&%@&0&%@&%d&%d&%d&%d&%d&%d&0&0&0&0&0",_entityId,_deviceType.control_type,_brand.brand_ch,_serialNumber.text,1,0,0,26,0,0];
    [[Interface shareInterface:nil] writeFormatDataAction:@"39" didMsg:msg didCallBack:^(NSString *code) {
        
    }];
}

-(IBAction)p_nextAction:(id)sender
{
    if ([_serialNumber.text intValue] >=0) {
        _serialNumber.text = [NSString stringWithFormat:@"%d",[_serialNumber.text intValue] + 1];
    }
    NSString *msg = [NSString stringWithFormat:@"%@&%@&%@&0&%@&%d&%d&%d&%d&%d&%d&0&0&0&0&0",_entityId,_deviceType.control_type,_brand.brand_ch,_serialNumber.text,1,0,0,26,0,0];
    [[Interface shareInterface:nil] writeFormatDataAction:@"39" didMsg:msg didCallBack:^(NSString *code) {
        
    }];
}

-(IBAction)p_previewAction:(id)sender
{
    [self performSegueWithIdentifier:@"MNewPreviewIdentifier" sender:nil];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MNewPreviewIdentifier"]) {
        MNewRemotePreviewViewController *remotePreview = segue.destinationViewController;
        remotePreview.entityId = _entityId;
        remotePreview.deviceType = _deviceType;
        remotePreview.brand = _brand;
        remotePreview.brandGroupIndex = _serialNumber.text;
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
