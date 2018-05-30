//
//  NumEditView.h
//  LeGu
//
//  Created by 梁显杰 on 2018/5/25.
//  Copyright © 2018年 zhongding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPayKeyboard.h"
#import "FPayTextFieldView.h"

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



