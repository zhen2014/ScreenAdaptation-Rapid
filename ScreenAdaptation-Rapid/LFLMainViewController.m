//
//  LFLMainViewController.m
//  ScreenAdaptation-Rapid
//          demo
//  Created by vintop_xiaowei on 16/1/22.
//  Copyright © 2016年 李夫龙. All rights reserved.
//
#import "LFLMainViewController.h"
#import "FrameAutoScaleLFL.h"

@interface LFLMainViewController ()

@end

@implementation LFLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    1.1 Eg: [FrameAutoScaleLFL CGLFLMakeX:30 Y:300 width:200 height:40] example Code
    [self lable_LFL];
    
//  1.2.1 Eg:[FrameAutoScaleLFL CGLFLMakeX:20 CGRectGetX:CGRectGetMaxY(lable_LFL1.frame) width:300 height:30]
    [self lable_LFL1];
//  1.2.2 Eg:设置导航栏 64 Y (不可以缩放情况使用这个) specially for height
    [self navigationUIExample];
    
//    1.3  其他CGSize CGPoint代码演示
    [self otherMethodExample];
    
#pragma mark ---2. 关于storyBorad xib 的适配解决办法-一行代码搞定全部布局.
//  1.storyBorad  (填入对应storyBorad 类名即可)
//  2. xib 类名 testXib.xib
//    仅仅演示xib代码了,storyBorad一样,一行即可
    [FrameAutoScaleLFL xibLFLAutoLayoutsWithNibClassName:@"testXib"];
//    得到 xib 的按钮
    UIView *testXib = [[[NSBundle mainBundle] loadNibNamed: @"testXib" owner:nil options:nil]firstObject];
    UIButton *btn = testXib.subviews.firstObject;
    LFLog(@"xib的按钮%@",NSStringFromCGRect(btn.frame));
    
}

#pragma mark    1.1普通使用 以下测试。请切换模拟器查看打印数据对比 是否等比例缩放 iPhone4s -6sPlus 如果公司UI图是以iphone6为基准, 直接写UI图上的坐标即可,如果其他,FrameAutoScaleLFL.h文件头文件有说明.
/**
 1.1 Eg: [FrameAutoScaleLFL CGLFLMakeX:30 Y:300 width:200 height:40]
 */
- (void)lable_LFL{
    UILabel *lable_LFL = [UILabel new];
    lable_LFL.textAlignment = NSTextAlignmentCenter;
    lable_LFL.adjustsFontSizeToFitWidth = YES;
    lable_LFL.backgroundColor = [UIColor yellowColor];
    //    Generally we wrote any View frame code like this.
    lable_LFL.frame = CGRectMake(30, 300, 200, 40);
    //  Example One :  lable_LFL iphone 6  (30 300  200  40)
    lable_LFL.frame = [FrameAutoScaleLFL CGLFLMakeX:30 Y:300 width:200 height:40];
    lable_LFL.text = NSStringFromCGRect(lable_LFL.frame);
    LFLog(@"缩放后对应坐标%@",NSStringFromCGRect(lable_LFL.frame));
    [self.view addSubview:lable_LFL];
    /**
     4/4s   :   {25 215}, {170 28}
     5/5s   :   {25 255}, {170 34}
     6/6s   :   {30 300}, {200 40}
     6p/6sp :   {33 331}, {220 44}
     */
}
#pragma mark 1.2增加 如果布局中有使用 CGRectGetMaxY() CGRectGetMaxX等方式的 新API方法
/**
1.2 Eg:[FrameAutoScaleLFL CGLFLMakeX:20 CGRectGetX:CGRectGetMaxY(lable_LFL1.frame) width:300 height:30]
 */
