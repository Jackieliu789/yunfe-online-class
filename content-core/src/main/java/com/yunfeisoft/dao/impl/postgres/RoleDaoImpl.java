/**
 * RoleDaoImpl.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.impl.postgres;

import com.applet.base.BaseDaoImpl;
import com.applet.sql.builder.WhereBuilder;
import com.applet.sql.mapper.DefaultRowMapper;
import com.applet.utils.Page;
import com.yunfeisoft.dao.inter.RoleDao;
import com.yunfeisoft.enumeration.YesNoEnum;
import com.yunfeisoft.model.Role;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: RoleDaoImpl</p>
 * <p>Description: 角色管理Dao实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Repository
public class RoleDaoImpl extends BaseDaoImpl<Role, String> implements RoleDao {

    @Override
    public List<Role> queryByUserId(String userId) {
        String sql = String.format("SELECT R.%s FROM TR_ROLE_USER RU JOIN %s R ON RU.ROLE_ID_ = R.ID_ WHERE R.STATE_ = ? AND RU.USER_ID_ = ?",
                joinColumn(", R."), domainModelAnalysis.getTableName());
        Object args[] = new Object[]{YesNoEnum.YES_ACCPET.getValue(), userId};
        return jdbcTemplate.query(sql, args, new DefaultRowMapper<Role>(domainModelAnalysis));
    }

    @Override
    public List<Role> query(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        if (params != null && params.size() > 0) {
            wb.andEquals("state", params.get("state"));
        }
        return super.query(wb);
    }

    @Override
    public Page<Role> queryPage(Map<String, Object> params) {
        String sql = "SELECT TR.*, TU.NAME_ AS CREATE_NAME_ FROM TS_ROLE TR JOIN TS_USER TU ON TR.CREATE_ID_ = TU.ID_";
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithDesc("tr.createTime");
        if (params != null) {
            wb.andFullLike("tr.name", params.get("name"));

            initPageParam(wb, params);
        }
        return queryPage(sql, wb);
    }

    @Override
    public int batchRemove(String[] ids) {
        WhereBuilder wb = new WhereBuilder();
        wb.andIn("id", ids);
        return deleteByCondition(wb);
    }

    @Override
    public int modifyState(final String[] ids, final int state) {
        String sql = String.format("UPDATE %s SET STATE_=? WHERE ID_=?", domainModelAnalysis.getTableName());
        int[] batchUpdate = jdbcTemplate.batchUpdate(sql, new BatchPreparedStatementSetter() {

            @Override
            public void setValues(PreparedStatement ps, int i) throws SQLException {
                ps.setInt(1, state);
                ps.setString(2, ids[i]);
            }

            @Override
            public int getBatchSize() {
                return ids.length;
            }
        });
        return batchUpdate.length;
    }

    @Override
    public Boolean isDuplicateName(String id, String name) {
        return super.isDuplicateField(id, name, "name");
    }
}