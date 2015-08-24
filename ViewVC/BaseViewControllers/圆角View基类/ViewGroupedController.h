//
//  ViewGroupedController.h
//  Home
//
//  Created by 刘军林 on 14-5-29.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MBaseViewController.h"

@interface ViewGroupedController : MBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, strong) IBOutlet UITableView *table;


@end
