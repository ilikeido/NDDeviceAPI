//
//  NDAPIShareVaule.h
//  Pods
//
//  Created by ilikeido on 14-12-5.
//
//

#import <Foundation/Foundation.h>

@interface NDAPIShareValue : NSObject

@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) NSString *user_id;
@property(nonatomic,strong) NSString *app_key;
@property(nonatomic,strong) NSString *secret_key;

+(NDAPIShareValue *)standardShareValue;

@end
