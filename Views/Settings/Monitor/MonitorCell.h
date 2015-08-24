//
//  MonitorCell.h
//  Home
//
//  Created by 刘军林 on 14-9-4.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MonitorCellDelegate <NSObject>

-(void) monitorBindWithIndex:(int) index;

@end

@interface MonitorCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *monitorImg;
@property (nonatomic, strong) IBOutlet UILabel *monitorName;
@property (nonatomic, strong) IBOutlet UIButton *monitorBindBut;
@property (nonatomic, strong) IBOutlet UILabel *bangding;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, weak) id<MonitorCellDelegate> delegate;

-(IBAction)monitorBindAction:(id)sender;
@end
