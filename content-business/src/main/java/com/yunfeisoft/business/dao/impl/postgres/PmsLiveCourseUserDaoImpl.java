package com.yunfeisoft.business.dao.impl.postgres;

import com.applet.base.ServiceDaoImpl;
import com.applet.sql.builder.SelectBuilder;
import com.applet.sql.builder.WhereBuilder;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.PmsLiveCourseUserDao;
import com.yunfeisoft.business.model.PmsLiveCourseUser;
import com.yunfeisoft.model.User;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsLiveCourseUserDaoImpl
 * Description: 直播课堂-用户表Dao实现
 * Author: Jackie liu
 * Date: 2020-04-15
 */
@Repository
public class PmsLiveCourseUserDaoImpl extends ServiceDaoImpl<PmsLiveCourseUser, String> implements PmsLiveCourseUserDao {

    @Override
    public Page<PmsLiveCourseUser> queryPage(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        if (params != null) {
            initPageParam(wb, params);
        }
        return queryPage(wb);
    }

    @Override
    public List<PmsLiveCourseUser> queryByCourseId(String courseId) {
        if (StringUtils.isBlank(courseId)) {
            return new ArrayList<>();
        }

        WhereBuilder wb = new WhereBuilder();
        wb.andEquals("lcu.liveCourseId", courseId);

        SelectBuilder builder = selectBuilder("lcu");
        builder.column("u.name as userName")
                .from(domainModelAnalysis.getTableName()).alias("lcu").build()
                .join(User.class).alias("u").on("lcu.userId = u.id").build();

        return query(builder.getSql(), wb);
    }

    @Override
    public int queryCount(String courseId) {
        WhereBuilder wb = new WhereBuilder();
        wb.andEquals("liveCourseId", courseId);
        return count(wb);
    }
}