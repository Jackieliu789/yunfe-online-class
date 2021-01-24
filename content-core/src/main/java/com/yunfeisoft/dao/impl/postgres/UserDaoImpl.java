/**
 * UserDaoImpl.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.impl.postgres;

import com.applet.base.BaseDaoImpl;
import com.applet.sql.builder.SelectBuilder;
import com.applet.sql.builder.WhereBuilder;
import com.applet.sql.mapper.DefaultRowMapper;
import com.applet.utils.Page;
import com.yunfeisoft.dao.inter.UserDao;
import com.yunfeisoft.model.Organization;
import com.yunfeisoft.model.Position;
import com.yunfeisoft.model.User;
import org.apache.commons.lang3.StringUtils;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: UserDaoImpl</p>
 * <p>Description: 用户管理Dao实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Repository
public class UserDaoImpl extends BaseDaoImpl<User, String> implements UserDao {

    @Override
    public List<User> queryByAccount(String account) {
        WhereBuilder wc = new WhereBuilder();
        wc.andEquals("policeNo", account);
        return query(wc);
    }

    @Override
    public List<User> queryByOpenId(String openId) {
        WhereBuilder wc = new WhereBuilder();
        wc.andEquals("openId", openId);
        return query(wc);
    }

    @Override
    public List<User> queryByPhoneOrIdCard(String phoneOrIdCard) {
        WhereBuilder wc = new WhereBuilder();
        wc.andEquals("phone", phoneOrIdCard);
        wc.orEquals("idcard", phoneOrIdCard);
        return query(wc);
    }

    @Override
    public List<User> queryList(Map<String, Object> params) {
        WhereBuilder wb = new WhereBuilder();
        if (params != null) {
            wb.andEquals("u.state", params.get("state"));
            wb.andIn("u.orgId", (List) params.get("orgIds"));
        }

        SelectBuilder builder = selectBuilder("u");
        builder.column("o.name as orgName")
                .from(domainModelAnalysis.getTableName()).alias("u").build()
                .leftJoin(Organization.class).alias("o").on("u.orgId = o.id").build();

        return query(builder.getSql(), wb);
    }

    @Override
    public List<User> queryByRoleId(String roleId) {
        String sql = String.format("SELECT U.%s FROM %s U INNER JOIN TR_ROLE_USER RU ON U.ID_ = RU.USER_ID_ WHERE ROLE_ID_ = ?", joinColumn(", U."), domainModelAnalysis.getTableName());
        return jdbcTemplate.query(sql, new Object[]{roleId}, new DefaultRowMapper<User>(domainModelAnalysis));
    }

    @Override
    public boolean isDuplicateName(String id, String orgId, String name) {
        WhereBuilder wb = new WhereBuilder();
        wb.andEquals("orgId", orgId);
        wb.andEquals("name", name);
        wb.andNotEquals("id", id);
        return count(wb) > 0;
    }

    @Override
    public boolean isDuplicatePoliceNo(String id, String policeNo) {
        return isDuplicateField(id, policeNo, "policeNo");
    }

    @Override
    public boolean isDuplicateIdCard(String id, String idCard) {
        return isDuplicateField(id, idCard, "idcard");
    }

    @Override
    public Page<User> queryPage(Map<String, Object> params) {
        WhereBuilder queryCondition = new WhereBuilder();
        queryCondition.setOrderByWithAsc("policeNo");
        if (params != null) {
            initPageParam(queryCondition, params);
            queryCondition.andFullLike("orgId", params.get("orgId"));
            String searchInput = (String) params.get("searchInput");
            if (StringUtils.isNotEmpty(searchInput)) {
                queryCondition.andGroup()
                        .andFullLike("a.name", searchInput)
                        .orFullLike("policeNo", searchInput);
            }
        }

        SelectBuilder selectBuilder = selectBuilder("a");
        selectBuilder.column("b.name as orgName")
                .column("c.name as positionName")
                .from(domainModelAnalysis.getTableName()).alias("a").build()
                .leftJoin(Organization.class).alias("b").on("a.orgId = b.id").build()
                .leftJoin(Position.class).alias("c").on("a.positionId = c.id").build();

        return queryPage(selectBuilder.getSql(), queryCondition);
        //return queryPage(queryCondition);
    }

    @Override
    public User queryById(String id) {
        SelectBuilder selectBuilder = selectBuilder("a");
        selectBuilder.column("b.name as orgName")
                .column("c.name as positionName")
                .from(domainModelAnalysis.getTableName()).alias("a").build()
                .leftJoin(Organization.class).alias("b").on("a.orgId = b.id").build()
                .leftJoin(Position.class).alias("c").on("a.positionId = c.id").build();

        WhereBuilder whereBuilder = new WhereBuilder();
        whereBuilder.andEquals("a.id", id);

        List<User> list = query(selectBuilder.getSql(), whereBuilder);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public int modifyState(final String[] ids, final int state) {
        String sql = String.format("UPDATE %s SET STATE_ = ? WHERE ID_ = ?", domainModelAnalysis.getTableName());
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
    public List<User> queryByOrgId(String orgId) {
        WhereBuilder wb = new WhereBuilder();
        wb.andCustomSQL("ORG_ID_ IN (SELECT ID_ FROM TS_ORGANIZATION WHERE ID_PATH_ LIKE ?)", new Object[]{"%" + orgId + "%"});
        return query(wb);
    }

    @Override
    public int modifyPass(final String[] ids, final String pass) {
        String sql = String.format("UPDATE %s SET PASS_ = ? WHERE ID_ = ?", domainModelAnalysis.getTableName());
        int result = jdbcTemplate.batchUpdate(sql, new BatchPreparedStatementSetter() {
            @Override
            public void setValues(PreparedStatement preparedStatement, int i) throws SQLException {
                preparedStatement.setString(1, pass);
                preparedStatement.setString(2, ids[i]);
            }

            @Override
            public int getBatchSize() {
                return ids.length;
            }
        }).length;
        return result;
    }

    @Override
    public List<User> queryStranger(String userId) {
        WhereBuilder wb = new WhereBuilder();
        wb.andNotEquals("id", userId);
        wb.andCustomSQL("ID_ NOT IN (SELECT UG.FRIEND_ID_ FROM TR_IM_USER_GROUP UG JOIN TT_IM_GROUP IG ON UG.GROUP_ID_ = IG.ID_ WHERE IG.USER_ID_ = ?)", new Object[]{userId});
        return query(wb);
    }
}