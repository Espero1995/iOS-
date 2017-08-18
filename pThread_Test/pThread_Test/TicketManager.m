//
//  TicketManager.m
//  pThread_Test
//
//  Created by Espero on 2017/8/18.
//  Copyright © 2017年 Espero. All rights reserved.
//

#import "TicketManager.h"
#define Total 20;
@interface TicketManager ()

@property  int tickets;//剩余票数
@property  int saleCounts;//卖出票数


@property(nonatomic,strong) NSThread *threadBJ;
@property(nonatomic,strong) NSThread *threadSH;

@property(nonatomic,strong)NSCondition *ticketCondition;

@end
@implementation TicketManager

-(instancetype)init{
    if (self=[super init]) {
        self.tickets=Total;
        self.threadBJ=[[NSThread alloc]initWithTarget:self selector:@selector(sale) object:nil];
        [self.threadBJ setName:@"北京售票口"];
        self.threadSH=[[NSThread alloc]initWithTarget:self selector:@selector(sale) object:nil];
        [self.threadSH setName:@"上海售票口"];
        
        //初始化
        self.ticketCondition=[[NSCondition alloc]init];
    }
    return self;
}

-(void)sale{
    while (true) {
//        @synchronized (self) {
        
        [self.ticketCondition lock];
        
        //ticke>0说明还有票可以卖
        if (self.tickets>0) {
            [NSThread sleepForTimeInterval:0.5];
            self.tickets--;
            int zong=Total;
            self.saleCounts=zong-self.tickets;
            NSLog(@"%@:当前余票：%d,售出：%d",[NSThread currentThread].name,self.tickets,self.saleCounts);
        }else{
            break;
        }
            [self.ticketCondition unlock];
//        }
        
    }
}

-(void)startToSale{
    [self.threadBJ start];
    [self.threadSH start];
}

@end
