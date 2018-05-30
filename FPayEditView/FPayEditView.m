//
//  BuyEditNumView.m
//  LeGu
//
//  Created by 梁显杰 on 2018/5/24.
//  Copyright © 2018年 zhongding. All rights reserved.
//
#import "FPayEditView.h"
static CGFloat _screenWidth;
CGFloat _screenHeight;
@interface FPayEditView ()
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

#pragma mark - 键盘
@interface FPayKeyboard(){
    CGFloat _viewWidth;
    CGFloat _viewHeight;
}
@property(strong ,nonatomic) NSTimer * timer;
@property(strong ,nonatomic) UIButton * deleteBtn;
@property(strong ,nonatomic) FPayInputConfig * config;
@end
@implementation FPayKeyboard

- (instancetype)initWithFrame:(CGRect)frame config:(FPayInputConfig *)config{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.3f];
        _viewWidth = self.frame.size.width;
        _viewHeight = self.frame.size.height;
        _config = config;
        
        if (!_config.keyboardDeleteImage) {
            _config.keyboardDeleteImage = [UIImage imageNamed:@"ic_fkeyboard_delete"];
        }
        
        if (!_config.keyboardHideImage) {
            _config.keyboardHideImage = [UIImage imageNamed:@"ic_fkeyboard"];
        }
        
        [self _createUI];
    }
    return self;
}


- (void)_createUI{
    for (int i=0; i<14; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitleColor:self.config.keyboardTextColor forState:UIControlStateNormal];
        btn.titleLabel.font = self.config.keyboardTextFont;
        
        btn.tag = 10+i;
        
        if (i<10) {
            [btn setTitle:[@(i) stringValue] forState:UIControlStateNormal];
        } else {
            if (i == 10) {
                [btn setTitle:@"." forState:UIControlStateNormal];
            } else if (i==11) {
                //删除
                [btn setImage:[self.config.keyboardDeleteImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                
                self.deleteBtn = btn;
            }else if (i == 12){
                //键盘
                [btn setImage:[self.config.keyboardHideImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }
            else {
                //确认
                [btn setTitle:@"确认" forState:UIControlStateNormal];
                btn.backgroundColor = self.config.keyboardConfirmBackGroundColor;
                [btn setTitleColor:self.config.keyboardConfirmTextColor forState:UIControlStateNormal];
            }
        }
        
        //点击按钮，抬起手指触发点击事件
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        //为删除键添加手指按下、手指离开事件
        if ([btn isEqual:self.deleteBtn]) {
            [btn addTarget:self action:@selector(startDeleteTimer) forControlEvents:UIControlEventTouchDown];
            [btn addTarget:self action:@selector(stopDeleteTimer) forControlEvents:UIControlEventTouchUpOutside];
        }
        
        [self addSubview:btn];
    }
}

#pragma mark - 按下删除键，启动定时器，每隔0.2秒删除一个字符，抬起手指，停止定时器
- (void)startDeleteTimer{
    _timer = [NSTimer timerWithTimeInterval:.2f target:self selector:@selector(runDelete) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)stopDeleteTimer{
    if (_timer) {
        [_timer invalidate];
    }
    _timer = nil;
}

//持续按删除键，则一直调用代理方法
- (void)runDelete{
    [self delegateAction:self.deleteBtn];
}

#pragma mark - 按钮点击触发事件
- (void)click:(UIButton *)btn{
    [self stopDeleteTimer];
    //代理回调
    [self delegateAction:btn];
}

- (void)delegateAction:(UIButton *)btn{
    if (self.didSelectBlock) {
        self.didSelectBlock(btn);
    }
}

#pragma mark - 绘制线
- (void)drawRect:(CGRect)rect{
    
    CGFloat w = _viewWidth/4;
    CGFloat h = _viewHeight/4;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    for (int i=0; i<5; i++) {
        [bezierPath moveToPoint: CGPointMake(0, h*i)];
        if (i == 1) {
            [bezierPath addLineToPoint: CGPointMake(_viewWidth-w, h*i)];
            
        }else{
            [bezierPath addLineToPoint: CGPointMake(_viewWidth, h*i)];
        }
    }
    for (int i=1; i<=3; i++) {
        [bezierPath moveToPoint: CGPointMake(w*i, 0)];
        [bezierPath addLineToPoint: CGPointMake(w*i, _viewHeight)];
    }
    [[UIColor lightGrayColor] setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
}

//设置坐标
- (void)layoutSubviews{
    CGFloat w = _viewWidth/4;
    CGFloat h = _viewHeight/4;
    for (int i=1; i<=9; i++) {
        UIView *view = [self viewWithTag:i+10];
        [view setFrame:CGRectMake(w*((i-1)%3), h*((i-1)/3), w, h)];
    }
    [self viewWithTag:10].frame = CGRectMake(w, h*3, w, h);
    [self viewWithTag:20].frame = CGRectMake(0, h*3, w, h);
    [self viewWithTag:21].frame = CGRectMake(w*3, 0, w, 2*h);
    [self viewWithTag:22].frame = CGRectMake(w*2, h*3, w, h);
    [self viewWithTag:23].frame = CGRectMake(w*3, 2*h, w, h*2);
}


- (void)dealloc{
    [self stopDeleteTimer];
    NSLog(@"%s",__func__);
}

@end

@implementation FPayInputConfig
@end
