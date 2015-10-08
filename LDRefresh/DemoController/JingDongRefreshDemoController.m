//
//  TaobaoRefreshDemoController.m
//  LDRefresh
//
//  Created by lidi on 10/6/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import "JingDongRefreshDemoController.h"
#import "LDRefreshFooterView.h"
#import "LDRefreshHeaderView.h"
#import "UIScrollView+LDRefresh.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define FirstTableColor [UIColor colorWithRed:119/255.0 green:210/255.0 blue:197/255.0 alpha:1.0]
#define SecondTableColor [UIColor colorWithRed:30/255.0 green:171/255.0 blue:201/255.0 alpha:1.0]

@interface JingDongRefreshDemoController ()
//UI
@property (nonatomic, strong)   UITableView *firstTableView;
@property (nonatomic, strong)   UITableView *secondTableView;

//Data
@property (nonatomic, assign) NSInteger data;
@end

@implementation JingDongRefreshDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.title = @"FirstTableView";
    
    self.firstTableView = ({
        UITableView *tableView = [[UITableView alloc] init];
        tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];

        tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
        tableView.contentInset = UIEdgeInsetsMake(0, 0, LDFooterOffsetHeight, 0);
        tableView;
    });
    
    self.secondTableView = ({
        UITableView *tableView = [[UITableView alloc] init];
        tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        
        tableView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - 64);
        tableView;
    });
    
    [self addRefresh];
    
    _data = 20;
}

- (void)addRefresh {
    //_footerView
    __weak __typeof(self)weakSelf = self;
    self.firstTableView.refreshFooter = [self.firstTableView addRefreshFooterWithHandler:^{
        [weakSelf loadMoreData];
    }];
    self.firstTableView.refreshFooter.autoLoadMore = NO;
    
    NSDictionary *upDic = @{
                            @"normalText" : @"上拉查看图文详情",
                            @"pullingText" : @"上拉查看图文详情",
                            @"loadingText" : @"上拉查看图文详情"
                            };
    [self.firstTableView.refreshFooter setValue:upDic forKey:@"stateTextDic"];
    [self.firstTableView.refreshFooter setValue:@NO forKey:@"needLoadingAnimation"];
    
    //_headerView
    self.secondTableView.refreshHeader = [self.secondTableView addRefreshHeaderWithHandler:^{
        [weakSelf refreshData];
    }];

    NSDictionary *downDic = @{
                              @"normalText" : @"下拉回到商品详情",
                              @"pullingText" : @"释放回到商品详情",
                              @"loadingText" : @"释放回到商品详情"
                              };
    [self.secondTableView.refreshHeader setValue:downDic forKey:@"stateTextDic"];
    [self.secondTableView.refreshHeader setValue:@NO forKey:@"needLoadingAnimation"];
}

- (void)refreshData {
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = weakSelf.secondTableView.frame;
        frame.origin.y = 64;
        weakSelf.firstTableView.frame = frame;
        
        frame = weakSelf.secondTableView.frame;
        frame.origin.y = kScreenHeight;
        weakSelf.secondTableView.frame = frame;
    } completion:^(BOOL finished) {
        weakSelf.title = @"FirstTableView";
        [weakSelf.secondTableView.refreshHeader endRefresh];
    }];

}

- (void)loadMoreData {
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = weakSelf.firstTableView.frame;
        frame.origin.y = - (kScreenHeight - 64);
        weakSelf.firstTableView.frame = frame;
        
        frame = weakSelf.secondTableView.frame;
        frame.origin.y = 64;
        weakSelf.secondTableView.frame = frame;
    } completion:^(BOOL finished) {
        weakSelf.title = @"SecondTableView";
        [weakSelf.firstTableView.refreshFooter endRefresh];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (tableView == self.firstTableView) {
        cell.backgroundColor = FirstTableColor;
    }else {
        cell.backgroundColor = SecondTableColor;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}
@end
