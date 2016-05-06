//
//  HomePageViewController.m
//  微博个人主页
//
//  Created by zenglun on 16/5/4.
//  Copyright © 2016年 chengchengxinxi. All rights reserved.
//

#import "HomePageViewController.h"
#import "BaseTableViewController.h"
#import "LeftTableViewController.h"
#import "MiddleTableViewController.h"
#import "RightTableViewController.h"
#import "TableViewScrollingProtocol.h"
#import "HMSegmentedControl.h"
#import "ColorUtility.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width 
#define kScrrenHeight [UIScreen mainScreen].bounds.size.height
#define headerImgHeight 200 // 头部图片
#define topBarHeight 64  // 导航栏加状态栏高度

@interface HomePageViewController () <TableViewScrollingProtocol>

@property (nonatomic, weak) UIView *navView;
@property (nonatomic, strong) HMSegmentedControl *segCtrl;
@property (nonatomic, strong) NSArray  *titleList;
@property (nonatomic, weak) UIViewController *showingVC;

@property (nonatomic, strong) NSMutableDictionary *offsetYDict; // 存储每个tableview在Y轴上的偏移量

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleList = @[@"主页", @"微博", @"相册"];
    
    [self configNav];
    [self addController];
    [self addSegmentedControl];
    [self segmentedControlChangedValue:_segCtrl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

#pragma mark - BaseTabelView Delegate
- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY{
    if (offsetY > headerImgHeight - topBarHeight) {
        if (![_segCtrl.superview isEqual:self.view]) {
            [self.view addSubview:_segCtrl];
        }
        CGRect rect = self.segCtrl.frame;
        rect.origin.y = topBarHeight;
        self.segCtrl.frame = rect;
    } else {
        if (![_segCtrl.superview isEqual:tableView]) {
            [tableView addSubview:_segCtrl];
        }
        CGRect rect = self.segCtrl.frame;
        rect.origin.y = headerImgHeight;
        self.segCtrl.frame = rect;
    }
    
    if (offsetY > 0) {
        CGFloat alpha = (offsetY-36)/100;
        self.navView.alpha = alpha;
        
        if (alpha > 0.5) {
            self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        } else {
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        }
    }
}

- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    _segCtrl.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", tableView];
    if (offsetY > headerImgHeight - topBarHeight) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= headerImgHeight - topBarHeight) {
                _offsetYDict[key] = @(headerImgHeight - topBarHeight);
            }
        }];
    } else {
        if (offsetY < headerImgHeight - topBarHeight) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        } else if (offsetY == headerImgHeight - topBarHeight) {
            _offsetYDict[addressStr] = @(offsetY);
        }
    }
}

- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    _segCtrl.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", tableView];
    if (offsetY > headerImgHeight - topBarHeight) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= headerImgHeight - topBarHeight) {
                _offsetYDict[key] = @(headerImgHeight - topBarHeight);
            }
        }];
    } else {
        if (offsetY < headerImgHeight - topBarHeight) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        } else if (offsetY == headerImgHeight - topBarHeight) {
            _offsetYDict[addressStr] = @(offsetY);
        }
    }
}

- (void)tableViewWillBeginDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    _segCtrl.userInteractionEnabled = NO;
}

- (void)tableViewWillBeginDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    _segCtrl.userInteractionEnabled = NO;
}

#pragma mark - Private
- (void)configNav {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, kScreenWidth, 20)];
//    titleLabel.backgroundColor = [UIColor blackColor];
    titleLabel.text = @"我帮你打水";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    navView.alpha = 0;
    [self.view addSubview:navView];
    
    _navView = navView;
}

- (void)addController {
    LeftTableViewController *vc1 = [[LeftTableViewController alloc] init];
    vc1.delegate = self;
    MiddleTableViewController *vc2 = [[MiddleTableViewController alloc] init];
    vc2.delegate = self;
    RightTableViewController *vc3 = [[RightTableViewController alloc] init];
    vc3.delegate = self;
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self addChildViewController:vc3];
}

- (void)addSegmentedControl {
    HMSegmentedControl *segCtrl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, headerImgHeight, kScreenWidth, 40)];
    self.segCtrl = segCtrl;
    
    segCtrl.backgroundColor = [ColorUtility colorWithHexString:@"e9e9e9"];
    segCtrl.sectionTitles = _titleList;
    segCtrl.selectionIndicatorHeight = 2.0f;
    segCtrl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segCtrl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segCtrl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:15]};
    segCtrl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [ColorUtility colorWithHexString:@"fea41a"]};
    segCtrl.selectionIndicatorColor = [ColorUtility colorWithHexString:@"fea41a"];
    segCtrl.selectedSegmentIndex = 0;
    
    [segCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl*)sender {
    [_showingVC.view removeFromSuperview];
    
    BaseTableViewController *newVC = self.childViewControllers[sender.selectedSegmentIndex];
    if (!newVC.view.superview) {
        [self.view addSubview:newVC.view];
        newVC.view.frame = self.view.bounds;
    }
    
    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", newVC.view];
    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
    newVC.tableView.contentOffset = CGPointMake(0, offsetY);
    
    [self.view insertSubview:newVC.view belowSubview:self.navView];
    if (offsetY <= headerImgHeight - topBarHeight) { // 如果offsetY大于136的话，此时_segCtrl应该加在主控制器View上
        [newVC.view addSubview:_segCtrl];
        CGRect rect = self.segCtrl.frame;
        rect.origin.y = headerImgHeight;
        self.segCtrl.frame = rect;
    } else {
        [self.view addSubview:_segCtrl];
        CGRect rect = self.segCtrl.frame;
        rect.origin.y = topBarHeight;
        self.segCtrl.frame = rect;
    }
    _showingVC = newVC;
}

#pragma mark - Getter/Setter
- (NSMutableDictionary *)offsetYDict {
    if (!_offsetYDict) {
        _offsetYDict = [NSMutableDictionary dictionary];
        for (BaseTableViewController *vc in self.childViewControllers) {
            NSString *addressStr = [NSString stringWithFormat:@"%p", vc.view];
            _offsetYDict[addressStr] = @(CGFLOAT_MIN);
        }
    }
    return _offsetYDict;
}

@end
