//
//  LDRefreshHeaderView.h
//  LDRefresh
//
//  Created by lidi on 10/6/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat LDRefreshHeaderHeight;

typedef void(^LDRefreshedHandler)(void);
@interface LDRefreshHeaderView : UIView

- (void)startRefresh;
- (void)endRefresh;

@end

