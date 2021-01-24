package com.yunfeisoft.business.dao.inter;

import com.applet.base.BaseDao;
import com.yunfeisoft.business.model.PmsCourseUser;
import com.applet.utils.Page;

import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsCourseUserDao
 * Description: 互动课堂-课程学生/老师表Dao
 * Author: Jackie liu
 * Date: 2020-03-27
 */
public interface PmsCourseUserDao extends BaseDao<PmsCourseUser, String> {

    public Page<PmsCourseUser> queryPage(Map<String, Object> params);

    public List<PmsCourseUser> queryList(Map<String, Object> params);

    public int deleteByRefId(String refId);

    public int queryCount(String refId, int type);
}