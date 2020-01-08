//
//  DBHelper.m
//  utree
//
//  Created by 科研部 on 2019/12/18.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "DBManager.h"
#import <FMDB.h>
#import "UTParent.h"
#import "UTMessage.h"
#import "JSONUtil.h"
#import "RecentContact.h"
#import "ContactDC.h"
#import "UTCache.h"
static NSString *T_Contacts = @"t_contacts";
static NSString *Prefix_Table = @"t_His_";
@interface DBManager()

//@property(nonatomic,strong)FMDatabase *db;
@property(nonatomic,strong)NSMutableDictionary *existTableDic;
@property(strong, nonatomic,readwrite) FMDatabaseQueue *dbQueue;

@end

@implementation DBManager
static dispatch_once_t onceToken;
static DBManager *instance = nil;
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.existTableDic = [[NSMutableDictionary alloc]init];
        [self initDB];
    }
    return self;
}



+ (instancetype)sharedInstance
{
    dispatch_once(&onceToken, ^{
        instance = [[DBManager alloc] init];
    });
    return instance;
}

-(void)initDB
{
    NSString *userId = [[UTCache readProfile] objectForKey:@"teacherId"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFilePath = paths.firstObject;
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@",documentFilePath,userId];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL tag = [fileManager fileExistsAtPath:dbPath isDirectory:NULL];
    //文件夹不存在，则创建文件夹
    if (!tag) {
        [fileManager createDirectoryAtPath:dbPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }

//    self.db = [FMDatabase databaseWithPath:[dbPath stringByAppendingString:@"/chatMessageDB.db"]];
    self.dbQueue =[FMDatabaseQueue databaseQueueWithPath:[dbPath stringByAppendingString:@"/chatMessageDB.db"]];
    [self openDB];
    [self initTables];
}

-(void)openDB
{
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
       if(![db open])
       {
           db =nil;
           return ;
       }
    }];
}


- (void)closeDB
{
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db close];
    }];
}

-(void)initTables
{
    
    NSString *createTableSqlString =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (accountId text PRIMARY KEY, accountName text , picPath text, studentName text);",T_Contacts];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeStatements:createTableSqlString];
    }];
    
}

#pragma mark 建立联系人聊天记录表
-(void)createParentsTable:(NSString *)parentId db:(FMDatabase *)db
{
    NSString *tableName = [NSString stringWithFormat:@"%@%@",Prefix_Table,parentId];
    //每个联系人建立聊天消息表
    NSString *createTableSQL =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (messagId text PRIMARY KEY,ownerId TEXT, timeStamp TEXT NOT NULL, msgJSON text,msgType text,readStatus INTEGER );",tableName];
    
    if([db executeStatements:createTableSQL])
    {
        [self.existTableDic setObject:tableName forKey:parentId];
    }
}

#pragma mark 查询表是否存在
-(void)checkTableExist:(NSString *)parentId withResult:(DBExecuteResult)callback
{
    //查询内存缓存是否有表名
    
    NSString *tableName = [self.existTableDic objectForKey:parentId];
    if (!tableName) {
        NSString *tableName = [NSString stringWithFormat:@"%@%@",Prefix_Table,parentId];
        NSString *checkSql = [NSString stringWithFormat:@"SELECT count(*) FROM sqlite_master WHERE type='table' AND name = '%@'",tableName];
        [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            FMResultSet *rs=[db executeQuery:checkSql];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:db forKey:@"database"];
            if ([rs next]) {
                int count = [rs intForColumnIndex:0];
                if (count>0) {
                    //存在则加入到内存缓存
                    [self.existTableDic setObject:tableName forKey:parentId];
                    [dic setObject:[NSNumber numberWithBool:YES] forKey:@"check"];
                    callback(dic);
                }else{
                    [dic setObject:[NSNumber numberWithBool:NO] forKey:@"check"];
                    callback(dic);
                }
        
            }else{
                //联系人聊天记录表不存在，则创建表
                [dic setObject:[NSNumber numberWithBool:NO] forKey:@"check"];
                callback(dic);
            }
         }];
        
    }else{
        callback([NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"check"]);
    }

}

-(void)deleteRecordWithId:(NSString *)parentId
{
    NSString *delSQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE accountId = '%@';",T_Contacts,parentId];
    NSString *tableName = [NSString stringWithFormat:@"%@%@",Prefix_Table,parentId];
    NSString *dropSQL = [NSString stringWithFormat:@"DROP TABLE %@;",tableName];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:delSQL];
        [db executeStatements:dropSQL];
        [self.existTableDic removeObjectForKey:parentId];
    }];
}

