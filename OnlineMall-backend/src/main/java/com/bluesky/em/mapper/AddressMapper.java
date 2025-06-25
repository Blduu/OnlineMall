package com.bluesky.em.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bluesky.em.entity.Address;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户地址 持久层（mapper）
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Mapper
public interface AddressMapper extends BaseMapper<Address> {

}
