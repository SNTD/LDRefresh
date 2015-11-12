//
//  TNInjectionAnimation.h
//  LDRefresh
//  途牛双向注水动画
//  Created by lidi on 11/12/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TNInjectionAnimation : UIView
- (instancetype)initWithFrame:(CGRect)frame;

- (void)refreshMaskLayerPosition:(CGFloat)dragHeight;
@end
