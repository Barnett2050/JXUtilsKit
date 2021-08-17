//
//  JXPhotoManager.m
//  JXUtilsKit
//
//  Created by Barnett on 2021/8/11.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import "JXPhotoManager.h"
#import <UIKit/UIKit.h>

static NSString *kPhotoLibraryKey = @"NSPhotoLibraryUsageDescription"; // 相册读写权限key
static NSString *kPhotoLibraryKeyAddOnly = @"NSPhotoLibraryAddUsageDescription"; // 相册只写入权限key

@interface JXPhotoManager ()

@property (nonatomic, assign, readwrite) JXPhotoManagerAssetGetType getType;
@property (nonatomic, strong) NSMutableArray *assetArray;
@end

@implementation JXPhotoManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onestoken;
    static JXPhotoManager *manager;
    dispatch_once(&onestoken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.assetCollectionType = PHAssetCollectionTypeSmartAlbum;
        self.assetCollectionSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary;
    }
    return self;
}

+ (NSDictionary *)getExifInfoWithImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    CGImageSourceRef cImageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    
    // 获取照片信息
//    NSDictionary *dict =  (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(cImageSource, 0, NULL));
//    NSMutableDictionary *dictInfo = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    // 获取照片EXIF信息
    CFDictionaryRef imageInfo = CGImageSourceCopyPropertiesAtIndex(cImageSource, 0,NULL);
    NSDictionary *exifDic = (__bridge NSDictionary *)CFDictionaryGetValue(imageInfo, kCGImagePropertyExifDictionary);
    
    return (NSDictionary *)exifDic;
}

+ (void)requestAuthorizationType:(JXPhotoManagerRequestType)requestType completion:(requestAuthorizationStatusCallBack)completion
{
    if (!completion) { return; }
    
    if (@available(iOS 14.0,*)) {
        PHAccessLevel accessLevel;
        if (requestType == JXPhotoManagerRequest_AddOnly) {
            accessLevel = PHAccessLevelAddOnly;
        } else {
            accessLevel = PHAccessLevelReadWrite;
        }
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:accessLevel];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelAddOnly handler:^(PHAuthorizationStatus status) {
                [self requestAuthorizationResultWith:status completion:completion];
            }];
        } else {
            [self requestAuthorizationResultWith:status completion:completion];
        }
    } else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                [self requestAuthorizationResultWith:status completion:completion];
            }];
        } else {
            [self requestAuthorizationResultWith:status completion:completion];
        }
    }
}

+ (void)saveImage:(UIImage *)savedImage albumName:(nullable NSString *)albumName successCallBack:(saveSuccessCallBack)successCallBack failCallBack:(saveFailCallBack)failCallBack
{
    // 获得相片
    PHFetchResult<PHAsset *> *createdAssets = [JXPhotoManager createdAssetsWithImage:savedImage];
    // 获得相册
    PHAssetCollection *createdCollection = [JXPhotoManager createdCollectionWithName:albumName];
    
    if (createdAssets == nil || createdCollection == nil) {
        failCallBack(nil);
    } else { // 成功 将图片添加到相册
        NSError *error = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
            [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
        } error:&error];
    
        if (error) {
            failCallBack(error);
        } else {
            successCallBack();
        }
    }
}

+ (void)saveFileWithUrl:(NSURL *)fileUrl fileType:(JXPhotoManagerSaveFileType)fileType albumName:(nullable NSString *)albumName successCallBack:(saveSuccessCallBack)successCallBack failCallBack:(saveFailCallBack)failCallBack
{
    // 获得存储的文件
    PHFetchResult<PHAsset *> *createdAssets = [JXPhotoManager createdAssetsWithFile:fileUrl fileType:fileType];
    // 获得相册
    PHAssetCollection *createdCollection = [JXPhotoManager createdCollectionWithName:albumName];
    if (createdAssets == nil || createdCollection == nil) {
        failCallBack(nil);
    }else
    { // 成功 将文件添加到相册
        NSError *error = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
            [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
        } error:&error];
        if (error) {
            failCallBack(error);
        } else {
            successCallBack();
        }
    }
}

+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(nullable PHImageRequestOptions *)options resultHandler:(void (^)(UIImage *_Nullable result, NSDictionary *_Nullable info))resultHandler
{
    return [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:contentMode options:options resultHandler:resultHandler];
}

