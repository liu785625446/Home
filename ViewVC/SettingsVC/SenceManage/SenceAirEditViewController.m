//
//  SenceAirEditViewController.m
//  Home
//
//  Created by 刘军林 on 14-8-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "SenceAirEditViewController.h"
#import "Toast+UIView.h"

@interface SenceAirEditViewController ()

@end

@implementation SenceAirEditViewController

@synthesize switchBut;

@synthesize airTypeBut1;
@synthesize airTypeBut2;
@synthesize airTypeBut3;
@synthesize airTypeBut4;
@synthesize airTypeBut5;
@synthesize airTypeCurrentBut;

@synthesize airWindBut1;
@synthesize airWindBut2;
@synthesize airWindBut3;
@synthesize airWindBut4;
@synthesize airWindCurrentBut;

@synthesize airCelsiusBut16;
@synthesize airCelsiusBut17;
@synthesize airCelsiusBut18;
@synthesize airCelsiusBut19;
@synthesize airCelsiusBut20;
@synthesize airCelsiusBut21;
@synthesize airCelsiusBut22;
@synthesize airCelsiusBut23;
@synthesize airCelsiusBut24;
@synthesize airCelsiusBut25;
@synthesize airCelsiusBut26;
@synthesize airCelsiusBut27;
@synthesize airCelsiusBut28;
@synthesize airCelsiusBut29;
@synthesize airCelsiusBut30;
@synthesize airCelsiusBut31;
@synthesize airCelsiusBut32;
@synthesize airCelsiusCurrentBut;

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
    
    if (_entityRemote.arcPower == 0) {
        [self.switchBut setOn:NO animated:YES];
    }else{
        [self.switchBut setOn:YES animated:YES];
    }
    
    if (_entityRemote.arcFanMode == 0) {
        [self.sweptBut setOn:NO animated:YES];
    }else {
        [self.sweptBut setOn:YES animated:YES];
    }
    
//    [self.airTypeBut1 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                forState:UIControlStateSelected];
//    
//    [self.airTypeBut2 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                forState:UIControlStateSelected];
//    
//    [self.airTypeBut3 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                forState:UIControlStateSelected];
//    
//    [self.airTypeBut4 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                forState:UIControlStateSelected];
//    
//    [self.airTypeBut5 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                forState:UIControlStateSelected];
    
    for (int i=1 ; i<6 ; i++) {
        UIButton *but = [self valueForKey:[NSString stringWithFormat:@"airTypeBut%d",i]];
        if (_entityRemote.arcMode == but.tag) {
            but.selected = YES;
            self.airTypeCurrentBut = but;
        }
    }
    
//    [self.airWindBut1 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                forState:UIControlStateSelected];
//    
//    [self.airWindBut2 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                forState:UIControlStateSelected];
//    
//    [self.airWindBut3 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                forState:UIControlStateSelected];
//    
//    [self.airWindBut4 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                forState:UIControlStateSelected];
    
    for (int i=1 ; i<5 ; i++) {
        UIButton *but = [self valueForKey:[NSString stringWithFormat:@"airWindBut%d",i]];
        if (_entityRemote.arcFan == but.tag) {
            but.selected = YES;
            self.airWindCurrentBut = but;
        }
    }
    
//    [self.airCelsiusBut16 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut17 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut18 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut19 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut20 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut21 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut22 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut23 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut24 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut25 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut26 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut27 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut28 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut29 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut30 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut31 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
//    
//    [self.airCelsiusBut32 setBackgroundImage:[UIImage imageNamed:@"kongtiaobutover.png"]
//                                    forState:UIControlStateSelected];
    
    UIButton *tempBut = [self valueForKey:[NSString stringWithFormat:@"airCelsiusBut%d",26]];
    tempBut.selected = YES;
    self.airCelsiusCurrentBut = tempBut;
    for (int i=16 ; i<33 ; i++) {
        UIButton *but = [self valueForKey:[NSString stringWithFormat:@"airCelsiusBut%d",i]];
        if (_entityRemote.arcTemp == [but.titleLabel.text intValue]) {
            but.selected = YES;
            self.airCelsiusCurrentBut = but;
        }
    }

    // Do any additional setup after loading the view.
}

#pragma mark Action
-(IBAction)sweptAction:(id)sender
{
    
}

-(IBAction)airTypeAction:(id)sender
{
    UIButton *but = (UIButton *)sender;
    
    if (!self.airTypeCurrentBut) {
        self.airTypeCurrentBut = but;
        but.selected = YES;
    }else {
        self.airTypeCurrentBut.selected = NO;
        but.selected = YES;
        self.airTypeCurrentBut = but;
    }
}

-(IBAction)airWindAction:(id)sender
{
    UIButton *but = (UIButton *)sender;
    
    if (!self.airWindCurrentBut) {
        self.airWindCurrentBut = but;
        but.selected = YES;
    }else {
        self.airWindCurrentBut.selected = NO;
        but.selected = YES;
        self.airWindCurrentBut = but;
    }
}

-(IBAction)airCelsiusAction:(id)sender
{
    UIButton *but = (UIButton *)sender;
    
    if (!self.airCelsiusCurrentBut) {
        self.airCelsiusCurrentBut = but;
        but.selected = YES;
    } else {
        self.airCelsiusCurrentBut.selected = NO;
        but.selected = YES;
        self.airCelsiusCurrentBut = but;
    }
}

-(IBAction)saveSenceAirAction:(id)sender
{
    if (self.switchBut.isOn) {
        if (!self.airTypeCurrentBut || !self.airWindCurrentBut || !self.airCelsiusCurrentBut) {
            [self.view.window makeToast:[NSString stringWithFormat:@"请配置空调信息!"]];
            return;
        }else{
            
            if (self.sweptBut.isOn) {
                _entityRemote.arcFanMode = 1;
            }else{
                _entityRemote.arcFanMode = 0;
            }
            _entityRemote.arcPower = 1;
            _entityRemote.arcMode = self.airTypeCurrentBut.tag;
            _entityRemote.arcTemp = [self.airCelsiusCurrentBut.titleLabel.text intValue];
            _entityRemote.arcFan = self.airWindCurrentBut.tag;
            
        }
        
    }else{
        _entityRemote.arcPower = 0;
    }
    
    [_delegate eidtAirSence:_entityRemote];
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *name;
    if (section == 1) {
        name = @"     模式";
    }else if (section == 2) {
        name = @"     风量";
    }else if (section == 3) {
        name = @"     温度";
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 15)];
    label.text = name;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13.0f];
    return label;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"模式";
    }else if (section == 2) {
        return @"风量";
    }else if (section == 3) {
        return @"温度";
    }else{
        return nil;
    }
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else
    {
        return 1;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
