package com.yunfeisoft.business.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.MeetingDao;
import com.yunfeisoft.business.dao.inter.MeetingUserDao;
import com.yunfeisoft.business.model.Meeting;
import com.yunfeisoft.business.model.MeetingUser;
import com.yunfeisoft.business.service.inter.MeetingUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * ClassName: MeetingUserServiceImpl
 * Description: 会议-用户表service实现
 * Author: Jackie liu
 * Date: 2020-03-29
 */
@Service("meetingUserService")
public class MeetingUserServiceImpl extends BaseServiceImpl<MeetingUser, String, MeetingUserDao> implements MeetingUserService {

    @Autowired
    private MeetingDao meetingDao;

    @Override
    @DataSourceChange(slave = true)
    public Page<MeetingUser> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @Override
    public List<MeetingUser> queryByMeetingId(String meetingId) {
        return getDao().queryByMeetingId(meetingId);
    }

    @Override
    public int save(MeetingUser meetingUser) {
        int count = getDao().queryCount(meetingUser.getMeetingId());
        Meeting meeting = new Meeting();
        meeting.setId(meetingUser.getMeetingId());
        meeting.setUserNum(count + 1);
        meetingDao.update(meeting);
        return super.save(meetingUser);
    }

    @Override
    public int remove(String id) {
        MeetingUser meetingUser = getDao().load(id);
        int count = getDao().queryCount(meetingUser.getMeetingId());
        Meeting meeting = new Meeting();
        meeting.setId(meetingUser.getMeetingId());
        meeting.setUserNum(count - 1);
        meetingDao.update(meeting);
        return super.remove(id);
    }
}