package com.yunfeisoft.business.dao.inter;

import com.applet.base.BaseDao;
import com.yunfeisoft.business.model.Meeting;
import com.applet.utils.Page;

import java.util.List;
import java.util.Map;

/**
 * ClassName: MeetingDao
 * Description: 会议表Dao
 * Author: Jackie liu
 * Date: 2020-03-29
 */
public interface MeetingDao extends BaseDao<Meeting, String> {

    public Page<Meeting> queryPage(Map<String, Object> params);

    public List<Meeting> queryList(Map<String, Object> params);

    public int modifyInviteCode(String id, String inviteCode);

    public int modifyStatusWithDate(int classStatus);
}