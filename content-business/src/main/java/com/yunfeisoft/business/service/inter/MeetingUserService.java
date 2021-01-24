package com.yunfeisoft.business.service.inter;

import com.applet.base.BaseService;
import com.yunfeisoft.business.model.MeetingUser;
import com.applet.utils.Page;

import java.util.List;
import java.util.Map;

/**
 * ClassName: MeetingUserService
 * Description: 会议-用户表service接口
 * Author: Jackie liu
 * Date: 2020-03-29
 */
public interface MeetingUserService extends BaseService<MeetingUser, String> {

    public Page<MeetingUser> queryPage(Map<String, Object> params);

    public List<MeetingUser> queryByMeetingId(String meetingId);
}