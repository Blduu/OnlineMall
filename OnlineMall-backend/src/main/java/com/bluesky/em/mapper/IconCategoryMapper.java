package com.bluesky.em.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bluesky.em.entity.IconCategory;
import org.apache.ibatis.annotations.Mapper;

/**
 * 图片 - 分类关联持久层（mapper）
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Mapper
public interface IconCategoryMapper extends BaseMapper<IconCategory> {

}