+ (PHImageRequestID)requestImageDataForAsset:(PHAsset *)asset options:(nullable PHImageRequestOptions *)options resultHandler:(void (^)(NSData *_Nullable imageData, NSString *_Nullable dataUTI, UIImageOrientation orientation, NSDictionary *_Nullable info))resultHandler
{
    if (@available(iOS 13, *)) {
        return [[PHImageManager defaultManager] requestImageDataAndOrientationForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
            UIImageOrientation imageOrientation = UIImageOrientationUp;
            switch (orientation) {
                case kCGImagePropertyOrientationUp:
                    imageOrientation = UIImageOrientationUp;
                    break;
                case kCGImagePropertyOrientationUpMirrored:
                    imageOrientation = UIImageOrientationUpMirrored;
                    break;
                case kCGImagePropertyOrientationDown:
                    imageOrientation = UIImageOrientationDown;
                    break;
                case kCGImagePropertyOrientationDownMirrored:
                    imageOrientation = UIImageOrientationDownMirrored;
                    break;
                case kCGImagePropertyOrientationLeftMirrored:
                    imageOrientation = UIImageOrientationLeftMirrored;
                    break;
                case kCGImagePropertyOrientationRight:
                    imageOrientation = UIImageOrientationRight;
                    break;
                case kCGImagePropertyOrientationRightMirrored:
                    imageOrientation = UIImageOrientationRightMirrored;
                    break;
                case kCGImagePropertyOrientationLeft:
                    imageOrientation = UIImageOrientationLeft;
                    break;
                default:
                    break;
            }
            resultHandler(imageData,dataUTI,imageOrientation,info);
        }];
    } else {
        return [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:resultHandler];
    }
}

+ (PHImageRequestID)requestPlayerItemForVideo:(PHAsset *)asset options:(nullable PHVideoRequestOptions *)options resultHandler:(void (^)(AVPlayerItem *__nullable playerItem, NSDictionary *__nullable info))resultHandler
{
    return [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:options resultHandler:resultHandler];
}

+ (PHImageRequestID)requestAVAssetForVideo:(PHAsset *)asset options:(nullable PHVideoRequestOptions *)options resultHandler:(void (^)(AVAsset *__nullable asset, AVAudioMix *__nullable audioMix, NSDictionary *__nullable info))resultHandler
{
    return [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:resultHandler];
}

- (void)getAssetsWith:(JXPhotoManagerAssetGetType)getType range:(NSRange)range completion:(void(^)(NSArray <PHAsset *>*,BOOL isHaveMore))completion
{
    if (!completion) { return; }
    if (self.getType == getType && self.assetArray.count != 0) {
        
    } else {
        self.getType = getType;
        PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:self.assetCollectionType subtype:self.assetCollectionSubtype options:self.collectionFetchOptions];
        self.assetArray = [NSMutableArray array];
        PHAssetMediaType mediaType;
        switch (getType) {
            case JXPhotoManagerGetType_ImageAsset:
            {
                mediaType = PHAssetMediaTypeImage;
            }
                break;
            case JXPhotoManagerGetType_VideoAsset:
            {
                mediaType = PHAssetMediaTypeVideo;
            }
                break;
            default:
                mediaType = PHAssetMediaTypeUnknown;
                break;
        }
        if (self.assetFetchOptions) {
            NSString *predicateFormat = self.assetFetchOptions.predicate.predicateFormat;
            self.assetFetchOptions.predicate = [NSPredicate predicateWithFormat:@"%@ AND mediaType = %d", predicateFormat,mediaType];
        } else if (mediaType != PHAssetMediaTypeUnknown) {
            self.assetFetchOptions = [[PHFetchOptions alloc] init];
            self.assetFetchOptions.predicate =  [NSPredicate predicateWithFormat:@"mediaType = %d", mediaType];
        }
        
        for (int i = 0; i < collections.count; i++) {
            PHAssetCollection *collection = collections[i];
            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:self.assetFetchOptions];
            if (assetResult.count != 0) {
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, assetResult.count)];
                [self.assetArray addObjectsFromArray:[assetResult objectsAtIndexes:indexSet]];
            }
        }
    }
    
    if (range.location + range.length >= self.assetArray.count && range.location < self.assetArray.count) {
        NSRange newRange = NSMakeRange(range.location, self.assetArray.count - range.location);
        NSIndexSet *indexS = [NSIndexSet indexSetWithIndexesInRange:newRange];
        completion([self.assetArray objectsAtIndexes:indexS],NO);
    } else if (range.length != 0) {
        NSIndexSet *indexS = [NSIndexSet indexSetWithIndexesInRange:range];
        completion([self.assetArray objectsAtIndexes:indexS],YES);
    } else {
        completion(self.assetArray,NO);
    }
}

- (void)getAllAssetsWith:(JXPhotoManagerAssetGetType)getType completion:(void(^)(NSArray <PHAsset *>*))completion
{
    [self getAssetsWith:getType range:NSMakeRange(0, 0) completion:^(NSArray<PHAsset *> *assetArray, BOOL isHaveMore) {
        completion(assetArray);
    }];
}

#pragma mark - private

