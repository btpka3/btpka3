## 安装
[SPRING TOOL SUITE](http://www.springsource.org/sts )

##常用插件
* [AnyEdit](http://andrei.gmxhome.de/anyedit/)  
update site：http://andrei.gmxhome.de/eclipse -> Eclipse 3.5 - 4.2 plugins -> AnyEditTools  
配置：STS : Preferences -> General/Editors/AnyEdit Tools 
* [Properties Editor](http://propedit.sourceforge.jp/index_en.html)
update site： http://propedit.sourceforge.jp/eclipse/updates/
* [SVN](http://www.eclipse.org/subversive/installation-instructions.php)  
请参照 `Option 2 - Use a Subversive Update Site`
* [Sonar](http://docs.codehaus.org/display/SONAR/Installing+SonarQube+in+Eclipse)  
最新版Update site: http://dist.sonar-ide.codehaus.org/eclipse/  
历史版本更新站点目录: http://dist.sonar-ide.codehaus.org/eclipse-archives/  
注意：需要根据使用的SonarQuebe服务器的版本而选定Eclipse插件的版本
* [CheckStyle](http://eclipse-cs.sourceforge.net/)  
建议使用Sonar插件替代。
* [Findbugs](http://findbugs.sourceforge.net/manual/eclipse.html)  
建议使用Sonar插件替代。  
update site： http://findbugs.cs.umd.edu/eclipse
* [PMD](http://pmd.sourceforge.net/)  
建议使用Sonar插件替代。  
* [ERMaster](http://ermaster.sourceforge.net/)
* [AmaterasUML](http://amateras.sourceforge.jp/cgi-bin/fswiki_en/wiki.cgi?page=AmaterasUML)
* [AmeterasERD](http://amateras.sourceforge.jp/cgi-bin/fswiki_en/wiki.cgi?page=AmaterasERD)  
需要先安装 AmaterasUML
* [GitHub Flavored Markdown viewer plugin for Eclipse](https://marketplace.eclipse.org/content/github-flavored-markdown-viewer-plugin-eclipse)

## 常用快捷键
* Ctrl+Shift+D : Clean Up (需要自定义：STS-Windows-Preferences-General-Keys：Clean Up)
* Ctrl+Shift+F : Format (建议使用Ctrl+Shift+D替代)
* Alt+Shift+J  : 追加Javadoc（自动使用Java/Code Style/Code Templates）
* Alt+/        : 自动提示

==其他插件==
* Drools and JBPM
:: 可用于研究 jBPM 5<br/>更新站点：http://download.jboss.org/drools/release/5.5.0.Final/org.drools.updatesite/ <br/>参考：http://www.jboss.org/drools/downloads

==常见问题==
===Win7下eclipse3.7中文字体过小===
原因：由于Eclipse 3.7 用的字体是 Consolas，显示中文的时候默认太小了。
* 解决方法一：把字体设置为Courier New 

打开Elcipse，点击菜单栏上的“Windows”——点击“Preferences”——点击“Genneral”——点击“Appearance”——点击“Colors and Font”——在右侧框展开“Basic”文件夹--双击“Text Font”——在弹出窗选择“Courier New”（注：这里可能找不到“Courier New”，点击字体选择框左下角的“显示更多字体”链接来打开设置字体的控制面板，找到“Courier New”，右键选择“显示”即可激活该字体）——点击按钮“确定”——点击按钮“OK”，完成。

* 解决方法二：使用混合字体代替Consolas字体
*# 下载[http://files.cnblogs.com/icelyb24/YaHei.Consolas.1.12.rar Consolas和微软雅黑混合字体]
*# 解压之后，把YaHei.Consolas.1.12.ttfw文件复制到C:\Windows\Fonts目录下，完成字体的安装
*# 打开Elcipse，点击菜单栏上的“Windows”——点击“Preferences”——点击“Genneral”——点击“Appearance”——点击“Colors and Font”——在右侧框展开“Basic”文件夹--双击“Text Font”——在弹出窗选择“YaHei.Consolas”——点击按钮“确定”——点击按钮“OK”，完成。
