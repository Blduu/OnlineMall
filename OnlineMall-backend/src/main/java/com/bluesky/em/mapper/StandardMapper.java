package com.bluesky.em.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bluesky.em.entity.Standard;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

/**
 * 商品规格持久层 （mapper）
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Mapper
public interface StandardMapper extends BaseMapper<Standard> {

    @Update("update good_standard set store = #{num} where good_id = #{good_id} and value = #{standard}")
    void deductStore(long good_id, String standard, @Param("num") int num);

    @Select("select store from good_standard where good_id = #{good_id} and value = #{standard}")
    int getStore(long good_id,String standard);
}
