package com.yunfeisoft.business.dao.impl.postgres;

import com.applet.base.ServiceDaoImpl;
import com.applet.sql.builder.SelectBuilder;
import com.applet.sql.builder.WhereBuilder;
import com.applet.sql.mapper.DefaultRowMapper;
import com.applet.utils.DateUtils;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.PmsCourseItemDao;
import com.yunfeisoft.business.enums.ClassStatusEnum;
import com.yunfeisoft.business.model.PmsCourse;
import com.yunfeisoft.business.model.PmsCourseItem;
import com.yunfeisoft.model.User;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsCourseItemDaoImpl
 * Description: 互动课堂-课节表Dao实现
 * Author: Jackie liu
 * Date: 2020-03-27
 */
@Repository
public class PmsCourseItemDaoImpl extends ServiceDaoImpl<PmsCourseItem, String> implements PmsCourseItemDao {

    @Override
    public Page<PmsCourseItem> queryPage(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithDesc("createTime");
        if (params != null) {
            initPageParam(wb, params);
            wb.andEquals("ci.courseId", params.get("courseId"));
            wb.andFullLike("ci.name", params.get("name"));
        }

        SelectBuilder builder = selectBuilder("ci");
        builder.column("u.name as teacherName")
                .from(domainModelAnalysis.getTableName()).alias("ci").build()
                .leftJoin(User.class).alias("u").on("ci.teacherId = u.id").build();

        return queryPage(builder.getSql(), wb);
    }

    @Override
    public PmsCourseItem queryMaxAndMinDate(String courseId) {
        String sql = "SELECT MIN(BEGIN_DATE_) AS BEGIN_DATE_, MIN(END_DATE_) AS END_DATE_ FROM PMS_COURSE_ITEM WHERE COURSE_ID_ = ?";
        List<PmsCourseItem> list = jdbcTemplate.query(sql, new Object[]{courseId}, new DefaultRowMapper<PmsCourseItem>(domainModelAnalysis));
        return CollectionUtils.isEmpty(list) ? null : list.get(0);
    }

    @Override
    public int queryCount(String courseId) {
        WhereBuilder wb = new WhereBuilder();
        wb.andEquals("courseId", courseId);
        return count(wb);
    }

    @Override
    public int queryOverCount(String courseId) {
        WhereBuilder wb = new WhereBuilder();
        wb.andEquals("courseId", courseId);
        wb.andEquals("classStatus", ClassStatusEnum.OVER.getValue());
        return count(wb);
    }

    @Override
    public int modifyInviteCode(String id, String inviteCode) {
        if (StringUtils.isBlank(id)) {
            return 0;
        }
        String sql = "UPDATE PMS_COURSE_ITEM SET INVITE_CODE_ = ? WHERE ID_ = ?";
        return jdbcTemplate.update(sql, new Object[]{inviteCode, id});
    }

    @Override
    public int modifySort(String id, int sort) {
        if (StringUtils.isBlank(id)) {
            return 0;
        }

        PmsCourseItem item = new PmsCourseItem();
        item.setId(id);
        item.setSort(sort);
        return update(item);
    }

    @Override
    public List<PmsCourseItem> queryList(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithDesc("ci.createTime");
        if (params != null) {
            wb.andGreaterEquals("ci.beginDate", DateUtils.getTimestamp(params.get("beginDate")));
            wb.andLessEquals("ci.beginDate", DateUtils.getTimestamp(params.get("endDate")));
            wb.andLessThan("ci.endDate", DateUtils.getTimestamp(params.get("minEndDate")));
            wb.andNotEquals("ci.classStatus", params.get("notClassStatus"));

            String userId = (String) params.get("userId");
            if (StringUtils.isNotBlank(userId)) {
                wb.andCustomSQL("(CI.TEACHER_ID_ = ? OR CI.ID_ IN (SELECT COURSE_ID_ FROM PMS_COURSE_USER WHERE IS_DEL_ = 2 AND USER_ID_ = ?))", new Object[]{userId, userId});
            }
        }

        SelectBuilder builder = selectBuilder("ci");
        builder.column("c.coverPath as coverPath")
                .from(domainModelAnalysis.getTableName()).alias("ci").build()
                .join(PmsCourse.class).alias("c").on("ci.courseId = c.id").build();

        return query(builder.getSql(), wb);
    }

}