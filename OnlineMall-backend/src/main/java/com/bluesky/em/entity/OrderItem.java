package com.bluesky.em.entity;

import lombok.Data;

/**
 * 用来接收前台下订单时，传来的‘goods'参数
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Data
public class OrderItem {

    /*
     *商品id
     */
    private Long id;

    /*
     *商品规格
     */
    private String standard;

    /*
     *数量
     */
    private Integer num;

}
