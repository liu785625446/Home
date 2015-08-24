//
//  RemoteTypeViewController.m
//  Home
//
//  Created by 刘军林 on 14-7-31.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "RemoteTypeViewController.h"
#import "RemoteTypeCell.h"
#import "RemoteBrandViewController.h"
#import "DeviceResource.h"

@interface RemoteTypeViewController ()

@end

@implementation RemoteTypeViewController

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
    
    _img_list = @[[DeviceResource getOpenImage:26],[DeviceResource getOpenImage:24],@"icon_mrjmr_round.png"];
    _name_list = @[@"电视",@"空调",@"自定义"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UICollectionViewController
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_img_list count];
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
    RemoteTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RemoteTypeCell" forIndexPath:indexPath];

    cell.index = indexPath.row;
    
    NSString *img = [_img_list objectAtIndex:indexPath.row];
    [cell.remoteImg setImage:[UIImage imageNamed:img]];
    
    NSString *name = [_name_list objectAtIndex:indexPath.row];
    cell.remoteName.text = name;
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _current_index = indexPath.row;
    [self performSegueWithIdentifier:@"RemoteBrand" sender:nil];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RemoteBrand"]) {
        RemoteBrandViewController *brand = segue.destinationViewController;
        brand.remoteType = self.current_index;
        brand.entity_id = _entity_id;
        brand.deviceManageDelegate = _deviceManageDelegate;
        brand.deviceEditDelegate = _deviceEditDelegate;
    }
}


@end
