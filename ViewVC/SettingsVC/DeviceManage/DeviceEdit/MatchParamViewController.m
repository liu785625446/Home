//
//  MatchParamViewController.m
//  Home
//
//  Created by 刘军林 on 14-8-8.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MatchParamViewController.h"
#import "RemotePatternViewController.h"

@interface MatchParamViewController ()

@end

@implementation MatchParamViewController

@synthesize matchBut;
@synthesize info;

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
    
    self.matchBut.layer.cornerRadius = 75;
    self.matchBut.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.matchBut.layer.borderWidth = 1.0f;
    
    self.info.numberOfLines = 0;
    self.info.lineBreakMode = UILineBreakModeCharacterWrap;
    
    self.title = [NSString stringWithFormat:@"开始匹配%@",_remoteName];
    
    NSString *infoStr;
    if (_remoteType == 0) { //电视
        
        infoStr = [NSString stringWithFormat:@"   您选择的%@,拥有%@种遥控型号，可能需要您一个一个切换匹配。\n  如果电视出现声音遥控效果，将表示匹配成功。\n  点击保存并可在管理界面自定义一个名称。",_remoteName,_patternAmount ];
        
        
    }else if (_remoteType == 1) { //空调
        
        infoStr = [NSString stringWithFormat:@"   您选择的%@,拥有%@种遥控型号，可能需要您一个一个切换匹配。\n   如果空调出现电源开关遥控效果，将表示匹配成功。\n   点击保存并可在管理界面自定义一个名称",_remoteName,_patternAmount];
        
    }else if (_remoteType == 2) { //机顶_remoteName
    
        infoStr = [NSString stringWithFormat:@"   您选择的%@，拥有%@种遥控型号，可能需要您一个一个切换匹配。\n   如果机顶盒出现声音遥控效果，将表示匹配成功。\n   点击保存并可在管理界面自定义一个名称。",_remoteName,_patternAmount];
        
    }
    
    CGSize size = [infoStr sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(self.info.frame.size.width, self.info.frame.size.height)];
    self.info.frame = CGRectMake(self.info.frame.origin.x, self.info.frame.origin.y, size.width, size.height);
    self.info.text = infoStr;
    // Do any additional setup after loading the view.
}

#pragma mark Action
-(IBAction)matchAction:(id)sender
{
    [self performSegueWithIdentifier:@"RemotePattern" sender:nil];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RemotePattern"]) {
        
        RemotePatternViewController *pattern = segue.destinationViewController;
        pattern.patternAmount = _patternAmount;
        pattern.remoteType = _remoteType;
        pattern.entity_id = _entity_id;
        pattern.remoteBrandIndex = _remoteBrandIndex;
        pattern.remoteName = _remoteName;
        
        pattern.deviceManageDelegate = _deviceManageDelegate;
        pattern.deviceEditDelegate = _deviceEditDelegate;
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
