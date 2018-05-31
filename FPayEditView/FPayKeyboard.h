//
//  FPayKeyboard.h
//  JieApp
//
//  Created by 梁显杰 on 2018/5/31.
//  Copyright © 2018年 jie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FPayInputConfig.h"

//键盘
@interface FPayKeyboard : UIView
- (instancetype)initWithFrame:(CGRect)frame config:(FPayInputConfig *)config;
@property(copy ,nonatomic) void (^didSelectBlock)(UIButton *btn);
@end

