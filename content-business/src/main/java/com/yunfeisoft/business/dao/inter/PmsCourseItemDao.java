package com.yunfeisoft.business.dao.inter;

import com.applet.base.BaseDao;
import com.yunfeisoft.business.model.PmsCourse;
import com.yunfeisoft.business.model.PmsCourseItem;
import com.applet.utils.Page;

import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsCourseItemDao
 * Description: 互动课堂-课节表Dao
 * Author: Jackie liu
 * Date: 2020-03-27
 */
public interface PmsCourseItemDao extends BaseDao<PmsCourseItem, String> {

    public Page<PmsCourseItem> queryPage(Map<String, Object> params);

    public PmsCourseItem queryMaxAndMinDate(String courseId);

    public int queryCount(String courseId);

    public int queryOverCount(String courseId);

    public int modifyInviteCode(String id, String inviteCode);

    public int modifySort(String id, int sort);

    public List<PmsCourseItem> queryList(Map<String, Object> params);
}