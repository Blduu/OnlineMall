package com.bluesky.em.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bluesky.em.entity.OrderGoods;
import org.apache.ibatis.annotations.Mapper;

/**
 * 订单-商品关联持久层 （mapper）
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Mapper
public interface OrderGoodsMapper extends BaseMapper<OrderGoods> {

}
