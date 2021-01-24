/**
 * OrganizationDao.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.inter;

import com.applet.base.BaseDao;
import com.applet.utils.Page;
import com.yunfeisoft.model.Organization;

import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: OrganizationDao</p>
 * <p>Description: 组织机构Dao</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
public interface OrganizationDao extends BaseDao<Organization, String> {

    public boolean isDuplicateCode(String id, String code);

    public boolean isDuplicateName(String id, String name);

    public Page<Organization> queryPage(Map<String, Object> params);

    public List<Organization> queryList(Map<String, Object> params);

    //public List<Organization> queryByCategory();

    //public List<Organization> queryChildrenOrg(Long id);

    public Organization queryById(String id);

    public Organization queryByAreaId(String areaId);

    public List<Organization> queryChildOrgList(String parentId);
}