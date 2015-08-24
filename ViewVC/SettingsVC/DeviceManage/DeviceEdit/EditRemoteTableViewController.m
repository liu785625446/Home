//
//  EditRemoteTableViewController.m
//  Home
//
//  Created by 刘军林 on 14-8-7.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EditRemoteTableViewController.h"
#import "EntityRemote.h"
#import "DeviceResource.h"
#import "Interface.h"
#import "Tool.h"
#import "EditDeviceCell.h"
#import "SelectImgViewController.h"
#import "ImageList.h"
#import "EntityRemoteProcess.h"
#import "EntityProcess.h"
#import "MRoomSelectViewController.h"

@interface EditRemoteTableViewController ()

@end

@implementation EditRemoteTableViewController

@synthesize entityRemote;

@synthesize remoteImg;
@synthesize remoteName;
@synthesize editRemoteName;

@synthesize deleteRemoteBut;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _entityRemoteProcess = [[EntityRemoteProcess alloc] init];
    _entityProcess = [[EntityProcess alloc] init];
    
    [self.editRemoteName setImage:[UIImage imageNamed:@"icon_editorsave.png"]
                         forState:UIControlStateSelected];
    self.remoteName.text = entityRemote.entityRemoteName;
    
    UIToolbar *tool= [[UIToolbar alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 self.view.bounds.size.width,
                                                                 38.0f)];
    tool.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(resignkeyBoard)];
    [doneBarItem setTintColor:[UIColor grayColor]];
    [tool setItems:[NSArray arrayWithObjects:spaceBarItem, doneBarItem, nil]];

    
    self.remoteName.inputAccessoryView = tool;
    [self.remoteImg setImage:[UIImage imageNamed:[DeviceResource getDefaultImage:entityRemote.entityRemoteIcon]]];
    
    NSString *plistPat = @"";
    if (entityRemote.brandType == 0) {
        plistPat = [[NSBundle mainBundle] pathForResource:@"TVBrand" ofType:@"plist"];
    }else if (entityRemote.brandType == 1) {
        plistPat = [[NSBundle mainBundle] pathForResource:@"AirBrand" ofType:@"plist"];
    }else{
//        plistPat = [[NSBundle mainBundle] pathForResource:@"STBBrand" ofType:@"plist"];
    }
    NSArray *brand_list = [[NSArray alloc] initWithContentsOfFile:plistPat];
    self.title = [brand_list objectAtIndex:entityRemote.remoteBrandIndex];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.deleteRemoteBut.normalColor = [UIColor redColor];
    self.deleteRemoteBut.selectColor = [UIColor whiteColor];
    
    [_entityRemoteProcess synchronousEntityRemote:@[entityRemote.entityId] didSuccess:^{
        entityRemote = [_entityRemoteProcess findRemoteForEntityRemote:entityRemote];
    } didFail:^{
        
    }];
}

