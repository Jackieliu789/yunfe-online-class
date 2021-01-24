package com.yunfeisoft.business.dao.inter;

import com.applet.base.BaseDao;
import com.applet.utils.Page;
import com.yunfeisoft.business.model.SysConfig;

import java.util.List;
import java.util.Map;

/**
 * ClassName: SysConfigDao
 * Description: 系统配置Dao
 * Author: Jackie liu
 * Date: 2019-11-05
 */
public interface SysConfigDao extends BaseDao<SysConfig, String> {

    public Page<SysConfig> queryPage(Map<String, Object> params);

    public List<SysConfig> queryList(Map<String, Object> params);

    public int removeAll();
}