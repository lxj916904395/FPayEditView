- (FPayEditView *)payEditView{
    if (!_payEditView) {
        FPayInputConfig *config = [FPayInputConfig new];
        config.inputViewHeight = kFloatFit(70);
        config.inputTextFieldInsets = UIEdgeInsetsMake(15, 25, 15, 25);
        config.inputFont = kFitFont(16);
        config.inputColor = grayColor;
        config.inputTinColor = themeColor;
        config.inputBolderColor = color_f0f0f0;
        config.keyboardBackGroundColor = color_f0f0f0;
        config.keyboardLineColor = lightGrayColor;
        config.keyboardTextColor = blackColor;
        config.keyboardConfirmBackGroundColor = themeColor;
        config.keyboardTextFont = kFitFont(16);
        config.keyboardConfirmTextColor = whiteColor;
        config.keyboardHeight = kFloatFit(270);
        config.inputMaxLength = 20;
        config.inputTextFieldPlaceholder = @"请输入购买数量";
        _payEditView = [[FPayEditView alloc] initWithFrame:keyWindow.bounds config:config];
        _payEditView.delegate = self;
    }
    return _payEditView;
}

#pragma mark - FPayEditViewDelegate
- (void)payInputViewDoHide:(FPayEditView *)payInputView{
    //隐藏编辑框
}

- (void)payInputView:(FPayEditView *)payInputView doSelectConfirm:(NSString *)inputText{
    if (FStringIsEmpty(inputText)) {
        showErrorMessage(@"请输入购买数量");
       
    }else{
        [payInputView hiden];
        //点击确认
        [self.paymentView show];
    }
}
