//
//  LDJingdongRefreshHeaderView.m
//  LDRefresh
//
//  Created by lidi on 10/11/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import "LDJingdongRefreshHeaderView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define TextColor(alphaValue) [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:alphaValue]
#define TextFont  [UIFont systemFontOfSize:12.0f]

static const CGFloat initAlpha = 0;

@interface LDJingdongRefreshHeaderView ()
@property (nonatomic, strong) UILabel *statusLab;
@end

@implementation LDJingdongRefreshHeaderView

- (NSDictionary *)stateTextDic{
    return @{@"normalText" : @"下拉查看商品详情",
             @"pullingText" : @"释放查看商品详情",
             @"loadingText" : @"释放查看商品详情"
             };
}

- (CGFloat)dragHeightThreshold {
    return LDRefreshHeaderHeight;
}

- (void)drawRefreshView {
    self.frame = CGRectMake(0, -LDRefreshHeaderHeight, ScreenWidth, LDRefreshHeaderHeight);
    
    _statusLab = [[UILabel alloc] init];
    _statusLab.frame = CGRectMake(0, 0, ScreenWidth, LDRefreshHeaderHeight);
    _statusLab.font = TextFont;
    _statusLab.textColor = TextColor(initAlpha);
    _statusLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_statusLab];
}

- (void)normalAnimation{
    _statusLab.text = self.stateTextDic[@"normalText"];
    
    CGFloat canNotSeeStatusLabHeight = (self.dragHeightThreshold - 12.0f)/2.0;
    _statusLab.textColor = TextColor((initAlpha + (self.dragHeight - canNotSeeStatusLabHeight))/(self.dragHeightThreshold - canNotSeeStatusLabHeight)*(1 - initAlpha));
}

- (void)pullingAnimation{
    _statusLab.text = self.stateTextDic[@"pullingText"];
    
    _statusLab.textColor = TextColor(1.0);

}

- (void)loadingAnimation {
    _statusLab.text = self.stateTextDic[@"loadingText"];
    _statusLab.textColor = TextColor(1.0);
}
@end
