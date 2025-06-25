package com.bluesky.em.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bluesky.em.entity.User;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户持久层 （mapper）
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Mapper
public interface UserMapper extends BaseMapper<User> {

}
