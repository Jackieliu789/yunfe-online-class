package com.yunfeisoft.utils;

import com.applet.utils.SpringContextHelper;
import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import com.yunfeisoft.business.model.SysConfig;
import com.yunfeisoft.business.service.inter.SysConfigService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;

/**
 * 缓存信息
 */
public class SysConfigCache {

    private static final Logger logger = LoggerFactory.getLogger(SysConfigCache.class);

    private Cache<String, Map<String, String>> configCache;

    public SysConfigCache() {
        //通过CacheBuilder构建一个缓存实例
        configCache = CacheBuilder.newBuilder()
                .maximumSize(150) // 设置缓存的最大容量
                //.expireAfterWrite(5, TimeUnit.MINUTES) // 设置缓存在写入5分钟后失效
                //.concurrencyLevel(10) // 设置并发级别为10
                .recordStats() // 开启缓存统计
                .build();
    }

    public Map<String, String> getConfig() {
        try {
            return configCache.get("sys_config", new Callable<Map<String, String>>() {

                @Override
                public Map<String, String> call() throws Exception {
                    SysConfigService configService = SpringContextHelper.getBean(SysConfigService.class);
                    List<SysConfig> configList = configService.queryList(null);
                    Map<String, String> map = new HashMap<>();
                    for (SysConfig config : configList) {
                        map.put(config.getKey(), config.getValue());
                    }
                    return map;
                }
            });
        } catch (ExecutionException e) {
            logger.error("获取Token异常", e);
            return null;
        }
    }

    public void cleanCache() {
        configCache.invalidateAll();
    }
}
