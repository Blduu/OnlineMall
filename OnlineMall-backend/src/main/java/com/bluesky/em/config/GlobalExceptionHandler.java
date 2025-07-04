package com.bluesky.em.config;

import com.bluesky.em.common.R;
import com.bluesky.em.exception.BizException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 全局异常处理
 * <p>
 * 处理接口中抛出的业务异常 {@link BizException}，返回 {@link R} 结构
 * 全局异常，可以统一异常的处理，不需要每个地方都写相关处理逻辑
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 拦截业务异常
     *
     * @param e 业务异常
     * @return R
     */
    @ResponseBody
    @ExceptionHandler(BizException.class)
    public R handle(BizException e) {
        return R.error(e.getCode(), e.getMessage());
    }

}
