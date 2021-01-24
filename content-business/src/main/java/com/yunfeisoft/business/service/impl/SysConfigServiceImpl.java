package com.yunfeisoft.business.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.SysConfigDao;
import com.yunfeisoft.business.model.SysConfig;
import com.yunfeisoft.business.service.inter.SysConfigService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * ClassName: SysConfigServiceImpl
 * Description: 系统配置service实现
 * Author: Jackie liu
 * Date: 2019-11-05
 */
@Service("sysConfigService")
public class SysConfigServiceImpl extends BaseServiceImpl<SysConfig, String, SysConfigDao> implements SysConfigService {

    @Override
    @DataSourceChange(slave = true)
    public Page<SysConfig> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @Override
    public List<SysConfig> queryList(Map<String, Object> params) {
        return getDao().queryList(params);
    }

    @Override
    public int batchSave(List<SysConfig> list) {
        getDao().removeAll();
        return super.batchSave(list);
    }
}