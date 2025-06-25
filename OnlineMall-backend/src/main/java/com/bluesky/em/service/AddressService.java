package com.bluesky.em.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bluesky.em.entity.Address;
import com.bluesky.em.mapper.AddressMapper;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 地址相关 服务层
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Service
public class AddressService extends ServiceImpl<AddressMapper, Address> {

    /**
     * 通过用户id查询
     * @param userId 用户id
     * @return 地址列表
     */
    public List<Address> selectById(Long userId) {
        return lambdaQuery()
                .eq(Address::getUserId, userId)
                .list();
    }

}
