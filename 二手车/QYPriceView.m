//
//  QYPriceView.m
//  二手车
//
//  Created by qingyun on 16/1/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYPriceView.h"
#import "Header.h"

@interface QYPriceView () <UITextFieldDelegate>
@property (nonatomic, strong) NSArray *dataArray;// 显示的数组
@property (nonatomic, strong) NSArray *priceArray;// 用于传递的数组

@property (nonatomic, strong) UITextField *lowTextField;// 低价格
@property (nonatomic, strong) UITextField *highTextField;// 高价格

@property (nonatomic, strong) UIButton *selectBtn;// 选中的btn

@property (nonatomic, strong) UIButton *choseBtn;

@end

@implementation QYPriceView
#pragma mark - 初始化 view
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _dataArray = @[@"不限",@"3万以下",@"3-5万",@"5-10万",@"10-15万",@"15-20万",@"20-30万", @"30-50万",@"50万以上"];
        
        // 添加子视图
        [self createAndAddSubviews];
    }
    return self;
}

#pragma mark - 懒加载
- (NSArray *)priceArray {
    if (_priceArray == nil) {
        _priceArray = @[@"0",@"0-3",@"3-5",@"5-10",@"10-15",@"15-20",@"20-30",@"30-50",@"50"];
    }
    return _priceArray;
}

#pragma mark - 添加手势
- (void)createAndAddTap:(UIView *)view {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromVC)];
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
}

// 移除视图
- (void)removeFromVC {
    if (_isCloseBlock) {
        _isCloseBlock();
    }
}

#pragma mark - 创建并添加子视图
- (void)createAndAddSubviews {
    // 价格区域视图
    [self createAndAddPriceView];
    
    // 添加下面的view 用于点击
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, self.frame.size.width, self.frame.size.height)];
    [self addSubview:tempView];
    tempView.backgroundColor = [UIColor blackColor];
    tempView.alpha = 0.5;
    // 添加手势
    [self createAndAddTap:tempView];
    
}

