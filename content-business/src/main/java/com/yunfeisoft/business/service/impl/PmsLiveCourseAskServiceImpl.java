package com.yunfeisoft.business.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.PmsLiveCourseAskDao;
import com.yunfeisoft.business.model.PmsLiveCourseAsk;
import com.yunfeisoft.business.service.inter.PmsLiveCourseAskService;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * ClassName: PmsLiveCourseAskServiceImpl
 * Description: 直播课堂提问表service实现
 * Author: Jackie liu
 * Date: 2020-04-15
 */
@Service("pmsLiveCourseAskService")
public class PmsLiveCourseAskServiceImpl extends BaseServiceImpl<PmsLiveCourseAsk, String, PmsLiveCourseAskDao> implements PmsLiveCourseAskService {

    @Override
    @DataSourceChange(slave = true)
    public Page<PmsLiveCourseAsk> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }
}