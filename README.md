## JXUtilsKit

* 包含权限请求，Byte转换工具，宏定义，线程安全的数组和字典

### 如果您认为我整理总结的比较好，希望您给我一个star，您的支持是我坚持下去的动力。

## 引用

* 可以通过pod进行引用：pod 'JXUtilsKit'

## 内容

* JXByteConversion
  * 将字节型的data转换为内容是字节的字符串
  * 将内容是字节的字符串转换为data
  * 取得一个大于256小于65536数字的高位字节
  * 取得一个数字的低位字节
  * 将字节转为字符串
  * 将十六进制字符串转为带符号整型
  
* JXGlobalMacroHeader
  * 快速声明
  * 日志打印
  
* JXSafeMutableArray
  * 多线程安全数组处理
    
* JXSafeMutableDictionary
  * 多线程安全字典处理
  
* JXAuthorization
  * 请求相机，麦克风，音乐媒体，通讯录，日历，提醒，语音识别权限设置
  
* JXFoundationUtils
  * 弧度角度参数转换
  * 数据验证
  
* JXGPSManager
  * 请求定位权限
  * 临时一次精准定位请求
  * 定位更新
  * 停止定位更新
  
* JXHealthTool
  * 申请health权限
  * 获取步数数据
  
* JXParameterTool
  * 获取电池状态和电量
  
* JXPhotoManager
  * 获取图片信息
  * 请求授权
  * 保存图片到相册
  * 保存文件到相册
  * 根据asset取image,方法默认是异步执行
  * 根据asset取image data,方法默认是异步执行
  * 根据asset取AVPlayerItem
  * 根据asset取AVAsset
  * 获取指定位置数量asset
  * 获取所有asset
  
* JXSystemLockTool
  * 显示生物识别
  * 显示生物识别和密码输入
  
* JXUIKitUtils
  * 设备型号系统版本
  * 视图尺寸相关参数 
  * 颜色相关参数 
  * Application相关参数 
  * 字体设置
