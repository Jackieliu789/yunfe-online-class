package com.yunfeisoft.business.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.ParticipateUserDao;
import com.yunfeisoft.business.model.ParticipateUser;
import com.yunfeisoft.business.service.inter.ParticipateUserService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ParticipateUserServiceImpl
 * Description: 课程参与用户(进入直播间上课的用户)service实现
 * Author: Jackie liu
 * Date: 2020-05-26
 */
@Service("participateUserService")
public class ParticipateUserServiceImpl extends BaseServiceImpl<ParticipateUser, String, ParticipateUserDao> implements ParticipateUserService {

    @Override
    @DataSourceChange(slave = true)
    public Page<ParticipateUser> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @Override
    public List<ParticipateUser> queryList(Map<String, Object> params) {
        return getDao().queryList(params);
    }

    @Override
    public int modifyTime(ParticipateUser participateUser) {
        return getDao().modifyTime(participateUser);
    }

    @Override
    public int save(ParticipateUser participateUser) {
        int num = getDao().queryNum(participateUser.getRoomId(), participateUser.getUserId());
        if (num > 0) {
            return 0;
        }
        return super.save(participateUser);
    }
}