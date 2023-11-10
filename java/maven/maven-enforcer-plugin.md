


- [maven-enforcer-plugin](https://maven.apache.org/enforcer/maven-enforcer-plugin/index.html)
  - [extra-enforcer-rules](https://www.mojohaus.org/extra-enforcer-rules/)
  - [ossindex-maven-enforcer-rules](https://sonatype.github.io/ossindex-maven/enforcer-rules/)
- github :
  - [apache/maven-enforcer](https://github.com/apache/maven-enforcer)


# 命令行

```bash
mvn enfocer:enforce
mvnDebug org.apache.maven.plugins:maven-enforcer-plugin:3.4.1:enforce -Denforcer.rules=alwaysFail -Denforcer.failFast=true

```


# 堆栈
实例化 org.apache.maven.enforcer.rules.dependency.BannedDependencies

```plain
"main@1" prio=5 tid=0x1 nid=NA runnable
  java.lang.Thread.State: RUNNABLE
	  at org.apache.maven.enforcer.rules.dependency.BannedDependencies.<init>(BannedDependencies.java:38)
	  at sun.reflect.NativeConstructorAccessorImpl.newInstance0(NativeConstructorAccessorImpl.java:-1)
	  at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:62)
	  at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45)
	  at java.lang.reflect.Constructor.newInstance(Constructor.java:423)
	  at com.google.inject.internal.DefaultConstructionProxyFactory$ReflectiveProxy.newInstance(DefaultConstructionProxyFactory.java:126)
	  at com.google.inject.internal.ConstructorInjector.provision(ConstructorInjector.java:114)
	  at com.google.inject.internal.ConstructorInjector.access$000(ConstructorInjector.java:32)
	  at com.google.inject.internal.ConstructorInjector$1.call(ConstructorInjector.java:98)
	  at com.google.inject.internal.ProvisionListenerStackCallback$Provision.provision(ProvisionListenerStackCallback.java:112)
	  at com.google.inject.internal.ProvisionListenerStackCallback$Provision.provision(ProvisionListenerStackCallback.java:127)
	  at com.google.inject.internal.ProvisionListenerStackCallback.provision(ProvisionListenerStackCallback.java:66)
	  at com.google.inject.internal.ConstructorInjector.construct(ConstructorInjector.java:93)
	  at com.google.inject.internal.ConstructorBindingImpl$Factory.get(ConstructorBindingImpl.java:306)
	  at com.google.inject.internal.FactoryProxy.get(FactoryProxy.java:62)
	  at com.google.inject.internal.InjectorImpl$1.get(InjectorImpl.java:1050)
	  at org.eclipse.sisu.inject.Guice4$1.get(Guice4.java:162)
	  - locked <0xb8d> (a org.eclipse.sisu.inject.Guice4$1)
	  at org.eclipse.sisu.inject.LazyBeanEntry.getValue(LazyBeanEntry.java:81)
	  at org.eclipse.sisu.plexus.LazyPlexusBean.getValue(LazyPlexusBean.java:51)
	  at org.codehaus.plexus.DefaultPlexusContainer.lookup(DefaultPlexusContainer.java:263)
	  at org.codehaus.plexus.DefaultPlexusContainer.lookup(DefaultPlexusContainer.java:255)
	  at org.apache.maven.plugins.enforcer.internal.EnforcerRuleManager.createRuleDesc(EnforcerRuleManager.java:140)    #
	  at org.apache.maven.plugins.enforcer.internal.EnforcerRuleManager.createRules(EnforcerRuleManager.java:110)
	  at org.apache.maven.plugins.enforcer.EnforceMojo.execute(EnforceMojo.java:213)
	  at org.apache.maven.plugin.DefaultBuildPluginManager.executeMojo(DefaultBuildPluginManager.java:137)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:210)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:156)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:148)
	  at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:117)
	  at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:81)
	  at org.apache.maven.lifecycle.internal.builder.singlethreaded.SingleThreadedBuilder.build(SingleThreadedBuilder.java:56)
	  at org.apache.maven.lifecycle.internal.LifecycleStarter.execute(LifecycleStarter.java:128)
	  at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:305)
	  at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:192)
	  at org.apache.maven.DefaultMaven.execute(DefaultMaven.java:105)
	  at org.apache.maven.cli.MavenCli.execute(MavenCli.java:956)
	  at org.apache.maven.cli.MavenCli.doMain(MavenCli.java:288)
	  at org.apache.maven.cli.MavenCli.main(MavenCli.java:192)
	  at sun.reflect.NativeMethodAccessorImpl.invoke0(NativeMethodAccessorImpl.java:-1)
	  at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	  at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	  at java.lang.reflect.Method.invoke(Method.java:498)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.launchEnhanced(Launcher.java:282)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.launch(Launcher.java:225)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.mainWithExitCode(Launcher.java:406)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.main(Launcher.java:347)

```

@Paramter 设置值
org.apache.maven.plugins.enforcer.EnforceMojo#failFast




```plain
"main@1" prio=5 tid=0x1 nid=NA runnable
  java.lang.Thread.State: RUNNABLE
	  at org.apache.maven.plugins.enforcer.EnforceMojo.setFailFast(EnforceMojo.java:442)
	  at jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(NativeMethodAccessorImpl.java:-1)
	  at jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	  at jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	  at java.lang.reflect.Method.invoke(Method.java:566)
	  at org.eclipse.sisu.plexus.CompositeBeanHelper.setProperty(CompositeBeanHelper.java:181)
	  at org.codehaus.plexus.component.configurator.converters.composite.ObjectWithFieldsConverter.processConfiguration(ObjectWithFieldsConverter.java:101)
            # 这里将 @Paramter 转换成 PlexusConfiguration : <failFast default-value="false">${enforcer.failFast}</failFast>
            # 再按照  eclipse sisu 的注入机制进行注入
	  at org.codehaus.plexus.component.configurator.BasicComponentConfigurator.configureComponent(BasicComponentConfigurator.java:34)
	  at org.apache.maven.plugin.internal.DefaultMavenPluginManager.populatePluginFields(DefaultMavenPluginManager.java:635)
	  at org.apache.maven.plugin.internal.DefaultMavenPluginManager.getConfiguredMojo(DefaultMavenPluginManager.java:597)
	  at org.apache.maven.plugin.DefaultBuildPluginManager.executeMojo(DefaultBuildPluginManager.java:124)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:210)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:156)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:148)
	  at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:117)
	  at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:81)
	  at org.apache.maven.lifecycle.internal.builder.singlethreaded.SingleThreadedBuilder.build(SingleThreadedBuilder.java:56)
	  at org.apache.maven.lifecycle.internal.LifecycleStarter.execute(LifecycleStarter.java:128)
	  at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:305)
	  at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:192)
	  at org.apache.maven.DefaultMaven.execute(DefaultMaven.java:105)
	  at org.apache.maven.cli.MavenCli.execute(MavenCli.java:956)
	  at org.apache.maven.cli.MavenCli.doMain(MavenCli.java:288)
	  at org.apache.maven.cli.MavenCli.main(MavenCli.java:192)
	  at jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(NativeMethodAccessorImpl.java:-1)
	  at jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	  at jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	  at java.lang.reflect.Method.invoke(Method.java:566)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.launchEnhanced(Launcher.java:282)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.launch(Launcher.java:225)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.mainWithExitCode(Launcher.java:406)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.main(Launcher.java:347)
```
