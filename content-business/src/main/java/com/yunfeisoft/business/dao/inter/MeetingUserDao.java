package com.yunfeisoft.business.dao.inter;

import com.applet.base.BaseDao;
import com.applet.utils.Page;
import com.yunfeisoft.business.model.MeetingUser;

import java.util.List;
import java.util.Map;

/**
 * ClassName: MeetingUserDao
 * Description: 会议-用户表Dao
 * Author: Jackie liu
 * Date: 2020-03-29
 */
public interface MeetingUserDao extends BaseDao<MeetingUser, String> {

    public Page<MeetingUser> queryPage(Map<String, Object> params);

    public List<MeetingUser> queryByMeetingId(String meetingId);

    public int queryCount(String meetingId);
}