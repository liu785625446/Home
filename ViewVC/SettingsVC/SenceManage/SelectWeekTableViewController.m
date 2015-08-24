//
//  SelectWeekTableViewController.m
//  Home
//
//  Created by 刘军林 on 14-8-13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "SelectWeekTableViewController.h"
#import "Sence.h"

@interface SelectWeekTableViewController ()

@end

@implementation SelectWeekTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _week_list = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark -
#pragma mark Action
-(IBAction)saveWeekAction:(id)sender
{
    [_delegate SelectWeekValue:_week];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return [_week_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = [_week_list objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        
        if ((_week & SUNDAY) == SUNDAY) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }else if (indexPath.row == 1){
        
        if ((_week & MONDAY) == MONDAY) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }else if (indexPath.row == 2) {
        
        if ((_week & TUESDAY) == TUESDAY) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }else if (indexPath.row == 3) {
        
        if ((_week & WEDNESDAY) == WEDNESDAY) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }else if (indexPath.row == 4) {
        
        if ((_week & THURSDAY) == THURSDAY) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }else if (indexPath.row == 5) {
        
        if ((_week & FRIDAY) == FRIDAY) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }else {
        
        if ((_week & SATURDAY) == SATURDAY) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        if ((_week & SUNDAY) == SUNDAY) {
            _week -=SUNDAY;
        }else{
            _week +=SUNDAY;
        }
        
    }else if (indexPath.row == 1){
        
        if ((_week & MONDAY) == MONDAY) {
            _week -=MONDAY;
        }else{
            _week +=MONDAY;
        }
        
    }else if (indexPath.row == 2) {
        
        if ((_week & TUESDAY) == TUESDAY) {
            _week -=TUESDAY;
        }else{
            _week += TUESDAY;
        }
        
    }else if (indexPath.row == 3) {
        
        if ((_week & WEDNESDAY) == WEDNESDAY) {
            _week -=WEDNESDAY;
        }else{
            _week +=WEDNESDAY;
        }
        
    }else if (indexPath.row == 4) {
        
        if ((_week & THURSDAY) == THURSDAY) {
            _week -=THURSDAY;
        }else{
            _week +=THURSDAY;
        }
        
    }else if (indexPath.row == 5) {
        
        if ((_week & FRIDAY) == FRIDAY) {
            _week -=FRIDAY;
        }else{
            _week +=FRIDAY;
        }
        
    }else {
        
        if ((_week & SATURDAY) == SATURDAY) {
            _week -=SATURDAY;
        }else{
            _week +=SATURDAY;
        }
        
    }
    
    [self.tableView reloadData];
}

@end
