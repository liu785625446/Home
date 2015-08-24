//
//  AddContactTableViewController.m
//  Home
//
//  Created by 刘军林 on 14-5-20.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "AddContactTableViewController.h"
#import "AppDelegate.h"
#import "Alarmphone.h"
#import "Tool.h"
#import "Interface.h"
#import "AlarmPhoneProcess.h"

@interface AddContactTableViewController ()

@end

@implementation AddContactTableViewController

@synthesize nameField;
@synthesize phoneField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _alarmPhoneProcess = [[AlarmPhoneProcess alloc] init];
    
    self.defineBut.normalColor = [UIColor blueColor];
    self.defineBut.selectColor = [UIColor whiteColor];
    self.defineBut.selectTitleColor = [UIColor whiteColor];
    self.defineBut.normalTitleColor = [UIColor blueColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(IBAction)addContactAction:(id)sender
{
    if ([nameField.text isEqualToString:@""] || nameField.text == nil) {
        [Tool showMyAlert:@"请填写联系人名称"];
        return;
    }
    
    if ([phoneField.text isEqualToString:@""] || phoneField.text == nil) {
        [Tool showMyAlert:@"请填写联系号码"];
        return;
    }
    
    if (![Tool validateMobile:phoneField.text]) {
        [Tool showMyAlert:@"手机号格式错误"];
        return;
    }
    
    if ([Tool checkFormatStr:phoneField.text] || [Tool checkFormatStr:nameField.text]) {
        [Tool showMyAlert:S_FORMAT_ERROR];
        return;
    }
    
    if (![Interface shareInterface:nil].isConnection) {
        [MTopWarnView addTopWarnText:S_NETWORK_NO_DETECT_NETWORK_SETTINGS view:self.tableView];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%@&%@&%@&%@",BOX_ID_VALUE,@"0",self.nameField.text,self.phoneField.text];
    
    [Tool showMyHUD:@"加载中"];
    [[Interface shareInterface:nil] writeFormatDataAction:@"17"
                                                   didMsg:msg
                                              didCallBack:^(NSString *code){
                                                  NSArray *tempArray = [code componentsSeparatedByString:@","];
                                                  if ([tempArray count] >= 3) {
                                                      [_alarmPhoneProcess synchronousAlarmPhone:^(int size){
                                                          [Tool showSuccessHUD:@"添加成功"];
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      }didFail:^{
                                                          [Tool showFailHUD:@"添加失败"];
                                                      }];
                                                  }else{
                                                      [Tool showFailHUD:@"添加失败"];
                                                  }
                                              }
     ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
@end
