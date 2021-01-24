package com.yunfeisoft.business.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.MeetingDao;
import com.yunfeisoft.business.dao.inter.VideoRoomIdSeqDao;
import com.yunfeisoft.business.model.Meeting;
import com.yunfeisoft.business.service.inter.MeetingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * ClassName: MeetingServiceImpl
 * Description: 会议表service实现
 * Author: Jackie liu
 * Date: 2020-03-29
 */
@Service("meetingService")
public class MeetingServiceImpl extends BaseServiceImpl<Meeting, String, MeetingDao> implements MeetingService {

    @Autowired
    private VideoRoomIdSeqDao videoRoomIdSeqDao;

    @Override
    @DataSourceChange(slave = true)
    public Page<Meeting> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @Override
    public List<Meeting> queryList(Map<String, Object> params) {
        return getDao().queryList(params);
    }

    @Override
    public int modifyInviteCode(String id, String inviteCode) {
        return getDao().modifyInviteCode(id, inviteCode);
    }

    @Override
    public int modifyStatusWithDate(int classStatus) {
        return getDao().modifyStatusWithDate(classStatus);
    }

    @Override
    public int save(Meeting meeting) {
        meeting.setRoomId(videoRoomIdSeqDao.querySeq());
        return super.save(meeting);
    }
}