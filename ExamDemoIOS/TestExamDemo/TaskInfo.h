//
//  TaskInfo.h
//  TestExamDemo
//
//  Created by George She on 2018/6/15.
//  Copyright © 2018年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskInfo : NSObject
@property (nonatomic, assign) int taskId;//任务编号
@property (nonatomic, assign) int nodeId;//服务节点编号
@property (nonatomic, assign) int consumption;//率

@end
