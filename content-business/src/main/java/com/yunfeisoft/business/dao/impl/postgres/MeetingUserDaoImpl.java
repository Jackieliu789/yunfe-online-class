package com.yunfeisoft.business.dao.impl.postgres;

import com.applet.base.ServiceDaoImpl;
import com.applet.sql.builder.SelectBuilder;
import com.applet.sql.builder.WhereBuilder;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.MeetingUserDao;
import com.yunfeisoft.business.model.MeetingUser;
import com.yunfeisoft.model.User;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * ClassName: MeetingUserDaoImpl
 * Description: 会议-用户表Dao实现
 * Author: Jackie liu
 * Date: 2020-03-29
 */
@Repository
public class MeetingUserDaoImpl extends ServiceDaoImpl<MeetingUser, String> implements MeetingUserDao {

    @Override
    public Page<MeetingUser> queryPage(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        if (params != null) {
            initPageParam(wb, params);
        }
        return queryPage(wb);
    }

    @Override
    public List<MeetingUser> queryByMeetingId(String meetingId) {
        if (StringUtils.isBlank(meetingId)) {
            return new ArrayList<>();
        }

        WhereBuilder wb = new WhereBuilder();
        wb.andEquals("mu.meetingId", meetingId);

        SelectBuilder builder = selectBuilder("mu");
        builder.column("u.name as userName")
                .from(domainModelAnalysis.getTableName()).alias("mu").build()
                .join(User.class).alias("u").on("mu.userId = u.id").build();

        return query(builder.getSql(), wb);
    }

    @Override
    public int queryCount(String meetingId) {
        WhereBuilder wb = new WhereBuilder();
        wb.andEquals("meetingId", meetingId);
        return count(wb);
    }
}