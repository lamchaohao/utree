//
//  DropLevelProgressView.m
//  utree
//
//  Created by 科研部 on 2019/9/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "DropLevelProgressView.h"

@interface DropLevelProgressView()

@property(nonatomic,strong)UIView *progressView;
@property(nonatomic,strong)UILabel *currentScoreLabel;
@property(nonatomic,strong)UIImageView *indicatorView;
@property(nonatomic,strong)UIView *markPointViews;
@end

@implementation DropLevelProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCustomView];
        
    }
    return self;
    
}

- (void)setProgress:(CGFloat)progress andMaxValue:(CGFloat)maxValue
{
    if (progress>1) {
        progress/=100;
    }
    //进度条
    self.progressView.frame = CGRectMake(0, 40, self.frame.size.width*progress, 10);
    int progressInt = (int)100*progress;
    [self.currentScoreLabel setText:[NSString stringWithFormat:@"%d",progressInt]];
    self.currentScoreLabel.frame=CGRectMake(self.frame.size.width*progress-9, 20, 20, 17);
    self.indicatorView.frame=CGRectMake(self.frame.size.width*progress-5, 37, 12, 14);
    
    for (UIView *subView in [self.markPointViews subviews]) {
        [subView removeFromSuperview];
    }
    for (int value=0; value<=maxValue; value+=maxValue/5) {
         UILabel *markPoint=[[UILabel alloc]init];
         CGFloat x= self.frame.size.width*(value*1.0/maxValue);
         markPoint.frame =CGRectMake(x, 0, 12, 12);
         if (value==maxValue) {
             markPoint.frame=CGRectMake(self.frame.size.width-12, 0, 12, 12);
         }
         markPoint.textColor= [UIColor whiteColor];
         markPoint.font =[UIFont systemFontOfSize:12];
         [markPoint setText:[NSString stringWithFormat:@"%d",value]];
         [markPoint sizeToFit];

         [self.markPointViews addSubview:markPoint];
     }
}

-(void)createCustomView
{
    CGFloat progress = 0.374;
    CGFloat maxValue = 200;
    if (progress>1) {
        progress/=100;
    }
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 18)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text=@"本学期任务进度：";
    
    
    CGRect parentFrame = self.frame;
    UIView *mainProgress = [[UIView alloc]init];//总进度
    mainProgress.frame = CGRectMake(0, 40, parentFrame.size.width, 10);
    mainProgress.backgroundColor = [UIColor myColorWithHexString:@"#ADECED"];
    
    self.progressView = [[UIView alloc]init];
    self.progressView.frame = CGRectMake(0, 40, parentFrame.size.width*progress, 10);
    self.progressView.backgroundColor = [UIColor myColorWithHexString:@"#3CB3EE"];
    
    mainProgress.layer.cornerRadius = 4.5;
    self.progressView.layer.cornerRadius = 4.5;
    
    [self addSubview:titleLabel];
    [self addSubview:mainProgress];
    [self addSubview:self.progressView];
    
    self.indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pb_drop_indicator"]];
    self.indicatorView.frame=CGRectMake(parentFrame.size.width*progress-5, 37, 12, 14);
    
    self.currentScoreLabel = [[UILabel alloc]init];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pb_drop_score_rect"]];
    [self.currentScoreLabel setBackgroundColor:color];
    int progressInt = (int)100*progress;
    [self.currentScoreLabel setText:[NSString stringWithFormat:@"%d",progressInt]];
    self.currentScoreLabel.frame=CGRectMake(parentFrame.size.width*progress-9, 20, 20, 17);
    self.currentScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.currentScoreLabel.textColor = [UIColor whiteColor];
    self.currentScoreLabel.font = [UIFont systemFontOfSize:9];
    
    [self addSubview:self.indicatorView];
    [self addSubview:self.currentScoreLabel];
    
    
//    for (int progs=0; progs<=200; progs+=40) {
//        UILabel *startPoint=[[UILabel alloc]init];
//
//        startPoint.frame = CGRectMake(parentFrame.size.width*progs/100/2, parentFrame.size.height-2, 12, 12);
//        if (progs==200) {
//            startPoint.frame=CGRectMake(parentFrame.size.width*progs/100/2-12, parentFrame.size.height-2, 12, 12);
//        }
//        startPoint.textColor= [UIColor whiteColor];
//        startPoint.font =[UIFont systemFontOfSize:12];
//        [startPoint setText:[NSString stringWithFormat:@"%d",progs]];
//        [startPoint sizeToFit];
//        [self addSubview:startPoint];
//    }
    self.markPointViews = [[UIView alloc]initWithFrame:CGRectMake(0, 56, 12, 12)];
    NSLog(@"parentFrame.size.height=%f",parentFrame.size.height);
    for (int value=0; value<=maxValue; value+=maxValue/5) {
        UILabel *markPoint=[[UILabel alloc]init];
        CGFloat x= parentFrame.size.width*(value*1.0/maxValue);
        markPoint.frame =CGRectMake(x, 0, 12, 12);
        if (value==maxValue) {
            markPoint.frame=CGRectMake(parentFrame.size.width-12, 0, 12, 12);
        }
        markPoint.textColor= [UIColor whiteColor];
        markPoint.font =[UIFont systemFontOfSize:12];
        [markPoint setText:[NSString stringWithFormat:@"%d",value]];
        [markPoint sizeToFit];
        [self.markPointViews addSubview:markPoint];
    }
    [self addSubview:self.markPointViews];
}

@end
