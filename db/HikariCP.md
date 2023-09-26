- HikariCP:
    - https://github.com/brettwooldridge/HikariCP

- com.zaxxer.hikari.pool.PoolBase#initializeDataSource
- com.zaxxer.hikari.HikariDataSource


# 内部具体的实现的 dataSource 配置

优先级(针对 HikariDataSource)
1. #getDataSource()
2. #getDataSourceClassName() + #getDataSourceProperties()                
3. #getJdbcUrl() + #getDriverClassName() + #getDataSourceProperties()    # ❤️ 推荐
4. #getDataSourceJNDI()
