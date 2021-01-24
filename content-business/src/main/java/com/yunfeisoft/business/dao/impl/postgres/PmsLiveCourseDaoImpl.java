package com.yunfeisoft.business.dao.impl.postgres;

import com.applet.base.ServiceDaoImpl;
import com.applet.sql.builder.SelectBuilder;
import com.applet.sql.builder.WhereBuilder;
import com.applet.utils.DateUtils;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.PmsLiveCourseDao;
import com.yunfeisoft.business.model.PmsLiveCourse;
import com.yunfeisoft.model.User;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsLiveCourseDaoImpl
 * Description: 直播课堂表Dao实现
 * Author: Jackie liu
 * Date: 2020-03-29
 */
@Repository
public class PmsLiveCourseDaoImpl extends ServiceDaoImpl<PmsLiveCourse, String> implements PmsLiveCourseDao {

    @Override
    public Page<PmsLiveCourse> queryPage(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithDesc("lc.createTime");
        if (params != null) {
            initPageParam(wb, params);
            wb.andEquals("lc.createId", params.get("createId"));
            wb.andFullLike("lc.name", params.get("name"));
        }

        SelectBuilder builder = selectBuilder("lc");
        builder.column("u.name as teacherName")
                .from(domainModelAnalysis.getTableName()).alias("lc").build()
                .join(User.class).alias("u").on("lc.teacherId = u.id").build();

        return queryPage(builder.getSql(), wb);
    }

    @Override
    public List<PmsLiveCourse> queryList(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithDesc("createTime");
        if (params != null) {
            wb.andGreaterEquals("beginDate", DateUtils.getTimestamp(params.get("beginDate")));
            wb.andLessEquals("beginDate", DateUtils.getTimestamp(params.get("endDate")));
            //wb.andEquals("teacherId", params.get("teacherId"));

            String userId = (String) params.get("userId");
            if (StringUtils.isNotBlank(userId)) {
                wb.andCustomSQL("(TEACHER_ID_ = ? OR ID_ IN (SELECT LIVE_COURSE_ID_ FROM PMS_LIVE_COURSE_USER WHERE IS_DEL_ = 2 AND USER_ID_ = ?))", new Object[]{userId, userId});
            }
        }
        return query(wb);
    }

    @Override
    public int modifyInviteCode(String id, String inviteCode) {
        if (StringUtils.isBlank(id)) {
            return 0;
        }
        String sql = "UPDATE PMS_LIVE_COURSE SET INVITE_CODE_ = ? WHERE ID_ = ?";
        return jdbcTemplate.update(sql, new Object[]{inviteCode, id});
    }

    @Override
    public int modifyClassStatusWithDate(int classStatus) {
        WhereBuilder wb = new WhereBuilder();
        wb.andLessThan("endDate", DateUtils.getTimestamp(new Date()));

        PmsLiveCourse pmsLiveCourse = new PmsLiveCourse();
        pmsLiveCourse.setClassStatus(classStatus);
        return updateByCondition(pmsLiveCourse, wb);
    }
}