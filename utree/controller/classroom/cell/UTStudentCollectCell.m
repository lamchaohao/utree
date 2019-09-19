//
//  PersonCell.m
//  utree
//
//  Created by 科研部 on 2019/8/8.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTStudentCollectCell.h"

@implementation UTStudentCollectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createPersonHead];
    }
    return self;
}

-(void)createPersonHead
{
    _headView = [UIImageView new];
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.frame= self.bounds;
    _headView.myCenterX=0;
    _headView.myWidth=_headView.myHeight=55;
    _headView.myTop=6;
    
    [_headView setImage:[UIImage imageNamed:@"head_boy"]];
    [_headView sizeToFit];
    UIColor *color = [UIColor_ColorChange colorWithHexString:@"#CCCCCC"];

    UIView *rectView = [[UIView alloc] init];
    rectView.frame = CGRectMake(0,0,35.3,13.3);
    rectView.backgroundColor = [UIColor whiteColor];
//    rectView.layer.cornerRadius = 7;
    rectView.myCenterX=0;
    rectView.myTop=(-6);
    
    _scoreLabel = [ZBPaddingLabel new];
    [_scoreLabel setText:@"34399"];
    _scoreLabel.myCenterX=0;
    _scoreLabel.font = [UIFont systemFontOfSize:10];
    _scoreLabel.textColor=[UIColor colorWithRed:248/255.0 green:162/255.0 blue:26/255.0 alpha:1.0];
    _scoreLabel.layer.cornerRadius = 7;
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
//    _scoreLabel.edgeInsets =UIEdgeInsetsMake(3, 13, 3, 13);
    
    CALayer *layer=[rectView layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:7];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
//    UIColor *color = [UIColor_ColorChange colorWithHexString:@"#CCCCCC"];
    [layer setBorderColor:color.CGColor];
    _scoreLabel.myTop=(-13);
     [_scoreLabel sizeToFit];
    
    _nameLabel = [UILabel new];
    [_nameLabel setText:@"what"];
    _nameLabel.myCenterX=0;
    _nameLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    _nameLabel.font=[UIFont systemFontOfSize:13];
    _nameLabel.myTop=9;
    _nameLabel.myWidth=70;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_nameLabel sizeToFit];
    
    
    [rootLayout addSubview:_headView];
    [rootLayout addSubview:rectView];
    [rootLayout addSubview:_scoreLabel];
    [rootLayout addSubview:_nameLabel];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self addSubview:rootLayout];
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius = 6;
    
    _selectedModeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_unselected_gray_small"]];
    _selectedModeImg.frame= CGRectMake(self.bounds.size.width-15, -3, 21, 21);
    [self addSubview:_selectedModeImg];
    
}

- (void)setStudentModel:(UTStudent *)studentModel
{
    
    [_headView setImage: [UIImage imageWithData:studentModel.thumbnailImageData]];
    self.nameLabel.text =studentModel.studentName;
    self.scoreLabel.text=[NSString stringWithFormat:@"%ld",studentModel.dropScore];
    if (_nameLabel == nil) {
        NSLog(@"student = %@,%ld,%ld",studentModel.studentName,studentModel.dropScore,studentModel.attendanceMode);
    }
    
    if (studentModel.selectMode==1) {
        [_selectedModeImg setHidden:NO];
        [_selectedModeImg setImage:[UIImage imageNamed:@"ic_selected_green"]];
    }else if(studentModel.selectMode==2){
        [_selectedModeImg setHidden:NO];
        [_selectedModeImg setImage:[UIImage imageNamed:@"ic_unselected_gray_small"]];
    }else{
        [_selectedModeImg setHidden:YES];
    }
    
}

@end
