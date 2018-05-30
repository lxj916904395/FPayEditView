//
//  FPayTextFieldView.h
//  JieApp
//
//  Created by 梁显杰 on 2018/5/30.
//  Copyright © 2018年 jie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FPayInputConfig.h"

//输入框
@interface FPayTextFieldView : UIView
@property (strong, nonatomic) UITextField *inputTextField;
- (instancetype)initWithFrame:(CGRect)frame config:(FPayInputConfig *)config;
@end
