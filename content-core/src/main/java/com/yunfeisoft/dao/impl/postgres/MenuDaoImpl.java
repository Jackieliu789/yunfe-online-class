/**
 * MenuDaoImpl.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.impl.postgres;

import com.applet.base.BaseDaoImpl;
import com.applet.sql.builder.WhereBuilder;
import com.applet.sql.mapper.DefaultRowMapper;
import com.applet.utils.Page;
import com.yunfeisoft.dao.inter.MenuDao;
import com.yunfeisoft.enumeration.YesNoEnum;
import com.yunfeisoft.model.Menu;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: MenuDaoImpl</p>
 * <p>Description: 菜单管理Dao实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Repository
public class MenuDaoImpl extends BaseDaoImpl<Menu, String> implements MenuDao {

    @Override
    public List<Menu> queryByUserId(String userId) {
        String sql = String.format("SELECT M.%s FROM %s M WHERE M.STATE_ = ? AND M.ID_ IN (SELECT RM.MENU_ID_ FROM TR_ROLE_MENU RM JOIN TR_ROLE_USER RU ON RM.ROLE_ID_ = RU.ROLE_ID_ WHERE RU.USER_ID_ = ? ) ORDER BY M.ORDER_BY_ ASC", joinColumn(", M."), domainModelAnalysis.getTableName());
        Object args[] = new Object[]{YesNoEnum.YES_ACCPET.getValue(), userId};
        return jdbcTemplate.query(sql, args, new DefaultRowMapper<Menu>(domainModelAnalysis));
    }

    @Override
    public List<Menu> queryByRoleId(String roleId) {
        String sql = String.format("SELECT M.%s FROM %s M JOIN TR_ROLE_MENU RM ON RM.MENU_ID_ = M.ID_ WHERE RM.ROLE_ID_ = ?", joinColumn(", M."), domainModelAnalysis.getTableName());
        Object args[] = new Object[]{roleId};
        return jdbcTemplate.query(sql, args, new DefaultRowMapper<Menu>(domainModelAnalysis));
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<Menu> query(Map<String, Object> params) {
        WhereBuilder qc = new WhereBuilder();
        qc.setOrderByWithAsc("orderBy");
        if (params != null && params.size() > 0) {
            qc.andIn("parentId", (List<String>) params.get("parentId"));
            qc.andIn("id", (List<String>) params.get("ids"));
            qc.andEquals("state", params.get("state"));
        }
        return this.query(qc);
    }


    @Override
    public Page<Menu> queryPage(Map<String, Object> params) {
        WhereBuilder qc = new WhereBuilder();
        qc.setOrderByWithAsc("orderBy");
        if (params != null && params.size() > 0) {
            qc.andFullLike("name", params.get("searchInput"));
            qc.andEquals("parentId", params.get("parentId"));
            qc.orFullLike("code", params.get("searchInput"));
            initPageParam(qc, params);
        }
        Page<Menu> queryPage = queryPage(qc);
        return queryPage;
    }

    @Override
    public int batchRemove(String[] ids) {
        WhereBuilder qc = new WhereBuilder();
        qc.andIn("id", ids);
        return deleteByCondition(qc);

    }

    @Override
    public int modifyState(final String[] ids, final int state) {
        String sql = String.format("UPDATE %s SET STATE_=? WHERE ID_ =?", domainModelAnalysis.getTableName());
        int[] result = jdbcTemplate.batchUpdate(sql, new BatchPreparedStatementSetter() {
            // 用来为PreparedStatement设置，i表示 正在执行操作的索引
            @Override
            public void setValues(PreparedStatement ps, int i) throws SQLException {
                ps.setInt(1, state);
                ps.setString(2, ids[i]);
            }

            // 用来返回批次的大小
            @Override
            public int getBatchSize() {
                return ids.length;
            }
        });
        return result.length;
    }

    @Override
    public Boolean isDuplicateName(String id, String name) {
        return super.isDuplicateField(id, name, "name");
    }

    @Override
    public Boolean isDuplicateCode(String id, String code) {
        return super.isDuplicateField(id, code, "code");
    }

    @Override
    public List<Menu> queryParentList(String id) {
        String sql = String.format("WITH RECURSIVE TE_MENU AS (SELECT A.%s FROM %s A WHERE ID_ = ? UNION ALL SELECT K.%s FROM %s K INNER JOIN TE_MENU C ON C.PARENT_ID_ = K.ID_) SELECT %s FROM TE_MENU",
                joinColumn(", A."), domainModelAnalysis.getTableName(), joinColumn(", K."), domainModelAnalysis.getTableName(), domainModelAnalysis.getDefaultColumnArrayStr());
        return jdbcTemplate.query(sql, new Object[]{id}, new DefaultRowMapper<Menu>(domainModelAnalysis));
    }

    @Override
    public List<Menu> queryChildren(String id) {
        String sql = String.format("WITH RECURSIVE TE_MENU AS (SELECT A.%s FROM %s A WHERE ID_ = ? UNION ALL SELECT K.%s FROM %s K INNER JOIN TE_MENU C ON C.ID_ = K.PARENT_ID_) SELECT %s FROM TE_MENU",
                joinColumn(", A."), domainModelAnalysis.getTableName(), joinColumn(", K."), domainModelAnalysis.getTableName(), domainModelAnalysis.getDefaultColumnArrayStr());
        return jdbcTemplate.query(sql, new Object[]{id}, new DefaultRowMapper<Menu>(domainModelAnalysis));
    }
}