- (void)lable_LFL1{
    /**    获取相对上一个控件的最大X/Y,使用 [FrameAutoScaleLFL CGLFLMakeX:30 Y:CGRectGetMaxY(lable_LFL.frame) width:200 height:40] 造成问题解决
     */
    //    1.21 creat a long text label
    CGFloat begainY = 64;
    UILabel *lable_LFL1 = [UILabel new];
    lable_LFL1.layer.borderWidth = 1;
    lable_LFL1.text = @"https://github.com/LFL2018.DragonLihttps://github.com/LFL2018.DragonLi测试文字";
    CGFloat TextHeight = [self label_LFL:lable_LFL1 getHeightWithTextWidth:350];
    lable_LFL1.frame = [FrameAutoScaleLFL CGLFLMakeX:10 Y:begainY width:350 height:TextHeight];
    [self.view addSubview:lable_LFL1];
    //    1.22 此时需要在长文本下,创建其他控件.按照lable_LFL1 的最大Y 为开始值,如果使用之前方式,会二次缩放,导致比较麻烦
    //    切换5s 发现,6效果正常,5s就不对了,其他也不对
    UIView *belowTextView = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:10 Y:CGRectGetMaxY(lable_LFL1.frame) width:300 height:20]];
    belowTextView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:belowTextView];
    LFLog(@"belowTextView坐标%@",NSStringFromCGRect(lable_LFL1.frame)); // 5s 错位
    //1.23 可以使用这个新的方法 即可解决! CGRectGetMaxX() CGRectGetMinX() 同样也可以
    belowTextView.frame = [FrameAutoScaleLFL CGLFLMakeX:10 CGRectGetY:CGRectGetMaxY(lable_LFL1.frame) width:320 height:25];
    LFLog(@"belowTextView坐标%@",NSStringFromCGRect(lable_LFL1.frame)); // 正常显示
    
}
/**
1.2.2 Eg:设置导航栏 64 Y (不可以缩放情况使用这个) specially for height
 */
- (void)navigationUIExample{
    [self.navigationController.navigationBar setHidden:YES];
    UILabel *navigationBarLabel = [[UILabel alloc]init];
    navigationBarLabel.backgroundColor = [UIColor grayColor];
    navigationBarLabel.textAlignment = NSTextAlignmentCenter;
    navigationBarLabel.text = @"我的高度任何机型下都是64";
    navigationBarLabel.frame = [FrameAutoScaleLFL CGLFLMakeX:0 Y:0 width:375 heightAllSame:64];
    [self.view addSubview:navigationBarLabel];
     LFLog(@"navigationBarLabel高度%@",NSStringFromCGRect(navigationBarLabel.frame));
}
/**
 1.3  其他CGSize CGPoint代码演示
 */
- (void)otherMethodExample{
    /**********************其他代码演示********************************/
    //  1.  CGSize
    UIScrollView *SV = [UIScrollView new];
    SV.contentSize = [FrameAutoScaleLFL CGSizeLFLMakeMainScreenSize];
    LFLog(@" 全屏size%@",NSStringFromCGSize(SV.contentSize));
    SV.contentSize = [FrameAutoScaleLFL CGSizeLFLMakeWidth:200 hight:200];
    LFLog(@"CGSize%@",NSStringFromCGSize(SV.contentSize));
    
    //    2.CGPoint
    SV.center = [FrameAutoScaleLFL CGLFLPointMakeX:200 Y:200];
    LFLog(@"CGPoint%@",NSStringFromCGPoint(SV.center));
}


/**
 *  @author iOS_DragonLi
 *   根据宽度和字体计算label所占高度
 *  @param TextWidth 文本宽度
 *  @return 所占TextWidth
 */
- (CGFloat)label_LFL:(UILabel *)label_LFL getHeightWithTextWidth:(CGFloat)TextWidth
{
    NSDictionary *attribute = @{NSFontAttributeName: label_LFL.font};
    label_LFL.numberOfLines = 0;
    CGSize retSize = [label_LFL.text boundingRectWithSize:CGSizeMake(TextWidth, 0)
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    return retSize.height;
}

@end
