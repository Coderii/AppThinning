快给你的 App 包瘦瘦身
===

**之前对App瘦身这方面没有作太深入的了解，每次基本上都是写完代码，打包发布，没有考虑到 App 包的大小带来的一些影响，这段时间研究了下 App 包瘦身方面的知识点，对 App 包瘦身这方面有了更全面的一些认识，所以也顺便记录下来学习总结，与大家分享。**

关于这次瘦身内容的介绍将从下面几个方面展开:

- [1 . **什么是 App 瘦身，App 瘦身的重要性** ](#jump1)
- [2 . **从工程编译到打包过程中，影响 App 包的体积大小的一些因素**](#jump2)
- [3 . **App 根据影响的因素制定相应的瘦身的方案**](#jump3)
- [4 . **瘦身的总结**](#jump4)
- [5 . **参考链接**](#参考链接)

<span id="jump1"></span>
### 1. 什么是 App 瘦身？
***

每个 App 包的大小主要是有可执行代码和资源文件大小组成，但是不同的 App 内容大小情况不同，一部分 App 的可执行代码占用较多体积，资源文件内容较少，但是相反，一些 App 的可执行代码占用较少的体积，但是资源文件内容很多。

<div align=center><img src="http://ocbax1ag7.bkt.clouddn.com/%E5%9B%BE%E4%B8%80.png" width="300" height="300" alt="App 包主要结构"/></div>

毋庸置疑，减少 App 安装包的大小是很有必要的，由于蜂窝流量的消费较大，iOS 设备内存限制以及网络提速等因素，所以给即将发布的 App 包瘦身可以减少 App 安装包的大小可以节省用户从 AppStore 用蜂窝数据下载的流量，并且节省一定的设备内存。

<span id="jump2"></span>
### 2. 影响 App 包体积大小的因素

一般来说影响 App 包体积大小主要两个因素是 App 内的资源文件过大或者 App 的可执行代码较大，从资源和可执行代码两部分再进行细分列举一些影响 App 包体积大小的重要因素。

#### 2.1 **资源文件未进行压缩**

在 App 中常见的两种类型资源文件为音频和图片，一般的图片资源较为常见，包括 App 的图标，启动界面，App 内部的一些控件的图片资源等等，音频可能包括一些启动页面的音效文件，App 内部的一些其他音效等等。如果 App 中的资源文件较多，但是没有进行压缩，打包之后对 App 包的体积影响是特别大的。

- **音频压缩**

关于**音频压缩**，常规来说，使用 AAC 或者 MP3 来压缩音频，并且尝试降低音频的比特率，有时候采用44.1khz 没有大的必要，稍微低一点的比特率也不会降低音频的质量，同时采用压缩可以减少有放入音频资源的 App 包的大小。

- **图片压缩**

在开发中尽可能的去使用 8-bit 的 PNG 图片，同样一张图使用 8-bit 相比于使用 32-bit 会减少4倍的图片大小，但是 8-bit 图片支持最多256种不同的颜色，一般只用于小部分颜色的图片，比如灰度图片最好使用 8-bit。如果用到 32-bit 图片，尽量使用高压缩的比率，这样在很大程度上可以减少 JPEG 和 PNG 的图片大小。**Xcode 默认自动使用 [PNGCRUSH](https://developer.apple.com/library/ios/qa/qa1681/_index.html) 压缩 .png 图片**。

#### 2.2 **工程中的无用资源文件过多**

一个项目开发越久，添加的功能模块越多，相应的在项目中引入大量的图片等资源，但是某种情况下可能某些无用的功能模块被移除的时候，会忘记将一些与该模块相对应的图片资源删除，越积越多，导致打包出来的 ipa 包中有很多无用的资源，从而占用了一部分体积。

> 比如一些程序中还经常包含一些额外的文件，比如 readme 之类的从来不会被用到的，需要及时的进行清理，减少 App 的包的体积

#### 2.2 **没有使用 App Slicing**

在 iOS9 之后增加了 App Slicing 的新特性，前提是使用 Asset Catalogs 管理资源文件。通过 Asset Catalogs 管理资源并设置 Devices 的一些属性，就可以实现不同设备下载适用于本身的 App 版本的所需资源，达到减少 App 占用的空间。如果工程中的资源文件没有使用 Asset Catalogs 去管理，用户下载 App 将会下载至少一半无用的资源，增大 App 包的体积。

> App Slicing 不局限于图片资源，App Slicing 支持 Metal，Memory 等等。

<div align=center><img src="http://oce2uruna.bkt.clouddn.com/appslicing.png" width="500" height="" alt="App Slicing"/></div>

#### 2.3 **没有使用 On Demand Resources**

On Demand Resources 同为 iOS9 之后的 AppThing 中的一个新特性。使用了 ODR 的资源文件会被存储苹果服务器上或者自定义的服务器中的，只有在被我们需要的时候才会去下载，并且如果其他资源需要空间，这些资源是可以被移除掉的。如果项目工程中没有开启 On Demand Resources ，App 在下载的时候，所有的资源文件都会被一次性下载下来，导致用户在下载 App 包的时候，App体积特别大，影响用户的体验，苹果官方关于 ODR 支持的几种文件类型主要有下面几种。

<div align=center><img src="http://ocbax1ag7.bkt.clouddn.com/%E6%94%AF%E6%8C%81%E7%B1%BB%E5%9E%8B.png" width="500" height="" alt="ODR 支持类型"/></div>

一般会使用到按需加载的情况的可能会为下面几种情况

- App 中的一些资源主要功能要用到但是在启动的时候并不需要，可以标记资源为需要初始化，当应用运行的时候才去下载
- App 中的一些资源只有在特定的情景下才会使用到
- App 初次登录才会加载的资源，例如初始教程等资源可以设置按需加载
- App 中存在的一些购买资源等等 

使用 ODR 需要考虑网络情况，因为有些情况下用户从 AppStore 上下载应用的时候速度可能特别慢，如果所有的资源都放在服务器，让用户去下载完 App 后一次性都下载下来，可能给用户带来的体验还是很差的，在某种情况下，可以根据资源类型，设置不同的资源标识，ODR 提供三种 tag 类型可以去设置。

- **Initial Install Tags : 只有在初始安装 tag 下载到设备后，app 才能启动。这些资源会在下载 app 时一起下载。这部分资源的大小会包括在 App Store 中 app 的安装包大小。如果这些资源从来没有被 NSBundleResourceRequest 对象获取过，就有可能被清理掉。**
- **Prefetched Tag Order : 在 App 安装后会开始下载 tag，tag 会按照此处指定的顺序来下载，tag 在该列表中的位置决定其下载的顺序，最上面的 tag 会最先下载。**
- **Download Only On Demand : 当 App 请求一个 tag，且 tag 没有缓存时，才会下载该 tag 。**

#### 2.4 **没有开启 BitCode**

BitCode 同样也是 iOS9 新特性 App Thing 中的一种方案，如果工程没有开启 BitCode 打包和 开启 BitCode 打包，虽然两次在打包之后在上传到 AppStore 之前是观察不出明显的体积减小的效果，但是在用户下载的时候，使用 BitCode 打包后的 App 包大小和没有使用 BitCode 打包之后的 App 包的大小是截然不同的，大大的减少了用户下载时候 App 包的体积。
BitCode 也叫中间代码，是 App 被下载之前，苹果优化它的新的途径，中间代码保证了 App 可以在任何设备上尽可能的快速和高效执行，中间代码可以为最近使用的编译器自动编译 App，然后对特定的框架做出优化。因为不同的设备，CPU 和图形处理等能力是不同的，使用 BitCode 这一新特性的时候需要注意的是：

-  **BitCode 在 iOS 开发中是可选的，在 watchOS 开发中是必须要选择的， Mac OS 是不支持 BitCode 的。**
-  **工程目录中所有使用的第三方库都必须要支持 BitCode。**

#### 2.5 **可执行文件没有进行优化**

可执行文件没有优化导致 App 中的可执行文件过大从而影响到 App 包的体积大小主要有几个因素的影响：

- **无用代码或重复代码过多**

Objective-C 和 C++ 不同的是其动态特性，可以通过类和方法名反射获得这个类的方法进行调用，所以即便在代码中某个类没有被使用到，编译器也没办法保证这个类不会再运行时候通过反射去调用，所以可能出现的情况就是，只要是在项目中的文件，无论是否被使用到了都会被编译进可执行文件，当项目工程中的无用代码过多或者重复代码过多，打包之后导致可执行代码文件过大，从而影响到整个 App 包的体积大小。

- **第三方库的体积过大**

项目中可能会引入很多第三方静态库，因为第三方库节省了一定的开发时间，过多引入第三方库或者一些第三方库过大，导致编译后的可执行文件过大从而导致 App 包的体积过大，可以考虑是否存在更优的方案去替代第三方库。

- **使用了ARC编译（可选）**

项目中使用的都是 ARC， ARC 代码在某些情况下多出了一些 retain 和 release 的指令，例如调用一个方法，它返回的对象会被 retain，退出作用域后会被 release，MRC 就不需要，汇编指令变多，机器码变多，可执行文件就变大了。

<div align=center><img src="http://ocbax1ag7.bkt.clouddn.com/arcmrc.png" width="500" height="" alt="ARC 和 MRC 编译后的大小对比"/></div>

如果为了减少 App 包的体积采用 ARC 编译，会导致代码的维护成本上升，因为 iOS5 之后普遍都在使用 ARC了， 这方面可以结合自身情况考虑是否值得优化。


#### 2.6 **编译器的一些优势选项没有设置**

在 App 包打包过程中可以从编译角度处理，在一定的程度上可以减少 App 打包之后的体积大小，对于编译选项主要会存在下面几个因素影响 App 包的体积大小：

- **Debug 符号没有去除**

如果项目在工程编译的时候存在较多的调试符号没有进行处理，会导致编译后的可执行文件过大，设置 Strip Linked Product , Deployment Postprocessing , Symbols Hidden by Defaul 这些参数可以去除一些不必要的调试符号。

- **编译了多个架构**

如果编译多个架构会编译某个架构不需要的资源文件可代码文件，造成 App 包无用体积的占用。如果工程确定是只针对某一个架构开发，可以对程序指定的特定CPU类型做优化处理，以生成相对于的可执行文件。不同的硬件，将运行不同的可执行代码。虽然这样优化后的程序，只能针对某些设备运行，但是这大大减小可执行程序的大小。

<div align=center><img src="http://ocbax1ag7.bkt.clouddn.com/%E4%B8%8D%E5%90%8C%E5%B9%B3%E5%8F%B0.png" width="300" height="114" alt="不同架构"/></div>

- **没有开启编译优化**

开启编译优化会开启那些不增加代码大小的全部优化，并让可执行文件尽可能小，如果项目工程没有开启编译优化，可能会让可执行文件过大，从而导致 App 包的体积增大，可以通过设置 Optimization Level 来进行编译优化，但是一般情况下不建议这样做。

> Warning: These build settings will make your app harder to debug. It is not recommended that you enable these settings in general development builds. However, it’s important to use the same optimizations for a quality-assurance build that you will use for the final build, because different build settings can mask bugs.
> 这些设置会让你的程序很难 debug ，在一般的开发环境 build 中不建议这样设置。

<span id="jump3"></span>
### 3. 制定瘦身方案
***

前面介绍了关于 App 瘦身的说明和瘦身的必要性，以及介绍了一些在项目过程中会影响到我们 App 包体积大小的一些因素，这一节将会针对上述提到的内容进行实际性的操作去优化我们的 App 包的体积，为了能够针对瘦身效果做出说明，新建的工程中将从最坏的情况下（资源没有处理，编译设置没有优化等等）开始进行。

#### 3.1 创建工程

创建一个新的工程项目，导入一些资源文件和第三方库以及创建一些其他的类，将工程设置为最开始的情况。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/project.png" width="500" height="" alt="工程目录"/></div>

工程目录中的资源文件没有进行统一的管理，并且一些编译选项没有去进行设置，在开始瘦身之前，将 AppThing 项目打包，查看打包之后的 ipa 包的大小。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/originIpa.png
" width="500" height="" alt="初始打包大小"/></div>

#### 3.2 开始瘦身

拿到一个项目需要进行 App 包的瘦身，考虑所有可能影响包体积大小的因素，从对 App 包影响的大小进行考虑，进行瘦身效果的最大化。

- **查看是否存在无用的资源文件**

首先检查一遍项目中是否有存在无用的资源文件占用了无用的体积，检查无用资源的方法有很多，包括脚本文件和第三方工具，这里我使用了 **[LSUnusedResources](https://github.com/tinymind/LSUnusedResources/)** 查找工程文件是否存在无用的资源，使用 LSUnusedResources 需要运行项目才能进行检测。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/lsunusedResources.png" width="500" height="" alt="搜索无用资源"/></div>

对比前面的工程目录以及代码中对图片的引用，可以看出通过检查，发现项目中确实存在无用的资源，占用了一部分体积，检查到无用资源之后删除这些无用资源，再次进行打包，观察打包后的 ipa 包的大小。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/deleteUnusedResources.png" width="500" height="" alt="删除无用资源后"/></div>

通过对比可以看出体积减少了不少，删除无用资源带来的体积变化大小需要结合到实际项目中，不同工程目录中的资源文件不同，无用的资源文件也不相同，所以减少的体积的变化会不尽相同。

- **查看资源文件是否还可以继续压缩**

对于项目中如果存在图片资源或者音频文件，需要查看这些资源是否还可以进行压缩，尽可能的减少给 App 包体积带来的压力，关于资源压缩，这里只做图片资源压缩的效果对比，如果我们自己不确定是否可以进行压缩的时候有必要和设计师进行沟通，为了演示并测试压缩带来的效果，我将项目资源中的 1x，2x，3x 的资源文件分别进行了压缩，采用了[在线压缩](http://optimizilla.com/zh/)的方式。

> 压缩图片的方式也有很多种，网页在线压缩，软件进行压缩等等，这里使用了网页在线压缩，不做详细的说明，如果你不知道怎么压缩图片可以去谷歌。

压缩前后 1x，2x，3x 的资源文件大小分别从 2.1M -> 554k，6.6M -> 2.0M，13M -> 4.0M。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/compressPng.png" width="500" height="" alt="压缩对比图"/></div>

压缩之后的图片大小减少的很明显，将压缩后的图片替换掉原来项目中的资源文件，进行打包观察打包后的 ipa 包的大小结果。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/compressPNGResult.png" width="500" height="" alt="压缩之后打包结果"/></div>

还需要说明的是，因为不同的工程文件，资源的不同，所以压缩带来的对比效果是不尽相同的，从我的项目对比结果可以看出（我项目中存放了较大的图片，模拟了项目中存在很多张图片资源的情况），合理的必要的进行资源压缩，带来的 App 包的体积减少是很可观的，如果你的项目中存在大量资源没有进行压缩，你需要尽快的进行压缩，优化你的 App。  

> 关于图片压缩和音频压缩的其他详细介绍，比如使用多少位图的图片，可以参考**2.1节**中的资源压缩内容,不过涉及到资源压缩等方面的内容，最好需要和设计师交流，采取最佳方案。

- **是否使用了 App Slicing**

当项目中的没有存在多余无用的资源并且资源都已经进行过最大化的压缩处理，检查自己的项目的其他资源文件是否使用了 Asset Catalogs 进行管理，并且使用了新特性 App Slicing 设置对应设备的对应资源文件的属性，先将项目中的资源文件放入 Asset Catalogs 进行管理。

> 将资源放入 Asset Catalogs 的时候，默认的 App Slicing 设置是对应 Universal 的所有的设备但仅针对于 1x，2x，3x 的资源进行加载，没有设置就不会针对其它像具体的内存，或者图像处理能力等等去相应加载，如果你需要设置的更详细就需要设置 App Slicing 其它你需要的参数。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/newImageSet.png" width="500" height="" alt="使用 Asset Catalogs 管理资源 "/></div>

> 需要注意的是，如果资源文件是数据文件，需要新建 New Data Set。

为了设置对应设备的信息更详细，点击每一个资源 set 之后点击 Show the Attributes inspector 中设置相应的 Devices 属性，比如我将我的项目资源中的 1x，2x 图设置为对应 iPhone 1GB 内存设备（分别为 iPhone 4 iPhone 6）加载，3x 图片资源设置为对应的 iPhone 2GB 内存设备（iPhone 6s Plus）加载（其他的信息设置可以根据自己的项目会对应到的设备来进行相应的设置）。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/settingDevices1.png" width="500" height="" alt="使用 App Slicing"/></div>

设置完将工程进行一次打包，观察打包之后的效果，打包需要注意的是和前面打包不一样，为了观察不同设备带来的效果变化，使结果更加的有说服力，打包的时候选择 Export for specific devices 进行打包。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/packChoose.png" width="500" height="" alt="打包选项"/></div>

打包结束后发现与之前不同的是，打包之后的文件夹包含了不同机型的 ipa，并且这些 ipa 的体积都要比一个通用包（相当于没有使用 App Slicing 处理的包 ）的 ipa 体积要小。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/allAppsResults1.png" width="500" height="" alt="打包结果"/></div>

为了进一步验证刚才使用的 App Slicing 确实是生效了，在其中选取了 iPhone 4S, iPhone 6 和 iPhone 6s Plus 的 ipa 包和通用的 ipa 包拷贝出来，然后更改后缀名为 .zip 解压观察包内的内容，因为都使用了 Asset Catalogs 管理资源，所以不同的包中都存在 Assets.car 的文件，提取不同的 ipa 包中的 Assets.car，进行解压（这里我是用了 Assets Catalogs Tinkerer）观察里面的内容。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/testContent1.png" width="500" height="" alt="观察 assets.car"/></div>

将所取出来的 Assets.car 解压到不同的文件夹中，观察包中的内容（这里只针对 two.png 做了观察，第三方库中的某些资源这里就不做说明），最大的区别就是通用包中包含了 1x，2x，3x 的所有资源，但是不同设备需要的资源是不同的，比如我的是 iPhone 6s Plus，对我来说只需要 3x 资源，可以看出使用了 App Slicing ，打包出来给 iPhone 6s Plus 的资源文件只有 3x 的资源文件，并且 6s Plus 打包之后的包的大小只有 7.5M，相比于通用包的大小减少了很可观的体积大小。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/differentResults.png" width="500" height="" alt="观察 assets.car"/></div>

- **是否开启并使用了 On Demand Resources**

前面的 2.3 节中的内容已经介绍了关于 ODR 技术方面的内容，接下来通过使用 ODR 这一新特性并观察 ODR 对于 App 包体积减少带来的大小影响，开启 ODR 需要在 BuildSettings 中选择开启 ODR。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/openODR.png" width="500" height="" alt="观察 assets.car"/></div>

开启 ODR 属性并不能从真正意思上很好的使用 ODR，在项目资源中需要设置不同的 Tag 以供 App 在下载的时候会根据设置的 Tag 进行资源的请求，设置 Tag 只需要点击 Assets.xcassets，然后点击不同的 imageSet ，在 Attributes inspector 进行设置。

> 一个 tag 可以对应多个资源包。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/settingTag.png" width="500" height="" alt="观察 assets.car"/></div>

设置了 tag 之后运行程序，点击 Show The Debug navigator 可以观察使用 ODR 的资源情况，从 Disk 信息可以观察出当前的资源并没有下载。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/tagResults.png" width="500" height="" alt="观察 assets.car"/></div>

如果需要在不同的情况下加载使用了 ODR 新特性的资源文件，需要使用 [NSBundleResourceRequest](https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSBundleResourceRequest_Class/index.html#//apple_ref/occ/cl/NSBundleResourceRequest) 进行这些资源的请求操作等,并且每一个 NSBundleResourceRequest 对象只能用于一个请求访问，结束访问的循环。

```
// 初始化集合
NSSet *set = [NSSet setWithObject:@"two"];

// 根据set初始化NSBundleResourceRequest对象
self.tagTwoRequest = [[NSBundleResourceRequest alloc] initWithTags:set];

```

根据 bundle 属性可以获取到当前 App 的沙盒路径

```
// 获取当前request请求的App路径
NSLog(@"local path = %@", self.tagTwoRequest.bundle);

```

初始化 NSBundleResourceRequest 成功后，在请求资源之前，可以判断请求的资源是否已经存在在设备上。

```
// 判断请求的资源是否存在当前设备上
[self.tagTwoRequest conditionallyBeginAccessingResourcesWithCompletionHandler:^(BOOL resourcesAvailable) {
    if (resourcesAvailable) {
        NSLog(@"设备存在该资源");
    }
    else {
        NSLog(@"设备不存在该资源");
        
        // 请求加载资源
        [self loadResources];
    }
}];

```

如果资源不存在则请求加载资源

```
// 加载资源
- (void)loadResources {
    __weak typeof(self) weakSelf = self;
    [self.tagTwoRequest beginAccessingResourcesWithCompletionHandler:^(NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            NSLog(@"加载资源出现错误%@", error);
        }
        else {
            NSLog(@"加载资资源成功");
            
            // 结束对tag的访问
            [strongSelf.tagTwoRequest endAccessingResources];
        }
    }];
}

```

运行程序，观察程序的 Log 界面

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/NSBundleResourceRequest.png" width="500" height="" alt="程序的 Log 界面"/></div>

观察 Disk 中的资源使用情况，可以看到使用 ODR 的资源可以正常的被加载到应用程序中，并且你可以根据你想要触发下载资源的时候去使用代码加载，不需要同 App 下载的时候一起下载下来，这也是 ODR 最大的特点所在。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/requestDisk.png" width="500" height="" alt="使用代码加载资源后的 Disk 情况"/></div>

使用 ODR 对应用程序进行打包，观察 ipa 的内容，为了和上一步骤的结果做对比，同样选择打包不同设备的不同包。

> 打包过程不同于之前的操作，会出现选择服务器的情况

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/chooseServer.png" width="500" height="" alt="打包选项"/></div>

为了方便说明 ODR 的效果，这里选择自定义一个服务器（假设这个服务器时可用的），因为自定义服务器地址存放，项目中的资源文件会和 ipa 包分离开，可以便于清楚的观察出效果，不需要像使用默认服务器一样，将资源文件放在 ipa 一起上传到苹果服务器上，进行打包。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/useODR.png" width="500" height="" alt="使用 ODR 打包结果"/></div>

但是除了多出一个 OnDemandResources 文件夹，包的体积大小好像并没有发生变化，因为 ODR 只有在用户下载的时候才能体现出来，所以无法将结果在这里做出说明。

> 但是打开每个文件夹中的 app-thining.plist 观察与没有使用 ODR 发现了变化。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/ODRDifferent.png" width="500" height="" alt="plist 的比较"/></div>

查看苹果文档，关于 ODR 方面的介绍，确实用户在下载 App 的时候，除了设置 tag 为第一次下载 App下载资源才会跟 App 一起下载，其他的 tag 都是在特定的情况下按需下载，所以并不会增加 App 包的体积，所以 App 包的体积在下载的时候会减少 ODR 文件夹中存放在服务器中的资源的大小。

- **开启 BitCode**

在前面的 2.4 节中已经介绍了 Bitcode 的一些内容，作为中间代码，Bitcode 可以减少 App 包的体积，使用 BitCode 很简单只需要在 BuildSettings 中开启 Bitcode 即可，如果成功开启了 Bitcode ，在打包过程中会出现下面的提示（亲自体验打包过程时间稍微长了一点）

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/successBitcode.png" width="500" height="" alt="开启 Bitcode 的打包过程"/></div>

打包结束后选取相同的机型和上一次打包的结果对比，可以观察开启 Bitcode 之后包的体积确实有减少。关于 Bitcode 带来的效果需要看项目工程中的代码量，因为我的测试项目，代码量较少，变化的结果不是很明显。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/bitcodeResult.png" width="500" height="" alt="开启 Bitcode 的打包结果"/></div>

> 但是如果项目中存在第三方库不支持 Bitcode，则会在打包的过程中出现错误，如果出现这样的情况（拿我之前的一个项目，之前的项目还没有使用 Cocoapods 请忽略，其中 SSDK 不支持 Bitcode），可以考虑替换第三方库，或者关闭 BitCode。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/notBitcode.png" width="500" height="" alt="不支持 Bitcode 的错误"/></div>

- **其他因素优化**
- 设置 Strip Linked Product , Deployment Postprocessing , Symbols Hidden by Defaul 这些属性，去除 Debug 符号。
> 需要注意的是去除 Debug 代码的影响会导致用户崩溃的时候，无法追踪到崩溃的信息，所以去除 Debug 代码可以看自己需求使用。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/removeDebugSymbol.png" width="500" height="" alt="去除 Debug 符号"/></div>

- 如果只对特定架构开发的项目，可以避免编译多个架构，生成其他架构多余的可执行代码的大小，在 BuildSettings 中搜索 Architectures，选择添加编译特定的平台，比如我假设我的工程针对 
> 只针对特定架构编译项目打包，会导致打包出来的 ipa 包只能在当前架构下正常运行，其他架构上运行会出现崩溃。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/targetsCPU.png" width="500" height="" alt="针对特定的架构"/></div>

- 开启编译优化
> 开启编译优化会让程序很难 Debug，一般开发环境 Build 不建议开启编译优化。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/buildOptimize.png" width="500" height="" alt="编译优化"/></div>

针对其他因素做了一些优化后打包观察包的体积大小，确实较之前的减少了一部分体积，因为我的项目中代码不是很多，所以优化后减少的体积不是很明显，如果工程中的代码量过多，可以考虑优化编译的一些选项再进行打包，但是尽可能考虑到给你项目中带来的一些其他影响，权衡的去选择。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/buildSettingOptimize.png" width="500" height="" alt="编译优化"/></div>

**额外补充：如何在项目中开启 linkmap 的输出**

关于前面的2.5节中介绍了一些可以通过删除无用代码或者重复代码额措施来一定程度上减少可执行文件的大小，这里介绍下如果开启 linkmap 追踪输出信息。在 XCode | Project | Build Settings 搜索 Write Link Map File 或者直接输入 map，设置 Write Link Map File 为 YES。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/linkmap.png" width="500" height="" alt="开启 linkmap"/></div>

开启之后当你运行项目的时候，则会输出一个当前工程名开头的 -LinkMap-.txt 的文件。这个文件往往存在你的 /Users/zj-db0512/Library/Developer/Xcode/DerivedData/xxx-xxxxxx/Build/Intermediates/xxx.build/Release-iphonesimulator/xxx.build/ 的目录下。

<div align=center><img src="http://ocqcxogw0.bkt.clouddn.com/linkmapOut.png" width="500" height="" alt="linkmap 的输出目录"/></div>

提取出 linkmap 的输出文件然后通过一些脚本文件或者第三方软件，分析 linkmap 的输出文件，从而可以达到检索无用代码等功能，减少项目中的一些垃圾代码，但是因为本人能力有限，除了找到一个分析库的[第三方工具](https://github.com/huanxsd/LinkMap)，没有找到好的脚本文件可以实现出找到无用代码的功能，如果后续存在，将在文档中补充更新。

<span id="jump4"></span>
### 4. 瘦身小结
***

这次的工程项目瘦身，先是从原来的 50M 直接减少到了 12M（这里的 12M 并不是最终 App 包的体积大小，其中用户下载的时候的包的大小还会有所减少，因为 ODR 的效果在这里没有体现出来，只有在下载的时候才会有所体现），当然因为项目中的资源文件的不同和项目中代码量不同减少的变化也不尽相同，但是可以明确的是，结合自己的项目情况选择适合自己的瘦身计划给自己的 App 包瘦身是很有必要的，减少 App 包体积，增加用户的体验感是非常重要的。  
因为本人能力有限，其中的某些效果并没有很好的展示出来，可能需要之后进行优化更新，并且可能还有很多瘦身方案，本文没有涉及到，希望你们可以多点意见或者提出文章没有涉及到的一些瘦身内容，让我们一起掌握更多更好的优化方案。

<span id="参考链接"></span>
### 参考链接

**[Reducing the size of my App](https://developer.apple.com/library/ios/qa/qa1795/_index.html)**  
**[On-Demand Resources Essentials](https://developer.apple.com/library/tvos/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/)**  
**[iOS微信安装包瘦身](http://www.cocoachina.com/ios/20151211/14562.html)**  
**[理解Bitcode：一种中间代码](http://www.cocoachina.com/ios/20150817/13078.html)**  
**[如何使用 iOS 9 App 瘦身功能](https://segmentfault.com/a/1190000004268671)**