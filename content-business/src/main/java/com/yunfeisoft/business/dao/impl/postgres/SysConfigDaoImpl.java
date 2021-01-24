package com.yunfeisoft.business.dao.impl.postgres;

import com.applet.base.ServiceDaoImpl;
import com.applet.sql.builder.WhereBuilder;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.SysConfigDao;
import com.yunfeisoft.business.model.SysConfig;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * ClassName: SysConfigDaoImpl
 * Description: 系统配置Dao实现
 * Author: Jackie liu
 * Date: 2019-11-05
 */
@Repository
public class SysConfigDaoImpl extends ServiceDaoImpl<SysConfig, String> implements SysConfigDao {

    @Override
    public Page<SysConfig> queryPage(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        if (params != null) {
            initPageParam(wb, params);
        }
        return queryPage(wb);
    }

    @Override
    public List<SysConfig> queryList(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        if (params != null) {
        }
        return query(wb);
    }

    @Override
    public int removeAll() {
        String sql = String.format("DELETE FROM %s", domainModelAnalysis.getTableName());
        return jdbcTemplate.update(sql);
    }
}