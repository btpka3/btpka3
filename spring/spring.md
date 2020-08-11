

# @Transactional

```java
@Transactional
public class ParentService {

    @Transactional(transactionManager="transactionManager101")
    public void aaa(){}

    @Transactional(transactionManager="transactionManager102")
    public void bbb(){}

    public void ccc(){}

    public void ddd(){}
}

@Transactional(transactionManager="transactionManager200")
public class ChildService extends ParentService {
    @Transactional(transactionManager="transactionManager201")
    public void aaa(){}

    public void ddd(){}
}
```
假设 Spring ApplicationContext 中有以下名称的 transactionManager:
- "transactionManager"
- "transactionManager101"
- "transactionManager102"
- "transactionManager201"
- "transactionManager202"

问： 针对一个 childService 实例，调用不同方法会使用哪个 transactionManager?

答：
- aaa: transactionManager201. 使用 方法上声明的 Transactional 配置.
- bbb: transactionManager102. 使用 方法上声明的 Transactional 配置.
- ccc: 报错. 找声明该方法的类上(ChildService)的 Transactional 配置。
   但是由于未明确指定 transactionManager，会按照class类型去找，会因为找到多个而报错。
   如果类 ChildService 上明确指定了，则会用 明确指定的。
- ddd: transactionManager200. 使用 声明该方法的类上(ChildService)的 Transactional 配置

参考：
- org.springframework.transaction.interceptor.AbstractFallbackTransactionAttributeSource#computeTransactionAttribute

