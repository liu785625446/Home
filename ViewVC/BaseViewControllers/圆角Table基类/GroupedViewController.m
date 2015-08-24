//
//  GroupedViewController.m
//  FIS
//
//  Created by 刘军林 on 14-3-4.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "GroupedViewController.h"

@interface GroupedViewController ()

@end

@implementation GroupedViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.baseTableView) {
            
            CGFloat cornerRadius = 4.f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
            CAShapeLayer *selectedLayer = [[CAShapeLayer alloc] init];
            
            CGMutablePathRef borderPathRef = CGPathCreateMutable();
            CGRect bounds0 = CGRectInset(cell.bounds, 0.5, 0.5);
            
//            勾画边界
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                
                CGPathAddRoundedRect(borderPathRef, nil, bounds0, cornerRadius, cornerRadius);
                
            } else if (indexPath.row == 0) {
                
                CGPathMoveToPoint(borderPathRef, nil, CGRectGetMinX(bounds0), CGRectGetMaxY(bounds0));//left bottom
                CGPathAddArcToPoint(borderPathRef, nil, CGRectGetMinX(bounds0), CGRectGetMinY(bounds0), CGRectGetMidX(bounds0), CGRectGetMinY(bounds0), cornerRadius);
                
                CGPathAddArcToPoint(borderPathRef, nil, CGRectGetMaxX(bounds0), CGRectGetMinY(bounds0), CGRectGetMaxX(bounds0), CGRectGetMidY(bounds0), cornerRadius);
                CGPathAddLineToPoint(borderPathRef, nil, CGRectGetMaxX(bounds0), CGRectGetMaxY(bounds0));
                
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(borderPathRef, nil, CGRectGetMinX(bounds0), CGRectGetMinY(bounds0));//left top
                CGPathAddArcToPoint(borderPathRef, nil, CGRectGetMinX(bounds0), CGRectGetMaxY(bounds0), CGRectGetMidX(bounds0), CGRectGetMaxY(bounds0), cornerRadius);
                CGPathAddArcToPoint(borderPathRef, nil, CGRectGetMaxX(bounds0), CGRectGetMaxY(bounds0), CGRectGetMaxX(bounds0), CGRectGetMidY(bounds0), cornerRadius);
                CGPathAddLineToPoint(borderPathRef, nil, CGRectGetMaxX(bounds0), CGRectGetMinY(bounds0));
            } else {
                CGPathAddRect(borderPathRef, nil, CGRectInset(cell.bounds, 0.5, 0));
            }
            
            borderLayer.path = borderPathRef;
            borderLayer.fillColor = [[UIColor lightGrayColor] CGColor];

            CFRelease(borderPathRef);
            cornerRadius = 4.f;
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 1, 1);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds0));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds0));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds0));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds0));
            } else {
                CGPathAddRect(pathRef, nil, CGRectInset(cell.bounds, 1, 0));
                addLine = YES;
            }
            layer.path = pathRef;
            selectedLayer.path = pathRef;
            CFRelease(pathRef);
            layer.fillColor = [UIColor whiteColor].CGColor;

            selectedLayer.fillColor = [[UIColor blueColor] CGColor];
            borderLayer.zPosition = 0.0f;
            borderLayer.strokeColor = [UIColor whiteColor].CGColor;
            borderLayer.lineWidth = 0.2;
            borderLayer.lineCap = kCALineCapRound;
            borderLayer.lineJoin = kCALineJoinRound;
            
            [borderLayer addSublayer:layer];
            if (addLine == YES) {

            }
            //add general view
            
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:borderLayer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
            
            //add selected layer view;
            UIView *testView2 = [[UIView alloc] initWithFrame:bounds];
            [testView2.layer insertSublayer:selectedLayer atIndex:0];
            testView2.backgroundColor = UIColor.clearColor;
            cell.selectedBackgroundView = testView2;
        }
    }
}
@end
