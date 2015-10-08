

GitHub 上下拉刷新项目代码已不少，为何还写LDRefresh呢？

1.高扩展性: 平时定制GitHub的上下拉刷新代码时发现代码过于繁琐，不易修改，代码简单的项目可扩展性又不强，LDRefresh代码通俗易懂, 在做到简单的同时不失扩展性， 在理解上下拉刷新要素的基础上，你在本代码之上稍加修改，便能实现大部分软件的上下拉刷新效果！

2.集成京东商品详情页上下拉切换:一直想实现下这个效果，此次将此功能集成了进来！

### 效果演示

![](https://github.com/sntd/LDRefresh/raw/master/Picture/LDRefresh.gif)

### Demo说明

1.微博Demo:

(一)微博最新版的上下拉刷新去除了时间显示功能，这一点我也很赞同，刷新控件就应该简约，时间显示多余了。

(二）demo中第一次上拉刷新LoadMoreEnabled默认是使能的，第二次置成了NO所以无法上拉加载更多了，重新下拉刷新会置成YES。

2.京东Demo:

 (一)淘宝商品详情页，知乎回答上下拉切换 都类似此效果


### 功能说明:

支持tableView, webView 以及所有继承自scrollView的控件。

``` objective-c
__weak __typeof(self) weakSelf = self;

//下拉刷新
_tableView.refreshHeader = [_tableView addRefreshHeaderWithHandler:^ {
    [weakSelf refreshData];
}];

//上拉加载更多
_tableView.refreshFooter = [_tableView addRefreshFooterWithHandler:^ {
    [weakSelf loadMoreData];
}];
```