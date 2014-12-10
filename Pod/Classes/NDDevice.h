//
//  NDDevice.h
//  Pods
//
//  Created by ilikeido on 14-12-3.
//
//

#import <Foundation/Foundation.h>
/**
 *  设备信息
 */
@interface NDDevice : NSObject

/**
 *  设备id
 */
@property(nonatomic,strong) NSString *ndevice_id;

/**
 *  设备sn
 */
@property(nonatomic,strong) NSString *ndevice_sn;

/**
 *  设备昵称
 */
@property(nonatomic,strong) NSString *nick_name;

/**
 *  设备附加属性（厂商可自定义内容）
 */
@property(nonatomic,strong) NSString *device_info;

@end