#pragma mark 用于打开联系人聊天界面
-(void)openContactToChat:(UTParent *)parent
{
    [self checkTableExist:parent.parentId withResult:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *check = [resultDic objectForKey:@"check"];
        if (!check.boolValue) {
            FMDatabase *db = [resultDic objectForKey:@"database"];
            [self addContacts:parent db:db];
        }
    }];
    
}
#pragma mark 增加联系人
-(void)addContacts:(UTParent *)parent db:(FMDatabase *)db
{
    NSString *stuNameShow = @"";
    for (int index=0; index<parent.studentList.count; index++) {
        UTStudent *stu = parent.studentList[index];
        if (index==0) {
            NSString *className = [NSString stringWithFormat:@"%ld年%ld班",stu.classDo.classGrade.longValue,stu.classDo.classCode.longValue];
            stuNameShow = [stuNameShow stringByAppendingFormat:@"%@", className];
            stuNameShow = [stuNameShow stringByAppendingFormat:@"%@", stu.studentName];
        }
    }
    if (parent.studentName) {
        stuNameShow = parent.studentName;
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (accountId,accountName,picPath,studentName) VALUES ('%@', '%@', '%@','%@');",T_Contacts,parent.parentId,parent.parentName,parent.picPath,stuNameShow];
    [db executeUpdate:sql];


    NSString *tableName = [NSString stringWithFormat:@"%@%@",Prefix_Table,parent.parentId];
    //每个联系人建立聊天消息表
    NSString *createTableSQL =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (messagId text PRIMARY KEY,ownerId TEXT, timeStamp TEXT NOT NULL, msgJSON text,msgType text,readStatus INTEGER );",tableName];
    
    if([db executeStatements:createTableSQL])
    {
        [self.existTableDic setObject:tableName forKey:parent.parentId];
    }
    

    
}

#pragma mark 更新联系人
-(void)updateContactsData:(UTParent *)parent
{
    [self openDB];
    NSString *stuNameShow = @"";
    for (int index=0; index<parent.studentList.count; index++) {
        UTStudent *stu = parent.studentList[index];
        if (index==0) {
            NSString *className = [NSString stringWithFormat:@"%ld年%ld班",stu.classDo.classGrade.longValue,stu.classDo.classCode.longValue];
            stuNameShow = [stuNameShow stringByAppendingFormat:@"%@", className];
            stuNameShow = [stuNameShow stringByAppendingFormat:@"%@", stu.studentName];
        }
    }
    
        
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET accountName = '%@',picPath='%@',studentName='%@' WHERE accountId = '%@';",T_Contacts,parent.parentName,parent.picPath,stuNameShow,parent.parentId];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if(![db executeUpdate:sql]){
            NSLog(@"%@",[db lastError]);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:UpdateParentDataNotifyName object:parent];
    }];
   
}

-(void)updateMessageReadStatus:(NSString*)parentId
{
    NSString *tableName = [NSString stringWithFormat:@"%@%@",Prefix_Table,parentId];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET readStatus = 1 where readStatus= 0",tableName];
    [self openDB];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:sql];
    }];
}


#pragma mark 查询会话列表
-(void)queryRecentContactListWithResult:(DBExecuteResult)callback
{
    
    [self queryTheNewestMessageAndUnreadCountFromWithResult:^(NSDictionary * _Nonnull resultDic) {
        callback(resultDic);
    }];
    
}

#pragma mark 保存收到的聊天记录
-(void)saveReceivedMessage:(UTMessage *)msg
{
//    保存的收到的聊天记录中，UTMessage.toAccount = mimcMessage.getFromAccount
    NSLog(@"call saveReceivedMessage");
    [self checkTableExist:msg.accountId withResult:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *check =[resultDic objectForKey:@"check"];
        FMDatabase *db = [resultDic objectForKey:@"database"];
        if (!check.boolValue) {
            //  模拟数据
             UTParent *parent = nil;
            for (UTParent *fakeParent in [self addFakeData]) {
                if([fakeParent.parentId isEqualToString:msg.accountId]){
                    parent =fakeParent;
                    break;
                }
            }
            if (!parent) {
                parent = [[UTParent alloc]init];
                parent.parentId =msg.accountId;
                parent.parentName = msg.accountId;
            }
           //联系人聊天记录表不存在，则创建表
            [self addContacts:parent db:db];
            //保存消息
            NSString *sql = [self makeSaveMessageSQL:msg];
            if([db executeUpdate:sql])
            {
                NSLog(@"保存记录成功");
            }else{
                NSLog(@"保存失败 %@",[db lastErrorMessage]);
            }
            [db close];
            //通过发送通知进行获取家长的信息，由消息监听者进行更新数据
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchParentDataNotifyName object:msg.accountId];
            
            
        }else{
            NSLog(@"saveReceivedMessage with exist table");
            NSString *sql = [self makeSaveMessageSQL:msg];
            if (db) {
                if([db executeUpdate:sql])
                {
                   NSLog(@"保存记录成功");
                }else{
                   NSLog(@"保存失败 %@",[db lastErrorMessage]);
                }
            }else{
                //没有返回db的
                [self saveSendMessage:msg];
            }
            
        }
    }];
}


