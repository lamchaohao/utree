//
//  TeachClassModel.h
//  utree
//
//  Created by 科研部 on 2019/9/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TeachClassModel : NSObject

@property(nonatomic,strong)NSString *teachClassName;
@property(nonatomic,strong)NSArray<NSString *> *subjectArray;


@end

NS_ASSUME_NONNULL_END
