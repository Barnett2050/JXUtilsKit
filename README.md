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

* JXFoundationMacroHeader
  * 弧度角度参数转换
  * 快速声明
  * 数据验证
  * 日志打印
* JXUIKitMacroHeader
  * 设备型号系统版本
  * 视图尺寸相关参数 
  * 颜色相关参数 
  * Application相关参数 
  * 字体设置
  
* JXSafeMutableArray
  * 多线程安全数组处理
  
* JXSafeMutableDictionary
  * 多线程安全字典处理
