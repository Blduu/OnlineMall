package com.bluesky.em.config;

import com.bluesky.em.interceptor.JwtInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import javax.annotation.Resource;

/**
 * 拦截器配置
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Configuration
public class InterceptorConfig implements WebMvcConfigurer {

    @Resource
    JwtInterceptor jwtInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        //jwt拦截器
        registry.addInterceptor(jwtInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/login", "/register", "/file/**", "/avatar/**", "/api/good/**", "/api/icon/**",
                        "/messages/**", "/api/category/**", "/api/market/**", "/api/carousel/**", "/message","/messages/**","/replay/**",
                        // Swagger UI 相关路径
                        "/swagger-resources/**", "/webjars/**", "/v2/**", "/swagger-ui.html/**", "/swagger-ui/**", 
                        "/doc.html"
                )
                .order(0);

        WebMvcConfigurer.super.addInterceptors(registry);
    }


}
