//
//  LoginViewModel.h
//  utree
//
//  Created by 科研部 on 2019/10/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LoginViewManagerDelegate <NSObject>


-(void)hideKeyboard;

-(void)showCountDownViewFrom:(int)begin;


@end

@interface LoginViewModel : NSObject

@property(nonatomic,assign) id<LoginViewManagerDelegate> delegate;

-(void)hideKeyboard;

-(void)showCountDownViewFrom:(int)begin;


@end

NS_ASSUME_NONNULL_END
