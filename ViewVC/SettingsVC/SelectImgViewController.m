//
//  SelectImgViewController.m
//  Home
//
//  Created by 刘军林 on 14-5-15.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "SelectImgViewController.h"
#import "AppCollectionCell.h"
#import "ImageList.h"
#import "DeviceResource.h"

@interface SelectImgViewController ()

@end

@implementation SelectImgViewController

@synthesize img_list;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//1223
//5290

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.img_list = [ImageList getImageList:_type];
    
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
    return [self.img_list count];
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
    AppCollectionCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                     forIndexPath:indexPath];
    
    DeviceResource *resource = [self.img_list objectAtIndex:indexPath.row];
    cell.image.image = [UIImage imageNamed:resource.open_icon];
    cell.index = indexPath.row;
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceResource *resource = [img_list objectAtIndex:indexPath.row];
    [delegate selectImg:[NSString stringWithFormat:@"%d",resource.icon_tag]];
    [self dismissViewControllerAnimated:YES completion:nil];
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
