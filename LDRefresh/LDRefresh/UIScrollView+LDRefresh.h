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

- (LDRefreshHeaderView *)addHeaderWithRefreshHandler:(LDRefreshedHandler)refreshHandler;
- (LDRefreshFooterView *)addFooterWithRefreshHandler:(LDRefreshedHandler)refreshHandler;

@end
