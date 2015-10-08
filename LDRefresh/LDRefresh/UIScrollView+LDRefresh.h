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

//footer
@property (strong, nonatomic) LDRefreshFooterView *refreshFooter;
- (LDRefreshFooterView *)addRefreshFooterWithHandler:(LDRefreshedHandler)refreshHandler;

@end
