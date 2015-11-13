//
//  LDRefreshHeaderView.h
//  LDRefresh
//
//  Created by lidi on 10/6/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat LDRefreshHeaderHeight;

@interface LDRefreshHeaderView : UIView
@property (nonatomic, assign) CGFloat dragHeight;

- (void)startRefresh;
- (void)endRefresh;
@end

