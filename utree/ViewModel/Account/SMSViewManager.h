//
//  SMSViewManager.h
//  utree
//
//  Created by 科研部 on 2019/10/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMSViewManagerDelegate <NSObject>

-(void)hideKeyboard;

-(void)showCountDownViewFrom:(int)begin;

@end


@interface SMSViewManager : NSObject

//隐藏键盘
-(void)shrinkKeyboard;

-(void)showCountDownFrom:(int)begin;

@property(nonatomic,assign)id<SMSViewManagerDelegate> viewDelegate;

@end

NS_ASSUME_NONNULL_END
