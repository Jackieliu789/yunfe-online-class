/**
 * OrganizationDaoImpl.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.impl.postgres;

import com.applet.base.BaseDaoImpl;
import com.applet.sql.builder.WhereBuilder;
import com.applet.sql.mapper.DefaultRowMapper;
import com.applet.utils.Page;
import com.yunfeisoft.dao.inter.OrganizationDao;
import com.yunfeisoft.model.Organization;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: OrganizationDaoImpl</p>
 * <p>Description: 组织机构Dao实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Repository
public class OrganizationDaoImpl extends BaseDaoImpl<Organization, String> implements OrganizationDao {

    @Override
    public boolean isDuplicateCode(String id, String code) {
        return isDuplicateField(id, code, "code");
    }

    @Override
    public boolean isDuplicateName(String id, String name) {
        return isDuplicateField(id, name, "name");
    }

    @Override
    public Page<Organization> queryPage(Map<String, Object> params) {
        WhereBuilder queryCondition = new WhereBuilder();
        //queryCondition.setOrderByWithAsc("a.ordernum");
        if (params != null) {
            initPageParam(queryCondition, params);
            queryCondition.andFullLike("idPath", params.get("idPath"));
            String searchInput = (String) params.get("searchInput");
            if (StringUtils.isNotEmpty(searchInput)) {
                queryCondition.andGroup()
                        .andFullLike("name", searchInput)
                        .orFullLike("code", searchInput);
            }
        }
        //String sql = "SELECT A.*,B.NAME_ AS AREA_NAME_ FROM TS_ORGANIZATION A LEFT JOIN TC_AREA B ON A.AREA_ID_=B.ID_";
        return queryPage(queryCondition);
        // return queryPage(queryCondition);
    }

    @Override
    public List<Organization> queryList(Map<String, Object> params) {
        WhereBuilder queryCondition = new WhereBuilder();
        //queryCondition.setOrderByWithAsc("ordernum");
        if (params != null) {
            queryCondition.andFullLike("idPath", params.get("idPath"));
            queryCondition.andFullLike("name", params.get("name"));
            queryCondition.andEquals("code", params.get("code"));
            queryCondition.andIn("id", (String[]) params.get("ids"));
        }
        return query(queryCondition);
    }

    @Override
    public Organization queryById(String id) {
        String sql = "SELECT A.*,B.NAME_ AS AREA_NAME_ FROM TS_ORGANIZATION A LEFT JOIN TC_AREA B ON A.AREA_ID_=B.ID_ WHERE A.ID_ = ?";
        List<Organization> list = jdbcTemplate.query(sql, new Object[]{id}, new DefaultRowMapper<Organization>(domainModelAnalysis));
        return list.isEmpty() ? null : list.get(0);
    }

    /*@Override
    public List<Organization> queryByCategory() {
        WhereBuilder queryCondition = new WhereBuilder();
        queryCondition.andEquals("category", Organization.Category.SHI_JU.getValue());
        return query(queryCondition);
    }*/

    /*@Override
    public List<Organization> queryChildrenOrg(Long id) {
        WhereBuilder queryCondition = new WhereBuilder();
        queryCondition.andEquals("category", Organization.Category.XIAN_JU.getValue());
        queryCondition.andFullLike("idPath", id);
        return query(queryCondition);
    }*/

    //根据areaId查找对应的单位组织
    @Override
    public Organization queryByAreaId(String areaId) {
        WhereBuilder queryCondition = new WhereBuilder();
        queryCondition.andEquals("areaId", areaId);
        List<Organization> list = query(queryCondition);
        if (list != null && list.size() > 0) {
            return list.get(0);
        }
        return null;
    }

    @Override
    public List<Organization> queryChildOrgList(String parentId) {
        WhereBuilder wb = new WhereBuilder();
        wb.setOrderByWithAsc("code");
        wb.andEquals("parentId", parentId);
        return query(wb);
    }
}