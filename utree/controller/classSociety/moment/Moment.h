//
//  Moment.h
//  utree
//
//  Created by 科研部 on 2019/8/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface Moment : NSObject

@property(nonatomic,copy)NSString *headImgUrl;
@property(nonatomic,copy)NSString *postTime;
@property(nonatomic,copy)NSString *poster;
@property(nonatomic,copy)NSString *momentDetail;
@property(nonatomic,copy)NSArray *photoUrls;


-(instancetype)initWithAuthorName:(NSString *)name time:(NSString *)time content:(NSString *)content photos:(NSArray *)picUrls;

@end

NS_ASSUME_NONNULL_END
