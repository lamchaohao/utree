//
//  CHInputVC.h
//  utree
//
//  Created by 科研部 on 2020/1/9.
//  Copyright © 2020 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CHInputCallBack <NSObject>

-(void)CHInputdialogWillClose;

-(void)CHInputFinishEditing:(NSString *)content index:(int)index;

-(void)CHInputAdded:(NSString *)content;

@end

@interface CHInputVC : BaseViewController
@property(nonatomic,assign)long inputLengthLimit;
- (instancetype)initWithContent:(NSString *)content index:(int)index;
@property(nonatomic,strong)NSString *saveBtnStr;;
@property(nonatomic,weak)id<CHInputCallBack> callback;

@end

NS_ASSUME_NONNULL_END
