package com.yunfeisoft.business.dao.inter;

import com.applet.base.BaseDao;
import com.applet.utils.Page;
import com.yunfeisoft.business.model.PmsLiveCourseUser;

import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsLiveCourseUserDao
 * Description: 直播课堂-用户表Dao
 * Author: Jackie liu
 * Date: 2020-04-15
 */
public interface PmsLiveCourseUserDao extends BaseDao<PmsLiveCourseUser, String> {

    public Page<PmsLiveCourseUser> queryPage(Map<String, Object> params);

    public List<PmsLiveCourseUser> queryByCourseId(String courseId);

    public int queryCount(String courseId);
}