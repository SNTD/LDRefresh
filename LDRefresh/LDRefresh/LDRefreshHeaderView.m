//
//  LDRefreshHeaderView.m
//  LDRefresh
//
//  Created by lidi on 10/6/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import "LDRefreshHeaderView.h"

typedef NS_ENUM(NSInteger, LDRefreshState) {
    LDRefreshStateNormal = 1,
    LDRefreshStatePulling = 2,
    LDRefreshStateLoading = 3,
};

const CGFloat LDRfreshHeaderHeight = 60;

#define TextColor [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]
#define TextFont  [UIFont systemFontOfSize:12.0f]

@interface LDRefreshHeaderView ()
//UI
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong)  UILabel *statusLabel;
@property (nonatomic, strong)  UIImageView *arrowImage;
@property (nonatomic, strong)  UIActivityIndicatorView *activityView;

//Data
@property (nonatomic, assign)  UIEdgeInsets initEdgeInset;
@property (nonatomic, strong) NSDictionary *stateTextDic;
@property (nonatomic, assign) BOOL needLoadingAnimation;//default YES

@property (nonatomic, copy) LDRefreshedHandler refreshHandler;
@property (nonatomic, assign) LDRefreshState refreshState;
@end

@implementation LDRefreshHeaderView

- (void)dealloc{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

+ (instancetype)refreshHeaderWithHandler:(LDRefreshedHandler)refreshHandler {
    LDRefreshHeaderView *header = [[LDRefreshHeaderView alloc] init];
    header.refreshHandler = refreshHandler;
    return header;
}

- (instancetype)init {
    if (self = [super init]) {

        [self drawRefreshView];
        
        [self initData];
    }
    return self;
}

- (void)drawRefreshView {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, -LDRfreshHeaderHeight, screenWidth, LDRfreshHeaderHeight);
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.frame = CGRectMake(0, 0, screenWidth, LDRfreshHeaderHeight);
    _statusLabel.font = TextFont;
    _statusLabel.textColor = TextColor;
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_statusLabel];
    
    //orgin.y=10 special adapt
    _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grayArrow"]];
    _arrowImage.frame = CGRectMake(screenWidth/2.0 - 50, 10, 15, 40);
    [self addSubview:_arrowImage];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.color = TextColor;
    _activityView.frame = _arrowImage.frame;
    [self addSubview:_activityView];
}

- (void)initData {
    _needLoadingAnimation = YES;
    
    _stateTextDic = @{@"normalText" : @"下拉刷新",
                      @"pullingText" : @"释放更新",
                      @"loadingText" : @"加载中..."
                     };
    
    self.refreshState = LDRefreshStateNormal;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView != scrollView) {
        _initEdgeInset = scrollView.contentInset;
        _scrollView = scrollView;
        [_scrollView addSubview:self];
        
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange];
    }
}

- (void)scrollViewContentOffsetDidChange {
    if (self.refreshState == LDRefreshStateLoading) {
        return;
    }
    
    if (self.scrollView.isDragging) {
        if (self.dragHeight < LDRfreshHeaderHeight) {
            self.refreshState = LDRefreshStateNormal;
        }else {
            self.refreshState = LDRefreshStatePulling;
        }
    } else {
        if (self.refreshState == LDRefreshStatePulling) {
            self.refreshState = LDRefreshStateLoading;
        }
    }
}

- (CGFloat)dragHeight {
    return (self.scrollView.contentOffset.y + _initEdgeInset.top) * -1.0;
}

- (void)setRefreshState:(LDRefreshState)refreshState {
    if (_refreshState != refreshState) {
        _refreshState = refreshState;
        
        switch (refreshState) {
            case LDRefreshStateNormal: {
                _statusLabel.text = self.stateTextDic[@"normalText"];
                _arrowImage.hidden = NO;
                [_activityView stopAnimating];
                
                [UIView animateWithDuration:0.3 animations:^{
                    _arrowImage.transform = CGAffineTransformIdentity;
                    self.scrollView.contentInset = _initEdgeInset;
                }];
                break;
            }
                
            case LDRefreshStatePulling: {
                _statusLabel.text = self.stateTextDic[@"pullingText"];
                
                [UIView animateWithDuration:0.3 animations:^{
                    _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                }];
                
                break;
                
            }
                
            case LDRefreshStateLoading: {
                if (self.needLoadingAnimation) {
                    _statusLabel.text = self.stateTextDic[@"loadingText"];
                    
                    [_activityView startAnimating];
                    _arrowImage.hidden = YES;
                    _arrowImage.transform = CGAffineTransformIdentity;
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        UIEdgeInsets edgeInset = _initEdgeInset;
                        edgeInset.top += LDRfreshHeaderHeight;
                        self.scrollView.contentInset = edgeInset;
                    }];
                }
                
                if (self.refreshHandler) {
                    self.refreshHandler();
                }
                break;
            }
        }
    }
}

- (void)startRefresh {
    self.refreshState = LDRefreshStateLoading;
}

- (void)endRefresh {
    self.refreshState = LDRefreshStateNormal;
}

- (void)setNeedLoadingAnimation:(BOOL)needLoadingAnimation {
    if (needLoadingAnimation != _needLoadingAnimation) {
        _needLoadingAnimation = needLoadingAnimation;
        
        if (_needLoadingAnimation) {
            [_arrowImage removeFromSuperview];
            [self addSubview:_arrowImage];
        }else {
            [_arrowImage removeFromSuperview];
        }
    }
}

- (void)setStateTextDic:(NSDictionary *)stateTextDic {
    _stateTextDic = stateTextDic;
    
    [self refreshStatusLabel];
}

- (void)refreshStatusLabel {
    switch (_refreshState) {
        case LDRefreshStateNormal: {
            _statusLabel.text = self.stateTextDic[@"normalText"];
            break;
        }
        case LDRefreshStatePulling: {
            _statusLabel.text = self.stateTextDic[@"pullingText"];
            break;
        }
        case LDRefreshStateLoading: {
            _statusLabel.text = self.stateTextDic[@"loadingText"];
            break;
        }
    }
}
@end
