## JXUtilsKit

* 包含Byte转换工具，宏定义，线程安全的数组和字典

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

* JXFoundationUtils
  * 弧度角度参数转换
  * 数据验证
  
* JXUIKitUtils
  * 设备型号系统版本
  * 视图尺寸相关参数 
  * 颜色相关参数 
  * Application相关参数 
  * 字体设置
  
* JXParameterTool
  * 获取电池状态和电量
  
* JXAuthorization
  * 跳转权限设置
  * 获取照相机权限
  * 后面的摄像头是否可用
  * 前面的摄像头是否可用
  * 获取麦克风权限
  * 获取相册权限 iOS 8.0之后
  * 获取日历事件权限
  * 获取提醒事项权限，需要注意:添加提醒事项需要打开iCloud里面的日历,日历权限和提醒权限必须同时申请
  * 获取媒体权限，iOS 9.3之后
  
  * JXGlobalMacroHeader
    * 快速声明
    * 日志打印
  
* JXSafeMutableArray
  * 多线程安全数组处理
  
* JXSafeMutableDictionary
  * 多线程安全字典处理
