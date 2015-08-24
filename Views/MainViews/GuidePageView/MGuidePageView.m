//
//  BootPageVIew.m
//  Home
//
//  Created by 刘军林 on 14-7-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MGuidePageView.h"

@implementation MGuidePageView

@synthesize scrollview;
@synthesize pages;
@synthesize currentPage;
@synthesize backLayerView;
@synthesize frontLayerView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect rect = [UIScreen mainScreen].bounds;
        self.scrollview = [[UIScrollView alloc] initWithFrame:rect];
        self.scrollview.delegate = self;
        [self addSubview:scrollview];
        
        self.pages = [[NSMutableArray alloc] initWithCapacity:0];
        [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width*3, self.scrollview.frame.size.height)];
        [self.scrollview setPagingEnabled:YES];
        [self.scrollview setShowsHorizontalScrollIndicator:NO];
        [self.scrollview setShowsVerticalScrollIndicator:YES];
        
        backLayerView = [[UIImageView alloc] initWithFrame:rect];
        frontLayerView = [[UIImageView alloc] initWithFrame:rect];
        
        for (int i=1 ; i<4 ; i++) {
            
            NSString *imageUrl = @"";
            if (rect.size.height == 480.0f) {
                imageUrl = [NSString stringWithFormat:@"480_0%d.png",i];
            }else {
                imageUrl = [NSString stringWithFormat:@"1136_0%d.png",i];
            }
            
            [self.pages addObject:imageUrl];
        }
        
        [backLayerView setImage:[UIImage imageNamed:[self.pages objectAtIndex:0]]];
        [frontLayerView setImage:[UIImage imageNamed:[self.pages objectAtIndex:1]]];
        
        [self addSubview:frontLayerView];
        [self addSubview:backLayerView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterMainAction:)];
        
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
        [self.scrollview addGestureRecognizer:tap];
        
    }
    return self;
}

-(void) enterMainAction:(id)sender
{
    if (currentPage == 2) {
        if ([_delegate respondsToSelector:@selector(mGuidePageViewComplete:)]) {
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:MGUIDEPAGEVIEW forKey:MGUIDEPAGEVIEW];
            [_delegate mGuidePageViewComplete:self];
        }
    }
}

-(void) scrollingToNextPageWithOffset:(float)offset {
    
    NSInteger page = (int)(offset);
    
    float alphaValue = offset - (int)offset;
    
    if (self.currentPage <= page) {
        [self.backLayerView setAlpha:1-alphaValue];
        [self.frontLayerView setAlpha:alphaValue];
    }else {
        [self.backLayerView setAlpha:alphaValue];
        [self.frontLayerView setAlpha:1-alphaValue];
    }
    
    if (alphaValue == 0) {
        
        if (self.currentPage <= page) {
            [self.backLayerView setAlpha:1];
            [self.frontLayerView setAlpha:0];
            self.currentPage = page;
            [self.backLayerView setImage:[UIImage imageNamed:[self.pages objectAtIndex:page]]];
            if ([self.pages count] > page + 1 ) {
                [self.frontLayerView setImage:[UIImage imageNamed:[self.pages objectAtIndex:page+1]]];
            }else{
                [self.frontLayerView setImage:[UIImage imageNamed:[self.pages objectAtIndex:page-1]]];
            }
        }else {
            
            [self.backLayerView setAlpha:1];
            [self.frontLayerView setAlpha:0];
            self.currentPage = page;
            [self.backLayerView setImage:[UIImage imageNamed:[self.pages objectAtIndex:page]]];
            if (page > 0) {
                [self.frontLayerView setImage:[UIImage imageNamed:[self.pages objectAtIndex:page-1]]];
            }else {
                [self.frontLayerView setImage:[UIImage imageNamed:[self.pages objectAtIndex:page+1]]];
            }
        }
    }
}

#pragma mark -
#pragma mark UIScrollView
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    float scrollingPosition = scrollView.contentOffset.x / self.frame.size.width;
    [self scrollingToNextPageWithOffset:scrollingPosition];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
