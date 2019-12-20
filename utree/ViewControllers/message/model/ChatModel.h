//
//  ChatModel.h
//  utree
//
//  Created by 科研部 on 2019/12/16.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UUMessageFrame;
@interface ChatModel : NSObject

@property (nonatomic, strong) NSMutableArray<UUMessageFrame *> *dataSource;

@property (nonatomic) BOOL isGroupChat;

- (void)populateRandomDataSource;

- (void)addRandomItemsToDataSource:(NSInteger)number;

- (void)addSpecifiedItem:(NSDictionary *)dic;

- (void)recountFrame;

@end
