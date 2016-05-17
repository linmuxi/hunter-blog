---
title: 修改Android Studio工程目录结构
date: 2016-05-16 08:35:28
tags: [AndroidStudio2.0]
categories: [技术]
description: 修改Android Studio工程目录结构
keywords: AndroidStudio
---
接上一篇，我们已将Eclipse中的Android项目导入到Android Studio2.0中，并能成功运行起来。

细心的可以发现，Android Studio为我们添加了些新的文件和文件夹：settings.gradle、build.gradle、gradle、app ...

其中app中包含了Android项目源代码，这是AS将所有代码按照既定格式复制过去了，这样就存在两处源代码。这当然不是我们想要的结果，我们想要的是依旧使用Eclipse目录结构来进行开发。

针对上面的问题，接下来，我们做下简单的配置，以便于在Eclipse和Android Studio中都能很好的进行协同开发。

找到工程(TV)下面的build.gradle配置文件。

步骤：
step1：将app目录下build.gradle内容复制到工程(TV)下的build.gradle里面。
step2：关键的一步，在Android闭包中增加如下代码
~~~groovy
sourceSets {
    main {
        manifest.srcFile 'AndroidManifest.xml'
        assets.srcDirs = ['assets']
        res.srcDirs = ['res']
        resources.srcDirs = ['src']
        java.srcDirs = ['src']
    }
}
~~~
step3：Rebuild Project

通过上面的步骤，就可以将AndroidStudio目录结构同Eclipse一样了。

最后，可以将多余的文件进行删除：app

