/**
 * OrganizationService.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.inter;

import com.applet.base.BaseService;
import com.applet.utils.Page;
import com.yunfeisoft.model.Organization;

import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: OrganizationService</p>
 * <p>Description: 组织机构service接口</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
public interface OrganizationService extends BaseService<Organization, String> {

    public boolean isDuplicateCode(String id, String code);

    public boolean isDuplicateName(String id, String name);

    public Page<Organization> queryPage(Map<String, Object> params);

    public List<Organization> queryList(Map<String, Object> params);

    public Organization queryById(String id);

    /**
     * 拖拽变换组织节点从属
     *
     * @param id       要变换的节点id
     * @param targetId 变换到目标节点id
     * @return
     */
    public int modifyWithDrag(String id, String targetId);

    //public List<Organization> queryByCategory();

    //public List<Organization> queryChildrenOrg(String id);

    public Organization queryByAreaId(String areaId);

    public List<Organization> queryChildOrgList(String parentId);
}