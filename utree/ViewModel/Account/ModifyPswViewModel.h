//
//  ModifyPswViewModel.h
//  utree
//
//  Created by 科研部 on 2019/10/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ModifyPswViewManagerDelegate <NSObject>

-(void)hideKeyboard;

-(void)showCountDownViewFrom:(int)begin;

@end

@interface ModifyPswViewModel : NSObject

@property(nonatomic,assign)id<ModifyPswViewManagerDelegate> viewDelegate;

-(void)hidekeyBoard;

-(void)showCountDownViewFrom:(int)begin;

@end

NS_ASSUME_NONNULL_END
