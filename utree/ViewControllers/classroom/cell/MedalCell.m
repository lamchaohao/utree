//
//  MedalCell.m
//  utree
//
//  Created by 科研部 on 2019/10/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MedalCell.h"

@implementation MedalCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self creatItemView];
    }
    return self;
}

-(void)creatItemView
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    MyFrameLayout *rootLayout = [MyFrameLayout new];
    rootLayout.frame = CGRectMake(0, 0, ScreenWidth*0.26, ScreenWidth*0.333);
    
    self.medalImgView = [[UIImageView alloc]init];
    self.medalMaskView =[[UIImageView alloc]init];
    
    self.medalProgressView = [[MedalProgressView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth*0.26*0.7, 60) andProgress:10];
    self.medalProgressView.myLeft=self.medalProgressView.myRight=14;
    self.medalProgressView.bottomPos.equalTo(self.medalImgView.bottomPos).offset(-25);
    
    NSString *maskPath =[[NSBundle mainBundle]pathForResource:@"medal_locked" ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:maskPath];
    self.medalImgView = [[UIImageView alloc]initWithImage:img];
    self.medalMaskView =[[UIImageView alloc]initWithImage:img];

    
    [rootLayout addSubview:self.medalImgView];
    [rootLayout addSubview:self.medalMaskView];
    [rootLayout addSubview:self.medalProgressView];
    [self addSubview:rootLayout];
}

-(void)setDataToviewWithMedalImagePath:(NSString *)medalPath progress:(CGFloat)prg needMask:(BOOL)mask
{
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:medalPath ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    [self.medalImgView setImage:img];
    [self.medalProgressView setProgressForView:prg];
    [self.medalMaskView setHidden:!mask];
}


@end
