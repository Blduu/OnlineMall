package com.bluesky.em.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bluesky.em.entity.Category;
import org.apache.ibatis.annotations.Mapper;

/**
 * 商品分类 持久层（mapper）
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Mapper
public interface CategoryMapper extends BaseMapper<Category> {

}
