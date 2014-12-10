//
//  NDUserAPI.m
//  Pods
//
//  Created by ilikeido on 14-12-5.
//
//

#import "NDUserAPI.h"
#import "NDConfig.h"

/**
 *  用户注册请求
 */
@interface NDRegiterRequest :NDAPIRequest

@property(nonatomic,strong) NDRegiterParams *params;

@end

@implementation NDRegiterResult 

@end

@implementation NDRegiterParams

@end

@implementation NDRegiterRequest

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

/**
 *  相应API路径
 *
 */
-(NSString *)_apiPath{
    return V1_API_ACCOUNT;
}

-(NSString *)method{
    return @"register";
}

@end


@implementation NDLoginParams


@end

@interface NDLoginRequest:NDAPIRequest

@property(nonatomic,strong) NDLoginParams *params;

@end

@implementation NDLoginRequest

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

/**
 *  相应API路径
 *
 */
-(NSString *)_apiPath{
    return V1_API_ACCOUNT;
}

-(NSString *)method{
    return @"login";
}


@end

@implementation NDLoginResult


@end


@implementation NDUserAPI

+(void)regiterWithParams:(NDRegiterParams *)params completionBlockWithSuccess:(void(^)(NDRegiterResult *result))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDRegiterRequest *request = [[NDRegiterRequest alloc]init];
    request.params = params;
    [self request:request resultClass:[NDRegiterResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess((NDRegiterResult *)result);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

+(void)loginWithParams:(NDLoginParams *)params completionBlockWithSuccess:(void(^)(NDLoginResult *result))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    NDLoginRequest *request = [[NDLoginRequest alloc]init];
    request.params = params;
    [self request:request resultClass:[NDLoginResult class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess((NDLoginResult *)result);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

@end
