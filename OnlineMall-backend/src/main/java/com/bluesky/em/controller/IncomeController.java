package com.bluesky.em.controller;

import com.bluesky.em.common.R;
import com.bluesky.em.service.IncomeService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;


/**
 * 营收统计接口
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@RestController
@RequestMapping("/api/income")
@RequiredArgsConstructor
public class IncomeController {

    private final IncomeService incomeService;

    /**
     * 收入统计图
     *
     * @return 数据
     */
    @GetMapping("/chart")
    public R<Map<String,Object>> getChart() {
        return R.success(incomeService.getChart());
    }

    /**
     * 本周收入统计图
     *
     * @return 数据
     */
    @GetMapping("/week")
    public R<Map<String,Object>> getWeekIncome() {
        return R.success(incomeService.getWeekIncome());
    }

    /**
     * 本月收入统计图
     *
     * @return 数据
     */
    @GetMapping("/month")
    public R<Map<String,Object>> getMonthIncome() {
        return R.success(incomeService.getMonthIncome());
    }

}