#pragma mark -
#pragma mark Action
-(IBAction)saveTitleAction:(id)sender
{
    UIButton *but = (UIButton *)sender;
    
    if (but.selected) {
        [remoteName resignFirstResponder];
        [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
        but.selected = NO;
        entityRemote.entityRemoteName = self.remoteName.text;
        
        if ([Tool checkFormatStr:self.remoteName.text]) {
            [Tool showMyAlert:S_FORMAT_ERROR];
            return;
        }
        
        NSString *msg = [NSString stringWithFormat:@"%d&%d&%@&%d&%@",0,entityRemote.entityRemoteIndex,entityRemote.entityRemoteName,entityRemote.entityRemoteIcon,entityRemote.roomId];
        
        [_entityRemoteProcess editEntityRemoteMsg:msg success:^(NSString *code) {
            [self.tableView reloadData];
        } fail:^(NSError *result, NSString *errInfo) {
            
        }];

    }else {
        [self.remoteName becomeFirstResponder];
        if (self.view.frame.size.height == 480) {
            NSLog(@"%f",self.tableView.contentOffset.y);
            [self.tableView setContentOffset:CGPointMake(0, -50) animated:YES];
        }
        but.selected = YES;
    }
}

-(void) resignkeyBoard
{
    [remoteName resignFirstResponder];
     editRemoteName.selected = NO;
    [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
    entityRemote.entityRemoteName = self.remoteName.text;
    
    if ([Tool checkFormatStr:self.remoteName.text]) {
        [Tool showMyAlert:S_FORMAT_ERROR];
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"%d&%d&%@&%d&%@",0,entityRemote.entityRemoteIndex,entityRemote.entityRemoteName,entityRemote.entityRemoteIcon,entityRemote.roomId];
    
    [_entityRemoteProcess editEntityRemoteMsg:msg success:^(NSString *code) {
        [self.tableView reloadData];
    } fail:^(NSError *result, NSString *errInfo) {
        
    }];
}

-(IBAction)deleteRemoteAction:(id)sender
{
    if (![Interface shareInterface:nil].isConnection) {
        [MTopWarnView addTopWarnText:S_NETWORK_NO_DETECT_NETWORK_SETTINGS view:self.tableView];
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"%d&%d&%@&%d&%@",1,entityRemote.entityRemoteIndex,entityRemote.entityRemoteName,entityRemote.entityRemoteIcon,entityRemote.roomId];
    [self.remoteName resignFirstResponder];
    [Tool showMyHUD:@"删除中"];
    [_entityRemoteProcess editEntityRemoteMsg:msg success:^(NSString *code) {
        [_entityRemoteProcess removeEntityRemote:entityRemote];
        [Tool showSuccessHUD:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSError *result, NSString *errInfo) {
        [Tool showSuccessHUD:@"删除失败"];
    }];
}

#pragma mark -
#pragma mark UITextFieldDelegate
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.remoteName = textField;
    self.editRemoteName.selected = YES;
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![Interface shareInterface:nil].isConnection) {
        [MTopWarnView addTopWarnText:S_NETWORK_NO_DETECT_NETWORK_SETTINGS view:self.tableView];
        return;
    }
//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
//        [self performSegueWithIdentifier:@"SelectImg" sender:nil];
    }else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"RoomsIdentifier" sender:nil];
    }
}

#pragma mark -
#pragma mark SelectImgViewDelegate
-(void) selectImg:(NSString *)image
{
    entityRemote.entityRemoteIcon = [image intValue];
    NSString *msg = [NSString stringWithFormat:@"%d&%d&%@&%d&%@",0,entityRemote.entityRemoteIndex,entityRemote.entityRemoteName,entityRemote.entityRemoteIcon,entityRemote.roomId];
    if (self.editRemoteName.selected) {
        [self.remoteName becomeFirstResponder];
    }
    [Tool showMyHUD:@"加载中"];
    [_entityRemoteProcess editEntityRemoteMsg:msg success:^(NSString *code) {
        entityRemote = [_entityRemoteProcess findRemoteForEntityRemote:entityRemote];
        [self.remoteImg setImage:[UIImage imageNamed:[DeviceResource getOpenImage:entityRemote.entityRemoteIcon]]];
        [self.tableView reloadData];
        [Tool hideMyHUD];
    } fail:^(NSError *result, NSString *errInfo) {
        [Tool showFailHUD:@"操作失败"];
    }];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SelectImg"]) {
        UINavigationController *nav = segue.destinationViewController;
        SelectImgViewController *selectImg = [[nav viewControllers] objectAtIndex:0];
        if (entityRemote.brandType == 0) {
            selectImg.type = _TVICON;
        }else if (entityRemote.brandType == 1){
            selectImg.type = _AIRICON;
        }
        selectImg.delegate = self;
    }else if ([segue.identifier isEqualToString:@"RoomsIdentifier"]) {
        UINavigationController *nav = segue.destinationViewController;
        MRoomSelectViewController *roomSelect = [[nav viewControllers] objectAtIndex:0];
        roomSelect.baseModel = entityRemote;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
