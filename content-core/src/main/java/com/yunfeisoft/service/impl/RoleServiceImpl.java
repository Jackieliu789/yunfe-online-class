/**
 * RoleServiceImpl.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.dao.inter.RoleDao;
import com.yunfeisoft.model.Role;
import com.yunfeisoft.service.inter.RoleService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: RoleServiceImpl</p>
 * <p>Description: 角色管理service实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Service("roleService")
public class RoleServiceImpl extends BaseServiceImpl<Role, String, RoleDao> implements RoleService {

    @DataSourceChange(slave = true)
    @Override
    public List<Role> queryByUserId(String userId) {
        return getDao().queryByUserId(userId);
    }

    @DataSourceChange(slave = true)
    @Override
    public List<Role> query(Map<String, Object> params) {
        return getDao().query(params);
    }

    @DataSourceChange(slave = true)
    @Override
    public Page<Role> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @DataSourceChange(slave = false)
	@Override
	public int batchRemove(String[] ids) {
		 return getDao().batchRemove(ids);
 	}

    @DataSourceChange(slave = false)
	@Override
	public int modifyState(String[] ids, int state) {
 	 return getDao().modifyState(ids, state);
	}

    @DataSourceChange(slave = true)
	@Override
	public Boolean isDuplicateName(String id, String name) {
		 return getDao().isDuplicateName(id, name);
	}
}