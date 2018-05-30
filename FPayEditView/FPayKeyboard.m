//
//  FPayKeyboard.m
//  JieApp
//
//  Created by 梁显杰 on 2018/5/30.
//  Copyright © 2018年 jie. All rights reserved.
//

#import "FPayKeyboard.h"

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
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
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
                [btn setImage:self.config.keyboardDeleteImage forState:UIControlStateNormal];
                
                self.deleteBtn = btn;
            }else if (i == 12){
                //键盘隐藏键
                [btn setImage:self.config.keyboardHideImage forState:UIControlStateNormal];
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
