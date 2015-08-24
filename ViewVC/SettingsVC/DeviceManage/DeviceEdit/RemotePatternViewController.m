//
//  RemotePatternViewController.m
//  Home
//
//  Created by 刘军林 on 14-7-31.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "RemotePatternViewController.h"
#import "RemoteTypeCell.h"
#import "Interface.h"
#import "Tool.h"
#import "Toast+UIView.h"
#import "EntityProcess.h"
#import "EntityRemoteProcess.h"
#import "RemoteAddSuccessViewController.h"

@interface RemotePatternViewController ()

@end

@implementation RemotePatternViewController

@synthesize patternAmount;
@synthesize collection;
@synthesize remoteType;
@synthesize remoteBrandIndex;
@synthesize remoteName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _entityProcess = [[EntityProcess alloc] init];
    _entityRemoteProcess = [[EntityRemoteProcess alloc] init];
    
    self.title = [NSString stringWithFormat:@"%@匹配",remoteName];
    _remoteGroupIndex = -1;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Action
-(IBAction)addRemoteAction:(id)sender
{
    if (_remoteGroupIndex < 0) {
        [self.view makeToast:[NSString stringWithFormat:@"请选择码组值!"]];
        return;
    }
    
    int iconIndex;
    
//    红外设备图标
    if (self.remoteType == 0) {
        iconIndex = 47;
    }else if (self.remoteType == 1) {
        iconIndex = 17;
    }else if (self.remoteType == 2) {
        iconIndex = 46;
    }else{
        iconIndex = 0;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%@&%d&%@&%d&%d&%d&%@&%@",_entity_id,self.remoteType,self.remoteName,self.remoteGroupIndex,self.remoteBrandIndex,iconIndex,@"test",@"1"];
    
    NSLog(@"msg:%@",msg);
    
    [self showMyHUD:@"加载中"];
    [[Interface shareInterface:self] writeFormatDataAction:@"8"
                                                    didMsg:msg
                                               didCallBack:^(NSString *code){
                                                   
                                                   NSLog(@"code:%@",code);
                                                   NSArray *tempArray = [code componentsSeparatedByString:@","];
                                                   if ([tempArray count] == 2) {
                                                       [self showSuccessHUD:@"添加成功"];
                                                       NSString *entityStr = [tempArray objectAtIndex:0];
                                                       NSString *entityRemoteStr = [tempArray objectAtIndex:1];
                                                       [_entityProcess addEntityForStr:entityStr];
                                                       [_entityRemoteProcess addEntityRemote:entityRemoteStr];
                                                       [self performSegueWithIdentifier:@"AddSuccess" sender:nil];
                                                   }
    }];
}

#pragma mark -
#pragma mark UICollectionViewController
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [patternAmount intValue];
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
    RemotePatternCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RemotePatternCell" forIndexPath:indexPath];
    
    cell.index = indexPath.row;
    cell.pattern.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.remoteGroupIndex = indexPath.row;
    
    NSString *msg = [NSString stringWithFormat:@"%@&%d&%d&%d&%d&%d&%d&%d&%d&%d",_entity_id,self.remoteType,self.remoteBrandIndex,self.remoteGroupIndex,1,0,0,26,0,0];
    NSLog(@"msg:%@",msg);
    [[Interface shareInterface:self] writeFormatDataAction:@"9" didMsg:msg didCallBack:^(NSString *code){
    
    }];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddSuccess"]) {
        RemoteAddSuccessViewController *success = (RemoteAddSuccessViewController *)segue.destinationViewController;
        success.deviceEditDelegate = _deviceEditDelegate;
        success.devicemanageDelegate = _deviceManageDelegate;
    }
}

@end
