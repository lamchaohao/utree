//
//  AwardItemCell.m
//  utree
//
//  Created by 科研部 on 2019/9/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AwardItemCell.h"

@interface AwardItemCell()
@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UILabel *tabLabel;
@property(nonatomic,strong)UIImageView *itemScoreBg;
@property(nonatomic,strong)UILabel *itemScoreLabel;
@property(nonatomic,strong)UILabel *itemName;

@end

@implementation AwardItemCell


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
    _headView = [UIImageView new];
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.frame= self.bounds;
    _headView.myCenterX=0;
    _headView.myWidth=_headView.myHeight=55;
    _headView.myTop=6;
    _headView.myCenterY=0;
    [_headView setImage:[UIImage imageNamed:@"head_boy"]];
    
    _tabLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 7, 18, 18)];
    _tabLabel.backgroundColor = [UIColor myColorWithHexString:@"#FCEBCD"];
    _tabLabel.layer.cornerRadius = 6;
    _tabLabel.textColor = [UIColor myColorWithHexString:@"#FFA200"];
    _tabLabel.font = [UIFont systemFontOfSize:10];
    _tabLabel.text = @"学";
    _tabLabel.myLeft=_tabLabel.myTop=7;
    _tabLabel.textAlignment = NSTextAlignmentCenter;

    
    _itemName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    _itemName.topPos.equalTo(_headView.bottomPos).offset(2);
    _itemName.textAlignment = NSTextAlignmentCenter;
    _itemName.text = @"坚持阅读";
    _itemName.font = [UIFont systemFontOfSize:12];
    _itemName.textColor = [UIColor myColorWithHexString:SecondTextColor];
    
    
    _itemScoreBg= [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-29, 7, 19, 19)];
    // 为图片切圆
    _itemScoreBg.layer.masksToBounds = YES;
    _itemScoreBg.layer.cornerRadius = _itemScoreBg.frame.size.width / 2.0;
    // 为图片添加边框,根据需要设置边框
    _itemScoreBg.layer.borderWidth = _itemScoreBg.frame.size.width / 2.0;//边框的宽度
    _itemScoreBg.layer.borderColor = [UIColor_ColorChange colorWithHexString:@"#43D27F"].CGColor;//边框的颜色
    _itemScoreBg.myLeft=self.bounds.size.width-23;
    _itemScoreBg.myTop=7;

    _itemScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-29, 7, 19, 19)];
    _itemScoreLabel.text = @"2";
    _itemScoreLabel.font = [UIFont systemFontOfSize:12];
    _itemScoreLabel.textColor = [UIColor whiteColor];
    _itemScoreLabel.myLeft=self.bounds.size.width-23;
    _itemScoreLabel.myTop=7;
    _itemScoreLabel.textAlignment=NSTextAlignmentCenter;


    [rootLayout addSubview:_headView];
    [rootLayout addSubview:_itemName];
    [rootLayout addSubview:_tabLabel];
    [rootLayout addSubview:_itemScoreBg];
    [rootLayout addSubview:_itemScoreLabel];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self addSubview:rootLayout];
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius = 6;
}


@end
