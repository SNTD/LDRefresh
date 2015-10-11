//
//  LDZhihuArrow.h
//  LDRefresh
//
//  Created by lidi on 10/11/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDZhihuArrow : UIView

extern CGFloat kArrowWidth;
extern CGFloat kArrowLineHeight;
extern CGFloat kArrowUpDownHeight;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)showLine;
- (void)showUpArrow;
- (void)showDownArrow;
@end
