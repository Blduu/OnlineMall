package com.bluesky.em.constants;

/**
 * Redis 常量
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
public class RedisConstants {

    /**
     * 用户token键值
     */
    public static final String USER_TOKEN_KEY = "user:token:";
    public static final Integer USER_TOKEN_TTL = 180;

    /**
     * 商品id键值
     */
    public static final String GOOD_ID_KEY = "good:id:";
    public static final Integer GOOD_ID_TTL = 30;
}
