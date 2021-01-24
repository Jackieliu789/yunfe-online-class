package com.yunfeisoft.business.dao.inter;

import com.applet.base.BaseDao;
import com.yunfeisoft.business.model.PmsLiveCourseAsk;
import com.applet.utils.Page;

import java.util.Map;

/**
 * ClassName: PmsLiveCourseAskDao
 * Description: 直播课堂提问表Dao
 * Author: Jackie liu
 * Date: 2020-04-15
 */
public interface PmsLiveCourseAskDao extends BaseDao<PmsLiveCourseAsk, String> {

    public Page<PmsLiveCourseAsk> queryPage(Map<String, Object> params);
}