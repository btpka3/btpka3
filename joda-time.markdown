[source on github](https://github.com/btpka3/btpka3.github.com/blob/master/java/jdk/TestJDK/src/main/java/me/test/TestJodaTime.java)


```java
import java.util.Calendar;
import java.util.Locale;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.joda.time.format.ISODateTimeFormat;

public class TestJodaTime {

    public static void main(String[] args) {

        // JDK Caendar, Date -> Joda DateTime
        System.out.println(new DateTime(Calendar.getInstance()));
        System.out.println(new DateTime(Calendar.getInstance().getTime()));

        System.out.println("*****************");
        DateTime dt = DateTime.now();

        // Joda DateTime -> JDK Caendar, Date
        System.out.println(dt);
        System.out.println(dt.toDate());
        System.out.println(dt.toCalendar(Locale.CHINA));

        // Joda DateTime plus/minus
        DateTime dt1 = dt.plusYears(1).plusDays(1).minusHours(1);
        System.out.println(dt1);

        // Joda DateTime field access
        System.out.println("----------------");
        System.out.println(dt.getMonthOfYear());
        System.out.println(dt.monthOfYear().getAsText());
        System.out.println(dt.monthOfYear().getAsShortText(Locale.FRENCH));

        System.out.println("================");
        // format : ISO
        DateTimeFormatter fmt = ISODateTimeFormat.dateTime();
        String str = fmt.print(dt);
        System.out.println(str);

        // format : pattern
        fmt = DateTimeFormat.forPattern("yyyy/MM/dd HH:mm:ss.SSS Z");
        str = fmt.withLocale(Locale.ENGLISH).print(dt);
        System.out.println(str);

        System.out.println("################");
        // parse : pattern
        DateTime dt2 = fmt.parseDateTime("2000/01/02 03:04:05.006 +0800");
        System.out.println(dt2);

    }

}
/* Output Sample :
2012-09-13T11:37:50.203+08:00
2012-09-13T11:37:50.625+08:00
*****************
2012-09-13T11:37:50.640+08:00
Thu Sep 13 11:37:50 CST 2012
java.util.GregorianCalendar[time=1347507470640,areFieldsSet=true,areAllFieldsSet=true,lenient=true,zone=sun.util.calendar.ZoneInfo[id="Asia/Shanghai",offset=28800000,dstSavings=0,useDaylight=false,transitions=19,lastRule=null],firstDayOfWeek=1,minimalDaysInFirstWeek=1,ERA=1,YEAR=2012,MONTH=8,WEEK_OF_YEAR=37,WEEK_OF_MONTH=3,DAY_OF_MONTH=13,DAY_OF_YEAR=257,DAY_OF_WEEK=5,DAY_OF_WEEK_IN_MONTH=2,AM_PM=0,HOUR=11,HOUR_OF_DAY=11,MINUTE=37,SECOND=50,MILLISECOND=640,ZONE_OFFSET=28800000,DST_OFFSET=0]
2013-09-14T10:37:50.640+08:00
----------------
9
九月
sept.
================
2012-09-13T11:37:50.640+08:00
2012/09/13 11:37:50.640 +0800
################
2000-01-02T03:04:05.006+08:00
*/
```