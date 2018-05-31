//
//  BuyEditNumView.m
//  LeGu
//
//  Created by 梁显杰 on 2018/5/24.
//  Copyright © 2018年 zhongding. All rights reserved.
//
#import "FPayEditView.h"

#import "FPayTextFieldView.h"
#import "FPayKeyboard.h"

@interface FPayEditView (){
    CGFloat _screenWidth;
    CGFloat _screenHeight;
}
@property(strong ,nonatomic) FPayTextFieldView * textfieldView;
@property(strong ,nonatomic) FPayKeyboard * keyBoard;
@property(strong ,nonatomic) FPayInputConfig * config;

@end
@implementation FPayEditView

- (instancetype)initWithFrame:(CGRect)frame config:(FPayInputConfig *)config{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        
        _screenHeight = [UIScreen mainScreen].bounds.size.height;
        _screenWidth = [UIScreen mainScreen].bounds.size.width;
        _config = config;
        
        if(!_config.inputMaxLength)_config.inputMaxLength = 10;
        
        [self addSubview:self.textfieldView];
        [self addObser];
        
        //键盘点击回调
        __weak typeof(self)weak = self;
        [self.keyBoard setDidSelectBlock:^(UIButton *btn) {
            [weak keyBoardDidSelectItem:btn];
        }];
    }
    return self;
}

//数量输入框
- (FPayTextFieldView *)textfieldView{
    if (_textfieldView == nil) {
        _textfieldView = [[FPayTextFieldView alloc] initWithFrame:CGRectMake(0, _screenHeight, _screenWidth, self.config.inputViewHeight) config:self.config];
        _textfieldView.inputTextField.inputView = self.keyBoard;
    }
    return _textfieldView;
}

//数字键盘
- (FPayKeyboard *)keyBoard{
    if (!_keyBoard) {
        _keyBoard = [[FPayKeyboard alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, self.config.keyboardHeight) config:self.config];
    }
    return _keyBoard;
}

#pragma mark - 显示、隐藏
- (void)show{
    if (!self.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    [self.textfieldView.inputTextField becomeFirstResponder];
}

- (void)hiden{
    [self.textfieldView resignFirstResponder];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)hidenView{
    [self hiden];
    //通知代理界面消失
    if (_delegate && [_delegate respondsToSelector:@selector(payInputViewDoHide:)]) {
        [_delegate payInputViewDoHide:self];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGRect rect = CGRectMake(0, 0, _screenWidth, self.textfieldView.frame.origin.y);
    //点击灰色区域
    if (CGRectContainsPoint(rect, point)) {
        [self hidenView];
    }
}


#pragma mark - FPayKeyboardDelegate 键盘输入
- (void)keyBoardDidSelectItem:(UIButton *)item{
    
    NSString *currentMoneyStr = self.textfieldView.inputTextField.text;
    
    NSMutableString *mStr = [currentMoneyStr mutableCopy];
    NSInteger index = item.tag-10;
    switch (index) {
        case 0:
        {
            if (currentMoneyStr.floatValue==0 && [currentMoneyStr containsString:@"0"] && ![currentMoneyStr containsString:@"."]) {
                break;
            } else {
                [mStr appendString:@"0"];
            }
            break;
        }
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        {
            if ([currentMoneyStr isEqualToString:@"0"]) {
                [mStr deleteCharactersInRange:NSMakeRange(0, 1)];
            }
            [mStr appendString:[@(index) stringValue]];
            break;
        }
        case 10:
        {
            if (currentMoneyStr.length==0 || [currentMoneyStr containsString:@"."]) {
                break;
            } else {
                [mStr appendString:@"."];
            }
        }
            break;
        case 11:
        {
            if (currentMoneyStr.length) {
                [mStr deleteCharactersInRange:NSMakeRange(currentMoneyStr.length-1, 1)];
            }
        }
            break;
            
        case 12:
            [self hidenView];
            break;
        case 13:
        {
            [self hiden];
            //确认代理回调
            if (_delegate && [_delegate respondsToSelector:@selector(payInputView:doSelectConfirm:)]) {
                [_delegate payInputView:self doSelectConfirm:mStr];
            }
        }
            
            break;
            
        default:
            break;
    }
    
    if (self.config.inputMaxLength &&mStr.length>self.config.inputMaxLength) {
        return;
    }
    self.textfieldView.inputTextField.text = mStr;
}

#pragma mark - 键盘坐标改变
-(void)changeKeyBoard:(NSNotification *)aNotifacation{
    
    NSNumber *duration = [aNotifacation.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [aNotifacation.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    NSValue *keyboardEndBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect=[keyboardEndBounds CGRectValue];
    
    //执行自定义动画，与键盘动画一致
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    //更改聊天窗口table的inset  位置  inputbar位置
    CGRect rect = self.textfieldView.frame;
    rect.origin.y =  endRect.origin.y-rect.size.height;
    self.textfieldView.frame = rect;
    [UIView commitAnimations];
}

//添加键盘坐标改变通知
- (void)addObser{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)removeObser{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc{
    [self removeObser];
}

@end


