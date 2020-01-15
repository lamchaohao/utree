//
//  DBHelper.h
//  utree
//
//  Created by 科研部 on 2019/12/18.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTParent.h"
#import "UTMessage.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^DBExecuteResult)(NSDictionary *resultDic);


@interface DBManager : NSObject

+ (instancetype)sharedInstance;

+(void)attempDealloc;

-(void)openContactToChat:(UTParent *)parent;

-(void)queryRecentContactListWithResult:(DBExecuteResult)callback;

-(void)saveSendMessage:(UTMessage *)msg;

-(void)saveReceivedMessage:(UTMessage *)msg;

-(void)queryMessageWithAccount:(NSString *)accountId limit:(int)limit offset:(int)offset withResult:(DBExecuteResult)callback;

-(void)updateContactsData:(UTParent *)parent;

-(void)updateMessageReadStatus:(NSString*)parentId;

-(void)deleteRecordWithId:(NSString *)parentId;

-(void)closeDB;

@end

NS_ASSUME_NONNULL_END
