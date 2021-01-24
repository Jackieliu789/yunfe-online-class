package com.yunfeisoft.business.dao.inter;

import com.applet.base.BaseDao;
import com.yunfeisoft.business.model.PmsLiveCourse;
import com.applet.utils.Page;

import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsLiveCourseDao
 * Description: 直播课堂表Dao
 * Author: Jackie liu
 * Date: 2020-03-29
 */
public interface PmsLiveCourseDao extends BaseDao<PmsLiveCourse, String> {

    public Page<PmsLiveCourse> queryPage(Map<String, Object> params);

    public List<PmsLiveCourse> queryList(Map<String, Object> params);

    public int modifyInviteCode(String id, String inviteCode);

    public int modifyClassStatusWithDate(int classStatus);
}