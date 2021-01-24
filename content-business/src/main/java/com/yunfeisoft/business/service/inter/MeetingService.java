package com.yunfeisoft.business.service.inter;

import com.applet.base.BaseService;
import com.applet.utils.Page;
import com.yunfeisoft.business.model.Meeting;

import java.util.List;
import java.util.Map;

/**
 * ClassName: MeetingService
 * Description: 会议表service接口
 * Author: Jackie liu
 * Date: 2020-03-29
 */
public interface MeetingService extends BaseService<Meeting, String> {

    public Page<Meeting> queryPage(Map<String, Object> params);

    public List<Meeting> queryList(Map<String, Object> params);

    public int modifyInviteCode(String id, String inviteCode);

    public int modifyStatusWithDate(int classStatus);
}