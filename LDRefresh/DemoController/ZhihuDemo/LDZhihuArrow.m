//
//  LDZhihuArrow.m
//  LDRefresh
//
//  Created by lidi on 10/11/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import "LDZhihuArrow.h"

CGFloat kArrowWidth = 26.0f;
CGFloat kArrowLineHeight = 4.0f;
CGFloat kArrowUpDownHeight = 6.0f;

#define arrowStrokeColor [UIColor colorWithRed:197/255.0 green:200/255.0 blue:214/255.0 alpha:1.0].CGColor
#define arrowFillColor [UIColor groupTableViewBackgroundColor].CGColor

@interface LDZhihuArrow ()
@property (nonatomic, strong) CAShapeLayer *arrowLayer;
@end
@implementation LDZhihuArrow

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0.0, 0.0, kArrowWidth, kArrowUpDownHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.arrowLayer = ({
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            //线高
            shapeLayer.strokeColor = arrowStrokeColor;
            shapeLayer.lineWidth = kArrowLineHeight;
            //填充线中空的颜色
            shapeLayer.fillColor = arrowFillColor;
            shapeLayer.lineCap = kCALineCapRound;
            [self.layer addSublayer:shapeLayer];
            
            shapeLayer;
        });

        //默认
        [self showLine];
    }
    return self;
}

- (CGPathRef)drawArrowPath:(CGFloat)offsetY{
    UIBezierPath *line = [UIBezierPath bezierPath];
    CGFloat arrowOriginX = 0.0f;
    CGFloat arrowOriginY = 0.0f;
    
    CGPoint originPoint = CGPointMake(arrowOriginX, arrowOriginY);
    CGPoint endPoint = CGPointMake(arrowOriginX + kArrowWidth, arrowOriginY);
    CGPoint controlPoint1 = CGPointMake(arrowOriginX + kArrowWidth/2.0, arrowOriginY + offsetY);
    
    //起始点到中点
    [line moveToPoint:originPoint];
    [line addLineToPoint:controlPoint1];
    //中点到终点
    [line moveToPoint:controlPoint1];
    [line addLineToPoint:endPoint];
    
    return [line CGPath];
}

- (void)showLine {
    _arrowLayer.path = [self drawArrowPath:0.0f];
}

- (void)showUpArrow {
    _arrowLayer.path = [self drawArrowPath:-kArrowUpDownHeight];
}

- (void)showDownArrow {
    _arrowLayer.path = [self drawArrowPath:kArrowUpDownHeight];
}
@end
