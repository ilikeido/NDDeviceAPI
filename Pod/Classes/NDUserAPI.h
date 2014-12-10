//
//  NDUserAPI.h
//  Pods
//
//  Created by ilikeido on 14-12-5.
//
//

#import <Foundation/Foundation.h>
#import "NDBaseAPI.h"

@interface NDRegiterParams : NSObject

/**
 *  用户名(必填)
 */
@property(nonatomic,strong) NSString *user_name;

/**
 *  密码（MD5加密）
 */
@property(nonatomic,strong) NSString *password;

/**
 *  备注信息
 */
@property(nonatomic,strong) NSString *info;

@end

/**
 *  注册结果
 */
@interface NDRegiterResult : NSObject
/**
 *  用户id
 */
@property(nonatomic,strong) NSString *user_id;

@end


@interface NDLoginParams : NSObject


/**
 *  用户名(必填)
 */
@property(nonatomic,strong) NSString *user_name;

/**
 *  密码（MD5加密）
 */
@property(nonatomic,strong) NSString *password;

@end

/**
 *  登录结果
 */
@interface NDLoginResult : NSObject
/**
 *  用户id
 */
@property(nonatomic,strong) NSString *user_id;

//返回token
@property(nonatomic,strong) NSString *token;

@end


@interface NDUserAPI : NDBaseAPI

+(void)regiterWithParams:(NDRegiterParams *)params completionBlockWithSuccess:(void(^)(NDRegiterResult *result))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

+(void)loginWithParams:(NDLoginParams *)params completionBlockWithSuccess:(void(^)(NDLoginResult *result))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


@end
