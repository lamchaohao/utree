//
//  BaseWorkView.m
//  utree
//
//  Created by 科研部 on 2019/11/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseWorkView.h"
#import "AchievementView.h"
@interface BaseWorkView()


@end

@implementation BaseWorkView

-(UIView *)headView
{
    if (!_headView) {
        UIView *rootView = [MyRelativeLayout new];
        rootView.frame = CGRectMake(0, 0, ScreenWidth, 240);
        UILabel *tips = [UILabel new];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 230, 170)];
        NSString *picPath;
        picPath =[[NSBundle mainBundle] pathForResource:_headViewPath ofType:@"png"];
        [tips setText:self.headViewMessage];
        UIImage *img = [UIImage imageWithContentsOfFile:picPath];
        [imageView setImage:img];
        imageView.myCenterX=0;
        imageView.myCenterY=0;
        [tips sizeToFit];
        tips.textColor = [UIColor myColorWithHexString:@"#666666"];
        tips.font=[UIFont systemFontOfSize:14];
        tips.topPos.equalTo(imageView.bottomPos).offset(20);
        tips.myCenterX =0;
        
        [rootView addSubview:imageView];
        [rootView addSubview:tips];
        _headView = rootView;
    }
    
    return _headView;
}

- (void)viewWillAppear:(BOOL)animated{}

- (void)viewWillDisappear:(BOOL)animated{}

@end