/// 添加图片到相机胶卷,然后返回胶卷中的图片
/// @param saveImage 保存的图片
+ (PHFetchResult<PHAsset *> *)createdAssetsWithImage:(UIImage *)saveImage
{
    __block NSString *createdAssetId = nil;
    // 添加图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:saveImage].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    
    if (createdAssetId == nil) {
        return nil;
    } else {
        // 在保存完毕后取出图片
        return [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
    }
}

/// 添加图片或者视频文件到相机胶卷,然后返回胶卷中存入的文件
/// @param fileUrl 文件路径
/// @param fileType 文件类型
+ (PHFetchResult<PHAsset *> *)createdAssetsWithFile:(NSURL *)fileUrl fileType:(JXPhotoManagerSaveFileType)fileType
{
    __block NSString *createdAssetId = nil;
    if (fileType == JXPhotoManagerFile_Image) { // 图片文件 添加图片到【相机胶卷】
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:fileUrl].placeholderForCreatedAsset.localIdentifier;
        } error:nil];
    }else { // 视频文件 添加视频到相机胶卷
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileUrl].placeholderForCreatedAsset.localIdentifier;
        } error:nil];
    }
    
    if (createdAssetId == nil) {
        return nil;
    } else {
        // 在保存完毕后取出文件
        return [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
    }
}

/// 获得自定义的相册
/// @param albumName 相册的名称
+ (PHAssetCollection *)createdCollectionWithName:(NSString *)albumName
{
    NSString *title;
    if (albumName == nil) {
        // 获取软件的名字作为相册的标题
        title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    } else {
        title = albumName;
    }
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    
    // 代码执行到这里，说明还没有自定义相册
    __block NSString *createdCollectionId = nil;
    // 创建一个新的相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    if (createdCollectionId == nil) { // 失败
        return nil;
    } else { // 成功,创建完毕后再取出相册
        return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
    }
}

+ (void)requestAuthorizationResultWith:(PHAuthorizationStatus)status completion:(requestAuthorizationStatusCallBack)completion
{
    switch (status) {
        case PHAuthorizationStatusRestricted:
            completion(JXPhotoManagerAuthorizationStatus_Restricted);
            break;
        case PHAuthorizationStatusDenied:
            completion(JXPhotoManagerAuthorizationStatus_Denied);
            break;
        case PHAuthorizationStatusAuthorized:
            completion(JXPhotoManagerAuthorizationStatus_Authorized);
            break;
        case PHAuthorizationStatusLimited:
            if (@available(iOS 14, *)) {
                completion(JXPhotoManagerAuthorizationStatus_Limited);
            } else {
                // Fallback on earlier versions
            }
            break;
        default:
            break;
    }
}

+ (BOOL)infoPlistContainWith:(JXPhotoManagerRequestType)requestType
{
    NSString *content;
    NSString *message;
    switch (requestType) {
        case JXPhotoManagerRequest_AddOnly:
            content = kPhotoLibraryKeyAddOnly;
            message = @"info.plist文件缺少相册写入权限相关描述";
            break;
        case JXPhotoManagerRequest_ReadWrite:
            content = kPhotoLibraryKey;
            message = @"info.plist文件缺少相册读写权限相关描述";
            break;
        default:
            break;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    BOOL flag = false;
    if ([infoDictionary.allKeys containsObject:content]) {
        NSString *stringValue = [infoDictionary objectForKey:content];
        if (stringValue.length != 0) {
            flag = true;
        }
    }
    if (!flag) {
        [JXPhotoManager showAlertWithTitle:@"提示" message:message confirm:@"确定" cancle:nil confirmBlock:nil cancleBlock:nil];
    }
    return flag;
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirm:(NSString *)confirmStr cancle:(NSString *)cancleStr confirmBlock:(void(^)(void))confirm cancleBlock:(void(^)(void))cancle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        if (confirmStr != nil) {
            [alertController addAction:[UIAlertAction actionWithTitle:confirmStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (confirm) {
                    confirm();
                }
            }]];
        }
        if (cancleStr != nil) {
            [alertController addAction:[UIAlertAction actionWithTitle:cancleStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (cancle) {
                    cancle();
                }
            }]];
        }
        [[JXPhotoManager visibleViewController] presentViewController:alertController animated:YES completion:nil];
    });
}

