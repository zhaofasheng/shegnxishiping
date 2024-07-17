//
//  CMUUIDManager.m
//  UUID
//
//  Created by lxy on 2017/2/22.
//  Copyright © 2017年 xxx All rights reserved.
//
 
 
#import "CMUUIDManager.h"
#import "CMKeyChain.h"
 
@implementation CMUUIDManager

static NSString * const KEY_IN_KEYCHAIN = @"com.xxx.UUID";
static NSString * const KEY_UUID = @"com.xxx.UUID.uuid";

+(void)saveUUID:(NSString *)uuid
{
    NSMutableDictionary *usernameUuidPairs = [NSMutableDictionary dictionary];
    [usernameUuidPairs setObject:uuid forKey:KEY_UUID];
    [CMKeyChain save:KEY_IN_KEYCHAIN data:usernameUuidPairs];
}
 
+(id)readUUID
{
    NSMutableDictionary *usernameUuidPairs = (NSMutableDictionary *)[CMKeyChain load:KEY_IN_KEYCHAIN];
    return [usernameUuidPairs objectForKey:KEY_UUID];
}
 
+(void)deleteUUID
{
    [CMKeyChain delete:KEY_IN_KEYCHAIN];
}

@end
