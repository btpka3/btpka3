
# "spring.datasource"
- code : 
    - org.springframework.boot.autoconfigure.jdbc.DataSourceProperties
    - org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
    - org.springframework.boot.autoconfigure.jdbc.DataSourceConfiguration.Hikari


- HikariCP:
    - https://github.com/brettwooldridge/HikariCP
- MySql
    - Maven GAV: 
        - mysql:mysql-connector-java
            For Connector/J 8.0.29 and earlier, 需要使用这个。
        - [com.mysql:mysql-connector-j](https://dev.mysql.com/doc/connector-j/8.0/en/connector-j-installing-maven.html)
            使用 spring boot 3.x 时应该使用这个。
    - 《[6.3 Configuration Properties](https://dev.mysql.com/doc/connector-j/8.0/en/connector-j-reference-configuration-properties.html)》 # Table 6.13 Performance Extensions Properties