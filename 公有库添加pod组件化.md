

1--
    pod lib create GYHSKit

2--回答一些问题，注意最好有个Example工程,完成后，
GYHSKit.podspec描述文件中有s.source路径，github上创建好仓库，例如：https://github.com/kenny2006cen/GYHSKit



3--进入Example目录,替换replace.m文件，并在classes目录下新增文件比如GYHSKit,然后在Example目录下pod install,

4--文件根目录下 pod lib lint --verbose --allow-warnings #检测是否被pod支持 

#私有组件打上tag
5--
git remote add origin https://github.com/kenny2006cen/GYHSKit

(错误：fatal: refusing to merge unrelated histories)
（解决如下：）
git pull origin master --allow-unrelated-histories

（分析，出现这个问题的最主要原因还是在于本地仓库和远程仓库实际上是独立的两个仓库。假如我之前是直接clone的方式在本地建立起远程github仓库的克隆本地仓库就不会有这问题了）

 git add .
git commit -m ‘添加代码’
git tag -a 0.0.1 -m ‘tag’
Git push  —-tags
git push origin master

(pod没注册就先注册一个，
pod trunk register kenny2006cen@163.com ‘kenny2006cen‘ --verbose
pod trunk me

)

pod trunk push GYHSKit.podspec  --allow-warnings (发布到公共pod)


pod search  #如果搜索不到 
pod repo update
rm ~/Library/Caches/CocoaPods/search_index.json
pod search xxx --simple

搜索结果 --
-> GYHSKit (0.1.0)
A short description of GYHSKit.
pod 'GYHSKit', '~> 0.1.0'
- Homepage: https://github.com/kenny2006cen/GYHSKit
- Source:   https://github.com/kenny2006cen/GYHSKit.git
- Versions: 0.1.0 [trunk repo]


工程内引用
pod 'GYHSKit','~>0.1.0'


pod文件和版本升级
1.修改相应文件
2.修改GYHSKit.podspec ->s.version的版本号
3.Example目下重新pod install 
4.项目根目录下， git tag 0.1.1 (增大版本号)
5.git push --tags

6.终于搞定了,搞了一天


后续，如果需要打包成framekwork或者静态库
1.sudo gem install cocoapods-packager
2.pod package GYHSKit.podspec --no-mangle --force


备注：（s.frameworks和s.libraries指定依赖的SDK中的framework和类库，需要注意，依赖项不仅要包含你自己类库的依赖，还要包括所有第三方类库的依赖，只有这样当你的类库打包成.a或.framework时才能让其他项目正常使用。示例中s.frameworks和s.libraries都是ASIHTTPRequest的依赖项。）
