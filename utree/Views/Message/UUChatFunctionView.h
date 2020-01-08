//
//  UTChatFuctionView.h
//  utree
//
//  Created by 科研部 on 2020/1/7.
//  Copyright © 2020 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ChatFunctionItemType)
{
    FunctionTakePic = 0, /**< 显示拍照 */
    FunctionSelectPic,  /**< 显示相册 */
    FunctionPhrasebook,   /**< 常用语 */
};

@protocol UUChatFunctioViewDataSource;
@protocol UUChatFunctioViewDelegate;

@interface UUChatFunctionView : UIView

@property (weak, nonatomic) id<UUChatFunctioViewDelegate>   delegate;
@property (weak, nonatomic) id<UUChatFunctioViewDataSource> dataSource;

@property (assign, nonatomic) NSUInteger   numberPerLine;
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

- (void)reloadData;

@end


@protocol UUChatFunctioViewDelegate <NSObject>

@optional
/**
 *  moreView选中的index
 *
 */
- (void)moreView:(UUChatFunctionView *)moreView selectIndex:(ChatFunctionItemType)itemType;

@end

@protocol UUChatFunctioViewDataSource <NSObject>

@required
/**
 *  获取数组中一共有多少个titles
 *
 *
 *  @return titles
 */

- (NSArray *)titlesOfMoreView:(UUChatFunctionView *)moreView;

/**
 *  获取moreView展示的所有图片
 *
 *
 *  @return imageNames
 */
- (NSArray *)imageNamesOfMoreView:(UUChatFunctionView *)moreView;


@end

NS_ASSUME_NONNULL_END
