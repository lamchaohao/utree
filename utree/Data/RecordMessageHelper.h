//
//  RecordMessageHelper.h
//  utree
//
//  Created by 科研部 on 2019/12/19.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMCSDK/MMCSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface RecordMessageHelper : NSObject

- (instancetype)initWithUserId:(NSString *)userId;

-(void)saveMessage:(MIMCMessage *)mimcMessage;

-(void)updateParentData:(id)parent;

@end

NS_ASSUME_NONNULL_END
