package com.bluesky.em.controller;

import com.bluesky.em.common.R;
import com.bluesky.em.utils.TokenUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 角色 控制层
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@RestController
public class RoleController {

    /**
     * 查询当前用户角色
     *
     * @return 角色名
     */
    @PostMapping("/role")
    public R<String> getUserRole() {
        return R.success(TokenUtils.getCurrentUser().getRole());
    }

}
