package com.yunfeisoft.business.dao.impl.postgres;

import com.applet.base.ServiceDaoImpl;
import com.applet.sql.builder.SelectBuilder;
import com.applet.sql.builder.WhereBuilder;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.PmsCourseUserDao;
import com.yunfeisoft.business.model.PmsCourseUser;
import com.yunfeisoft.model.Organization;
import com.yunfeisoft.model.User;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsCourseUserDaoImpl
 * Description: 互动课堂-课程学生/老师表Dao实现
 * Author: Jackie liu
 * Date: 2020-03-27
 */
@Repository
public class PmsCourseUserDaoImpl extends ServiceDaoImpl<PmsCourseUser, String> implements PmsCourseUserDao {

    @Override
    public Page<PmsCourseUser> queryPage(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        if (params != null) {
            initPageParam(wb, params);
        }
        return queryPage(wb);
    }

    @Override
    public List<PmsCourseUser> queryList(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        if (params != null) {
            wb.andEquals("cu.courseId", params.get("courseId"));
            wb.andEquals("cu.type", params.get("type"));
        }

        SelectBuilder builder = selectBuilder("cu");
        builder.column("u.name as userName")
                .column("org.name as orgName")
                .from(domainModelAnalysis.getTableName()).alias("cu").build()
                .join(User.class).alias("u").on("cu.userId = u.id").build()
                .join(Organization.class).alias("org").on("u.orgId = org.id");

        return query(builder.getSql(), wb);
    }

    @Override
    public int deleteByRefId(String refId) {
        if (StringUtils.isBlank(refId)) {
            return 0;
        }

        WhereBuilder wb = new WhereBuilder();
        wb.andEquals("courseId", refId);
        return deleteByCondition(wb);
    }

    @Override
    public int queryCount(String refId, int type) {
        WhereBuilder wb = new WhereBuilder();
        wb.andEquals("courseId", refId);
        wb.andEquals("type", type);
        return count(wb);
    }
}