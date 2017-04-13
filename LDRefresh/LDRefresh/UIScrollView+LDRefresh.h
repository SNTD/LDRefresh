//
//  UIScrollView+LDRefresh.h
//  LDRefresh
//
//  Created by lidi on 10/6/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LDRefreshHeaderView;
@class LDRefreshFooterView;

typedef void(^LDRefreshedHandler)(void);
@interface UIScrollView (LDRefresh)

//header
@property (strong, nonatomic) LDRefreshHeaderView *refreshHeader;
- (LDRefreshHeaderView *)addRefreshHeaderWithHandler:(LDRefreshedHandler)refreshHandler;
//For header Extend
- (LDRefreshHeaderView *)addRefreshHeader:(LDRefreshHeaderView *)refreshHeaderView handler:(LDRefreshedHandler)refreshHandler;

//footer
@property (strong, nonatomic) LDRefreshFooterView *refreshFooter;
- (LDRefreshFooterView *)addRefreshFooterWithHandler:(LDRefreshedHandler)refreshHandler;
//For footer Extend
- (LDRefreshFooterView *)addRefreshFooter:(LDRefreshFooterView *)refreshFooterView handler:(LDRefreshedHandler)refreshHandler;

//去除内存泄漏，在dealloc方法中调用
- (void)removeRefreshHeader;

@end
