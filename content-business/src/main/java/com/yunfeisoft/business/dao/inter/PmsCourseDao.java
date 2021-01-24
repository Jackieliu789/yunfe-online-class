package com.yunfeisoft.business.dao.inter;

import com.applet.base.BaseDao;
import com.yunfeisoft.business.model.PmsCourse;
import com.applet.utils.Page;

import java.util.Map;

/**
 * ClassName: PmsCourseDao
 * Description: 互动课堂-课程表Dao
 * Author: Jackie liu
 * Date: 2020-03-27
 */
public interface PmsCourseDao extends BaseDao<PmsCourse, String> {

    public Page<PmsCourse> queryPage(Map<String, Object> params);
}