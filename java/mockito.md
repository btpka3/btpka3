

```groovy
when(userDao.queryUserInfo(any()))
        .thenReturn("mockReturnForFirstCall")       // 第一次调用的模拟返回
        .thenReturn("mockReturnForFistSecondCall"); // 第二次调用的模拟返回

when(userDao.queryUserInfo(any()))
        .thenReturn("mockReturnForFirstCall", "mockReturnForFistSecondCall") 

when(someMock.someMethod())
    .thenAnswer(new Answer() {
    private int count = 0;

    public Object answer(InvocationOnMock invocation) {
        if (count++ == 1)}{
            return 1;
        }
        return 2;
    });
    
doReturn(null).when(rulerService)
            .queryPunishRecordPreCheck(any())
doNothing()
            .when(api)
            .checkSrcEventColumn(any(), any(), any());


verify(
    myObject, 
    times(n)        // never()/times(n)/atLeastOnce()/astLeast(n)/atMost(n)/only()
)
    .someMethod()


// 校验参数  @Captor
ArgumentCaptor<Person> argument = ArgumentCaptor.forClass(Person.class);
verify(mock)
    .doSomething(argument.capture());
assertEquals("John", argument.getValue().getName());

org.springframework.test.util.ReflectionTestUtils.setField(
    api,
    "dictEventMappingDao",
    dictEventMappingDao
);
```
