package com.yunfeisoft.business.dao.inter;

import com.applet.base.BaseDao;
import com.applet.utils.Page;
import com.yunfeisoft.business.model.ParticipateUser;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ParticipateUserDao
 * Description: 课程参与用户(进入直播间上课的用户)Dao
 * Author: Jackie liu
 * Date: 2020-05-26
 */
public interface ParticipateUserDao extends BaseDao<ParticipateUser, String> {

    public Page<ParticipateUser> queryPage(Map<String, Object> params);

    public List<ParticipateUser> queryList(Map<String, Object> params);

    public int queryNum(String roomId, String userId);

    public int modifyTime(ParticipateUser participateUser);
}