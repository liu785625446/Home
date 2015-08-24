//
//  SliderLabelView.h
//  Home
//
//  Created by 刘军林 on 15/5/23.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSliderLabelView;

@protocol MSliderLabelViewDelegate <NSObject>

-(void) sliderLabelView:(MSliderLabelView *)sliderLabel selectOfIndex:(NSInteger)index;

@end

@interface MSliderLabelView : UIView

@property (nonatomic, weak) id <MSliderLabelViewDelegate> delegate;

-(id) initWithFrame:(CGRect)frame itemsTitles:(NSArray *)titleArray itemHighlight:(NSInteger)row;
-(void) setHighlightOfIndex:(int)tag;

@end
