package com.bluesky.em.utils;

import com.bluesky.em.entity.User;

/**
 * 用户信息
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
public class UserHolder {

    private static final ThreadLocal<User> userThreadLocal = new ThreadLocal<>();

    public static void saveUser(User user){
        userThreadLocal.set(user);
    }

    public static User getUser(){
        return userThreadLocal.get();
    }

    public static void removeUser(){
        userThreadLocal.remove();
    }

}
