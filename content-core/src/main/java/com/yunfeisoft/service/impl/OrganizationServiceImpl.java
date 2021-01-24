/**
 * OrganizationServiceImpl.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Constants;
import com.applet.utils.Page;
import com.yunfeisoft.dao.inter.OrganizationDao;
import com.yunfeisoft.model.Organization;
import com.yunfeisoft.service.inter.OrganizationService;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: OrganizationServiceImpl</p>
 * <p>Description: 组织机构service实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Service("organizationService")
public class OrganizationServiceImpl extends BaseServiceImpl<Organization, String, OrganizationDao> implements OrganizationService {

    @DataSourceChange(slave = false)
    @Override
    public boolean isDuplicateCode(String id, String code) {
        return getDao().isDuplicateCode(id, code);
    }

    @DataSourceChange(slave = false)
    @Override
    public boolean isDuplicateName(String id, String name) {
        return getDao().isDuplicateName(id, name);
    }

    @DataSourceChange(slave = false)
    @Override
    public Page<Organization> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @DataSourceChange(slave = false)
    @Override
    public List<Organization> queryList(Map<String, Object> params) {
        return getDao().queryList(params);
    }

    @DataSourceChange(slave = true)
    @Override
    public int modifyWithDrag(String id, String targetId) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("idPath", id);
        List<Organization> childList = getDao().queryList(params);

        //设置idPath,codePath
        Organization old = load(id);
        Organization target = load(targetId);

        String oldPath = old.getIdPath();
        String oldCode = old.getCodePath();

        old.setIdPath(target.getIdPath() + "/" + id);
        old.setParentId(targetId);
        old.setCodePath(target.getCodePath() + "/" + old.getCode());

        String newPath = old.getIdPath();
        String newCode = old.getCodePath();

        for (Organization child : childList) {
            if (child.getId().equals(id)) {
                continue;
            }

            child.setIdPath(child.getIdPath().replaceFirst(oldPath, newPath));
            child.setCodePath(child.getCodePath().replaceFirst(oldCode, newCode));
            getDao().update(child);
        }

        return getDao().update(old);
    }

    @DataSourceChange(slave = true)
    @Override
    public int save(Organization organization) {
        if (Constants.ROOT.equals(organization.getParentId())) {
            organization.setIdPath(String.valueOf(organization.getId()));
            organization.setCodePath(organization.getCode());
        } else {
            Organization parentOrg = load(organization.getParentId());
            if (parentOrg != null) {
                organization.setIdPath(parentOrg.getIdPath() + "/" + organization.getId());
                organization.setCodePath(parentOrg.getCodePath() + "/" + organization.getCode());
            }
        }
        return super.save(organization);
    }

    @DataSourceChange(slave = true)
    @Override
    public int modify(Organization organization) {
        return super.modify(organization);
    }
    
    /*@DataSourceChange(slave = true)
	@Override
	public List<Organization> queryByCategory() {
		return getDao().queryByCategory();
	}*/
    
    @DataSourceChange(slave = true)
	@Override
	public Organization queryById(String id) {
		return getDao().queryById(id);
	}
    
    /*@DataSourceChange(slave = true)
	@Override
	public List<Organization> queryChildrenOrg(Long id) {
		return getDao().queryChildrenOrg(id);
	}*/
    
    @DataSourceChange(slave = true)
	@Override
	public Organization queryByAreaId(String areaId) {
		return getDao().queryByAreaId(areaId);
	}
    
    @DataSourceChange(slave = true)
	@Override
    public List<Organization> queryChildOrgList(String parentId) {
    	return getDao().queryChildOrgList(parentId);
    }
}