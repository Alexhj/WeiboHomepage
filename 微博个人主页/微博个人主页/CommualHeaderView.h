//
//  CommualHeaderView.h
//  微博个人主页
//
//  Created by zenglun on 16/5/5.
//  Copyright © 2016年 chengchengxinxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommualHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHiddenHeightCons;


@end


