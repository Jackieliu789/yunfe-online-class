package com.yunfeisoft.business.service.inter;

import com.applet.base.BaseService;
import com.applet.utils.Page;
import com.yunfeisoft.business.model.ParticipateUser;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ParticipateUserService
 * Description: 课程参与用户(进入直播间上课的用户)service接口
 * Author: Jackie liu
 * Date: 2020-05-26
 */
public interface ParticipateUserService extends BaseService<ParticipateUser, String> {

    public Page<ParticipateUser> queryPage(Map<String, Object> params);

    public List<ParticipateUser> queryList(Map<String, Object> params);

    public int modifyTime(ParticipateUser participateUser);
}