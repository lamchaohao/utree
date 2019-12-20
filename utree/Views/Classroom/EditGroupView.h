//
//  EditGroupView.h
//  utree
//
//  Created by 科研部 on 2019/11/5.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol EditGroupViewResponser <NSObject>

-(void)onCloseViewController;

-(void)onDeleteGroup;

-(void)onRenameGroup:(NSString *)groupName;

-(void)onEditPress;

-(void)onRequestRefresh;

@end
@interface EditGroupView : MyRelativeLayout


@property(nonatomic,assign)id<EditGroupViewResponser> responser;

- (instancetype)initWithFrame:(CGRect)frame groupModel:(GroupModel *)model;

-(void)bindViewModel:(GroupModel *)groupModel;

-(void)onLoadDataFinish;

@end

NS_ASSUME_NONNULL_END
