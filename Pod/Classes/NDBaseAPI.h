//
//  NDBaseAPI.h
//  Pods
//
//  Created by ilikeido on 14-12-5.
//
//

#import <Foundation/Foundation.h>

@interface NDRequestSystem : NSObject

@property(nonatomic,strong) NSString *version;
@property(nonatomic,strong) NSString *jsonrpc;
@property(nonatomic,strong) NSString *sign;
@property(nonatomic,strong) NSString *key;
@property(nonatomic,strong) NSString *time;

@end

@interface NDRequestData : NSObject

@property(nonatomic,strong) NSString *user_id;
@property(nonatomic,strong) NSString *token;

@end


@interface NDAPIRequest : NSObject

@property(nonatomic,strong) NSString *method;
@property(nonatomic,strong) NSObject *params;

-(NSString *)_serverUrl;
-(NSString *)_apiPath;
-(NSString *)_method;

@end

@interface NDBaseAPIRequest : NSObject

@property(nonatomic,strong) NDRequestSystem *system;

@property(nonatomic,strong) NDRequestData *request;

@property(nonatomic,strong) NSString *method;

@property(nonatomic,strong) NSObject *params;

@property(nonatomic,assign) long  id;

-(void)setAPIRequest:(NDAPIRequest *)apiRequest;

@end

@interface NDBaseResult : NSObject

@property(nonatomic,assign) int code;
@property(nonatomic,strong) NSString *message;
@property(nonatomic,strong) NSObject *data;

@end


@interface NDBaseAPIResponse : NSObject

@property(nonatomic,assign) long id;

@property(nonatomic,strong) NDBaseResult *result;

@end



@interface NDBaseAPI : NSObject

/**
 *  向服务器发起请求
 *
 *  @param request 请求对象
 *  @param sucess 成功返回的Block
 *  @param fail 失败返回的Block
 *
 */
+(void)request:(NDAPIRequest *)request resultClass:(Class)resultClass completionBlockWithSuccess:(void(^)(NSObject *result,NSString *message))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

@end
