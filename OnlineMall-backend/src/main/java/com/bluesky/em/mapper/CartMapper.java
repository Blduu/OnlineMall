package com.bluesky.em.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bluesky.em.entity.Cart;
import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

/**
 * 购物车 持久层（mapper）
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Mapper
public interface CartMapper extends BaseMapper<Cart> {

    @MapKey("id")
    List<Map<String, Object>> selectByUserId(Long userId);
}
