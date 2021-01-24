package com.yunfeisoft.business.dao.impl.postgres;

import com.applet.base.ServiceDaoImpl;
import com.applet.sql.builder.SelectBuilder;
import com.applet.sql.builder.WhereBuilder;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.ParticipateUserDao;
import com.yunfeisoft.business.model.ParticipateUser;
import com.yunfeisoft.model.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ParticipateUserDaoImpl
 * Description: 课程参与用户(进入直播间上课的用户)Dao实现
 * Author: Jackie liu
 * Date: 2020-05-26
 */
@Repository
public class ParticipateUserDaoImpl extends ServiceDaoImpl<ParticipateUser, String> implements ParticipateUserDao {

    @Override
    public Page<ParticipateUser> queryPage(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithDesc("pu.createTime");
        if (params != null) {
            initPageParam(wb, params);
            wb.andEquals("pu.roomId", params.get("roomId"));
        }
        SelectBuilder builder = getSelectBuilder("pu");
        builder.column("u.name as userName")
                .join(User.class).alias("u").on("pu.userId = u.id").build();

        return queryPage(builder.getSql(), wb);
    }

    @Override
    public List<ParticipateUser> queryList(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithDesc("pu.createTime");
        if (params != null) {
            wb.andEquals("pu.roomId", params.get("roomId"));
        }
        SelectBuilder builder = getSelectBuilder("pu");
        builder.column("u.name as userName")
                .join(User.class).alias("u").on("pu.userId = u.id").build();

        return query(builder.getSql(), wb);
    }

    @Override
    public int queryNum(String roomId, String userId) {
        WhereBuilder wb = new WhereBuilder();
        wb.andEquals("roomId", roomId);
        wb.andEquals("userId", userId);
        return count(wb);
    }

    @Override
    public int modifyTime(ParticipateUser participateUser) {
        WhereBuilder wb = new WhereBuilder();
        wb.andEquals("userId", participateUser.getUserId());
        wb.andEquals("roomId", participateUser.getRoomId());

        return updateByCondition(participateUser, wb);
    }
}