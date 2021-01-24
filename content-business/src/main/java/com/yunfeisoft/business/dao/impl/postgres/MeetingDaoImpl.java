package com.yunfeisoft.business.dao.impl.postgres;

import com.applet.base.ServiceDaoImpl;
import com.applet.sql.builder.SelectBuilder;
import com.applet.sql.builder.WhereBuilder;
import com.applet.utils.DateUtils;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.MeetingDao;
import com.yunfeisoft.business.model.Meeting;
import com.yunfeisoft.model.User;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * ClassName: MeetingDaoImpl
 * Description: 会议表Dao实现
 * Author: Jackie liu
 * Date: 2020-03-29
 */
@Repository
public class MeetingDaoImpl extends ServiceDaoImpl<Meeting, String> implements MeetingDao {

    @Override
    public Page<Meeting> queryPage(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithDesc("m.createTime");
        if (params != null) {
            initPageParam(wb, params);
            wb.andEquals("m.createId", params.get("createId"));
            wb.andFullLike("m.name", params.get("name"));
        }

        SelectBuilder builder = selectBuilder("m");
        builder.column("u.name as hostName")
                .from(domainModelAnalysis.getTableName()).alias("m").build()
                .join(User.class).alias("u").on("m.hostId = u.id").build();

        return queryPage(builder.getSql(), wb);
    }

    @Override
    public List<Meeting> queryList(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithDesc("createTime");
        if (params != null) {
            wb.andGreaterEquals("beginDate", DateUtils.getTimestamp(params.get("beginDate")));
            wb.andLessEquals("beginDate", DateUtils.getTimestamp(params.get("endDate")));

            String userId = (String) params.get("userId");
            if (StringUtils.isNotBlank(userId)) {
                wb.andCustomSQL("(HOST_ID_ = ? OR ID_ IN (SELECT MEETING_ID_ FROM MEETING_USER WHERE IS_DEL_ = 2 AND USER_ID_ = ?))", new Object[]{userId, userId});
            }
        }

        return query(wb);
    }

    @Override
    public int modifyInviteCode(String id, String inviteCode) {
        if (StringUtils.isBlank(id)) {
            return 0;
        }
        String sql = "UPDATE MEETING SET INVITE_CODE_ = ? WHERE ID_ = ?";
        return jdbcTemplate.update(sql, new Object[]{inviteCode, id});
    }

    @Override
    public int modifyStatusWithDate(int classStatus) {
        WhereBuilder wb = new WhereBuilder();
        wb.andLessThan("endDate", DateUtils.getTimestamp(new Date()));

        Meeting meeting = new Meeting();
        meeting.setStatus(classStatus);
        return updateByCondition(meeting, wb);
    }
}