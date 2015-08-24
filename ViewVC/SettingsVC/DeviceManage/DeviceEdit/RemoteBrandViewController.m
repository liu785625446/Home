//
//  RemoteBrandViewController.m
//  Home
//
//  Created by 刘军林 on 14-7-31.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "RemoteBrandViewController.h"
#import "RemoteTypeCell.h"
#import "MatchParamViewController.h"
#import "Tool.h"

@interface RemoteBrandViewController ()

@end

@implementation RemoteBrandViewController

@synthesize remoteType;

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
    
    NSString *tempStr;
    if (remoteType == 0) {
        tempStr = @"电视";
    }else if (remoteType == 1) {
        tempStr = @"空调";
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"敬请期待..." delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    self.title = [NSString stringWithFormat:@"选择%@品牌",tempStr];
    
    if (remoteType == 0) {
        NSString *brandStr = [[NSBundle mainBundle] pathForResource:@"TVBrand" ofType:@"plist"];
        _brand_list = [[NSArray alloc] initWithContentsOfFile:brandStr];
        
        NSString *patternStr = [[NSBundle mainBundle] pathForResource:@"TVPattern" ofType:@"plist"];
        _pattern_list = [[NSArray alloc] initWithContentsOfFile:patternStr];
        
    }else if (remoteType == 1) {
        NSString *brandStr = [[NSBundle mainBundle] pathForResource:@"AirBrand" ofType:@"plist"];
        _brand_list = [[NSArray alloc] initWithContentsOfFile:brandStr];
        
        NSString *patternStr = [[NSBundle mainBundle] pathForResource:@"AirPattern" ofType:@"plist"];
        _pattern_list = [[NSArray alloc] initWithContentsOfFile:patternStr];
        
    }else{
       
    }
    
    [self.collectionView reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIAlertViewDelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UICollectionViewController
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_brand_list count];
}

-(CGSize ) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int width = collectionView.frame.size.width / 3;
    return CGSizeMake(width, width);
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RemoteBrandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RemoteBrandCell" forIndexPath:indexPath];
    
    cell.index = indexPath.row;
    
    cell.brand.text = [_brand_list objectAtIndex:indexPath.row];
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _current_index = indexPath.row;
    [self performSegueWithIdentifier:@"Match" sender:nil];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Match"]) {
        MatchParamViewController *match = segue.destinationViewController;
        
        match.patternAmount = [_pattern_list objectAtIndex:_current_index];
        match.remoteType = self.remoteType;
        match.entity_id = _entity_id;
        match.remoteBrandIndex = _current_index;
        
        match.deviceEditDelegate = _deviceEditDelegate;
        match.deviceManageDelegate = _deviceManageDelegate;
        
        NSString *key = [_brand_list objectAtIndex:_current_index];
        if (self.remoteType == 0) {
            match.remoteName = [NSString stringWithFormat:@"%@电视",key];
        }else if (self.remoteType == 1) {
            match.remoteName = [NSString stringWithFormat:@"%@空调",key];
        }else{
            
        }
    }
}


@end
