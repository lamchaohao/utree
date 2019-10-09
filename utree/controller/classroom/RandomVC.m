//
//  RandomVC.m
//  utree
//
//  Created by 科研部 on 2019/8/19.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "RandomVC.h"
#import "UIColor+ColorChange.h"
@interface RandomVC ()
@property(assign,atomic) int countPerson;
@property(atomic,strong) UILabel *countLabel;
@property(atomic,strong) UILabel *titleLabel;
@property(atomic,strong) UIButton *startRandomBtn;

@end

@implementation RandomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showView];
}

-(void)showView
{
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    self.view = rootLayout;
    
    MyFrameLayout *myTopLL = [MyFrameLayout new];
    myTopLL.myHorzMargin = 0;
    myTopLL.backgroundColor=[UIColor redColor];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0,0,ScreenWidth,490.8);
    bgView.backgroundColor = [UIColor myColorWithHexString:@"#FAFAFA"];
    bgView.layer.cornerRadius = 11;
    [self.view addSubview:bgView];
    bgView.myLeft=bgView.myRight=20;
    bgView.myCenterY=0;
    [bgView addSubview:myTopLL];

    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    
    _titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    [_titleLabel setText:@"请选择人数"];
    
    [_titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    [_titleLabel setTextColor:[UIColor blackColor]];
    _titleLabel.myTop = 20;
    _titleLabel.myCenterX = 0;            //水平居中,如果不等于0则会产生居中偏移
    [_titleLabel setWrapContentSize:YES];
    
    UIView *topBackView = [[UIView alloc] init];
    topBackView.frame = CGRectMake(0,0,ScreenWidth-40,55.2);
    topBackView.backgroundColor = [UIColor whiteColor];
    topBackView.layer.cornerRadius = 11;
    topBackView.myWidth=ScreenWidth-40;
    [myTopLL addSubview:topBackView];
    [myTopLL addSubview:_titleLabel];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(19, 20, 30, 30)];
    closeBtn.myLeft=closeBtn.myTop=20;
    [closeBtn setImage:[UIImage imageNamed:@"ic_close_black"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closedialog:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgView addSubview:closeBtn];
    
    MyLinearLayout *mycenterLL = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    mycenterLL.myCenterY=0;
    mycenterLL.myCenterX=0;
    mycenterLL.backgroundColor = [UIColor greenColor];
    UIButton *minusBtn = [[UIButton alloc]init];
    [minusBtn setImage:[UIImage imageNamed:@"btn_minus"] forState:UIControlStateNormal];
    [minusBtn sizeToFit];
    [minusBtn addTarget:self action:@selector(minusCount:) forControlEvents:UIControlEventTouchUpInside];
    minusBtn.myCenterY=0;
    minusBtn.myCenterX=0;
    
    _countLabel = [UILabel new];
    [_countLabel setFont:[UIFont systemFontOfSize:83]];
    _countPerson=1;
    [_countLabel setText:@"1"];
    [_countLabel setWrapContentSize:YES];
    _countLabel.myCenterY=0;
    _countLabel.myCenterX=0;
    _countLabel.myLeft=44;
    _countLabel.myRight=44;
    _countLabel.myWidth=110;
    
    UIButton *addsBtn = [[UIButton alloc]init];
    [addsBtn setImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
    [addsBtn addTarget:self action:@selector(addsCount:) forControlEvents:UIControlEventTouchUpInside];
    [addsBtn sizeToFit];
    addsBtn.myCenterY=0;
    addsBtn.myCenterX=0;
    
    minusBtn.centerYPos.equalTo(@0);
    _countLabel.centerYPos.equalTo(@0);
    addsBtn.centerYPos.equalTo(@0);
    
//    addsBtn.centerXPos.equalTo(@[_countLabel.centerXPos]).offset(-176);
    addsBtn.myCenterX=88;
    minusBtn.myCenterX=-88;
//    minusBtn.centerXPos.equalTo(@[_countLabel.centerXPos]).offset(88);
    [addsBtn setTag:110];
    [minusBtn setTag:112];
    
    
    [rootLayout addSubview:minusBtn];
    [rootLayout addSubview:_countLabel];
    [rootLayout addSubview:addsBtn];
//    mycenterLL setin
    [bgView addSubview:mycenterLL];
    
    UIButton *startBtn = [[UIButton alloc]init];
    [startBtn setTitle:@"开始抽选" forState:UIControlStateNormal];
    [startBtn sizeToFit];
    startBtn.myHeight=70;
    [startBtn setBackgroundImage:[UIImage imageNamed:@"bg_round_conner"] forState:UIControlStateNormal];
    startBtn.myCenterX=0;
    startBtn.myLeft=startBtn.myRight=23;
    startBtn.bottomPos.equalTo(bgView.bottomPos).offset(33);
    [startBtn addTarget:self action:@selector(startRandom:) forControlEvents:UIControlEventTouchUpInside];
    [rootLayout addSubview:startBtn];
}

-(void)closedialog:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)minusCount:(UIButton *)sender
{
    _countPerson--;
    if (_countPerson<0) {
        _countPerson=0;
    }
    NSLog(@"人数为 %d",_countPerson);
    [_countLabel setText:[NSString stringWithFormat:@"%d",_countPerson]];
    

}
-(void)addsCount:(UIButton *)sender
{
    _countPerson++;
    if (_countPerson>30) {
        _countPerson=30;
    }
    NSLog(@"人数为 %d",_countPerson);
    [_countLabel setText:[NSString stringWithFormat:@"%d",_countPerson]];
    
    
}

-(void)startRandom:(UIButton *)sender
{
    for (UIView *view in [self.view subviews]) {
        if(view.tag==110||view.tag==112){
            [view removeFromSuperview];
        }
    }
    [_countLabel removeFromSuperview];
    [_titleLabel setText:@"随机抽选"];
}



@end
