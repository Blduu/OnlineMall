package com.bluesky.em.entity.form;

import lombok.Data;

/**
 * 用户登录表单
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Data
public class LoginForm {

    /**
     * 用户名
     */
    private String username;

    /**
     * 密码
     */
    private String password;

}
