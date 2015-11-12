//
//  TNActivityIndicator.m
//  TuNiuApp
//
//  Created by Ben on 14/11/3.
//  Copyright (c) 2014年 Tuniu. All rights reserved.
//

#import "TNActivityIndicator.h"

@interface TNActivityIndicator ()

@property (nonatomic, strong) UIImageView *animateCircle;

@end

@implementation TNActivityIndicator

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_logo"]];
    [self addSubview:logo];
    
    _animateCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_indicator"]];
    [self addSubview:_animateCircle];
}

- (void)startAnimating
{
    CAAnimation *exiestAnimation = [self.animateCircle.layer animationForKey:@"rotate"];
    if (exiestAnimation)
    {
        return;
    }
    
    self.hidden = NO;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0;
    animation.toValue = @(2*M_PI);
    animation.repeatCount = HUGE_VALF;
    animation.duration = 1.0f;
    [self.animateCircle.layer addAnimation:animation forKey:@"rotate"];
}

- (void)stopAnimating
{
    if (self.hidesWhenStopped)
    {
        self.hidden = YES;
    }
    [self.animateCircle.layer removeAllAnimations];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    self.bounds = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
}

@end
