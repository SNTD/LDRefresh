//
//  UIScrollView+LDRefresh.m
//  LDRefresh
//
//  Created by lidi on 10/6/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import "UIScrollView+LDRefresh.h"
#import "LDRefreshHeaderView.h"
#import "LDRefreshFooterView.h"
#import <objc/runtime.h>

@implementation UIScrollView (LDRefresh)

#pragma mark - refreshHeader
static const void * LDRefreshHeaderViewKey = (void *)@"LDRefreshHeaderViewKey";

- (void)setRefreshHeader:(LDRefreshHeaderView *)refreshHeader
{
    if (refreshHeader != self.refreshHeader) {
        [self.refreshHeader removeFromSuperview];
        [self addSubview:refreshHeader];
        
        objc_setAssociatedObject(self, &LDRefreshHeaderViewKey,
                                 refreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (LDRefreshHeaderView *)refreshHeader
{
    return objc_getAssociatedObject(self, &LDRefreshHeaderViewKey);
}

- (LDRefreshHeaderView *)addRefreshHeaderWithHandler:(LDRefreshedHandler)refreshHandler {
    
    LDRefreshHeaderView *refreshHeader = [LDRefreshHeaderView refreshHeaderWithHandler:refreshHandler];
    [refreshHeader setValue:self forKey:@"scrollView"];
    return refreshHeader;
    
}
#pragma mark - footer
static const void * LDRefreshFooterViewKey = (void *)@"LDRefreshFooterViewKey";
- (void)setRefreshFooter:(LDRefreshFooterView *)refreshFooter
{
    if (refreshFooter != self.refreshFooter) {
        [self.refreshFooter removeFromSuperview];
        [self addSubview:refreshFooter];

        objc_setAssociatedObject(self, &LDRefreshFooterViewKey,
                                 refreshFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (LDRefreshFooterView *)refreshFooter
{
    return objc_getAssociatedObject(self, &LDRefreshFooterViewKey);
}

- (LDRefreshFooterView *)addRefreshFooterWithHandler:(LDRefreshedHandler)refreshHandler {
    
    LDRefreshFooterView *refreshfooter = [LDRefreshFooterView refreshFooterWithHandler:refreshHandler];
    [refreshfooter setValue:self forKey:@"scrollView"];
    return refreshfooter;
}
@end