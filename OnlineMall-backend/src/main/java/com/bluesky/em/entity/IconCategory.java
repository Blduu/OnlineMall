package com.bluesky.em.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 商品分类-图标
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Data
@TableName(value="icon_category")
public class IconCategory {

    /**
     * 图标主键
     */
    private Long iconId;

    /**
     * 分类id
     */
    private Long categoryId;

}
