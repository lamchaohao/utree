//
//  NoticeModel.h
//  utree
//
//  Created by 科研部 on 2019/8/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeModel : NSObject
@property(nonatomic,copy)NSString *headImgUrl;
@property(nonatomic,copy)NSString *postTime;
@property(nonatomic,copy)NSString *poster;
@property(nonatomic,copy)NSString *noticeTitle;
@property(nonatomic,copy)NSString *noticeDetail;
@property(nonatomic,copy)NSString *audioUrl;
@property(nonatomic,copy)NSArray *photoUrls;
@property(nonatomic,copy)NSArray *attachUrl;

-(instancetype)initWithPosterName:(NSString *)name time:(NSString *)time title:(NSString *)title detail:(NSString *)detail;



@end

NS_ASSUME_NONNULL_END
