//
//  SelectWeekTableViewController.h
//  Home
//
//  Created by 刘军林 on 14-8-13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectWeekDelegate <NSObject>

-(void) SelectWeekValue:(int)week;

@end

@interface SelectWeekTableViewController : UITableViewController

@property (nonatomic, weak) id<SelectWeekDelegate> delegate;

@property (nonatomic, strong) NSArray *week_list;
@property (assign) int week;

-(IBAction)saveWeekAction:(id)sender;

@end