#pragma mark - 价格区域的视图
- (void)createAndAddPriceView {
    NSInteger selectBtnTag =  [[NSUserDefaults standardUserDefaults] integerForKey:kSelectBtnTag];
    
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 250)];
    [self addSubview:priceView];
    priceView.backgroundColor = [UIColor whiteColor];
    
    UILabel *guideLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 100, 20)];
    [priceView addSubview:guideLabel];
    guideLabel.text = @"自定义价格(万)";
    guideLabel.font = [UIFont systemFontOfSize:12];
    guideLabel.textColor = [UIColor lightGrayColor];
    
    CGFloat marginX = 8;
    CGFloat spaceX = 20;
    CGFloat spaceY = 10;
    CGFloat btnW = (self.frame.size.width - 2 * (marginX + spaceX)) / 3.0;
    CGFloat btnH = 40;

    //创建两个textField 用于输入自定义价格
    _lowTextField = [[UITextField alloc] initWithFrame:CGRectMake(marginX, 40, btnW, btnH)];
    [priceView addSubview:_lowTextField];
    _lowTextField.placeholder = @"最低";
    _lowTextField.textAlignment = NSTextAlignmentCenter;
    _lowTextField.font = [UIFont systemFontOfSize:14];
    [self addLayer:_lowTextField];
    _lowTextField.delegate = self;
    _lowTextField.keyboardType = UIKeyboardTypeNumberPad;
    _highTextField = [[UITextField alloc] initWithFrame:CGRectMake(marginX+btnW+spaceX, 40, btnW, btnH)];
    [priceView addSubview:_highTextField];
    _highTextField.placeholder = @"最高";
    _highTextField.textAlignment = NSTextAlignmentCenter;
    _highTextField.font = [UIFont systemFontOfSize:14];
    _highTextField.keyboardType = UIKeyboardTypeNumberPad;
    _highTextField.delegate = self;
    [self addLayer:_highTextField];
    
    //确定按钮
    _choseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [priceView addSubview:_choseBtn];
    _choseBtn.frame = CGRectMake(marginX+(btnW+spaceX)*2, 40, btnW, btnH);
    _choseBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_choseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _choseBtn.tag = 499;
    [_choseBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_choseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _choseBtn.layer.cornerRadius = 5;
    if (_choseBtn.tag == selectBtnTag) {
        [_choseBtn setBackgroundColor:[UIColor orangeColor]];
         NSString *priceStr = [[NSUserDefaults standardUserDefaults] stringForKey:kPrice];
        NSArray *separeArr = [priceStr componentsSeparatedByString:@"-"];
        _lowTextField.text = separeArr.firstObject;
        _highTextField.text = separeArr.lastObject;
    }else {
        [_choseBtn setBackgroundColor:[UIColor lightGrayColor]];
        _choseBtn.userInteractionEnabled = NO;
    }
    
    //添加修饰的view 和 label
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(marginX+btnW+5, 60, 10, 2)];
    [priceView addSubview:lineView];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(marginX+btnW*2+spaceX+3, 40, 15, 40)];
    [priceView addSubview:label];
    label.text = @"万";
    label.font = [UIFont systemFontOfSize:14];
    
    // 固定可选择价格的区域
    for (int i = 0; i < _dataArray.count; i++) {
        CGFloat btnX = (i % 3) * (spaceX + btnW) + marginX;
        CGFloat btnY = (i / 3) * (spaceY + btnH) + 90;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [priceView addSubview:btn];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitle:_dataArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 500 + i;
        [btn addTarget:self action:@selector(choseFixPriceBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //判断是否上次选中的btn
        if (btn.tag == selectBtnTag) {
            [btn setBackgroundColor:[UIColor orangeColor]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self addSelectBtnLayer:btn];
        }else {
            [self addLayer:btn];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

// 添加图层属性
- (void)addLayer:(id)sender {
    CALayer *layer = [sender layer];
    layer.cornerRadius = 5;
    layer.borderWidth = 1;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)addSelectBtnLayer:(UIButton *)sender {
    CALayer *layer = [sender layer];
    layer.cornerRadius = 5;
}

#pragma mark - 点击事件
// 自定义价格
- (void)btnClick:(UIButton *)sender {
    NSString *priceStr = [NSString stringWithFormat:@"%@-%@", _lowTextField.text, _highTextField.text];
     NSString *titleStr = [NSString stringWithFormat:@"%@-%@万", _lowTextField.text, _highTextField.text];
    
    // 保存选中的btn 下次进入时打开
    [[NSUserDefaults standardUserDefaults] setObject:@499 forKey:kSelectBtnTag];
    [[NSUserDefaults standardUserDefaults] setObject:priceStr forKey:kPrice];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (_changePriceBlock) {
        _changePriceBlock(priceStr, titleStr);
    }
}

// 选择价格
- (void)choseFixPriceBtn:(UIButton *)sender {
    NSInteger index = sender.tag - 500;
    
    // 保存选中的btn信息 下次进入时打开
    [[NSUserDefaults standardUserDefaults] setObject:@(sender.tag) forKey:kSelectBtnTag];
    [[NSUserDefaults standardUserDefaults] setObject:self.priceArray[index] forKey:kPrice];
    [[NSUserDefaults standardUserDefaults] setObject:_dataArray[index] forKey:KpriceBtnTitle];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (_changePriceBlock) {
        _changePriceBlock(self.priceArray[index], _dataArray[index]);
    }
}

#pragma mark - textFe
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location > 4) {
        return NO;
    }

    NSString *lowPrice;
    NSString *highPrice;
    
    // 判断当前是删除还是在输入数据5
    if (![string isEqualToString:@""]) {
        //当前在添加
        // 判断当前是哪个在编辑
        if (_lowTextField.editing == YES) {
            lowPrice = [_lowTextField.text stringByAppendingString:string];
            highPrice = _highTextField.text;
        }else {
            lowPrice = _lowTextField.text;
            highPrice = [_highTextField.text stringByAppendingString:string];
        }
    }else {
        // 删除
        if (_lowTextField.editing == YES) {
            lowPrice = [_lowTextField.text substringWithRange:NSMakeRange(0, range.location)];
            highPrice = _highTextField.text;
        }else {
            lowPrice = _lowTextField.text;
            highPrice = [_highTextField.text substringWithRange:NSMakeRange(0, range.location)];
        }
    }
    
    /** 
     *  判断输入框中数字是否合法
     *  输入框中不能为空
     *  价格低的输入框要小于高价格的输入中的数字
     */
    if (![lowPrice isEqualToString:@""] && ![highPrice isEqualToString:@""] && [lowPrice intValue] < [highPrice intValue]) {
        [_choseBtn setBackgroundColor:[UIColor orangeColor]];
        _choseBtn.userInteractionEnabled = YES;
    }else {
        [_choseBtn setBackgroundColor:[UIColor lightGrayColor]];
        _choseBtn.userInteractionEnabled = NO;
    }
    
    return YES;
}


@end
