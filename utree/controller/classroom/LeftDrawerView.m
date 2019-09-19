//
//  LeftDrawerView.m
//  utree
//
//  Created by 科研部 on 2019/8/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "LeftDrawerView.h"
#import "ClassCell.h"
@interface LeftDrawerView()<UITableViewDelegate,UITableViewDataSource>

@end



@implementation LeftDrawerView


static NSString *ID = @"myClassCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCustomView];
    }
    return self;
}

-(void)createCustomView
{
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(-ScreenWidth*0.814, 0, ScreenWidth*0.814, ScreenHeight)];
    _contentView.backgroundColor = [UIColor whiteColor];
//    _contentView.layer.cornerRadius = 16;
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.frame = CGRectMake(0, 0, ScreenWidth*0.814, ScreenHeight);
    contentLayout.backgroundColor = [UIColor whiteColor];
    
    UIImageView *topImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth*0.814, ScreenHeight*0.205)];
    topImg.contentMode = UIViewContentModeScaleToFill;
    [topImg setImage:[UIImage imageNamed:@"drawer_top_img"]];
    
    topImg.layer.cornerRadius = 16;
    [contentLayout addSubview:topImg];
    
    [_contentView addSubview:contentLayout];
    [self addSubview:_contentView];
    
    self.userInteractionEnabled = YES;
    [UIView setAnimationDelegate:self];

    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [self addGestureRecognizer:tapGesture];
    [tapGesture setNumberOfTapsRequired:1];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(-ScreenWidth*0.81, topImg.frame.size.height+12, ScreenWidth*0.81, ScreenHeight-topImg.frame.size.height) style:UITableViewStylePlain];
//    _tableView.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#E3E3E3"];
    [self addSubview:_tableView];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView registerClass:[ClassCell class] forCellReuseIdentifier:ID];

//    _tableView.sectionIndexColor = [UIColor myColorWithHexString:@"#FF676767"];
//    _tableView.contentInset = UIEdgeInsetsMake(0, 0, barHeight*2.3, 0);
    [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}

-(void)event:(UITapGestureRecognizer *)gesture
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = [self frame];
        //
        rect.origin.x = - rect.size.width;
        [self setFrame:rect];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassCell * cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
//    cell setmodel
    ClassModel *model = [[ClassModel alloc]initWithClassName:@"三年三班" subject:@"数学" studentCount:54 dropCount:788];
    if (indexPath.row==3) {
        model.isSelected= YES;
    }
    [cell setClassModel:model];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenWidth*0.432+10;
}



@end
