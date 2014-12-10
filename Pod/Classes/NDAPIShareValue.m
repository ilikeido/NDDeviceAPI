//
//  NDAPIShareVaule.m
//  Pods
//
//  Created by ilikeido on 14-12-5.
//
//

#import "NDAPIShareValue.h"

@implementation NDAPIShareValue

+(NDAPIShareValue *)standardShareValue{
    static NDAPIShareValue *_signleInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _signleInstance = [[NDAPIShareValue alloc]init];
    });
    return _signleInstance;
}

@end