#pragma mark 保存发送聊天记录
-(void)saveSendMessage:(UTMessage *)msg
{

    NSString *sql = [self makeSaveMessageSQL:msg];
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if([db executeUpdate:sql])
        {
            NSLog(@"保存记录成功");
        }else{
            NSLog(@"保存失败 %@",[db lastErrorMessage]);
        }
    }];
    
}


-(NSString *)makeSaveMessageSQL:(UTMessage *)msg
{
    NSString *msgJSONStr = @"";
    NSString *msgType = @"";
    
    switch (msg.type) {
        case UTMessageTypeText:
        {
            msgType = @"TEXT";
            NSDictionary *jsonDict = @{@"version":@0,
                                       @"content":msg.contentStr
                                     };
            msgJSONStr= [JSONUtil convertToJsonDataNoDeal:jsonDict];
        }
            break;
        case UTMessageTypeVoice:
        {
            msgType = @"AUDIO";
            NSDictionary *jsonDict = @{@"version":@0,
                                       @"content":msg.voiceUrl,
                                       @"duration":msg.voiceDuration
                                     };
            msgJSONStr= [JSONUtil convertToJsonDataNoDeal:jsonDict];
        }
            break;
        case UTMessageTypePicture:
        {
            msgType = @"PIC";
            NSInteger height = (int)msg.picture.size.height;
            NSInteger width = (int)msg.picture.size.width;
            NSDictionary *jsonDict = @{@"version":@0,
                                       @"content":msg.picUrl,
                                       @"height":@(height),
                                       @"width":@(width)
                                     };
            msgJSONStr= [JSONUtil convertToJsonDataNoDeal:jsonDict];
        }
            break;
        default:
            break;
    }
    if(msg.from == UTMessageFromMe){
        msg.readStatus =1;//自己发出的一定是已读
    }
    NSString *tableName = [NSString stringWithFormat:@"%@%@",Prefix_Table,msg.toAccount];
    return [NSString stringWithFormat:@"INSERT INTO %@ (messagId,ownerId,timeStamp,msgJSON,msgType,readStatus) VALUES ('%@', '%@', '%@','%@','%@',%d);",tableName,msg.messageId,msg.accountId,msg.timeStamp,msgJSONStr,msgType,msg.readStatus];
}



#pragma mark 查询与某某accountId的聊天记录
-(void)queryMessageWithAccount:(NSString *)accountId limit:(int)limit offset:(int)offset withResult:(DBExecuteResult)callback
{
    NSString *tableName = [NSString stringWithFormat:@"%@%@",Prefix_Table,accountId];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY timeStamp DESC LIMIT %d OFFSET %d ",tableName,limit,offset];
    NSMutableArray *messageList = [[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            
            FMResultSet *resultSet = [db executeQuery:sql];
            while ([resultSet next]) {
                //retrieve values for each record
                UTMessage *message = [self makeMessageFromResultSet:resultSet];
                message.from = [message.accountId isEqualToString:accountId]?UTMessageFromOther:UTMessageFromMe;
                [messageList addObject:message];
            }
            [resultSet close];
            if (callback) {
                callback([NSDictionary dictionaryWithObject:messageList forKey:@"result"]);
            }
        }];
    });

}


