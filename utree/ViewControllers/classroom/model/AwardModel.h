//
//  AwardModel.h
//  utree
//
//  Created by 科研部 on 2019/11/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface AwardModel : NSObject
/**
 "excitationId":"1",
 "excitationName":"坚持阅读",
 "dropPoint":2,
 "icon":{
     "fileId":"656289560812173",
     "fileName":"42922cf2df89e03c50254d2385d9b674.jpeg",
     "path":"static/Files/2/pic/42922cf2df89e03c50254d2385d9b674.jpeg",
     "uploadTime":"2019-07-12T01:40:08.000+0000",
     "minPath":"static/Files/2/pic/42922cf2df89e03c50254d2385d9b674.jpeg"
 },
 "excitationType":1
 */

@property(nonatomic,strong)NSString *excitationId;
@property(nonatomic,strong)NSString *excitationName;
@property(nonatomic,strong)NSNumber *dropPoint;
@property(nonatomic,strong)NSNumber *excitationType;
@property(nonatomic,strong)FileObject *icon;


@end

NS_ASSUME_NONNULL_END
