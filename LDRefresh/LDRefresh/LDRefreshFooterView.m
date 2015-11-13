//
//  LDRefreshFooterView.m
//  LDRefresh
//
//  Created by lidi on 10/6/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import "LDRefreshFooterView.h"

typedef NS_ENUM(NSInteger, LDRefreshState) {
    LDRefreshStateNormal  = 1,
    LDRefreshStatePulling = 2,
    LDRefreshStateLoading = 3,
};

typedef void(^LDRefreshedHandler)(void);

const CGFloat LDRefreshFooterHeight = 60;

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define TextColor   [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]
#define TextFont    [UIFont systemFontOfSize:12.0f]

@interface LDRefreshFooterView ()
//UI
@property (nonatomic, strong) UIScrollView            *scrollView;
@property (nonatomic, strong) UILabel                 *statusLab;
@property (nonatomic, strong) UIImageView             *arrowImage;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

//Data
@property (nonatomic, assign) UIEdgeInsets            initEdgeInset;
@property (nonatomic, strong) NSDictionary            *stateTextDic;
@property (nonatomic, assign) CGFloat                 dragHeightThreshold;

@property (nonatomic, copy  ) LDRefreshedHandler      refreshHandler;
@property (nonatomic, assign) LDRefreshState          refreshState;
@end

@implementation LDRefreshFooterView

- (void)dealloc{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (instancetype)init {
    if (self = [super init]) {
        [self drawRefreshView];
        
        [self initData];
    }
    return self;
}

- (void)drawRefreshView {
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, ScreenWidth, LDRefreshFooterHeight);
    
    self.statusLab = ({
        UILabel *lab        = [[UILabel alloc] init];
        lab.frame           = CGRectMake(0, 0, ScreenWidth, LDRefreshFooterHeight);
        lab.font            = TextFont;
        lab.textColor       = TextColor;
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment   = NSTextAlignmentCenter;
        [self addSubview:lab];
        
        lab;
    });

    self.arrowImage = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_pull_refresh"]];
        imageView.frame        = CGRectMake(ScreenWidth/2.0 - 60,(LDRefreshFooterHeight-32)/2.0, 32, 32);
        [self addSubview:imageView];
        
        imageView;
    });

    self.indicatorView = ({
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.color                    = TextColor;
        indicatorView.frame                    = _arrowImage.frame;
        [self addSubview:indicatorView];
        
        indicatorView;
    });
}

- (void)initData {
    _loadMoreEnabled = YES;
    _autoLoadMore = YES;
    
    self.stateTextDic = @{@"normalText" : @"加载中...",
                          @"pullingText" : @"加载中...",
                          @"loadingText" : @"加载中..."
                          };
    
    self.refreshState = LDRefreshStateNormal;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView != scrollView) {
        _initEdgeInset = scrollView.contentInset;
        _scrollView    = scrollView;
        [_scrollView addSubview:self];
        
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        //init
        [self refreshFootViewFrame];
    }
}

- (void)refreshFootViewFrame {
    CGRect frame   = self.frame;
    frame.origin.y = MAX(self.scrollView.frame.size.height, self.scrollView.contentSize.height);
    self.frame     = frame;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange];
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewContentSizeDidChange];
    }
}

- (void)scrollViewContentOffsetDidChange {
    if (self.dragHeight < 0 || self.refreshState == LDRefreshStateLoading || !self.loadMoreEnabled) {
        return;
    }
    
    if (self.autoLoadMore) {
        if (self.dragHeight > 1) {
            self.refreshState = LDRefreshStateLoading;
        }
    }
    else {
        if (self.scrollView.isDragging) {
            if (self.dragHeight < self.dragHeightThreshold) {
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
}

- (void)scrollViewContentSizeDidChange {
    [self refreshFootViewFrame];
}

- (CGFloat)dragHeight {
    CGFloat contentHeight   = self.scrollView.contentSize.height;
    CGFloat tableViewHeight = self.scrollView.bounds.size.height;
    CGFloat originY         = MAX(contentHeight, tableViewHeight);
    return  self.scrollView.contentOffset.y + self.scrollView.bounds.size.height - originY - _initEdgeInset.bottom;
}

- (CGFloat)dragHeightThreshold {
    return LDRefreshFooterHeight;
}

- (void)setRefreshState:(LDRefreshState)refreshState {
    _refreshState = refreshState;
    
    switch (_refreshState) {
        case LDRefreshStateNormal: {
            [self normalAnimation];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentInset = _initEdgeInset;
            }];
            break;
        }
            
        case LDRefreshStatePulling: {
            [self pullingAnimation];
            break;
        }
            
        case LDRefreshStateLoading: {
            [self loadingAnimation];
            
            [UIView animateWithDuration:0.3 animations:^{
                UIEdgeInsets inset           = self.scrollView.contentInset;
                inset.bottom                 += LDRefreshFooterHeight;
                self.scrollView.contentInset = inset;
            }];
            if (self.refreshHandler) {
                self.refreshHandler();
            }
            break;
        }
    }
}

- (void)normalAnimation{
    _statusLab.text    = self.stateTextDic[@"normalText"];

    _arrowImage.hidden = NO;
    [_indicatorView stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
    }];
}

- (void)pullingAnimation{
    _statusLab.text = self.stateTextDic[@"pullingText"];
    
    [UIView animateWithDuration:0.3 animations:^{
        _arrowImage.transform = CGAffineTransformIdentity;
    }];
}

- (void)loadingAnimation {
    _statusLab.text    = self.stateTextDic[@"loadingText"];

    _arrowImage.hidden = YES;
    _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
    [_indicatorView startAnimating];
}

- (void)endRefresh {
    self.refreshState = LDRefreshStateNormal;
}

- (void)setAutoLoadMore:(BOOL)autoLoadMore {
    if (autoLoadMore != _autoLoadMore) {
        _autoLoadMore = autoLoadMore;
        if (_autoLoadMore) {
            //autoLoadMore not need arrowImage
            [_arrowImage removeFromSuperview];
            _arrowImage.image = nil;
            
            self.stateTextDic = @{@"normalText" : @"加载中...",
                                  @"pullingText" : @"加载中...",
                                  @"loadingText" : @"加载中..."
                                  };
        }else {
            _arrowImage.image = [UIImage imageNamed:@"grayArrow"];
            [self addSubview:_arrowImage];
            
            self.stateTextDic = @{@"normalText" : @"上拉加载",
                                  @"pullingText" : @"释放加载",
                                  @"loadingText" : @"加载中..."
                                  };
        }
    }
}

- (void)setLoadMoreEnabled:(BOOL)loadMoreEnabled {
    if (loadMoreEnabled != _loadMoreEnabled) {
        _loadMoreEnabled = loadMoreEnabled;
        
        if (_loadMoreEnabled) {
            [self removeFromSuperview];
            [self.scrollView addSubview:self];
        }else {
            [self removeFromSuperview];
        }
    }
}
@end
