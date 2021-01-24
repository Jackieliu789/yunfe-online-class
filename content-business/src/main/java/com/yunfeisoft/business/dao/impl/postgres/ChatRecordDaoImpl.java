package com.yunfeisoft.business.dao.impl.postgres;

import com.applet.base.ServiceDaoImpl;
import com.applet.sql.builder.SelectBuilder;
import com.applet.sql.builder.WhereBuilder;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.ChatRecordDao;
import com.yunfeisoft.business.model.ChatRecord;
import com.yunfeisoft.model.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ChatRecordDaoImpl
 * Description: 聊天记录Dao实现
 * Author: Jackie liu
 * Date: 2020-05-26
 */
@Repository
public class ChatRecordDaoImpl extends ServiceDaoImpl<ChatRecord, String> implements ChatRecordDao {

    @Override
    public Page<ChatRecord> queryPage(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithDesc("cr.createTime");
        if (params != null) {
            initPageParam(wb, params);
            wb.andEquals("cr.roomId", params.get("roomId"));
        }

        SelectBuilder builder = getSelectBuilder("cr");
        builder.column("u.name as userName")
                .join(User.class).alias("u").on("cr.userId = u.id").build();

        return queryPage(builder.getSql(), wb);
    }

    @Override
    public List<ChatRecord> queryList(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithDesc("cr.createTime");
        if (params != null) {
            wb.andEquals("cr.roomId", params.get("roomId"));
        }

        SelectBuilder builder = getSelectBuilder("cr");
        builder.column("u.name as userName")
                .join(User.class).alias("u").on("cr.userId = u.id").build();

        return query(builder.getSql(), wb);
    }
}