//
//  SenceListViewController.m
//  Home
//
//  Created by 刘军林 on 14-8-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "SenceListViewController.h"
#import "Tool.h"
#import "FMDatabase.h"
#import "Interface.h"
#import "Sence.h"
#import "SenceListCell.h"
#import "AddSenceViewController.h"
#import "SenceProcess.h"

@interface SenceListViewController ()

@end

@implementation SenceListViewController

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
    
    _senceProcess = [[SenceProcess alloc] init];
    _sence_list = [[NSMutableArray alloc] initWithCapacity:0];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _sence_list = [_senceProcess findAllSence];
    
    [_senceProcess synchronousSence:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _sence_list = [_senceProcess findAllSence];
            [self.baseTableView reloadData];
        });
    }didFail:^{
        
    }];
    [self.baseTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sence_list count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SenceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenceListCell"
                                                          forIndexPath:indexPath];
    
    Sence *sence = [_sence_list objectAtIndex:indexPath.row];
    [cell setSence:sence];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    _currentIndex = indexPath.row;
    [self performSegueWithIdentifier:@"updateSence" sender:nil];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"updateSence"]) {
        AddSenceViewController *addSence = segue.destinationViewController;
        addSence.sence = [_sence_list objectAtIndex:_currentIndex];
    }
}


@end