+ (UIViewController *)visibleViewController
{
    UIViewController *rootViewController =[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [JXPhotoManager getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [JXPhotoManager getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [JXPhotoManager getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [JXPhotoManager getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

@end

/*
 PHAsset 用户照片库中一个单独的资源，简单而言就是单张图片的元数据吧
 PHAsset 组合而成PHAssetCollection(PHCollection)一个单独的资源集合(PHAssetCollection)可以是照片库中相簿中一个相册或者照片中一个时刻，或者是一个特殊的“智能相册”。这种智能相册包括所有的视频集合，最近添加的项目，用户收藏，所有连拍照片等
 PHCollectionList 则是包含PHCollection的PHCollection。因为它本身就是PHCollection，所以集合列表可以包含其他集合列表，它们允许复杂的集合继承。例子：年度->精选->时刻
 PHFetchResult 某个系列（PHAssetCollection）或者是相册（PHAsset）的的返回结果，一个集合类型，PHAsset或者PHAssetCollection的类方法均可以获取到
 PHImageManager 处理图片加载，加载图片过程有缓存处理
 PHCachingImageManager(PHImageManager的抽象) 处理图像的整个加载过程的缓存要加载大量资源的缩略图时可以使用该类的startCachingImage...预先将图像加载到内存中 ，使用时注意size要一致
 PHImageRequestOptions 设置加载图片方式的参数()
 PHFetchOptions 集合资源的配置方式（按一定的(例如时间)顺序对资源进行排列、隐藏/显示某一个部分的资源集合）
 */

/*
 typedef NS_ENUM(NSInteger, PHAssetCollectionSubtype) {
     
     // PHAssetCollectionTypeAlbum regular subtypes
     PHAssetCollectionSubtypeAlbumRegular         = 2, //用户在 Photos 中创建的相册
     PHAssetCollectionSubtypeAlbumSyncedEvent     = 3, /使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步过来的事件。
     PHAssetCollectionSubtypeAlbumSyncedFaces     = 4, //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步的人物相册。
     PHAssetCollectionSubtypeAlbumSyncedAlbum     = 5, //做了 AlbumSyncedEvent 应该做的事
     PHAssetCollectionSubtypeAlbumImported        = 6, //从相机或是外部存储导入的相册
     
     // PHAssetCollectionTypeAlbum shared subtypes
     PHAssetCollectionSubtypeAlbumMyPhotoStream   = 100, //用户的 iCloud 照片流
     PHAssetCollectionSubtypeAlbumCloudShared     = 101, //用户使用 iCloud 共享的相册
     
     // PHAssetCollectionTypeSmartAlbum subtypes
     PHAssetCollectionSubtypeSmartAlbumGeneric    = 200, //文档解释为非特殊类型的相册，主要包括从 iPhoto 同步过来的相册
     PHAssetCollectionSubtypeSmartAlbumPanoramas  = 201, //相机拍摄的全景照片
     PHAssetCollectionSubtypeSmartAlbumVideos     = 202, //相机拍摄的视频
     PHAssetCollectionSubtypeSmartAlbumFavorites  = 203, //收藏文件夹
     PHAssetCollectionSubtypeSmartAlbumTimelapses = 204, //延时视频文件夹，同时也会出现在视频文件夹中
     PHAssetCollectionSubtypeSmartAlbumAllHidden  = 205, //包含隐藏照片或视频的文件夹
     PHAssetCollectionSubtypeSmartAlbumRecentlyAdded = 206, //相机近期拍摄的照片或视频
     PHAssetCollectionSubtypeSmartAlbumBursts     = 207, //连拍模式拍摄的照片
     PHAssetCollectionSubtypeSmartAlbumSlomoVideos = 208, //Slomo 是 slow motion 的缩写，高速摄影慢动作解析，在该模式下，iOS 设备以120帧拍摄。
     PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209, //就是相机相册，所有相机拍摄的照片或视频都会出现在该相册中，而且使用其他应用保存的照片也会出现在这里。
     PHAssetCollectionSubtypeSmartAlbumSelfPortraits PHOTOS_AVAILABLE_IOS_TVOS(9_0, 10_0) = 210, //这个相册包含了用户使用前置摄像头拍摄的照片和视频
     PHAssetCollectionSubtypeSmartAlbumScreenshots PHOTOS_AVAILABLE_IOS_TVOS(9_0, 10_0) = 211, //使用设备的截屏功能生成的照片
     PHAssetCollectionSubtypeSmartAlbumDepthEffect PHOTOS_AVAILABLE_IOS_TVOS(10_2, 10_1) = 212, //在可兼容的设备上使用景深摄像模式拍的照片
     PHAssetCollectionSubtypeSmartAlbumLivePhotos PHOTOS_AVAILABLE_IOS_TVOS(10_3, 10_2) = 213, //包含所有的Live Photo资源
     PHAssetCollectionSubtypeSmartAlbumAnimated PHOTOS_AVAILABLE_IOS_TVOS(11_0, 11_0) = 214, //动图
     PHAssetCollectionSubtypeSmartAlbumLongExposures PHOTOS_AVAILABLE_IOS_TVOS(11_0, 11_0) = 215, //长曝光
     // Used for fetching, if you don't care about the exact subtype
     PHAssetCollectionSubtypeAny = NSIntegerMax ////包含所有类型
 } PHOTOS_ENUM_AVAILABLE_IOS_TVOS(8_0, 10_0);
 */
