//
//  MMonitorCell.m
//  Home
//
//  Created by 刘军林 on 15/4/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MMonitorCell.h"
#import "Camerainfos.h"
#import "UIColor+Hex.h"

@implementation MMonitorCell

-(void) setCamerainfos:(Camerainfos *)camerainfos
{
    _monitorName.text = camerainfos.cameraName;
    _monitorImg.layer.cornerRadius = _monitorImg.frame.size.width/2;
    _monitorImg.backgroundColor = [self getImageColor];
    _selectImg.layer.cornerRadius = 5;
    _selectImg.backgroundColor = [UIColor colorWithHexString:@"#3bcd6e" alpha:1.0];
}

-(UIColor *) getImageColor
{
    int index = arc4random() % 7;
    NSArray *rgbArray = @[@"#d95a76",@"#4f82db",@"#716493",@"#25b6ed",@"#3bb096",@"#f6931f",@"#648193"];
    return [UIColor colorWithHexString:[rgbArray objectAtIndex:index] alpha:1.0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
