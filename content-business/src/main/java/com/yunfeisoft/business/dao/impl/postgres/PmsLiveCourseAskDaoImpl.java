package com.yunfeisoft.business.dao.impl.postgres;

import com.applet.base.ServiceDaoImpl;
import com.applet.sql.builder.SelectBuilder;
import com.applet.sql.builder.WhereBuilder;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.PmsLiveCourseAskDao;
import com.yunfeisoft.business.model.PmsLiveCourseAsk;
import com.yunfeisoft.model.User;
import org.springframework.stereotype.Repository;

import java.util.Map;

/**
 * ClassName: PmsLiveCourseAskDaoImpl
 * Description: 直播课堂提问表Dao实现
 * Author: Jackie liu
 * Date: 2020-04-15
 */
@Repository
public class PmsLiveCourseAskDaoImpl extends ServiceDaoImpl<PmsLiveCourseAsk, String> implements PmsLiveCourseAskDao {

    @Override
    public Page<PmsLiveCourseAsk> queryPage(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithDesc("ca.createTime");
        if (params != null) {
            initPageParam(wb, params);
            wb.andEquals("ca.liveCourseId", params.get("liveCourseId"));
        }

        SelectBuilder builder = selectBuilder("ca");
        builder.column("u.name as createName")
                .from(domainModelAnalysis.getTableName()).alias("ca").build()
                .leftJoin(User.class).alias("u").on("ca.createId = u.id").build();

        return queryPage(builder.getSql(), wb);
    }
}