//
//  LDJingdongRefreshHeaderView.m
//  LDRefresh
//
//  Created by lidi on 10/11/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import "LDJingdongRefreshHeaderView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define TextColor [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]
#define TextFont  [UIFont systemFontOfSize:12.0f]

@interface LDJingdongRefreshHeaderView ()
@property (nonatomic, strong) UILabel *statusLab;
@end

@implementation LDJingdongRefreshHeaderView

- (NSDictionary *)stateTextDic{
    return @{@"normalText" : @"上拉查看图文详情",
             @"pullingText" : @"释放查看图文详情",
             @"loadingText" : @"释放查看图文详情"
             };
}

- (CGFloat)dragHeightThreshold {
    return LDRefreshHeaderHeight;
}

- (void)drawRefreshView {
    self.frame = CGRectMake(0, -LDRefreshHeaderHeight, ScreenWidth, LDRefreshHeaderHeight);
    
    CGFloat TopMargin = 0;
    
    _statusLab = [[UILabel alloc] init];
    _statusLab.frame = CGRectMake(0, TopMargin, ScreenWidth, LDRefreshHeaderHeight);
    _statusLab.font = TextFont;
    _statusLab.textColor = TextColor;
    _statusLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_statusLab];
}

- (void)normalAnimation{
    _statusLab.text = self.stateTextDic[@"normalText"];
}

- (void)pullingAnimation{
    _statusLab.text = self.stateTextDic[@"pullingText"];
}

- (void)loadingAnimation {
    _statusLab.text = self.stateTextDic[@"loadingText"];
}
@end
