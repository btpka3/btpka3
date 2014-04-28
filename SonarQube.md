

```sh
mvn -U 
    -Dsonar.host.url=http://10.1.10.100:9000/
    -Dsonar.jdbc.url=jdbc:postgresql://10.1.10.105:1949/sonar
    -Dsonar.jdbc.username=sonar 
    -Dsonar.jdbc.password=sonar
    -Dsonar.exclusions=**/package-info.java,com/tc/his/api/model/*.java,com/tc/his/provider/dao/*.java
    clean compile sonar:sonar
```