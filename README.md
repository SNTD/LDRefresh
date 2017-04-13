GitHub 上下拉刷新项目代码已不少，为何还写LDRefresh呢？

1.追求简洁, 微博5.4.0上下拉没有时间显示, 甚是喜欢, 于是有了LDRefresh。

2.高扩展性: 平时定制GitHub的上下拉刷新代码时发现代码过于繁琐，不易修改，代码简单的项目可扩展性又不强，LDRefresh代码通俗易懂, 在做到简单的同时不失扩展性， 在理解上下拉刷新要素的基础上，你在本代码之上稍加修改，便能实现大部分软件的上下拉刷新效果！

3.为了说明LDRefresh的高扩展性，除微博之外还写了几个Demo 

(1)知乎回答:箭头是通过UIBezierPath绘制的, 根据拖拽距离控制中点。

(2)京东商品详情页: 下拉时根据拖拽距离做了颜色渐变 。

(3)途牛上下拉刷新:感谢[CALayerAnimationDemo](https://github.com/wuwen1030/CALayerAnimationDemo)开源了双向注水动画的实现，对此Demo稍加修改，便实现了途牛上下拉刷新。

### 效果演示

![](https://github.com/sntd/LDRefresh/raw/master/Picture/LDRefresh.gif)



![](https://github.com/sntd/LDRefresh/raw/master/Picture/LDRefresh_Tuniu.gif)



### Demo说明

微博5.4.0:LDRefresh效果, demo中第一次上拉刷新LoadMoreEnabled默认是使能的，第二次置成了NO所以无法上拉加载更多了，重新下拉刷新会置成YES。

### 功能说明:

支持tableView，collectionView， webView 以及所有继承自scrollView的控件。

具体使用查看Demo代码，刷新结束注意调用endRefresh,并且在UIViewController的dealloc方法中移除绑定的refreshHeader，否则会有内存问题！

``` objective-c
//下拉刷新
_tableView.refreshHeader = [_tableView addRefreshHeaderWithHandler:^ {
}];

//上拉加载更多
_tableView.refreshFooter = [_tableView addRefreshFooterWithHandler:^ {
}];

//移除绑定的方法，防止内存问题
-(void)dealloc {
    [_tableView removeRefreshHeader];
}

```