package com.bluesky.em.service;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bluesky.em.entity.Icon;
import com.bluesky.em.entity.IconCategory;
import com.bluesky.em.mapper.IconCategoryMapper;
import com.bluesky.em.mapper.IconMapper;
import com.bluesky.em.utils.InterfaceWrapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * 图标 服务层
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@Service
@RequiredArgsConstructor
public class IconService extends ServiceImpl<IconMapper, Icon> {

    private final IconCategoryMapper iconCategoryMapper;

    private final IconMapper iconMapper;

    /**
     * 查询所有图标
     *
     * @return 图标
     */
    public List<Icon> getIconCategoryMapList() {
        return iconMapper.getIconCategoryMapList();
    }

    /**
     * 删除上级分类
     *
     * @param id id
     */
    public Map<String, Object> deleteById(Long id) {
        // 检查是否包含下级分类
        Long count = iconCategoryMapper.selectCount(
                Wrappers.<IconCategory>lambdaQuery()
                        .eq(IconCategory::getIconId, id));

        if (count > 0) {
            return InterfaceWrapper.error("该上级分类存在下级分类，请删除所有下级分类再尝试删除");
        }

        //删除图标
        this.removeById(id);

        return InterfaceWrapper.success();
    }

}
