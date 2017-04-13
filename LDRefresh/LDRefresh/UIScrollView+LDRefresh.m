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

- (void)removeRefreshHeader {
    self.refreshHeader = nil;
    self.refreshFooter = nil;
}

#pragma mark - refreshHeader
static const char * LDRefreshHeaderViewKey = "LDRefreshHeaderViewKey";

- (void)setRefreshHeader:(LDRefreshHeaderView *)refreshHeader
{
    if (refreshHeader != self.refreshHeader) {
        [self.refreshHeader removeFromSuperview];
        [self addSubview:refreshHeader];
        
        objc_setAssociatedObject(self, LDRefreshHeaderViewKey,
                                 refreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (LDRefreshHeaderView *)refreshHeader
{
    return objc_getAssociatedObject(self, LDRefreshHeaderViewKey);
}

- (LDRefreshHeaderView *)addRefreshHeaderWithHandler:(LDRefreshedHandler)refreshHandler {
    return [self addRefreshHeader:[[LDRefreshHeaderView alloc] init] handler:refreshHandler];
}

- (LDRefreshHeaderView *)addRefreshHeader:(LDRefreshHeaderView *)refreshHeader handler:(LDRefreshedHandler)refreshHandler {
    [refreshHeader setValue:[refreshHandler copy] forKey:@"refreshHandler"];
    [refreshHeader setValue:self forKey:@"scrollView"];
    return refreshHeader;
}

#pragma mark - refreshFooter
static const char * LDRefreshFooterViewKey = "LDRefreshFooterViewKey";

- (void)setRefreshFooter:(LDRefreshFooterView *)refreshFooter
{
    if (refreshFooter != self.refreshFooter) {
        [self.refreshFooter removeFromSuperview];
        [self addSubview:refreshFooter];

        objc_setAssociatedObject(self, LDRefreshFooterViewKey,
                                 refreshFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (LDRefreshFooterView *)refreshFooter
{
    return objc_getAssociatedObject(self, LDRefreshFooterViewKey);
}

- (LDRefreshFooterView *)addRefreshFooterWithHandler:(LDRefreshedHandler)refreshHandler {
    return [self addRefreshFooter:[[LDRefreshFooterView alloc] init] handler:refreshHandler];
}

- (LDRefreshFooterView *)addRefreshFooter:(LDRefreshFooterView *)refreshFooter handler:(LDRefreshedHandler)refreshHandler {
    [refreshFooter setValue:[refreshHandler copy] forKey:@"refreshHandler"];
    [refreshFooter setValue:self forKey:@"scrollView"];
    return refreshFooter;
}
@end