#pragma mark 查询最新一条聊天记录和未读消息数量
-(void)queryTheNewestMessageAndUnreadCountFromWithResult:(DBExecuteResult)callback
{
    NSString *queryContactsSql = [NSString stringWithFormat:@"SELECT * FROM %@ ",T_Contacts];
    NSMutableArray *recentList = [[NSMutableArray alloc]init];
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        FMResultSet *contactsRS = [db executeQuery:queryContactsSql];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
       
        while ([contactsRS next]) {
            //查询联系人
            UTParent *parent = [[UTParent alloc]init];
            parent.parentId=[contactsRS stringForColumnIndex:0];
            parent.parentName =[contactsRS stringForColumnIndex:1];
            parent.picPath = [contactsRS stringForColumnIndex:2];
            parent.studentName = [contactsRS stringForColumnIndex:3];
            RecentContact *recentContact = [[RecentContact alloc]init];
            recentContact.parent = parent;
            
            NSString *tableName = [NSString stringWithFormat:@"%@%@",Prefix_Table,parent.parentId];
            NSString *maxCountsql = [NSString stringWithFormat:@"SELECT count(*) FROM %@",tableName];
            NSString *unreadCountsql = [NSString stringWithFormat:@"SELECT count(*) FROM %@ where readStatus = 0",tableName];
            //查询未读消息数目
            FMResultSet *countResultSet =[db executeQuery:maxCountsql];
            FMResultSet *unreadRS =[db executeQuery:unreadCountsql];
            
            long unreadCount=0;
            if ([unreadRS next]) {
                 unreadCount = [unreadRS longForColumnIndex:0];
            }
            
            long maxCount=0;
            UTMessage *message = nil;
            if([countResultSet next]){
                maxCount = [countResultSet intForColumnIndex:0];
            }
            if (maxCount>0) {
                //查询最新一条信息
                NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %d OFFSET %ld",tableName,1,maxCount-1];
                FMResultSet *rs = [db executeQuery:sql];
                if ([rs next]) {
                    message = [self makeMessageFromResultSet:rs];
                    message.from = [message.accountId isEqualToString:parent.parentId]?UTMessageFromOther:UTMessageFromMe;
                    recentContact.lastMessage = message;
                    recentContact.unreadCount = (int)unreadCount;
                    
                    [recentList addObject:recentContact];
                }
                [rs close];
            }
            [unreadRS close];
            [countResultSet close];
            
        }
        [contactsRS close];
        [dic setObject:recentList forKey:@"result"];
        callback(dic);
       
    }];
    
    
    
}

-(UTMessage *)makeMessageFromResultSet:(FMResultSet *)resultSet
{
    UTMessage *message = [[UTMessage alloc]init];
    message.messageId=[resultSet stringForColumn:@"messagId"];
    message.accountId =[resultSet stringForColumn:@"ownerId"];
    message.timeStamp = [resultSet stringForColumn:@"timeStamp"];
    NSString *jsonStr = [resultSet stringForColumn:@"msgJSON"];
    NSString *bizType = [resultSet stringForColumn:@"msgType"];
    NSDictionary *jsonDict = [JSONUtil dictionaryWithJsonString:jsonStr];
    NSString *contentStr=jsonDict[@"content"];
    if ([bizType isEqualToString:@"TEXT"]) {
        message.contentStr=contentStr;
        message.type=UTMessageTypeText;
    }else if([bizType isEqualToString:@"AUDIO"]){
         NSString *durationStr = jsonDict[@"duration"];
        message.voiceUrl= contentStr;
        message.voiceDuration = durationStr;
        message.type=UTMessageTypeVoice;
    }else if([bizType isEqualToString:@"PIC"]){
        message.picUrl = contentStr;
        message.type=UTMessageTypePicture;
    }
    message.sendStatus=UTStatusSendCompleted;
    message.readStatus = [resultSet intForColumn:@"readStatus"];
    return message;
}


-(NSMutableArray *)addFakeData
{
    NSMutableArray *fakeDatas = [[NSMutableArray alloc]init];
    NSArray *parentAccounts = [NSArray arrayWithObjects:@"15740638061472660",@"25740671999455221",@"35741315680210787",@"556289560812949",@"65740635256461378",@"85724284004950383",@"15693771165596690", nil];
    NSArray *parentNames = [NSArray arrayWithObjects:@"warw",@"晓红",@"超豪老师",@"大肥雅",@"享培",@"二狗子",@"乐乐", nil];
    NSString *img9=@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2851238468,2653826075&fm=26&gp=0.jpg";
    NSString *img10 = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3240215558,3264545876&fm=26&gp=0.jpg";
    NSString *img11=@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3390282514,1409134585&fm=26&gp=0.jpg";
    NSString *img12=@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3047739253,1622211647&fm=26&gp=0.jpg";
    NSString *img13=@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3053536160,220854969&fm=26&gp=0.jpg";
    NSArray *imgs = [NSArray arrayWithObjects:img9,img10,img11,img12,img13, nil];
    for (int i=0; i<parentAccounts.count; i++) {
        UTParent *parent = [[UTParent alloc]init];
        parent.parentId = parentAccounts[i];
        parent.studentName = @"某某某";
        parent.parentName=parentNames[i];
        parent.picPath=[imgs objectAtIndex:i%imgs.count];
        [fakeDatas addObject:parent];
    }
    return fakeDatas;
}


@end
