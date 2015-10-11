//
//  LDZhihuRefreshHeadView.m
//  LDRefresh
//
//  Created by lidi on 10/11/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import "LDZhihuRefreshHeaderView.h"
#import "LDZhihuArrow.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define TextColor [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]
#define TextFont  [UIFont systemFontOfSize:12.0f]

@interface LDZhihuRefreshHeaderView ()
@property (nonatomic, strong) UILabel *statusLab;
@property (nonatomic, strong) LDZhihuArrow *zhihuArrow;
@end

@implementation LDZhihuRefreshHeaderView

- (NSDictionary *)stateTextDic{
    return @{@"normalText" : @"载入上一篇",
             @"pullingText" : @"载入上一篇",
             @"loadingText" : @"载入上一篇"
             };
}

- (CGFloat)dragHeightThreshold {
    return LDRefreshHeaderHeight;
}

- (void)drawRefreshView {
    self.frame = CGRectMake(0, -LDRefreshHeaderHeight, ScreenWidth, LDRefreshHeaderHeight);
    
    CGFloat TopMargin = 15.0f;
    CGFloat bottomMargin = 15.0f;
    
    _statusLab = [[UILabel alloc] init];
    _statusLab.frame = CGRectMake(0, TopMargin, ScreenWidth, 12.0f);
    _statusLab.font = TextFont;
    _statusLab.textColor = TextColor;
    _statusLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_statusLab];
    
    _zhihuArrow = [[LDZhihuArrow alloc] initWithFrame:CGRectMake(ScreenWidth/2.0 - kArrowWidth/2.0, LDRefreshHeaderHeight - bottomMargin, kArrowWidth, kArrowUpDownHeight)];
    [self addSubview:_zhihuArrow];
}

- (void)normalAnimation{
    _statusLab.text = self.stateTextDic[@"normalText"];
    
    [_zhihuArrow showUpArrow];
}

- (void)pullingAnimation{
    _statusLab.text = self.stateTextDic[@"pullingText"];
    
    [_zhihuArrow showLine];
}

- (void)loadingAnimation {
    _statusLab.text = self.stateTextDic[@"loadingText"];
    
    [_zhihuArrow showLine];
}
@end
