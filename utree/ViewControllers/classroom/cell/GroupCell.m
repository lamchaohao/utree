//
//  GroupCell.m
//  utree
//
//  Created by 科研部 on 2019/8/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "GroupCell.h"
#import "UTStudent.h"
@implementation GroupCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createView];
    }
    return self;
}


-(void)createView
{
    _headView = [UIImageView new];
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    
    rootLayout.frame= self.bounds;
    _headView.myCenterX=0;
//    _headView.myCenterY=-5;
    _headView.myWidth=_headView.myHeight=75;
    _headView.myTop=16;
    _headView.backgroundColor=[UIColor whiteColor];
    [_headView setImage:[UIImage imageNamed:@"default_head"]];
    _headView.layer.cornerRadius=5;
    UIColor *color = [UIColor_ColorChange colorWithHexString:@"#CCCCCC"];
    _headView.layer.borderColor=color.CGColor;
    _headView.layer.borderWidth=1;
    
    _memberCountLabel = [ZBPaddingLabel new];
    _memberCountLabel.frame = CGRectMake(0, 0, 43, 18);
    [_memberCountLabel setText:@"349"];
    _memberCountLabel.myTop=12;
    _memberCountLabel.myCenterX=48;
    _memberCountLabel.backgroundColor = [UIColor whiteColor];
    _memberCountLabel.font = [UIFont systemFontOfSize:10];
    _memberCountLabel.textColor=[UIColor myColorWithHexString:@"#FFF8A21A"];
    _memberCountLabel.layer.cornerRadius = 7;
    _memberCountLabel.textAlignment = NSTextAlignmentCenter;
    [_memberCountLabel setHidden:NO];
    
    CALayer *layer=[_memberCountLabel layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:7];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
    //    UIColor *color = [UIColor_ColorChange colorWithHexString:@"#CCCCCC"];
    [layer setBorderColor:color.CGColor];
    
    _groupNameLabel = [UILabel new];
    [_groupNameLabel setText:@"what"];
    _groupNameLabel.myCenterX=0;
    _groupNameLabel.textColor = [UIColor myColorWithHexString:@"#4D4D4D"];
    _groupNameLabel.font=[UIFont systemFontOfSize:13];
    _groupNameLabel.topPos.equalTo(_headView.bottomPos).offset(2);
    _groupNameLabel.myWidth=70;
    _groupNameLabel.textAlignment = NSTextAlignmentCenter;
    [_groupNameLabel sizeToFit];
    
    [rootLayout addSubview:_headView];
    [rootLayout addSubview:_memberCountLabel];
    [rootLayout addSubview:_groupNameLabel];

    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self addSubview:rootLayout];
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius = 6;
}

-(void)loadAddAction
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ic_add_group" ofType:@"png"];
    NSData *imgData = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage imageWithData:imgData];
    [_headView setImage:image];
    _headView.layer.borderWidth=0;
    [_groupNameLabel setText:@"添加小组"];
    [_memberCountLabel setText:@""];
    _memberCountLabel.layer.borderWidth=0;
    
}


-(void)loadData:(GroupModel *)groupModel
{

    NSMutableArray *studentImgList = [[NSMutableArray alloc]init];
    for (UTStudent *student in groupModel.studentDos) {
        if (student.fileDo.path!=nil) {
            [studentImgList addObject:student.fileDo.path];
        }
       
        if (studentImgList.count>9) {
            // 不需要那么多头像，最多九个即可
            break;
        }
    }
    
    [_headView dc_setImageAvatarWithGroupId:groupModel.groupId Source:studentImgList];
    
    _headView.layer.borderWidth=1;
    [_groupNameLabel setText:groupModel.groupName];
    
    _memberCountLabel.layer.borderWidth=1;
    [_memberCountLabel setText:[NSString stringWithFormat:@"%d",groupModel.dropNum.intValue]];
    [_memberCountLabel setHidden:NO];
  
}

@end
