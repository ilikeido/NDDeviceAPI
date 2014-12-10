//
//  NDBaseAPI.m
//  Pods
//
//  Created by ilikeido on 14-12-5.
//
//

#import "NDBaseAPI.h"
#import "NDAPIShareValue.h"
#import "NDConfig.h"
#import <CommonCrypto/CommonDigest.h>
#import "LK_NSDictionary2Object.h"
#import <AFNetworking.h>
#import <objc/runtime.h>
#import <objc/message.h>

#define TIMEOUT_DEFAULT 30

#define SUCCESS_CODE 0

@interface NSString (md5)
-(NSString *) md5HexDigest;
@end

@implementation NSString (md5)

-(NSString *) md5HexDigest

{
    
    const char *original_str = [self UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
        
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
    
}

@end


@implementation NDRequestSystem


-(id)init{
    self = [super init];
    if (self) {
        self.version = @"1.0";
        self.jsonrpc = @"2.0";
        self.key = [NDAPIShareValue standardShareValue].app_key;
        long timeInterval = (long)[[NSDate date]timeIntervalSince1970];
        self.time= [NSString stringWithFormat:@"%ld",timeInterval];
        self.sign = [[NSString stringWithFormat:@"%@%@%@%@%@",_key,_time,[NDAPIShareValue standardShareValue].user_id?[NDAPIShareValue standardShareValue].user_id:@"",[NDAPIShareValue standardShareValue].token?[NDAPIShareValue standardShareValue].token:@"",[NDAPIShareValue standardShareValue].secret_key]md5HexDigest];
    }
    return self;
}


@end

@implementation NDRequestData

-(id)init{
    self = [super init];
    if (self) {
        self.user_id = [NDAPIShareValue standardShareValue].user_id?[NDAPIShareValue standardShareValue].user_id:@"";
        self.token = [NDAPIShareValue standardShareValue].token?[NDAPIShareValue standardShareValue].token:@"";
    }
    return self;
}


@end

@implementation NDAPIRequest

/**
 *  服务端地址
 *
 */
-(NSString *)_serverUrl{
    return URL_SERVER_BASE;
}

/**
 *  相应API路径
 *
 */
-(NSString *)_apiPath{
    return @"";
}

/**
 *  请求方法
 *
 */
-(NSString *)_method{
    return NDAPI_METHOD;
}

@end

@interface NDBaseAPIRequest (){
    NDAPIRequest *_apiRequest;
}

@end

@implementation NDBaseAPIRequest

-(id)init{
    self = [super init];
    if (self) {
        self.id = (long)[[NSDate date]timeIntervalSince1970];
        self.system = [[NDRequestSystem alloc]init];
        self.request = [[NDRequestData alloc]init];
    }
    return self;
}

-(void)setAPIRequest:(NDAPIRequest *)apiRequest{
    _apiRequest = apiRequest;
    self.method = apiRequest.method;
    self.params = apiRequest.params;
}

/**
 *  服务端地址
 *
 */
-(NSString *)_serverUrl{
    return _apiRequest._serverUrl;
}

/**
 *  相应API路径
 *
 */
-(NSString *)_apiPath{
    return _apiRequest._apiPath;
}

/**
 *  请求方法
 *
 */
-(NSString *)_method{
    return _apiRequest._method;
}

@end

@implementation NDBaseResult

@end

@implementation NDBaseAPIResponse

@end

@interface NDBaseAPI(p)
+(AFHTTPClient *)client;
@end


@implementation NDBaseAPI


+(AFHTTPClient *)client{
    static dispatch_once_t onceToken;
    static AFHTTPClient *_client;
    dispatch_once(&onceToken, ^{
        _client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:URL_SERVER_BASE]];
    });
    return _client;
}

+(AFHTTPClient *)clientByRequest:(NDAPIRequest *)request{
    if ([request._serverUrl isEqual:URL_SERVER_BASE]) {
        return [NDBaseAPI client];
    }
    return [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:request._serverUrl]];
}

