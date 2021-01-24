/**
 * PositionDaoImpl.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.impl.postgres;

import com.applet.base.BaseDaoImpl;
import com.applet.sql.builder.WhereBuilder;
import com.applet.utils.Page;
import com.yunfeisoft.dao.inter.PositionDao;
import com.yunfeisoft.model.Position;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Map;

/**
 * <p>ClassName: PositionDaoImpl</p>
 * <p>Description: 职务管理Dao实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Repository
public class PositionDaoImpl extends BaseDaoImpl<Position, String> implements PositionDao {

    @Override
    public Page<Position> queryPage(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithDesc("createTime");
        if (params != null) {
            wb.andFullLike("name", params.get("name"));
            initPageParam(wb, params);
        }
        Page<Position> queryPage = queryPage(wb);
        return queryPage;
    }

    @Override
    public int batchRemove(String[] ids) {
        WhereBuilder wb = new WhereBuilder();
        wb.andIn("id", ids);
        return deleteByCondition(wb);
    }

    @Override
    public int modifyState(final String[] ids, final int state) {
        String sql = String.format("UPDATE %s SET STATE_ = ? WHERE ID_ = ?", domainModelAnalysis.getTableName());
        return jdbcTemplate.batchUpdate(sql, new BatchPreparedStatementSetter() {
            @Override
            public void setValues(PreparedStatement preparedStatement, int i) throws SQLException {
                preparedStatement.setInt(1, state);
                preparedStatement.setString(2, ids[i]);
            }

            @Override
            public int getBatchSize() {
                return ids.length;
            }
        }).length;
    }

    @Override
    public Boolean isDuplicateName(String id, String name) {
        return super.isDuplicateField(id, name, "name");
    }

    @Override
    public Boolean isDuplicateCode(String id, String code) {
        return super.isDuplicateField(id, code, "code");
    }

}