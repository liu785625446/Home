//
//  MNewRemotePreviewViewController.m
//  Home
//
//  Created by 刘军林 on 15/8/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MNewRemotePreviewViewController.h"
#import "MNewDeviceType.h"
#import "MDeviceAirView.h"
#import "MNewBrand.h"

@interface MNewRemotePreviewViewController ()

@end

@implementation MNewRemotePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MDeviceAirView *deviceAirView = [[[NSBundle mainBundle] loadNibNamed:@"MDeviceAirView" owner:self options:nil] objectAtIndex:0];
    deviceAirView.entityId = _entityId;
    deviceAirView.deviceType = _deviceType.control_type;
    deviceAirView.brand = _brand.brand_ch;
    deviceAirView.brandGroupIndex = _brandGroupIndex;
    [_backView addSubview:deviceAirView];
    // Do any additional setup after loading the view.
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
