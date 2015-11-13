//
//  ZhihuRefreshDemoController.m
//  LDRefresh
//
//  Created by lidi on 10/11/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import "ZhihuRefreshDemoController.h"
#import "LDZhihuRefreshFooterView.h"
#import "LDZhihuRefreshHeaderView.h"
#import "UIScrollView+LDRefresh.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define FirstTableColor [UIColor whiteColor]
#define SecondTableColor [UIColor whiteColor]

@interface ZhihuRefreshDemoController ()
//UI
@property (nonatomic, strong)   UITableView *firstTableView;
@property (nonatomic, strong)   UITableView *secondTableView;

//Data
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ZhihuRefreshDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.title = @"琅琊榜";
    
    self.firstTableView = ({
        UITableView *tableView                 = [[UITableView alloc] init];
        tableView.backgroundColor              = [UIColor groupTableViewBackgroundColor];
        tableView.delegate                     = (id<UITableViewDelegate>)self;
        tableView.dataSource                   = (id<UITableViewDataSource>)self;
        tableView.separatorStyle               = UITableViewCellSelectionStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        
        tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
        tableView;
    });
    
    self.secondTableView = ({
        UITableView *tableView                 = [[UITableView alloc] init];
        tableView.backgroundColor              = [UIColor groupTableViewBackgroundColor];
        tableView.delegate                     = (id<UITableViewDelegate>)self;
        tableView.dataSource                   = (id<UITableViewDataSource>)self;
        tableView.separatorStyle               = UITableViewCellSelectionStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        
        tableView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - 64);
        tableView;
    });
    
    [self addRefresh];
    _dataArray = @[@"江湖传言：“江左梅郎，麒麟之才，得之可得天下。”作为天下第一大帮“江左盟”的首领，梅长苏“梅郎”之名响誉江湖。然而，有着江湖至尊地位的梅长苏，却是一个病弱青年、弱不禁风，背负着十多年前巨大的冤案与血海深仇，就连身世背后也隐藏着巨大的秘密...",@"原来，十二年前，南梁大通年间，北魏兴兵南下，赤焰军少帅林殊随父出征、率七万将士抗击敌军，不料七万将士因奸佞陷害含冤埋骨梅岭。林殊从地狱之门拾回残命，历经至亲尽失、削骨易容之痛，化身天下第一大帮江左盟盟主梅长苏。\r\n十二年后,梅长苏假借养病之机、凭一介白衣之身重返帝都，从此踏上复仇、雪冤与夺嫡之路。面对曾有婚约的霓凰郡主（刘涛饰）、旧时的挚友靖王（王凯饰）以及过去熟悉的所有，他只能默默隐忍着一切，于看似不经意间，以病弱之躯只手掀起波波血影惊涛，辅佐明君靖王登上皇位，为七万赤焰忠魂洗雪了污名..."];
}

- (void)addRefresh {
    //_footerView
    __weak __typeof(self)weakSelf = self;
    self.firstTableView.refreshFooter = [self.firstTableView addRefreshFooter:[[LDZhihuRefreshFooterView alloc] init] handler:^{
        [weakSelf loadMoreData];
    }];
    self.firstTableView.refreshFooter.autoLoadMore = NO;

    //_headerView
    self.secondTableView.refreshHeader = [self.secondTableView addRefreshHeader:[[LDZhihuRefreshHeaderView alloc] init] handler:^{
        [weakSelf refreshData];
    }];
}

- (void)refreshData {
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame                   = weakSelf.secondTableView.frame;
        frame.origin.y                 = 64;
        weakSelf.firstTableView.frame  = frame;

        frame                          = weakSelf.secondTableView.frame;
        frame.origin.y                 = kScreenHeight;
        weakSelf.secondTableView.frame = frame;
    } completion:^(BOOL finished) {
        [weakSelf.secondTableView.refreshHeader endRefresh];
    }];
    
}

- (void)loadMoreData {
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame                   = weakSelf.firstTableView.frame;
        frame.origin.y                 = - (kScreenHeight - 64);
        weakSelf.firstTableView.frame  = frame;

        frame                          = weakSelf.secondTableView.frame;
        frame.origin.y                 = 64;
        weakSelf.secondTableView.frame = frame;
    } completion:^(BOOL finished) {
        [weakSelf.firstTableView.refreshFooter endRefresh];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.numberOfLines = 0;
    }
    
    if (tableView == self.firstTableView) {
        cell.backgroundColor = FirstTableColor;
        cell.textLabel.text = _dataArray[0];
    }else {
        cell.backgroundColor = SecondTableColor;
        cell.textLabel.text = _dataArray[1];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (tableView == self.firstTableView) {
        height = self.firstTableView.frame.size.height;
    }else {
        height = self.secondTableView.frame.size.height;
    }
    return height;
}
@end
