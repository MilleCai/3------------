//
//  ViewController.m
//  3行代码集成下拉-上拉刷新
//
//  Created by mj on 13-9-13.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"

@interface ViewController () <MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    NSMutableArray *_data;
}
@end

@implementation ViewController
// 打开音响，附有下拉刷新的音效
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    
    // 假数据
    _data = [NSMutableArray array];
}

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
     
    
    dispatch_async(  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        usleep(5000000);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH : mm : ss.SSS";
        if (_header == refreshView) {
            for (int i = 0; i<5; i++) {
                [_data insertObject:[formatter stringFromDate:[NSDate date]] atIndex:0];
            }
            
        } else {
            for (int i = 0; i<5; i++) {
                [_data addObject:[formatter stringFromDate:[NSDate date]]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
             [NSTimer scheduledTimerWithTimeInterval:0.1 target:self.tableView selector:@selector(reloadData) userInfo:nil repeats:NO];
        });
        
    });
    
    
  
   
}

- (void)dealloc
{
    // 释放资源
    [_footer free];
    [_header free];
}

#pragma mark 数据源-代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 让刷新控件恢复默认的状态
    [_header endRefreshing];
    [_footer endRefreshing];
    
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"lufy.jpeg"];
    cell.textLabel.text = _data[indexPath.row];
    cell.detailTextLabel.text = @"上面的是刷新时间";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
@end