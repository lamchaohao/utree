//
//  ConvertMessage.h
//  utree
//
//  Created by 科研部 on 2019/12/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMCSDK/MMCSDK.h>
#import "UTMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface ConvertMessageUtil : NSObject

+(UTMessage *)convertMimcMessage:(MIMCMessage *)mimcMsg;

@end

NS_ASSUME_NONNULL_END
