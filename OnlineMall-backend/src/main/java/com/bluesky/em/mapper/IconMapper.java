package com.bluesky.em.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bluesky.em.entity.Icon;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 图标持久层（mapper）
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Mapper
public interface IconMapper extends BaseMapper<Icon> {

    List<Icon> getIconCategoryMapList();
}
