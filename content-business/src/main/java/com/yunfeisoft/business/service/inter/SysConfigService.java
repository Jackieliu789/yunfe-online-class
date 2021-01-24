package com.yunfeisoft.business.service.inter;

import com.applet.base.BaseService;
import com.applet.utils.Page;
import com.yunfeisoft.business.model.SysConfig;

import java.util.List;
import java.util.Map;

/**
 * ClassName: SysConfigService
 * Description: 系统配置service接口
 * Author: Jackie liu
 * Date: 2019-11-05
 */
public interface SysConfigService extends BaseService<SysConfig, String> {

    public Page<SysConfig> queryPage(Map<String, Object> params);

    public List<SysConfig> queryList(Map<String, Object> params);
}