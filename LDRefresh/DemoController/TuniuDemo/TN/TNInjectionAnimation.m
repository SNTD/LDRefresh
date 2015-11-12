//
//  TNInjectionAnimation.m
//  LDRefresh
//  
//  Created by lidi on 11/12/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import "TNInjectionAnimation.h"

@interface TNInjectionAnimation ()
@property (nonatomic, strong) UIImageView *grayHead;
@property (nonatomic, strong) UIImageView *greenHead;
@property (nonatomic, strong) CAShapeLayer *maskLayerUp;
@property (nonatomic, strong) CAShapeLayer *maskLayerDown;
@end

@implementation TNInjectionAnimation

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.grayHead = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            imageView.image = [UIImage imageNamed:@"bull_head_gray"];
            [self addSubview:imageView];
            
            imageView;
        });
        
        self.greenHead = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:_grayHead.frame];
            imageView.image = [UIImage imageNamed:@"bull_head_green"];
            [self addSubview:imageView];
            
            imageView;
        });
        
        self.greenHead.layer.mask = [self greenHeadMaskLayer];
    }
    return self;
}

- (void)refreshMaskLayerPosition:(CGFloat)dragHeight
{
    self.maskLayerUp.position = [self calculateUpPosition:dragHeight];
    self.maskLayerDown.position = [self calculateDownPosition:dragHeight];
}

- (CALayer *)greenHeadMaskLayer
{
    CALayer *mask = [CALayer layer];
    mask.frame = self.greenHead.bounds;
    
    self.maskLayerUp = [CAShapeLayer layer];
    self.maskLayerUp.bounds = CGRectMake(0, 0, 30.0f, 30.0f);
    self.maskLayerUp.fillColor = [UIColor greenColor].CGColor; // Any color but clear will be OK
    self.maskLayerUp.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(15.0f, 15.0f)
                                                           radius:15.0f
                                                       startAngle:0
                                                         endAngle:2*M_PI
                                                        clockwise:YES].CGPath;
    self.maskLayerUp.opacity = 0.8f;
    self.maskLayerUp.position = CGPointMake(-5.0f, -5.0f);
    [mask addSublayer:self.maskLayerUp];
    
    self.maskLayerDown = [CAShapeLayer layer];
    self.maskLayerDown.bounds = CGRectMake(0, 0, 30.0f, 30.0f);
    self.maskLayerDown.fillColor = [UIColor greenColor].CGColor; // Any color but clear will be OK
    self.maskLayerDown.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(15.0f, 15.0f)
                                                             radius:15.0f
                                                         startAngle:0
                                                           endAngle:2*M_PI
                                                          clockwise:YES].CGPath;
    self.maskLayerDown.position = CGPointMake(35.0f, 35.0f);
    [mask addSublayer:self.maskLayerDown];
    
    return mask;
}

- (CGPoint)calculateUpPosition:(CGFloat)dragHeight {
    CGFloat canSeeDragHeight = (60 - 30)/2.0;
    
    if (dragHeight >= 60.0f) {
        dragHeight = 60.0f;
    }
    CGFloat positionX;
    if (dragHeight < canSeeDragHeight) {
        positionX = -5.0f;
    }
    else if(dragHeight > 60.0f) {
        positionX = 10.f;
    }
    else {
        positionX = -5.0f + 15.0f*(dragHeight - canSeeDragHeight)/(60-canSeeDragHeight);
    }
    
    return CGPointMake(positionX, positionX);
}

- (CGPoint)calculateDownPosition:(CGFloat)dragHeight {
    CGFloat canSeeDragHeight = (60 - 30)/2.0;
    
    CGFloat positionX;
    if (dragHeight < canSeeDragHeight) {
        positionX = 35.0f;
    }
    else if(dragHeight > 60.0f) {
        positionX = 20.0f;
    }
    else {
         positionX = 35.0f - 15.0f*(dragHeight - canSeeDragHeight)/(60-canSeeDragHeight);
    }
    
    return CGPointMake(positionX, positionX);
}
@end
