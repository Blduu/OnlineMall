package com.bluesky.em.utils;

import java.util.HashMap;
import java.util.Map;

/**
 * 接口响应包装
 *
 * @author: BlueSky
 * @date: 2025-06-15
 */
public class InterfaceWrapper {

    private static Map<String, Object> map(String code, Object data, String msg) {
        Map<String, Object> map = new HashMap<>();
        map.put("code", code);
        map.put("data", data);
        map.put("msg", msg);
        return map;
    }

    public static Map<String, Object> success() {
        return map("200", null, null);
    }

    public static Map<String, Object> success(Object data) {
        return map("200", data, null);
    }

    public static Map<String, Object> error(String msg) {
        return map("400", null, msg);
    }

}
