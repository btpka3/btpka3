

# 参考
- [RFC-7515 : JSON Web Signature (JWS)](https://tools.ietf.org/html/rfc7515)
- [RFC-7516 : JSON Web Encryption (JWE)](https://tools.ietf.org/html/rfc7516)
- [RFC-7517 : JSON Web Key (JWK)](https://tools.ietf.org/html/rfc7517)
- [RFC-7518 : JSON Web Algorithms (JWA)](https://tools.ietf.org/html/rfc7518)
- [RFC-7519 : JSON Web Token (JWT)](https://tools.ietf.org/html/rfc7519)
- [RFC-7797 : JSON Web Signature (JWS) Unencoded Payload Option](https://tools.ietf.org/html/rfc7797)
- [RFC-8725 : JSON Web Token Best Current Practices](https://tools.ietf.org/html/rfc8725)
- JOSE :  JSON Object Signing and Encryption

# 格式

```js
var jwt = {
    HEADER: {
        "alg":"HS256",  // JSON Web Algorithms (JWA):
        "jku":"",       // JWK Set URL
        "jwk":"",       // JSON Web Key
        "kid":"",       // Key ID
        "x5u":"",       // X.509 URL, 该URL 下载后是 PEM 格式 的公钥
        "x5c":[         // X.509 Certificate Chain
            "${chainCert1Base64}",
            "${chainCert2Base64}"
        ],
        "x5t":"",       // X.509 Certificate SHA-1 Thumbprint
        "x5t#S256":"",  // X.509 Certificate SHA-256 Thumbprint
        "typ":"JWT",    // Type
        "cty":"",       // Content Type, 不推荐使用
        "crit":[        // Critical : 用来指示 JWA 必去能识别且处理相应的 HEADER
            "exp"
        ],
    },
    PAYLOAD: {
        "iss" : "",     // issuer, 谁生成的该 jwt
        "sub" : "",     // Subject
        "aud" : "",     // Audience, 说明该 jwt 希望谁来接收并校验的
        "exp" : "",     // Expiration Time
        "nbf" : "",     // Not Before
        "iat" : "",     // Issued At: 说明该 JWT 是什么时候生成的, UTC, unix 时间戳（秒）
        "jti" : "",     // JWT ID: 该 JWT 的唯一标识符

    },
    SIGNATURE: ""
}

```

# JSON Web Key (JWK)


