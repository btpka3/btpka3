# Java面试题目


1. 下面代码 main 函数执行后的输出结果是？

    ```java
    public class Test04 {
        public static void main(String[] args) {
            System.out.println(0.1 + 0.2);
        }
    }
    ```
1. 下面代码 main 函数执行后的输出结果是？
 
   ```java
    public class Test00 {
        public static void main(String[] args) {
            String str1 = "aaa";
            String str2 = "aaa";
            String str3 = new String("aaa");
            String str4 = "a" + "aa";
            System.out.println("1. " + (str1 == str2));
            System.out.println("2. " + (str1 == str3));
            System.out.println("3. " + (str1 == str4));
        }
    }
    ```

1. 下面代码 main 函数执行后的输出结果是？

    ```java
    public class Test01 {
        public static void add(int i, int[] intArr) {
            System.out.println("a. " + (++i));
            System.out.println("b. " + (++intArr[0]));
        }
        public static void main(String[] args) {
            int x = 100;
            int[] y = {200};
            add(x, y);
            System.out.println("1. " + x);
            System.out.println("2. " + y[0]);
        }
    }
    ```

    <!--
    1. A.java中定义了静态常量int num=1，B.java中的方法会将该常量打印到控制台。
        之后，将A.java中的静态常量值修改为2, 但只重新编译A.java, 此时调用B的方法，会？
        如果静态常量num的类型改为Integer，重复上述步骤，又会怎样？
    -->

1. Java编程：请写出代码删除其中的奇数。

    ```java
    public class Test05 {
       public static void clearOdd(List<Integer> intList){
           // TODO
       }
       public static void main(String[] args) {
           List<Integer> intList = Arrays.asList(100,3,24,11,7);
           clearOdd(intList);
           System.out.println(intList);
       }
    }
    ```

1. Java编程：打印出 小于 n 的 斐波那契数列 ： 1、1、2、3、5、8、13、21、34 ...
1. Java编程思路：有一万条 字符串，要找出前10条出现次数最多的，该如何解决？
1. Java编程思路：有10亿个无序整数，已知无法全部放到内存中，现在需要从中找出最大的10个数，该如何解决？
1. Java编程思路：数据库中的商品图文（Html）需要java程序批量：更新从HTML中找到所有class中包含"cdnImg"的img标签，
   并将其src属性中的域名全部替换为 img.a.com，该处理需要在服务器端用Java处理，该如何进行？
   请阐明思路，以及该思路的优点（比如：速度，内存消耗，CPU消耗，可维护性等）。

1. == 与 equals() 的区别是？ equals() 相同时，hashCode()可否不同？如果不同会怎样？
1. ArrayList 和 LinkedList 有什么区别？
1. JavaEE开发中，forward 和 redirect 的区别是？

1. 举例并讲解一个URL组成部分。
1. HTTP有哪些 method？其含义分别是？HTTP请求中与缓存相关的HTTP消息头有哪些？哪些情况会使HTTP缓存失效？

1. JVM 常用的配置参数有哪些？JVM 内存模型是怎样的？JDK 自带的命令有哪些？
1. 给出一个单例模式 Singleton 的例子。
1. 什么是Java序列化？它的适用场景是？应当注意的事项有哪些？

1. 使用new关键字创建对象，和 Class.forName("...").newInstance() 的区别是？ 什么是依赖注入？依赖注入有何好处？
1. 什么是AOP？原理是？适用的场景有？下面的示例代码中，在获取到被AOP之后A的实例a后，分别调用 a.aaa(), a.bbb() 会如何打印？

    ```java
    public class A {
        public void aaa(){
            System.out.println("a");
            bbb();
            System.out.println("b");
        }

        @MyAOP // AOP的内容是：在目标方法调用前 println "d"
        public void bbb(){
            System.out.println("c");
        }
    }
    ```
1. 结合您的既有经验，给出利用熟悉的框架从接到请求到返回响应的完整流程。
    该流程中，哪些部分是singleton的，哪些是是prototype的？
    出错的异常处理流程是？
1. 需要架设一个高可靠、高并发的电商网站，暂不考虑服务器限制，您想如何架构？
