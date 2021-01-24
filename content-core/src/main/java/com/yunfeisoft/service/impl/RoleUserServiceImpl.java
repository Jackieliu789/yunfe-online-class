/**
 * RoleUserServiceImpl.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.KeyUtils;
import com.yunfeisoft.dao.inter.RoleUserDao;
import com.yunfeisoft.model.RoleUser;
import com.yunfeisoft.service.inter.RoleUserService;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * <p>ClassName: RoleUserServiceImpl</p>
 * <p>Description: 用户角色关系service实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Service("roleUserService")
public class RoleUserServiceImpl extends BaseServiceImpl<RoleUser, String, RoleUserDao> implements RoleUserService {

    @DataSourceChange(slave = false)
    @Override
    public int save(String userId, String[] roleIds) {
        List<RoleUser> list = new ArrayList<RoleUser>();
        for (String roleId : roleIds) {
            if (roleId == null) {
                continue;
            }
            RoleUser ru = new RoleUser();
            ru.setId(KeyUtils.getKey());
            ru.setRoleId(roleId);
            ru.setUserId(userId);
            list.add(ru);
        }
        getDao().deleteByUserId(userId);
        return batchSave(list);
    }

    @DataSourceChange(slave = false)
    @Override
    public int remove(String userId, String roleId) {
        return getDao().delete(userId, roleId);
    }
}