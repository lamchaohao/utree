//
//  PostHomeworkVC.h
//  utree
//
//  Created by 科研部 on 2019/10/8.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ResultPath)(NSString *filePath, NSString *fileName);

@interface PostHomeworkVC : BaseViewController

- (instancetype)initWithSubjectId:(NSString *)subjectId classIdList:(NSArray *)idList;

@end

NS_ASSUME_NONNULL_END
