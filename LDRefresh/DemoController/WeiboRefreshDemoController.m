//
//  WeiboRefreshDemoController.m
//  LDRefresh
//
//  Created by lidi on 10/6/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import "WeiboRefreshDemoController.h"
#import "LDRefreshFooterView.h"
#import "LDRefreshHeaderView.h"
#import "UIScrollView+LDRefresh.h"

@interface WeiboRefreshDemoController ()
//UI
@property (nonatomic, strong)   UITableView *tableView;

//Data
@property (nonatomic, assign) NSInteger data;
@end

@implementation WeiboRefreshDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.title = @"微博上下拉加载";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.height - 64)];
    _tableView.delegate = (id<UITableViewDelegate>)self;
    _tableView.dataSource = (id<UITableViewDataSource>) self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
    _data = 20;
    [self addRefreshView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView.refreshHeader startRefresh];
}

- (void)addRefreshView {
    
    __weak __typeof(self) weakSelf = self;

    //下拉刷新
    _tableView.refreshHeader = [_tableView addRefreshHeaderWithHandler:^ {
        [weakSelf refreshData];
    }];
    
    //上拉加载更多
    _tableView.refreshFooter = [_tableView addRefreshFooterWithHandler:^ {
        [weakSelf loadMoreData];
    }];
//    _footerView.autoLoadMore = NO;
}

- (void)refreshData {
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _data = 20;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.refreshHeader endRefresh];
        
        weakSelf.tableView.refreshFooter.loadMoreEnabled = YES;
    });
}

- (void)loadMoreData {
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _data += 20;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.refreshFooter endRefresh];
        
        weakSelf.tableView.refreshFooter.loadMoreEnabled = NO;
    });
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}
@end
