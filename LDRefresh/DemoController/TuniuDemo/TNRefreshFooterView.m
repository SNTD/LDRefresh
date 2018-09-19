//
//  TNRefreshFooterView.m
//  LDRefresh
//
//  Created by lidi on 11/12/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import "TNRefreshFooterView.h"
#import "TNActivityIndicator.h"
#import "TNInjectionAnimation.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define TextColor [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]
#define TextFont  [UIFont systemFontOfSize:12.0f]

@interface TNRefreshFooterView ()

@property (nonatomic, strong) UILabel *statusLab;
@property (nonatomic, strong) TNActivityIndicator  *loadingIndicator;
@property (nonatomic, strong) TNInjectionAnimation *injectionView;

@end

@implementation TNRefreshFooterView

- (NSDictionary *)stateTextDic{
    return @{@"normalText"  : @"上拉加载...",
             @"pullingText" : @"释放加载...",
             @"loadingText" : @"努力加载中..."
             };
}

- (CGFloat)dragHeightThreshold {
    return LDRefreshFooterHeight;
}

- (void)drawRefreshView {
    self.frame = CGRectMake(0, -LDRefreshFooterHeight, ScreenWidth, LDRefreshFooterHeight);
    
    self.statusLab = ({
        UILabel *lab      = [[UILabel alloc] init];
        lab.frame         = CGRectMake(0, 0, ScreenWidth, LDRefreshFooterHeight);
        lab.font          = TextFont;
        lab.textColor     = TextColor;
        lab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab];
        
        lab;
    });
    
    self.injectionView = ({
        TNInjectionAnimation *view = [[TNInjectionAnimation alloc] initWithFrame:CGRectMake(ScreenWidth/2.0 - 60 - 10,(LDRefreshFooterHeight - 30)/2.0, 30, 30)];
        [self addSubview:view];
        
        view;
    });
    
    self.loadingIndicator = ({
        TNActivityIndicator *loadingIndicator = [[TNActivityIndicator alloc] initWithFrame:_injectionView.frame];
        loadingIndicator.hidesWhenStopped     = YES;
        [self addSubview:loadingIndicator];
        
        loadingIndicator;
    });
}

- (void)normalAnimation{
    _statusLab.text = self.stateTextDic[@"normalText"];
    
    _injectionView.hidden = NO;
    [_injectionView refreshMaskLayerPosition:self.dragHeight];
    
    [_loadingIndicator stopAnimating];
}

- (void)pullingAnimation{
    _statusLab.text = self.stateTextDic[@"pullingText"];
    
    [_injectionView refreshMaskLayerPosition:self.dragHeight];
}

- (void)loadingAnimation {
    _statusLab.text = self.stateTextDic[@"loadingText"];
    
    _injectionView.hidden = YES;
    [_loadingIndicator startAnimating];
}
@end

