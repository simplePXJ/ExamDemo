//
//  Schedule.m
//  ExamDemo
//
//  Created by George She on 2018/6/8.
//  Copyright © 2018年 CMRead. All rights reserved.
//

#import "Schedule.h"
#import "TaskInfo.h"
#import "ServerPoint.h"
#import "ReturnCodeKeys.h"

@implementation Schedule
{
    NSMutableArray * taskArr;
    NSMutableArray * serverPointArr;
}


-(int)clean{
    serverPointArr = [NSMutableArray arrayWithCapacity:0];
    return kE001;
}

-(int)registerNode:(int)nodeId{
    
    if (nodeId<=0) return kE004; //注册非法
    
    BOOL severExist = NO;
    for (int i= 0; i<serverPointArr.count; i++) {
        ServerPoint * severP = serverPointArr[i];
        if (severP.nodeId == nodeId) {
            severExist = YES;
           
            break;
        }
    }
    if (!severExist) {
        ServerPoint * newSeverP = [[ServerPoint alloc] init];
        newSeverP.nodeId = nodeId;
        [serverPointArr addObject:newSeverP];
    }
    return  severExist?kE005:kE003;
}

-(int)unregisterNode:(int)nodeId{
    
    if (nodeId<=0) return kE004; //注册非法
    
    ServerPoint * unregisterServerP = nil;
    
    for (int i= 0; i<serverPointArr.count; i++) {
        ServerPoint * serverPoint = serverPointArr[0];
        if (serverPoint.nodeId ==nodeId) {
            unregisterServerP = serverPoint;
            break;
        }
    }
    if (unregisterServerP) {
        if (unregisterServerP.taskArr.count>0) {
            [taskArr addObjectsFromArray:unregisterServerP.taskArr];
        }
        [serverPointArr removeObject:unregisterServerP];
        return kE006;
    }else{
        return kE007;
    }
}

-(int)addTask:(int)taskId withConsumption:(int)consumption{
    if (taskId<=0) return kE009;
    
    NSInteger minConsumptionServerId = 0;
    NSInteger minConsumption = 0;
    for (int i=0; i<serverPointArr.count; i++) {
        ServerPoint * serverPoint = serverPointArr[i];
        
        if ([serverPoint existTaskId:taskId]) {
            return kE010;
        }
        if (i==0) {
            minConsumption = serverPoint.consumption;
        }else
        {
            if(serverPoint.consumption<minConsumption)
            {
                minConsumption = serverPoint.consumption;
                minConsumptionServerId = i;
            }
        }
    }
    ServerPoint * serverPoint = serverPointArr[minConsumptionServerId];
    TaskInfo * task = [[TaskInfo alloc] init];
    task.taskId = taskId;
    task.consumption = consumption;
    [serverPoint addTask:task];
    return kE008;
}

-(int)deleteTask:(int)taskId{
    if (taskId<=0) return kE009;
    
    for (int i= 0; i<serverPointArr.count; i++) {
        ServerPoint * serverPoint =serverPointArr[i];
        BOOL isDelete = [serverPoint deleteTaskWithId:taskId];
        if(isDelete)return kE011;
    }
    return kE012;
}

-(int)scheduleTask:(int)threshold{
    if (threshold<=0) return kE002;
    NSMutableArray * allTaskArray = [NSMutableArray arrayWithCapacity:0];
    for (ServerPoint *serverPoint in serverPointArr) {
        if (serverPoint.taskArr.count>0) {
            [allTaskArray addObjectsFromArray:serverPoint.taskArr];
        }
        serverPoint.consumption = 0;
        serverPoint.taskArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    if  (taskArr.count>0){
        [allTaskArray addObjectsFromArray:taskArr];
    }
    
    
    NSArray * allTaskList = [allTaskArray sortedArrayUsingComparator:^NSComparisonResult(TaskInfo *obj1, TaskInfo *obj2) {
        return [[NSNumber numberWithDouble:obj2.taskId] compare:[NSNumber numberWithDouble:obj1.taskId]];
    } ];
    //用现价对数组中的字典进行排序
    NSArray * allServerList = [serverPointArr sortedArrayUsingComparator:^NSComparisonResult(ServerPoint *obj1, ServerPoint *obj2) {
        return [[NSNumber numberWithDouble:obj1.nodeId] compare:[NSNumber numberWithDouble:obj2.nodeId]];
    }];
    
    for (int i=0; i<allTaskList.count; i++) {
        TaskInfo * taskInfo = allTaskList[i];
        
        int minConsumption = 0;
        ServerPoint * minServerpoint;
        for (int j=0; j<allServerList.count; j++) {
            ServerPoint * serverPoint = allServerList[j];
            NSLog(@"serverNodId%d--taskConsumption%d----j-%d",serverPoint.nodeId,serverPoint.consumption,j);
            if (i==0) {
                minServerpoint = serverPoint;
                minConsumption = taskInfo.consumption;
                break;
            }else{
                if (serverPoint.consumption<minConsumption) {
                    minServerpoint = serverPoint;
                    minConsumption = serverPoint.consumption;
                }
            }
        }
        [minServerpoint addTask:taskInfo];
    }
    
    int minServerConsumption = 0;
    int maxServerConsumption = 0;
    
    for (int i= 0; i<allServerList.count; i++) {
        ServerPoint * serverPoint = allServerList[i];
        if (i==0) {
            minServerConsumption = serverPoint.consumption;
            maxServerConsumption = serverPoint.consumption;
        }else{
            if (serverPoint.consumption>maxServerConsumption) {
                maxServerConsumption = serverPoint.consumption;
            }
            if (serverPoint.consumption<minServerConsumption) {
                minServerConsumption = serverPoint.consumption;
            }
        }
    }
    
    if ( maxServerConsumption-minServerConsumption<=threshold) {
        return kE013;
    }else{
        return kE014;
    }

}

-(int)queryTaskStatus:(NSMutableArray<TaskInfo *> *)tasks{
    
    for (ServerPoint * serverPoint in serverPointArr) {
        if (serverPoint.taskArr.count>0) {
            [tasks addObjectsFromArray:serverPoint.taskArr];
        }
    }
    if (taskArr.count>0) {
        [tasks addObjectsFromArray:taskArr];
    }
    if (tasks) {
        return kE015;
    }else{
        return kE016;
    };
}
@end
