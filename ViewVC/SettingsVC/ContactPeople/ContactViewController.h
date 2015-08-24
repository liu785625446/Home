//
//  ContactViewController.h
//  Home
//
//  Created by 刘军林 on 14-5-20.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AppDelegate.h"
#import "MBaseTableViewController.h"

@class AlarmPhoneProcess;

@interface ContactViewController : MBaseTableViewController <UIActionSheetDelegate,ABPeoplePickerNavigationControllerDelegate>
{

}

@property (nonatomic, strong) NSMutableArray *contactArr;
@property (nonatomic, strong) AlarmPhoneProcess *alarmPhoneProcess;

//短信号码最大值
@property (assign) int phoneMaxNum;

-(IBAction)addContactPeopleAction:(id)sender;
@end
