/**
 * RoleMenuDao.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.inter;

import com.applet.base.BaseDao;
import com.yunfeisoft.model.RoleMenu;

/**
 * <p>ClassName: RoleMenuDao</p>
 * <p>Description: 角色菜单Dao</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
public interface RoleMenuDao extends BaseDao<RoleMenu, String> {

    public int deleteByRoleId(String roleId);
}