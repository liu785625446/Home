//
//  AddContactTableViewController.h
//  Home
//
//  Created by 刘军林 on 14-5-20.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "MBaseTableViewController.h"

@class AlarmPhoneProcess;

@interface AddContactTableViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UITextField *phoneField;
@property (nonatomic, strong) IBOutlet CustomButton *defineBut;
@property (nonatomic, strong) AlarmPhoneProcess *alarmPhoneProcess;

-(IBAction)addContactAction:(id)sender;
@end
