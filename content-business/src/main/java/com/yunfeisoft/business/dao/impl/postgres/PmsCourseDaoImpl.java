package com.yunfeisoft.business.dao.impl.postgres;

import com.applet.base.ServiceDaoImpl;
import com.applet.sql.builder.WhereBuilder;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.PmsCourseDao;
import com.yunfeisoft.business.model.PmsCourse;
import org.springframework.stereotype.Repository;

import java.util.Map;

/**
 * ClassName: PmsCourseDaoImpl
 * Description: 互动课堂-课程表Dao实现
 * Author: Jackie liu
 * Date: 2020-03-27
 */
@Repository
public class PmsCourseDaoImpl extends ServiceDaoImpl<PmsCourse, String> implements PmsCourseDao {

    @Override
    public Page<PmsCourse> queryPage(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithDesc("createTime");
        if (params != null) {
            initPageParam(wb, params);
            wb.andEquals("createId", params.get("createId"));
        }
        return queryPage(wb);
    }
}