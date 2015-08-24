//
//  AddDeviceViewController.m
//  Home
//
//  Created by 刘军林 on 14-7-17.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "AddDeviceCollCell.h"
#import "config.h"
#import "Interface.h"
#import "AddDeviceStep1ViewController.h"
#import "APAddDeviceViewController.h"
#import "EntityProcess.h"

@interface AddDeviceViewController ()

@property (nonatomic, strong) EntityProcess *entityProcess;

@end

@implementation AddDeviceViewController

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
    imgList = @[@"icon_kaiguan1.png",@"icon_kaiguan1.png",@"icon_kaiguan1.png",@"icon_chazuo3.png",@"icon_yaokong_hongwai.png",@"icon_chuanglianmianban.png",@"icon_hongwai.png",@"icon_mengci.png",@"icon_yanggang.png"];
    typeList = @[@"一路面板开关",@"二路面板开关",@"三路面板开关",@"智能插座",@"红外遥控",@"窗帘面板开关",@"红外微波探测器",@"门磁报警器",@"烟感探测器"];
    _entityProcess = [[EntityProcess alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UICollectionViewDelegate
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [imgList count];
}

-(CGSize ) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int width = collectionView.frame.size.width / 3;
    return CGSizeMake(width, width);
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"DeviceCollCell"];
    
    AddDeviceCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.index = indexPath.row;
    NSString *img = [imgList objectAtIndex:indexPath.row];
    [cell.deviceImg setImage:[UIImage imageNamed:img]];
    
    NSString *type = [typeList objectAtIndex:indexPath.row];
    cell.deviceType.text = type;
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        _deviceType = PANEL_SWITCH_1;
    }else if (indexPath.row == 1) {
        _deviceType = PANEL_SWITCH_2;
    }
    else if (indexPath.row == 2) {
        _deviceType = PANEL_SWITCH_3;
    }else if (indexPath.row == 3) {
        _deviceType = SOCKET_SWITCH;
    }else if (indexPath.row == 4) {
        _deviceType = REMOTE_INFRARED;
    }else if (indexPath.row == 5) {
        _deviceType = CURTAIN_SWITCH;
    }else if (indexPath.row == 6) {
        _deviceType = INFRARED_PROBE;
    }else if (indexPath.row == 7) {
        _deviceType = MAGNETIC;
    }else if (indexPath.row == 8){
        _deviceType = SMKEN;
    }
    
    if ([[_entityProcess findAPEntity] count] > 0) {
        [self performSegueWithIdentifier:@"APAddDevice" sender:nil];
    }else{
        [self performSegueWithIdentifier:@"Step" sender:nil];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Step"]) {
        AddDeviceStep1ViewController *step = segue.destinationViewController;
        step.deviceType = _deviceType;
        step.settingDelegate = _settingsDelegate;
        step.entityType = @"0";
    }else if ([segue.identifier isEqualToString:@"APAddDevice"]) {
        APAddDeviceViewController *apAddDevice = segue.destinationViewController;
        apAddDevice.deviceType = _deviceType;
        apAddDevice.settingDelegate = _settingsDelegate;
        apAddDevice.apList = [_entityProcess findAPEntity];
    }
}

@end
