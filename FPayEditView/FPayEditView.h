//
//  NumEditView.h
//  LeGu
//
//  Created by 梁显杰 on 2018/5/25.
//  Copyright © 2018年 zhongding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPayInputConfig : NSObject
@property(assign ,nonatomic) CGFloat inputViewHeight;//输入框superview的高度
@property(assign ,nonatomic) UIEdgeInsets inputTextFieldInsets;//输入框距离superview的间距

@property(strong ,nonatomic) NSString *inputTextFieldPlaceholder;//输入框默认文字
@property(strong ,nonatomic) UIFont * inputFont;//输入框文字大小
@property(strong ,nonatomic) UIColor * inputColor;//输入框文字颜色
@property(strong ,nonatomic) UIColor * inputTinColor;//输入框光标颜色
@property(strong ,nonatomic) UIColor * inputBolderColor;//输入框边框颜色

@property(strong ,nonatomic) UIColor * keyboardBackGroundColor;//键盘背景色
@property(strong ,nonatomic) UIColor * keyboardLineColor;//键盘分割线颜色

@property(strong ,nonatomic) UIColor * keyboardTextColor;//键盘文字颜色
@property(strong ,nonatomic) UIColor * keyboardConfirmBackGroundColor;//键盘确定键背景色
@property(strong ,nonatomic) UIFont * keyboardTextFont;//键盘文字大小

@property(strong ,nonatomic) UIColor * keyboardConfirmTextColor;//键盘确定键文字颜色
@property(assign ,nonatomic) CGFloat keyboardHeight;//键盘高度
@property(assign ,nonatomic) NSInteger inputMaxLength;//最大输入长度
@property(strong ,nonatomic) UIImage * keyboardDeleteImage;//键盘删除键图标
@property(strong ,nonatomic) UIImage * keyboardHideImage;//键盘隐藏键图标


@end

@protocol FPayEditViewDelegate;
@interface FPayEditView : UIView
- (instancetype)initWithFrame:(CGRect)frame config:(FPayInputConfig *)config;

@property(weak ,nonatomic) id<FPayEditViewDelegate>delegate;
- (void)show;
- (void)hiden;
@end

@protocol FPayEditViewDelegate<NSObject>
//点击确定
- (void)payInputView:(FPayEditView *)payInputView doSelectConfirm:(NSString *)inputText;
//收起
- (void)payInputViewDoHide:(FPayEditView *)payInputView;

@end

//输入框
@interface FPayTextFieldView : UIView
@property (strong, nonatomic) UITextField *inputTextField;
- (instancetype)initWithFrame:(CGRect)frame config:(FPayInputConfig *)config;
@end

//键盘
@interface FPayKeyboard : UIView
- (instancetype)initWithFrame:(CGRect)frame config:(FPayInputConfig *)config;
@property(copy ,nonatomic) void (^didSelectBlock)(UIButton *btn);
@end

