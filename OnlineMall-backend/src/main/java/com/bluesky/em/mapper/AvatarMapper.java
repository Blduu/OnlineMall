package com.bluesky.em.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bluesky.em.entity.Avatar;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户头像 持久层（mapper）
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Mapper
public interface AvatarMapper extends BaseMapper<Avatar> {

}
