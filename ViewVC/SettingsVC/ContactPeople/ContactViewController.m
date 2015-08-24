//
//  ContactViewController.m
//  Home
//
//  Created by 刘军林 on 14-5-20.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "ContactViewController.h"

#import "ContactCell.h"
#import "Tool.h"
#import "Alarmphone.h"
#import "AppDelegate.h"
#import "Interface.h"
#import "const.h"
#import "AlarmPhoneProcess.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

@synthesize contactArr;

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
    _alarmPhoneProcess = [[AlarmPhoneProcess alloc] init];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animatedk
{
    [super viewWillAppear:animatedk];
    [self refreshAction];
}

-(void) refreshAction
{
    if (BOX_ID_VALUE) {
        
//        首先加载本地数据
        contactArr = [_alarmPhoneProcess findAllAlarmphone];
        [self.baseTableView reloadData];
        
//        同步数据
        [_alarmPhoneProcess synchronousAlarmPhone:^(int size){
            contactArr = [_alarmPhoneProcess findAllAlarmphone];
            _phoneMaxNum = size;
            [self.baseTableView reloadData];
        }didFail:^{
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action
-(IBAction)addContactPeopleAction:(id)sender
{
    if ([self checkConnectionStatus]) {
        return;
    }
    if([contactArr count] == _phoneMaxNum) {
        [Tool showMyAlert:@"紧急联系人已添加上线!"];
        return;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"紧急联系人"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"添加联系人",@"通讯录选择", nil];
    [sheet showInView:self.view];
}

#pragma mark -
#pragma mark UIActionSheetViewDelegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"AddContact" sender:nil];
    }else if (buttonIndex == 1) {
        ABPeoplePickerNavigationController *people = [[ABPeoplePickerNavigationController alloc] init];
        people.peoplePickerDelegate  = self;
        [self presentViewController:people animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark ABPeoplePickerNavigationDelegate

-(void) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person property:property identifier:identifier];
}

-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (firstName == NULL) {
        firstName = @"";
    }
    
    if (lastName == NULL) {
        lastName = @"";
    }
    NSString *phone = @"";
    for (int i=0; i<ABMultiValueGetCount(phoneMulti); i++) {
        NSString *phoneIndex = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        //        if (![phoneIndex isEqualToString:@"-"]) {
        phone = [NSString stringWithFormat:@"%@%@",phone,phoneIndex];
        //        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    for (Alarmphone *alarmphone in contactArr) {
        if ([alarmphone.contactNum isEqualToString:phone]) {
            [Tool showMyAlert:[NSString stringWithFormat:@"%@%@%@",lastName,firstName,@"已添加"]];
            return NO;
        }
    }
    
    NSString *msg = [NSString stringWithFormat:@"%@&%@&%@%@&%@",BOX_ID_VALUE,@"0",lastName,firstName,phone];
    [Tool showMyHUD:@"加载中"];
    [[Interface shareInterface:nil] writeFormatDataAction:@"17"
                                                   didMsg:msg
                                              didCallBack:^(NSString *code){
                                                  
                                                  NSArray *tempArray = [code componentsSeparatedByString:@","];
                                                  if ([tempArray count] >= 3) {
                                                      [Tool showSuccessHUD:@"添加成功"];
                                                      [self refreshAction];
                                                  }else{
                                                      [Tool showFailHUD:@"添加失败"];
                                                  }
                                              }
     ];

    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

-(void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contactArr count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactPeople" forIndexPath:indexPath];
    
    Alarmphone *alarmphone = [contactArr objectAtIndex:indexPath.row];
    cell.name.text = alarmphone.contactName;
    cell.phone.text = alarmphone.contactNum;
    return cell;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self checkConnectionStatus]) {
        [tableView reloadData];
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Alarmphone *alarmphone = [self.contactArr objectAtIndex:indexPath.row];
        NSString *msg = [NSString stringWithFormat:@"%@&%@&%@&%@",BOX_ID_VALUE,@"1",alarmphone.contactName,alarmphone.contactNum];
        
        [self showMyHUD:@"删除中"];
        [[Interface shareInterface:nil] writeFormatDataAction:@"17"
                                                       didMsg:msg
                                                  didCallBack:^(NSString *code){
                                                      NSLog(@"%@",code);
                                                      [self hideMyHUD];
                                                      NSArray *tempArray = [code componentsSeparatedByString:@","];
                                                      if ([tempArray count] >= 3) {
                                                          
                                                          [contactArr removeObject:alarmphone];
                                                          [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                                           withRowAnimation:UITableViewRowAnimationFade];
                                                          [_alarmPhoneProcess synchronousAlarmPhone:^(int size){
                                                              contactArr = [_alarmPhoneProcess findAllAlarmphone];
                                                              _phoneMaxNum = size;
                                                              [self.baseTableView reloadData];
                                                          }didFail:^{
                                                          }];
                                                      }else{
                                                      }
                                                  }
         ];
    }
}

@end
