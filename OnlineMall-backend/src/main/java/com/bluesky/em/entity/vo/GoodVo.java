package com.bluesky.em.entity.vo;

import lombok.Data;

import java.math.BigDecimal;

/**
 * 推荐商品信息
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Data
public class GoodVo {

    /**
     * 商品id
     */
    private Long id;

    /**
     * 商品名
     */
    private String name;

    /**
     * 商品图片
     */
    private String imgs;

    /**
     * 商品价格
     */
    private BigDecimal price;

}
