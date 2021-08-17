//
//  JXPhotoManager.h
//  JXUtilsKit
//
//  Created by Barnett on 2021/8/11.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    JXPhotoManagerFile_Image,
    JXPhotoManagerFile_Video,
} JXPhotoManagerSaveFileType;

typedef enum : NSUInteger {
    JXPhotoManagerRequest_AddOnly, // 相册仅允许添加照片
    JXPhotoManagerRequest_ReadWrite,// 相册允许访问照片，limitedLevel 必须为 readWrite
} JXPhotoManagerRequestType;

typedef enum : NSUInteger {
    JXPhotoManagerAuthorizationStatus_NotDetermined,// 用户第一次请求权限未授权
    JXPhotoManagerAuthorizationStatus_Restricted,   // 家长控制之类的活动限制
    JXPhotoManagerAuthorizationStatus_Denied,       // 用户明确拒绝
    JXPhotoManagerAuthorizationStatus_Authorized,   // 用户允许
    JXPhotoManagerAuthorizationStatus_Limited API_AVAILABLE(ios(14)), // 用户已授权此应用程序访问有限的照片库。
} JXPhotoManagerAuthorizationStatus;

typedef enum : NSUInteger {
    JXPhotoManagerGetType_Asset,     // 所有图片和视频的asset
    JXPhotoManagerGetType_ImageAsset,// 图片asset
    JXPhotoManagerGetType_VideoAsset,// 视频asset
} JXPhotoManagerAssetGetType;

typedef void(^requestAuthorizationStatusCallBack)(JXPhotoManagerAuthorizationStatus status);
typedef void(^saveSuccessCallBack)(void);
typedef void(^saveFailCallBack)(NSError * _Nullable error);

@interface JXPhotoManager : NSObject
/* 相册的类型,默认PHAssetCollectionTypeSmartAlbum
 PHAssetCollectionTypeAlbum - 从 iTunes 同步来的相册，以及用户在Photos中自己创建的相册
 PHAssetCollectionTypeSmartAlbum - 经由相机得来的相册
 */
@property (nonatomic, assign) PHAssetCollectionType assetCollectionType;
/* 相册子类型，默认PHAssetCollectionSubtypeSmartAlbumUserLibrary
 注意，获取指定类型的相册时，主类型和子类型要匹配，不要串台。如果不匹配，系统会按照 Any 子类型来处理。
 */
@property (nonatomic, assign) PHAssetCollectionSubtype assetCollectionSubtype;
/// 相册搜索的条件,没有提供PHOptions的情况下，返回的PHFetchResult结果是按相册的建立时间排序的，最新的在前面
@property (nonatomic, strong) PHFetchOptions *collectionFetchOptions;
/// asset搜索的条件
@property (nonatomic, strong) PHFetchOptions *assetFetchOptions;
/// asset获取的类型
@property (nonatomic, assign, readonly) JXPhotoManagerAssetGetType getType;

/// 单例，非绝对
+ (instancetype)sharedInstance;

/// 获取图片信息
/// @param image 图片
+ (NSDictionary *)getExifInfoWithImage:(UIImage *)image;

/// 请求授权
/// @param requestType 授权类型
/// @param completion 完成回调
+ (void)requestAuthorizationType:(JXPhotoManagerRequestType)requestType completion:(requestAuthorizationStatusCallBack)completion;

/// 保存图片到相册
/// @param savedImage 需要存储的图片
/// @param albumName 相册的名称（nil-默认应用名称）
/// @param successCallBack 存储成功
/// @param failCallBack 存储失败
+ (void)saveImage:(UIImage *)savedImage albumName:(nullable NSString *)albumName successCallBack:(saveSuccessCallBack)successCallBack failCallBack:(saveFailCallBack)failCallBack;

/// 保存文件到相册
/// @param fileUrl 文件地址
/// @param fileType 文件类型
/// @param albumName 相册的名称（nil-默认应用名称）
/// @param successCallBack 存储成功
/// @param failCallBack 存储失败
+ (void)saveFileWithUrl:(NSURL *)fileUrl fileType:(JXPhotoManagerSaveFileType)fileType albumName:(nullable NSString *)albumName successCallBack:(saveSuccessCallBack)successCallBack failCallBack:(saveFailCallBack)failCallBack;

/// 根据asset取image,方法默认是异步执行
/// @param asset 要加载其图像数据的资源。
/// @param targetSize 要返回的图像的目标大小。
/// @param contentMode 使图像与所请求大小的纵横比相匹配
/// @param options 条件
/// @param resultHandler 回调
+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(nullable PHImageRequestOptions *)options resultHandler:(void (^)(UIImage *_Nullable result, NSDictionary *_Nullable info))resultHandler;

/// 根据asset取image data,方法默认是异步执行
/// @param asset 要加载其图像数据的资源
/// @param options 条件
/// @param resultHandler 回调
+ (PHImageRequestID)requestImageDataForAsset:(PHAsset *)asset options:(nullable PHImageRequestOptions *)options resultHandler:(void (^)(NSData *_Nullable imageData, NSString *_Nullable dataUTI, UIImageOrientation orientation, NSDictionary *_Nullable info))resultHandler;

/// 根据asset取AVPlayerItem
/// @param asset 资源
/// @param options 条件
/// @param resultHandler 回调
+ (PHImageRequestID)requestPlayerItemForVideo:(PHAsset *)asset options:(nullable PHVideoRequestOptions *)options resultHandler:(void (^)(AVPlayerItem *__nullable playerItem, NSDictionary *__nullable info))resultHandler;

/// 根据asset取AVAsset
/// @param asset 资源
/// @param options 条件
/// @param resultHandler 回调
+ (PHImageRequestID)requestAVAssetForVideo:(PHAsset *)asset options:(nullable PHVideoRequestOptions *)options resultHandler:(void (^)(AVAsset *__nullable asset, AVAudioMix *__nullable audioMix, NSDictionary *__nullable info))resultHandler;

/// 获取asset
/// @param getType 类型
/// @param range 数量
/// @param completion 回调
- (void)getAssetsWith:(JXPhotoManagerAssetGetType)getType range:(NSRange)range completion:(void(^)(NSArray <PHAsset *>*,BOOL isHaveMore))completion;

/// 获取所有asset
/// @param getType 类型
/// @param completion 回调
- (void)getAllAssetsWith:(JXPhotoManagerAssetGetType)getType completion:(void(^)(NSArray <PHAsset *>*))completion;

@end

NS_ASSUME_NONNULL_END