+(NSString *)getFailDescriptByErrorCode:(int)errorCode{
    NSString *failDescription = @"";
    switch (errorCode) {
        case 100:
            failDescription = @"密码错误";
            break;
        case 101:
            failDescription = @"用户已存在";
            break;
        case 102:
            failDescription = @"用户不存在";
            break;
        case 1000:
            failDescription = @"授权过期";
            break;
        case 1001:
            failDescription = @"登录失败";
            break;
        case 1002:
            failDescription = @"注册失败";
            break;
        case 1003:
            failDescription = @"参数有误";
            break;
        case 1004:
            failDescription = @"获取设备信息失败";
            break;
        case 1005:
            failDescription = @"无法联系设备";
            break;
        case 1006:
            failDescription = @"操作超时";
            break;
        case 1011:
            failDescription = @"密码错误太多次";
            break;
        case 2000:
            failDescription = @"未登录";
            break;
        case 2001:
            failDescription = @"服务有误";
            break;
        case 2002:
            failDescription = @"服务未开启";
            break;
        case 2020:
            failDescription = @"数据库不存在";
            break;
        case 2021:
            failDescription = @"数据库有误";
            break;
        case 2101:
            failDescription = @"设备未注册";
            break;
        case 2102:
            failDescription = @"设备已绑定";
            break;
        case 2103:
            failDescription = @"设备未绑定";
            break;
        default:
            break;
    }
    return failDescription;
}

+(void)filterParams:(NSMutableDictionary *)dict{
    unsigned int propertyCount = 0;
    static NSMutableArray *objectDefaultKeys ;
    if (objectDefaultKeys == nil) {
        objc_property_t *properties = class_copyPropertyList([NSObject class], &propertyCount);
        objectDefaultKeys = [[NSMutableArray alloc]init];
        for ( NSUInteger i = 0; i < propertyCount; i++ )
        {
            const char *	name = property_getName(properties[i]);
            NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            [objectDefaultKeys addObject:propertyName];
        }
        [objectDefaultKeys addObject:@"hash"];
        [objectDefaultKeys addObject:@"debugDescription"];
        [objectDefaultKeys addObject:@"description"];
    }
    for (NSString *key in objectDefaultKeys) {
        [dict removeObjectForKey:key];
    }
}

/**
 *  向服务器发起请求
 *
 *  @param request 请求对象
 *  @param sucess 成功返回的Block
 *  @param fail 失败返回的Block
 *
 */
+(void)request:(NDAPIRequest *)request resultClass:(Class)resultClass completionBlockWithSuccess:(void(^)(NSObject *result,NSString *message))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    AFHTTPClient *client = [NDBaseAPI clientByRequest:request];
    client.parameterEncoding = AFJSONParameterEncoding;
    //    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    client.allowsInvalidSSLCertificate = YES;
    NDBaseAPIRequest *apiRequest = [[NDBaseAPIRequest alloc]init];
    [apiRequest setParams:request.params];
    [apiRequest setMethod:request.method];
    NSMutableDictionary *dict = (NSMutableDictionary *)apiRequest.lkDictionary;
    [NDBaseAPI filterParams:dict];
    NSLog(@"request:%@",dict);
    NSURLRequest *urlRequest = [client requestWithMethod:request._method path:request._apiPath  parameters:dict];
    AFHTTPRequestOperation *operation =
    [client HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSData *responseData = (NSData *)responseObject;
            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"url:%@|response:%@",urlRequest.URL,responseString);
            NSError *error = nil;
            //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
            if (dict) {
                NDBaseAPIResponse *response = [dict objectByClass:[NDBaseAPIResponse class]];
                if (!response) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        fail(-1,@"服务器异常");
                    });
                    return ;
                }
                if (response.result.code != SUCCESS_CODE) {
                    NSString *errorMessage = [self getFailDescriptByErrorCode:response.result.code ];
                    NSString *message = response.result.message;
                    if (errorMessage.length == 0) {
                        errorMessage = message;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        fail(response.result.code,errorMessage);
                    });
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_ERROR object:nil userInfo:@{ERROR_CODE:[NSString stringWithFormat:@"%d",response.result.code ],ERROR_DESCRIPTION:errorMessage}];
                    return;
                }
                if([response.result.data isKindOfClass:[NSArray class]]){
                    NSMutableArray *results = [NSMutableArray array];
                    for (NSDictionary *dic in (NSArray *)response.result.data) {
                        NSObject *obj = [dic objectByClass:resultClass];
                        [results addObject:obj];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        sucess(results,response.result.message);
                    });
                    
                }else if([response.result.data isKindOfClass:[NSDictionary class]]){
                    NSDictionary *dic = (NSDictionary *)response.result.data;
                    NSObject *obj = [dic objectByClass:resultClass];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        sucess(obj,response.result.message);
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    fail(-1,@"服务器异常");
                });
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"url:%@,fail:%@",urlRequest.URL,[error localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^{
            fail(-1,@"网络不给力");
        });
    }];
    [client enqueueHTTPRequestOperation:operation];
}

@end
