package com.bluesky.em.service;

import com.bluesky.em.entity.Good;

import java.util.List;

/**
 * 推荐服务
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
public interface RecommendService {

    /**
     * 推荐用户商品
     *
     * @param userId 用户id
     * @return 推荐商品
     */
    List<Good> recommendGoods(Long userId);
}

  