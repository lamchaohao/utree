//
//  UTAttendanceCell.m
//  utree
//
//  Created by 科研部 on 2019/9/18.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTAttendanceCell.h"

@implementation UTAttendanceCell

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
    _headView.layer.cornerRadius=28 ;//裁成圆角
    _headView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    _headView.layer.borderWidth = 0.5f;//边框宽度
    _headView.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色
    
    _nameLabel = [UILabel new];
    [_nameLabel setText:@"what"];
    _nameLabel.myCenterX=0;
    _nameLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    _nameLabel.font=[UIFont systemFontOfSize:13];
    _nameLabel.myTop=9;
    _nameLabel.myWidth=70;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_nameLabel sizeToFit];
    
    self.selectedModeImg= [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-15, -5, 26, 26)];
    
    // 为图片切圆
    
    self.selectedModeImg.layer.masksToBounds = YES;
    
    self.selectedModeImg.layer.cornerRadius = self.selectedModeImg.frame.size.width / 2.0;
    
    // 为图片添加边框,根据需要设置边框
    
    self.selectedModeImg.layer.borderWidth = self.selectedModeImg.frame.size.width / 2.0;//边框的宽度
    
    self.selectedModeImg.layer.borderColor = [UIColor_ColorChange colorWithHexString:@"#D1FFCC"].CGColor;//边框的颜色
    
    [rootLayout addSubview:_headView];
    [rootLayout addSubview:_nameLabel];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self addSubview:rootLayout];
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius = 6;
    
//    _selectedModeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_unselected_gray_small"]];
//    _selectedModeImg.frame= CGRectMake(self.bounds.size.width-15, -3, 21, 21);
    _attendanceStatuLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-12, -3, 21, 21)];
    [_attendanceStatuLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#28D016"]];
    [_attendanceStatuLabel setFont:[UIFont systemFontOfSize:10]];
    [_attendanceStatuLabel setText:@"出勤"];
    
    [self addSubview:_selectedModeImg];
    [self addSubview:_attendanceStatuLabel];
}

- (void)setStudentModel:(UTStudent *)studentModel
{
    [_headView sd_setImageWithURL:[NSURL URLWithString:studentModel.fileDo.path] placeholderImage:[UIImage imageNamed:studentModel.gender.boolValue?@"head_boy":@"head_girl"]];
    _headView.contentMode=UIViewContentModeScaleAspectFill;
    
    self.nameLabel.text =studentModel.studentName;
    
    if (_nameLabel == nil) {
        NSLog(@"student = %@,%ld,att=%ld",studentModel.studentName,studentModel.dropRecord,studentModel.attendanceMode);
    }
    if (studentModel.attendanceMode>3) {
        studentModel.attendanceMode=0;
    }
    switch (studentModel.attendanceMode) {
        case 0://出勤
            self.selectedModeImg.layer.borderColor = [UIColor_ColorChange colorWithHexString:@"#C4FFED"].CGColor;//边框的颜色
            [_attendanceStatuLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#11D499"]];
            [_attendanceStatuLabel setText:@"出勤"];

            break;
        case 1://迟到
            self.selectedModeImg.layer.borderColor = [UIColor_ColorChange colorWithHexString:@"#D5EDFF"].CGColor;//边框的颜色
            [_attendanceStatuLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#60B8F7"]];
            [_attendanceStatuLabel setText:@"迟到"];
            break;
        case 2://早退
            self.selectedModeImg.layer.borderColor = [UIColor_ColorChange colorWithHexString:@"#FFEFC6"].CGColor;//边框的颜色
            [_attendanceStatuLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#FBB708"]];
            [_attendanceStatuLabel setText:@"早退"];
            break;
        case 3://请假
            self.selectedModeImg.layer.borderColor = [UIColor_ColorChange colorWithHexString:@"#D1FFCC"].CGColor;//边框的颜色
            [_attendanceStatuLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#28D016"]];
            [_attendanceStatuLabel setText:@"请假"];
            break;
        default:
            break;
    }
}

@end
