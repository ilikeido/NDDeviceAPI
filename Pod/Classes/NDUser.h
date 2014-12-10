//
//  NDUser.h
//  Pods
//
//  Created by ilikeido on 14-12-3.
//
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    NDUSER_SEX_UNKNOW = 0,
    NDUSER_SEX_MALE = 1,
    NDUSER_SEX_FEMALE = 2,
} NDUSER_SEX;

/**
 *  用户
 */
@interface NDUser : NSObject

/**
 *  用户ID
 */
@property(nonatomic,strong) NSString *user_id;

/**
 *  用户名
 */
@property(nonatomic,strong) NSString *user_name;

/**
 *  性别
 */
@property(nonatomic,assign) int *sex;

/**
 *  昵称
 */
@property(nonatomic,strong) NSString *nick_name;

/**
 *  手机号
 */
@property(nonatomic,strong) NSString *mobile;

/**
 *  电子邮箱
 */
@property(nonatomic,strong) NSString *email;

@end
