//
//  PostMenuVC.m
//  utree
//
//  Created by 科研部 on 2019/9/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PostMenuVC.h"
#import "PostNoticeVC.h"
#import "PostHomeworkVC.h"
@interface PostMenuVC ()

@end

@implementation PostMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView
{
    CGRect rect =self.view.bounds;
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.frame = rect;
    self.view = rootLayout;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];

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
    postNoticeBtn.bottomPos.equalTo(self.view.bottomPos).offset(110);
    postNoticeBtn.myLeft = 49;
    [postNoticeBtn addTarget:self  action:@selector(postNotice:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [closeBtn setImage:[UIImage imageNamed:@"ic_close_round"] forState:UIControlStateNormal];
    closeBtn.myCenterX = 0;
    closeBtn.topPos.equalTo(postNoticeBtn.bottomPos).offset(40);
    [closeBtn addTarget:self action:@selector(closeVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    postWorkBtn.bottomPos.equalTo(self.view.bottomPos).offset(110);
    postWorkBtn.rightPos.equalTo(self.view.rightPos).offset(40);
    
     [postWorkBtn addTarget:self  action:@selector(postHomework:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:postNoticeBtn];
    [self.view addSubview:postWorkBtn];
    [self.view addSubview:closeBtn];
    
}


-(void)closeVC:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(void)postNotice:(id)sender
{
    PostNoticeVC *postVC = [[PostNoticeVC alloc]init];
//    [self.navigationController pushViewController:postVC animated:YES];
    postVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:postVC animated:YES completion:nil];
    [self.navigationController pushViewController:postVC animated:YES];

}

-(void)postHomework:(id)sender
{
    PostHomeworkVC *postVC = [[PostHomeworkVC alloc]init];
    //    [self.navigationController pushViewController:postVC animated:YES];
    postVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:postVC animated:YES completion:nil];
//    [self.navigationController pushViewController:postVC animated:YES];
}
@end
