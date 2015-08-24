//
//  MHorizontalSlidingView.m
//  Home
//
//  Created by 刘军林 on 15/5/22.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MHorizontalSlidingView.h"
#import "MJRefresh.h"
#import "Tool.h"

#define TABLEVIEW_TAG 1234

@implementation MHorizontalSlidingView

-(void) setItemsAttribute:(NSInteger)row
      SlidingViewDelegate:(id<MHorizontalSlidingViewDelegate>)delegate
            tableDelegate:(id<UITableViewDelegate>)tabDelegate
          tableDataSource:(id<UITableViewDataSource>)tabDataSource
{
        
//        _viewFrame = frame;
    _row = row;
    UICollectionViewFlowLayout *viewlayout = [[UICollectionViewFlowLayout alloc] init];
    [viewlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [viewlayout setHeaderReferenceSize:CGSizeMake(0, 0)];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:viewlayout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _slidingDelegate = delegate;
    _oldOff = 0.0f;
    
    _tableViewDelegate = tabDelegate;
    _tableViewDataSource = tabDataSource;
    _isScroll = YES;
    
    [self addSubview:_collectionView];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [Tool customAddAutoLayoutSub:_collectionView didSupView:self];
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

-(void) reloadSlidingView
{
    [_collectionView reloadData];
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _row;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    id cellObject = [cell viewWithTag:TABLEVIEW_TAG];
    if (!cellObject) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
        [table setSeparatorInset:UIEdgeInsetsMake(0, 75, 0, 0)];
        table.delegate = _tableViewDelegate;
        table.dataSource = _tableViewDataSource;
        table.backgroundColor = [UIColor blackColor];
        table.backgroundColor = [UIColor groupTableViewBackgroundColor];
        table.tag = TABLEVIEW_TAG;
        [cell.contentView addSubview:table];
        table.translatesAutoresizingMaskIntoConstraints = NO;
        [Tool customAddAutoLayoutSub:table didSupView:cell.contentView];
        
        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
        header.scrollView = table;
        header.backgroundColor = [UIColor groupTableViewBackgroundColor];
        header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
            if ([_slidingDelegate respondsToSelector:@selector(horizontalSlidingView:MJRefresh:)]) {
                [_slidingDelegate horizontalSlidingView:self MJRefresh:refreshView];
            }
        };
        _currentTable = table;
    }else{
        id object = [cell viewWithTag:TABLEVIEW_TAG];
        if ([object isKindOfClass:[UITableView class]]) {
            [((UITableView *)object) reloadData];
            _currentTable = (UITableView *)object;
        }
    }
    return cell;
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int off = scrollView.contentOffset.x / self.frame.size.width;
    
    if ([_slidingDelegate respondsToSelector:@selector(horizontalSlidingView:scrollRow:currentTable:)]) {
        [_slidingDelegate horizontalSlidingView:self scrollRow:off currentTable:_currentTable];
    }
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int off = scrollView.contentOffset.x / self.frame.size.width;
    
    if ([_slidingDelegate respondsToSelector:@selector(horizontalSlidingView:scrollRow:currentTable:)]) {
        [_slidingDelegate horizontalSlidingView:self scrollRow:off currentTable:_currentTable];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    float foff = scrollView.contentOffset.x / self.frame.size.width;
    NSInteger off = 0;
    if (foff > _oldOff) {
        off = _oldOff + 1;
    }else{
        off = foff;
    }
    _oldOff = foff;
    
    if ([_slidingDelegate respondsToSelector:@selector(horizontalScrollingView:scrollingOff:)]) {
        [_slidingDelegate horizontalScrollingView:self scrollingOff:off];
    }
}

-(void) setScrollPage:(NSInteger )page
{
    [_collectionView setContentOffset:CGPointMake(page * _collectionView.frame.size.width, 0) animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
