//
//  PostMenuVC.m
//  utree
//
//  Created by 科研部 on 2019/9/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PostMenuVC.h"
#import "PostNoticeVC.h"
#import "SelectSubjectsVC.h"
#import "SelectReadClassVC.h"
@interface PostMenuVC ()
@property(nonatomic,strong) MyRelativeLayout *rootLayout;
@end

@implementation PostMenuVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    CGRect rect =self.bounds;
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.frame = rect;
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.2;
    
    UIButton *postNoticeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 86, 120)];
//    postNoticeBtn setimage
    [postNoticeBtn setImage:[UIImage imageNamed:@"btn_post_notice"]  forState:UIControlStateNormal];
    [postNoticeBtn setTitle:@"发布通知" forState:UIControlStateNormal];
    postNoticeBtn.titleLabel.font = [CFTool font:14];
    [postNoticeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    postNoticeBtn.imageView.frame = CGRectMake(0, 0, 64, 64);
    postNoticeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [postNoticeBtn setImageEdgeInsets:UIEdgeInsetsMake(-postNoticeBtn.imageView.frame.size.height,(postNoticeBtn.frame.size.width-postNoticeBtn.imageView.frame.size.height)/2,0, 0)];//图片距离右边框距离减少图片的宽度
     [postNoticeBtn setTitleEdgeInsets:UIEdgeInsetsMake(postNoticeBtn.imageView.frame.size.height,-postNoticeBtn.imageView.frame.size.width,0,-6)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离根据实际情况调整
    postNoticeBtn.bottomPos.equalTo(self.bottomPos).offset(110);
    postNoticeBtn.myLeft = 49;
    [postNoticeBtn addTarget:self  action:@selector(postToNotice:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [closeBtn setImage:[UIImage imageNamed:@"ic_close_round"] forState:UIControlStateNormal];
    closeBtn.myCenterX = 0;
    closeBtn.topPos.equalTo(postNoticeBtn.bottomPos).offset(40);
    [closeBtn addTarget:self action:@selector(dismissMenuView) forControlEvents:UIControlEventTouchUpInside];
    
    
     UIButton *postWorkBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 86, 120)];
    //    postNoticeBtn setimage
    [postWorkBtn setImage:[UIImage imageNamed:@"btn_post_homework"]  forState:UIControlStateNormal];
    [postWorkBtn setTitle:@"布置作业/任务" forState:UIControlStateNormal];
    postWorkBtn.titleLabel.font = [CFTool font:14];
    [postWorkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    postWorkBtn.imageView.frame = CGRectMake(0, 0, 64, 64);
    postWorkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [postWorkBtn setImageEdgeInsets:UIEdgeInsetsMake(-postWorkBtn.imageView.frame.size.height,(postWorkBtn.frame.size.width-postWorkBtn.imageView.frame.size.height)/2,0, 0)];//图片距离右边框距离减少图片的宽度
     [postWorkBtn setTitleEdgeInsets:UIEdgeInsetsMake(postWorkBtn.imageView.frame.size.height,-postWorkBtn.imageView.frame.size.width,0,-6)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离根据实际情况调整
    postWorkBtn.bottomPos.equalTo(self.bottomPos).offset(110);
    postWorkBtn.rightPos.equalTo(self.rightPos).offset(40);
    
     [postWorkBtn addTarget:self  action:@selector(postToHomework:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rootLayout addSubview:postNoticeBtn];
    [self.rootLayout addSubview:postWorkBtn];
    [self.rootLayout addSubview:closeBtn];
    
}


- (void)showMenuView {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [self.rootLayout addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenuView)]];
    //遮罩
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.5;
    }];
    [window addSubview:self.rootLayout];
    self.rootLayout.transform = CGAffineTransformMakeTranslation(0.01, ScreenWidth);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.rootLayout.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
    }];
}
 
- (void)dismissMenuView {
    [UIView animateWithDuration:0.3 animations:^{
        self.rootLayout.transform = CGAffineTransformMakeTranslation(0.01, ScreenWidth);
        self.rootLayout.alpha = 0.2;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.rootLayout removeFromSuperview];

    }];
}


-(void)postToNotice:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(postNotice:)]) {
           [self.delegate postNotice:sender];
    }
    [self dismissMenuView];
}

-(void)postToHomework:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(postHomework:)]) {
        [self.delegate postHomework:sender];
    }
    [self dismissMenuView];
}
@end
