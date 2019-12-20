//
//  ClassStudentsView.h
//  utree
//
//  Created by 科研部 on 2019/10/30.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentsViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ClassStudentsViewResponser <NSObject>

-(void)onAwardStudents:(NSArray *)students;

-(void)onLoadNewData;

@end

@interface ClassStudentsView : MyFrameLayout


-(void)bindWithViewModel:(StudentsViewModel*)viewModel;

-(void)endRefreshing;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)StudentsViewModel* viewModel;
@property(nonatomic,assign)id<ClassStudentsViewResponser> responser;

@property(nonatomic,strong)UIImageView *defaultImgView;
@property(nonatomic,strong)UILabel *tipsLabel;
@property(nonatomic,strong)MyRelativeLayout *defaultLayout;

@end

NS_ASSUME_NONNULL_END
