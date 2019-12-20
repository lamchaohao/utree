//
//  PostMenuVC.h
//  utree
//
//  Created by 科研部 on 2019/9/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PostMenuDelegate <NSObject>

-(void)postNotice:(id)sender;
-(void)postHomework:(id)sender;

@end
@interface PostMenuVC : UIView
- (void)showMenuView;
- (void)dismissMenuView;
@property(nonatomic,assign)id<PostMenuDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
