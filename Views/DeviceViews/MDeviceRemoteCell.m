//
//  MDeviceRemoteCell.m
//  Home
//
//  Created by 刘军林 on 15/6/4.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MDeviceRemoteCell.h"
#import "Tool.h"
#import "Interface.h"

@implementation MDeviceRemoteCell

@synthesize volReduceBut;
@synthesize volAddBut;
@synthesize defineBut;
@synthesize homeBut;
@synthesize backBut;
@synthesize moreBut;
@synthesize keyBoardBut;

- (void)awakeFromNib {
    // Initialization code
    [self.volReduceBut setImage:[UIImage imageNamed:@"button_volsmallover.png"] forState:UIControlStateHighlighted];
    [self.volAddBut setImage:[UIImage imageNamed:@"button_voladdover.png"] forState:UIControlStateHighlighted];
    [self.defineBut setImage:[UIImage imageNamed:@"button_okover.png"] forState:UIControlStateHighlighted];
    [self.backBut setImage:[UIImage imageNamed:@"button_back_over.png"] forState:UIControlStateHighlighted];
    [self.homeBut setImage:[UIImage imageNamed:@"button_home_over.png"] forState:UIControlStateHighlighted];
    [self.moreBut setImage:[UIImage imageNamed:@"button_list_over.png"] forState:UIControlStateHighlighted];
    [self.keyBoardBut setImage:[UIImage imageNamed:@"button_jp_over.png"] forState:UIControlStateHighlighted];
    self.customBut.delegate = self;
    if (_toolbar == nil) {
        UIToolbar *tool= [[UIToolbar alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     self.bounds.size.width,
                                                                     38.0f)];
        tool.barStyle = UIBarStyleDefault;
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(keyBoardHideAction:)];
        doneBarItem.tintColor = [UIColor grayColor];
        
        [tool setItems:[NSArray arrayWithObjects:spaceBarItem, doneBarItem, nil]];
        _toolbar=tool;
    }
    _searchBar.inputAccessoryView = _toolbar;
}

-(IBAction)keyBoardHideAction:(id)sender
{
    [_searchBar resignFirstResponder];
}

-(IBAction)remoteDownAction:(id)sender
{
    UIButton *but = (UIButton *)sender;
    [Tool soundAction];
    butStatus = but.tag;
    NSString *msg = [NSString stringWithFormat:@"%d&%ld",0,(long)but.tag];
    [self performSelector:@selector(remoteUpAction:)
               withObject:[NSNumber numberWithInt:but.tag]
               afterDelay:1.0];
    [self sendRemoteMessage:msg];
}

-(void) sendRemoteMessage:(NSString *)msg
{
    if ([[Interface shareInterface:nil].connectIp isEqualToString:@"192.168.7.250"]) {
        NSLog(@"发送udp数据:%@",msg);
        AsyncUdpSocket *socket =  [[AsyncUdpSocket alloc] initWithDelegate:self];
        [socket sendData:[msg dataUsingEncoding:NSUTF8StringEncoding] toHost:[Interface shareInterface:nil].connectIp port:59607 withTimeout:-1 tag:0];
    }else{
        [[Interface shareInterface:nil] writeFormatDataAction:@"80" didMsg:msg didCallBack:nil];
    }
}

-(void) directionDown:(DirectionButton *)but didMsg:(NSString *)msg
{
    [self sendRemoteMessage:msg];
}

-(void)remoteUpAction:(id)sender
{
    NSString *msgUp = [NSString stringWithFormat:@"%d&%ld",1,(long)butStatus];
    [self sendRemoteMessage:msgUp];
}

-(IBAction)keyBoardShowAction:(id)sender
{
    [_searchBar becomeFirstResponder];
}

-(void)  searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (_oldStr.length < searchText.length) {
        if (_oldStr.length == 0) {
            NSString *msg = [NSString stringWithFormat:@"0&1000&%@",searchText];
            [self sendRemoteMessage:msg];
            sleep(0.2);
            msg = [NSString stringWithFormat:@"1&1000&%@",searchText];
            [self sendRemoteMessage:msg];
        }else{
            NSRange oldRange = [searchText rangeOfString:_oldStr];
            NSRange newRange = NSMakeRange(oldRange.length, searchText.length-_oldStr.length);
            NSString *send = [searchText substringWithRange:newRange];
            
            NSString *msg = [NSString stringWithFormat:@"0&1000&%@",send];
            [self sendRemoteMessage:msg];
            sleep(0.2);
            msg = [NSString stringWithFormat:@"1&1000&%@",send];
            [self sendRemoteMessage:msg];
        }
    }else{
        NSString *msg = [NSString stringWithFormat:@"0&1001&"];
            [self sendRemoteMessage:msg];
        sleep(0.2);
        msg = [NSString stringWithFormat:@"1&1001&"];
          [self sendRemoteMessage:msg];
    }
    _oldStr = searchText;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
