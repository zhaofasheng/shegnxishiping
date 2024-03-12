/////////////////////////////////////////////////////////////////////
//
//                     腾讯云通信服务 IMSDK
//
//  模块名称：V2TIMManager+Community
//
//  社群接口，里面包含了创建话题、删除话题、修改话题、获取话题列表等逻辑
//
/////////////////////////////////////////////////////////////////////
#import "V2TIMManager.h"
#import "V2TIMManager+Group.h"

V2TIM_EXPORT @protocol V2TIMCommunityListener;
@class V2TIMTopicInfo;
@class V2TIMTopicInfoResult;
@class V2TIMTopicOperationResult;

V2TIM_EXPORT @interface V2TIMManager (Community)

/// 操作话题列表结果
typedef void(^V2TIMTopicOperationResultSucc)(NSMutableArray<V2TIMTopicOperationResult *> *resultList);
/// 获取话题列表结果
typedef void(^V2TIMTopicInfoResultListSucc)(NSMutableArray<V2TIMTopicInfoResult *> *resultList);
/// 创建话题成功回调
typedef void (^V2TIMCreateTopicSucc)(NSString * topicID);

/////////////////////////////////////////////////////////////////////////////////
//
//                         社群监听器
//
/////////////////////////////////////////////////////////////////////////////////

/**
 *  1.1 添加社群监听器
 */
- (void)addCommunityListener:(id<V2TIMCommunityListener>)listener NS_SWIFT_NAME(addCommunityListener(listener:));

/**
 *  1.2 移除社群监听器
 */
- (void)removeCommunityListener:(id<V2TIMCommunityListener>)listener NS_SWIFT_NAME(removeCommunityListener(listener:));

/////////////////////////////////////////////////////////////////////////////////
//
//                       社群接口
//
/////////////////////////////////////////////////////////////////////////////////
/**
 * 2.1 创建支持话题的社群
 */
- (void)createCommunity:(V2TIMGroupInfo*)info memberList:(NSArray<V2TIMCreateGroupMemberInfo *>*) memberList succ:(V2TIMCreateGroupSucc)succ fail:(V2TIMFail)fail;

/**
 * 2.1 获取当前用户已经加入的支持话题的社群列表
 */
- (void)getJoinedCommunityList:(V2TIMGroupInfoListSucc)succ fail:(V2TIMFail)fail;

/**
 * 2.2 创建话题
 *
 * @param groupID 社群 ID，必须以 @TGS#_ 开头。
 */
- (void)createTopicInCommunity:(NSString *)groupID topicInfo:(V2TIMTopicInfo *)topicInfo succ:(V2TIMCreateTopicSucc)succ fail:(V2TIMFail)fail;

/**
 * 2.3 删除话题
 */
- (void)deleteTopicFromCommunity:(NSString *)groupID topicIDList:(NSArray<NSString *>*)topicIDList succ:(V2TIMTopicOperationResultSucc)succ fail:(V2TIMFail)fail;

/**
 * 2.4 修改话题信息
 */
- (void)setTopicInfo:(V2TIMTopicInfo *)topicInfo succ:(V2TIMSucc)succ fail:(V2TIMFail)fail;

/**
 * 2.5 获取话题列表。
 * @note: topicIDList 传空时，获取此社群下的所有话题列表
 */
- (void)getTopicInfoList:(NSString *)groupID topicIDList:(NSArray<NSString *>*)topicIDList succ:(V2TIMTopicInfoResultListSucc)succ fail:(V2TIMFail)fail;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                      社群回调
//
/////////////////////////////////////////////////////////////////////////////////
/// 资料关系链回调
V2TIM_EXPORT @protocol V2TIMCommunityListener <NSObject>
@optional

/// 话题创建回调
- (void)onCreateTopic:(NSString *)groupID topicID:(NSString *)topicID;

/// 话题被删除回调
- (void)onDeleteTopic:(NSString *)groupID topicIDList:(NSArray<NSString *> *)topicIDList;

/// 话题更新回调
- (void)onChangeTopicInfo:(NSString *)groupID topicInfo:(V2TIMTopicInfo *)topicInfo;

/// 收到 RESTAPI 下发的话题自定义系统消息
- (void)onReceiveTopicRESTCustomData:(NSString *)topicID data:(NSData *)data;

@end

/////////////////////////////////////////////////////////////////////////////////
//
//             话题基本资料
//
/////////////////////////////////////////////////////////////////////////////////
V2TIM_EXPORT @interface V2TIMTopicInfo : NSObject

/// 话题 ID，只能在创建话题或者修改话题信息的时候设置。组成方式为：社群 ID + @TOPIC#_xxx，例如社群 ID 为 @TGS#_123，则话题 ID 为 @TGS#_123@TOPIC#_xxx
@property(nonatomic, strong) NSString *topicID;

/// 话题名称，最长 150 字节，使用 UTF-8 编码
@property(nonatomic, strong) NSString *topicName;

/// 话题头像，最长 500 字节，使用 UTF-8 编码
@property(nonatomic, strong) NSString *topicFaceURL;

/// 话题介绍，最长 400 字节，使用 UTF-8 编码
@property(nonatomic, strong) NSString *introduction;

/// 话题公告，最长 400 字节，使用 UTF-8 编码
@property(nonatomic, strong) NSString *notification;

/// 话题全员禁言
@property(nonatomic, assign) BOOL isAllMuted;

/// 当前用户在话题中的禁言时间，单位：秒
@property(nonatomic, assign, readonly) uint32_t selfMuteTime;

/// 话题自定义字段
@property(nonatomic, strong) NSString *customString;

/// 话题消息接收选项，修改话题消息接收选项请调用 setGroupReceiveMessageOpt 接口
@property(nonatomic, assign, readonly) V2TIMReceiveMessageOpt recvOpt;

/// 话题草稿
@property(nonatomic, strong) NSString *draftText;

/// 话题消息未读数量
@property(nonatomic, assign, readonly) uint64_t unreadCount;

/// 话题 lastMessage
@property(nonatomic,strong,readonly) V2TIMMessage *lastMessage;

/// 话题 at 信息列表
@property(nonatomic, strong, readonly) NSArray<V2TIMGroupAtInfo *> *groupAtInfolist;

/// 话题创建时间，单位：秒
@property(nonatomic, assign, readonly) uint32_t createTime;
@end

/////////////////////////////////////////////////////////////////////////////////
//
//             V2TIMTopicOperationResult
//
/////////////////////////////////////////////////////////////////////////////////
V2TIM_EXPORT @interface V2TIMTopicOperationResult : NSObject

/// 结果 0：成功；非0：失败
@property(nonatomic, assign)  int errorCode;

/// 错误信息
@property(nonatomic, strong)  NSString *errorMsg;

/// 话题 ID
@property(nonatomic, strong)  NSString *topicID;
@end

/////////////////////////////////////////////////////////////////////////////////
//
//             V2TIMTopicInfoResult
//
/////////////////////////////////////////////////////////////////////////////////
V2TIM_EXPORT @interface V2TIMTopicInfoResult : NSObject

/// 结果 0：成功；非0：失败
@property(nonatomic, assign)  int errorCode;

/// 错误信息
@property(nonatomic, strong)  NSString *errorMsg;

/// 话题资料
@property(nonatomic, strong)  V2TIMTopicInfo *topicInfo;
@end
