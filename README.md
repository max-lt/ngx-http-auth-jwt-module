# About this fork

Original repository is https://github.com/TeslaGov/ngx-http-auth-jwt-module

### Changes: 
 - Rebased build on [official nginx Dockerfile](https://github.com/nginxinc/docker-nginx) (alpine) so some modules have been 
 removed (pcre, pcre-jit, debug, http_xslt_module, google_perftools_module, ...)
 - Significantly lighter image (uncompressed: ~780MB -> ~17MB, compressed: ~280MB -> ~7MB)
 - Copied the "nginx" directory from the [official nginx Dockerfile](https://github.com/nginxinc/docker-nginx) to reproduce official image.
 
### Build:
```bash
./build.sh # Will create a "jwt-nginx" (Dockerfile)
```
 
### Test:
```bash
./test.sh # Will create a "jwt-nginx-test" image from the "jwt-nginx" one (Dockerfile.test)
```

<hr>

# Intro
This is an NGINX module to check for a valid JWT and proxy to an upstream server or redirect to a login page.

# Build Requirements
This module depends on the [JWT C Library](https://github.com/benmcollins/libjwt)

Transitively, that library depends on a JSON Parser called [Jansson](https://github.com/akheron/jansson) as well as the OpenSSL library.

# NGINX Directives
This module requires several new nginx.conf directives, which can be specified in on the `main` `server` or `location` level.

```
auth_jwt_key "00112233445566778899AABBCCDDEEFF00112233445566778899AABBCCDDEEFF";
auth_jwt_loginurl "https://yourdomain.com/loginpage";
auth_jwt_enabled on;
```

So, a typical use would be to specify the key and loginurl on the main level and then only turn on the locations that you want to secure (not the login page).  Unauthorized requests are given 302 "Moved Temporarily" responses with a location of the specified loginurl.

```
auth_jwt_redirect            off;
```
If you prefer to return 401 Unauthorized, you may turn `auth_jwt_redirect` off.

```
auth_jwt_validation_type AUTHORIZATION;
auth_jwt_validation_type COOKIE=rampartjwt;
```
By default the authorization header is used to provide a JWT for validation.  However, you may use the `auth_jwt_validation_type` configuration to specify the name of a cookie that provides the JWT.

The Dockerfile builds all of the dependencies as well as the module, downloads a binary version of nginx, and runs the module as a dynamic module.

Have a look at build.sh, which creates the docker image and container and executes some test requests to illustrate that some pages are secured by the module and requre a valid JWT.
