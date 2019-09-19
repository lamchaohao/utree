//
//  MenuExpandView.m
//  utree
//
//  Created by 科研部 on 2019/9/19.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MenuExpandView.h"
#import "AttendanceVC.h"
#import "RandomVC.h"
#import "ListStudentVC.h"

@implementation MenuExpandView

- (instancetype)initWithFrame:(CGRect)frame andEx:(CGPoint)poi
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCustomViewWithCenter:poi];
        
    }
    return self;

}

-(void)createCustomViewWithCenter:(CGPoint)point
{
    [self initMenuBtn:point];
}



-(void)initMenuBtn:(CGPoint)point{
    
    _attendanceBtn=[[UIButton alloc]init];
    [_attendanceBtn setImage:[UIImage imageNamed:@"btn_attendance_menu"] forState:UIControlStateNormal];
    [_attendanceBtn sizeToFit];
    [_attendanceBtn addTarget:self action:@selector(jumpToAttendance:) forControlEvents:UIControlEventTouchUpInside];
    
    _sortBtn=[[UIButton alloc]init];
    [_sortBtn setImage:[UIImage imageNamed:@"btn_sort_menu"] forState:UIControlStateNormal];
    [_sortBtn sizeToFit];
    [_sortBtn addTarget:self action:@selector(sortMenuClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _randomBtn=[[UIButton alloc]init];
    [_randomBtn setImage:[UIImage imageNamed:@"btn_random_menu"] forState:UIControlStateNormal];
    [_randomBtn sizeToFit];
    [_randomBtn addTarget:self action:@selector(showRandomDialog:) forControlEvents:UIControlEventTouchUpInside];
    
    _showListBtn=[[UIButton alloc]init];
    [_showListBtn setImage:[UIImage imageNamed:@"btn_list_menu"] forState:UIControlStateNormal];
    [_showListBtn sizeToFit];
    [_showListBtn addTarget:self action:@selector(showListView:) forControlEvents:UIControlEventTouchUpInside];
    
    //展开菜单按钮
    _mainMenuBtn=[[UIButton alloc]initWithFrame:CGRectMake(point.x, point.y, 54, 54)];
    [_mainMenuBtn setImage:[UIImage imageNamed:@"btn_classroom_menu"] forState:UIControlStateNormal];
    
    [_mainMenuBtn sizeToFit];
    [_mainMenuBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *panGes= [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panScroll:)];
    
    [_mainMenuBtn addGestureRecognizer:panGes];
    //    menuBtn.myBottom=ScreenWidth*0.203-18;
    //    menuBtn.myTrailing = 8;
    [self addSubview:_mainMenuBtn];
    
    _attendanceBtn.frame=CGRectMake(0, 0, 54, 54);
    _sortBtn.frame=CGRectMake(0, 0, 54, 54);
    _randomBtn.frame=CGRectMake(0, 0, 54, 54);
    _showListBtn.frame=CGRectMake(0, 0, 54, 54);
    [self layoutMenuButton];
    
    [self addSubview:_attendanceBtn];
    [self addSubview:_sortBtn];
    [self addSubview:_randomBtn];
    [self addSubview:_showListBtn];
    
//    [self hideExtendButton];
}

-(void)hideExtendButton
{
    [_attendanceBtn setHidden:true];
    [_sortBtn setHidden:true];
    [_randomBtn setHidden:true];
    [_showListBtn setHidden:true];
}

-(void)showMenu:(UIButton *)sender
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

-(void)jumpToAttendance:(UIButton *)sender
{
    
    AttendanceVC *detailVC = [[AttendanceVC alloc]init];
    
    //注意是UIViewController调用hidesBottomBarWhenPushed而不是UINavigationController
    detailVC.hidesBottomBarWhenPushed=YES;
    
    
//    [self.navigationController pushViewController:detailVC animated:YES];
    [self hideExtendButton];
}

-(void)showRandomDialog:(UIButton *)sender
{
    RandomVC *randomVC= [[RandomVC alloc]init];
    
    randomVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:randomVC animated:YES completion:nil];
    [self hideExtendButton];
}

-(void)showListView:(UIButton *)sender
{
//    [_personVC showCollectionView:!_personVC.isCollectionViewOnShow];
    [self hideExtendButton];
    //    ListStudentVC *detailVC = [[ListStudentVC alloc]init];
    //
    //    //注意是UIViewController调用hidesBottomBarWhenPushed而不是UINavigationController
    //    detailVC.hidesBottomBarWhenPushed=YES;
    //
    //    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)sortMenuClick:(UIButton *)sender
{
    
//    [self.navigationController pushViewController:detailVC animated:YES];
    [self hideExtendButton];
}

-(CGFloat)getStatusBarAndNavHeight
{
    
    return iPhone_Top_NavH*2+iPhone_StatuBarHeight;
    
}

- (void)panScroll:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {//设置拖动范围
        CGPoint translation = [recognizer locationInView:self.mainMenuBtn];
        CGPoint newCenter = CGPointMake(recognizer.view.center.x+ translation.x,
                                        recognizer.view.center.y + translation.y);
        newCenter.y = MIN(ScreenHeight-30, newCenter.y);
        newCenter.y = MAX(iPhone_Top_NavH-SegmentTitleViewHeight, newCenter.y);
        newCenter.x = MAX(30, newCenter.x);
        newCenter.x = MIN(ScreenWidth-30,newCenter.x);
        recognizer.view.center = newCenter;
        [recognizer setTranslation:CGPointZero inView:self.mainMenuBtn];
        
        [self layoutMenuButton];
        
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {//可以在这里做一些复位处理
        
    }
}

#define degreesToRadians(degrees) ((degrees * (float)M_PI) / 180.0f)  //这个公式是计算弧度的

-(void)layoutMenuButton
{
    int startValue = 0;
    int separateValue = 4;
    NSArray *menuButtonArr = [NSArray arrayWithObjects:self.showListBtn, self.randomBtn,self.sortBtn,self.attendanceBtn,nil];
    for (int i= 1; i<=menuButtonArr.count;i++) {
        //_separateValue 几等分  _startValue 布局开始的位置,通过它来控制左半圆或者右半圆
        float angle = degreesToRadians((180 / separateValue) * (i+startValue));
        int radius = 80;
        //下面两个就是通过正余弦计算中心点的
        float y = cos(angle) * radius;
        float x = sin(angle) * radius;
        CGPoint center = CGPointMake(0, 0);
        if (_mainMenuBtn.center.x>ScreenWidth/2) {
            center.x = _mainMenuBtn.center.x - x;
        }else{
            center.x = _mainMenuBtn.center.x + x;
        }
        center.y =_mainMenuBtn.center.y + y;
        ((UIButton *) [menuButtonArr objectAtIndex:(i-1)]).center = center;
    }
}

@end
