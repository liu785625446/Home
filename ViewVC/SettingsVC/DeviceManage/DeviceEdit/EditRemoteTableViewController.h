//
//  EditRemoteTableViewController.h
//  Home
//
//  Created by 刘军林 on 14-8-7.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectImgViewController.h"
#import "CustomButton.h"
#import "MBaseTableViewController.h"

@class EntityRemote;
@class EntityRemoteProcess;
@class EntityProcess;

@interface EditRemoteTableViewController : UITableViewController <UITextFieldDelegate,SelectImgDelegate,UITextFieldDelegate>
{
    int offsetHeight;
}

@property (nonatomic, strong) IBOutlet UIImageView *remoteImg;
@property (nonatomic, strong) IBOutlet UITextField *remoteName;
@property (nonatomic, strong) IBOutlet UIButton *editRemoteName;

@property (nonatomic, strong) IBOutlet CustomButton *deleteRemoteBut;

@property (nonatomic, strong) EntityRemoteProcess *entityRemoteProcess;
@property (nonatomic, strong) EntityProcess *entityProcess;

@property (nonatomic,strong) EntityRemote *entityRemote;

@end
