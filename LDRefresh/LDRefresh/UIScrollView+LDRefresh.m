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

@implementation UIScrollView (LDRefresh)

- (LDRefreshHeaderView *)addHeaderWithRefreshHandler:(LDRefreshedHandler)refreshHandler {
    
    LDRefreshHeaderView *header = [LDRefreshHeaderView headerWithRefreshHandler:refreshHandler];
    [header setValue:self forKey:@"scrollView"];
    return header;
    
}

- (LDRefreshFooterView *)addFooterWithRefreshHandler:(LDRefreshedHandler)refreshHandler {
    
    LDRefreshFooterView *footer = [LDRefreshFooterView footerWithRefreshHandler:refreshHandler];
    [footer setValue:self forKey:@"scrollView"];
    return footer;
}

@end