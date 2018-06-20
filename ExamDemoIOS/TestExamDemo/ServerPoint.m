//
//  ServerPoint.m
//  TestExamDemo
//
//  Created by PXJ on 2018/6/20.
//  Copyright © 2018年 cmcc. All rights reserved.
//

#import "ServerPoint.h"

@implementation ServerPoint

- (id)init{
    self = [super init];
    if (self) {
        self.taskArr = [NSMutableArray arrayWithCapacity:0];
        self.nodeId = 0;
        self.consumption = 0;
    }
    return self;
}

- (int)calculateConsumption
{
    int allConsumption = 0;
    for (TaskInfo * task in _taskArr) {
        allConsumption += task.consumption;
    }
    self.consumption = allConsumption;
    return allConsumption;
}

- (BOOL)existTaskId:(int)taskId;
{
    for (TaskInfo * task in _taskArr) {
        if (task.taskId == taskId) {
            return YES;
        }
    }
    return NO;
}
- (void)addTask:(TaskInfo*)task;
{
    task.nodeId = self.nodeId;
    [self.taskArr addObject:task];
    [self calculateConsumption];
}

- (BOOL)deleteTaskWithId:(int )taskId;
{
    for (TaskInfo * task in _taskArr) {
        if (task.taskId == taskId) {
            [self calculateConsumption];
            return YES;
        }
    }
    return NO;
}
@end
