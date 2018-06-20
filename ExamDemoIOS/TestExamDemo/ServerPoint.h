//
//  ServerPoint.h
//  TestExamDemo
//
//  Created by PXJ on 2018/6/20.
//  Copyright © 2018年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskInfo.h"

@interface ServerPoint : NSObject

@property (nonatomic,strong)NSMutableArray * taskArr;

@property (nonatomic,assign)int nodeId;

@property (nonatomic,assign)int consumption;

//当前服务节点资源消耗率
- (int)calculateConsumption;

- (BOOL)existTaskId:(int)taskId;

- (void)addTask:(TaskInfo*)task;

- (BOOL)deleteTaskWithId:(int)taskId;
@end
