//
//  AwardResultView.m
//  utree
//
//  Created by 科研部 on 2019/11/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AwardResultView.h"

@interface AwardResultView()

@property(nonatomic,strong)MyRelativeLayout *contentView;
@property(nonatomic,strong)NSString *stuName;
@property(nonatomic,strong)NSString *dropScore;
@property(nonatomic,strong)NSString *stuNumber;
@property(nonatomic,assign)BOOL isMulti;
@end

@implementation AwardResultView

- (instancetype)initWithFrame:(CGRect)frame stuNum:(NSString *)number
{
    self = [super initWithFrame:frame];
    if (self) {
        _isMulti= YES;
        self.stuNumber = number;
        [self createCustomUI];
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame stuName:(NSString *)stuName score:(NSString *)score
{
    self = [super initWithFrame:frame];
    if (self) {
        _isMulti= NO;
        self.dropScore = score;
        self.stuName = stuName;
        [self createCustomUI];
    }
    return self;
}


-(void)createCustomUI
{
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.2;
    [self createContentView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView:)];
    [self addGestureRecognizer:recognizer];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 90)];
    NSString *picPath =[[NSBundle mainBundle] pathForResource:@"pic_award_success" ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:picPath];
    [imageView setImage:img];
    imageView.myTop=26;
    imageView.myCenterX=0;
    
    
    UILabel *awardSuccessLabel = [UILabel new];
    [awardSuccessLabel setText:@"奖励成功！"];
    awardSuccessLabel.font= [UIFont systemFontOfSize:16];
    [awardSuccessLabel sizeToFit];
    
    awardSuccessLabel.topPos.equalTo(imageView.bottomPos).offset(5);
    awardSuccessLabel.myCenterX=0;
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.textColor = [UIColor myColorWithHexString:@"#999999"];
    tipsLabel.font=[UIFont systemFontOfSize:13];
    if (_isMulti) {
        NSString *tipsStr = [NSString stringWithFormat:@"奖励%@人成功",self.stuNumber];
        NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:tipsStr];
        
        [abStr addAttribute:NSForegroundColorAttributeName value:[UIColor myColorWithHexString:@"#F8A21A"] range:NSMakeRange(2, self.stuNumber.length)];
        
        tipsLabel.attributedText = abStr;
    }else{
        NSString *tipsStr = [NSString stringWithFormat:@"奖励%@+%@滴",self.stuName,self.dropScore];
        NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:tipsStr];
        
        [abStr addAttribute:NSForegroundColorAttributeName value:[UIColor myColorWithHexString:@"#F8A21A"] range:NSMakeRange(2+self.stuName.length, self.dropScore.length+1)];
        [abStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, tipsStr.length)];
        tipsLabel.attributedText = abStr;
    }
    
    tipsLabel.font= [UIFont systemFontOfSize:16];
    [tipsLabel sizeToFit];
    tipsLabel.topPos.equalTo(awardSuccessLabel.bottomPos).offset(5);
    tipsLabel.myCenterX=0;
    
    [_contentView addSubview:imageView];
    [_contentView addSubview:awardSuccessLabel];
    [_contentView addSubview:tipsLabel];
    
}

- (UIView *)createContentView{
    if (!_contentView) {
        _contentView =[MyRelativeLayout new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake(0, 0, ScreenWidth*0.5, ScreenWidth*0.45);
        _contentView.myCenterX=_contentView.myCenterY=0;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.opaque = YES;
        _contentView.layer.cornerRadius = 11;
        _contentView.clipsToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.borderWidth = 0;
        [self addSubview:_contentView];
    }
    return _contentView;
}



- (void)showView {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)]];
    //遮罩
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.5;
    }];
    [window addSubview:_contentView];
    
    self.contentView.transform =CGAffineTransformMakeScale(0.01,1);
    //CGAffineTransformMakeTranslation(0.01, 389);
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
    }];
    
    
    [UIView animateWithDuration:[[CSToastManager sharedStyle] fadeDuration]
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         self.contentView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer timerWithTimeInterval:1.2 target:self selector:@selector(dismissView:) userInfo:self repeats:NO];
                         [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                         objc_setAssociatedObject(self, @"AwardResultViewTimerKey", timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
    
}
 
- (void)dismissView :(id)sender{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform =CGAffineTransformMakeScale(0.01,1);
//        CGAffineTransformMakeTranslation(0.01, 389);
        self.contentView.alpha = 0.2;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.contentView removeFromSuperview];
    }];
}


@end
