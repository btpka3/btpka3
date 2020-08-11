#!/usr/bin/env java --source 11

// 需要 JDK 11 才行
public class Test {
    public static void main(String ... args) {
        System.out.println("Hello " + (args.length == 0 ? "world!" : args[0]));
        System.out.println(Test2.add(1, 2));
    }
}

public class Test2 {
    public static String add(int a, int b) {
        return "aa_" + a + "_" + b;
    }
}
