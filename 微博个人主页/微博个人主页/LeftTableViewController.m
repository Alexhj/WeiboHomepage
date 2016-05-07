//
//  LeftTableViewController.m
//  微博个人主页
//
//  Created by zenglun on 16/5/4.
//  Copyright © 2016年 chengchengxinxi. All rights reserved.
//

#import "LeftTableViewController.h"

@interface LeftTableViewController ()

@end

@implementation LeftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"homePage";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID
                ];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"主页 %zd", indexPath.row];
    
    return cell;
}

@end
