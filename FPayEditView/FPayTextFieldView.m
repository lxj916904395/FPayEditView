//
//  FPayTextFieldView.m
//  JieApp
//
//  Created by 梁显杰 on 2018/5/31.
//  Copyright © 2018年 jie. All rights reserved.
//

#import "FPayTextFieldView.h"


#pragma mark - 输入框
@interface FPayTextFieldView ()
@property(strong ,nonatomic) FPayInputConfig * config;
@end
@implementation FPayTextFieldView
- (instancetype)initWithFrame:(CGRect)frame config:(FPayInputConfig *)config{
    if ( self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.config = config;
        [self addSubview:self.inputTextField];
    }
    return self;
}

- (void)setConfig:(FPayInputConfig *)config{
    [self.inputTextField setFrame:CGRectMake(config.inputTextFieldInsets.left, config.inputTextFieldInsets.top, self.frame.size.width-2*config.inputTextFieldInsets.left, self.frame.size.height-2*config.inputTextFieldInsets.top)];
    
    self.inputTextField.layer.borderWidth = 1;
    self.inputTextField.layer.borderColor = config.inputBolderColor.CGColor;
    self.layer.masksToBounds = NO;
    
    self.inputTextField.font = config.inputFont;
    self.inputTextField.textColor = config.inputColor;
    self.inputTextField.tintColor = config.inputTinColor;
    self.inputTextField.placeholder = config.inputTextFieldPlaceholder;
}

- (UITextField *)inputTextField{
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.textAlignment = NSTextAlignmentCenter;
    }
    return _inputTextField;
}
@end


