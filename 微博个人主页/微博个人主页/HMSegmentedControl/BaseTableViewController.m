//
//  BaseTableViewController.m
//  微博个人主页
//
//  Created by zenglun on 16/5/4.
//  Copyright © 2016年 chengchengxinxi. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CommualHeaderView.h"

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.showsHorizontalScrollIndicator  = NO;
    
    CommualHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"CommualHeaderView" owner:nil options:nil] lastObject];
    headerView.label.text = @"我帮你打水";
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if ([self.delegate respondsToSelector:@selector(tableViewScroll:offsetY:)]) {
        [self.delegate tableViewScroll:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewWillBeginDragging:offsetY:)]) {
        [self.delegate tableViewWillBeginDragging:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewWillBeginDecelerating:offsetY:)]) {
        [self.delegate tableViewWillBeginDecelerating:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewDidEndDragging:offsetY:)]) {
        [self.delegate tableViewDidEndDragging:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewDidEndDecelerating:offsetY:)]) {
        [self.delegate tableViewDidEndDecelerating:self.tableView offsetY:offsetY];
    }
}




@end
