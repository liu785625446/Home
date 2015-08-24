//
//  SliderLabelView.m
//  Home
//
//  Created by 刘军林 on 15/5/23.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MSliderLabelView.h"

@implementation MSliderLabelView

-(id) initWithFrame:(CGRect)frame itemsTitles:(NSArray *)titleArray itemHighlight:(NSInteger)row
{
    self = [super init];
    if (self) {
        
        int i = 0;
        for (NSString *str in titleArray) {
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(i*60, 0, 30, 30)];
            title.text = str;
            title.textAlignment = NSTextAlignmentCenter;
            title.font = [UIFont systemFontOfSize:15.0f];
            title.tag = i+1000;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topTitleAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            title.userInteractionEnabled = YES;
            [title addGestureRecognizer:tap];
            
            UILabel *round = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x + (title.frame.size.width/2) - 2.5, title.frame.origin.y + title.frame.size.height, 5, 5)];
            round.backgroundColor = [UIColor whiteColor];
            round.textColor = [UIColor whiteColor];
            round.layer.cornerRadius = round.frame.size.width/2;
            round.clipsToBounds = YES;
            round.tag = i+100;
            [self addSubview:round];
            
            i++;
            [self addSubview:title];
        }
        
        self.frame = CGRectMake(0, 0, ([titleArray count] * 2 - 1) * 30, 40);
    }
    return self;
}

-(void) topTitleAction:(id) sender
{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UILabel *currentLabel = (UILabel *)((UITapGestureRecognizer *)sender).view;
        [self setHighlightOfIndex:currentLabel.tag-1000];
    }
}

-(void) setHighlightOfIndex:(int)tag
{
    for (int i=0 ; i < 3; i++) {
        if (tag == i) {
            UILabel *label = (UILabel *)[self viewWithTag:i+1000];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:15.0f];
            label.alpha = 1.0f;
            
            UILabel *round = (UILabel *)[self viewWithTag:i+100];
            round.alpha = 1.0;
            
            if ([_delegate respondsToSelector:@selector(sliderLabelView:selectOfIndex:)]) {
                [_delegate sliderLabelView:self selectOfIndex:i];
            }
            
        }else{
            UILabel *label = (UILabel *)[self viewWithTag:i+1000];
            label.textColor = [UIColor groupTableViewBackgroundColor];
            label.alpha = 0.5f;
            label.font = [UIFont systemFontOfSize:14.0f];
            
            UILabel *round = (UILabel *)[self viewWithTag:i+100];
            round.alpha = 0.0;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
