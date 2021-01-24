/**
 * RoleMenuServiceImpl.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.KeyUtils;
import com.yunfeisoft.dao.inter.RoleMenuDao;
import com.yunfeisoft.model.RoleMenu;
import com.yunfeisoft.service.inter.RoleMenuService;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * <p>ClassName: RoleMenuServiceImpl</p>
 * <p>Description: 角色菜单service实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Service("roleMenuService")
public class RoleMenuServiceImpl extends BaseServiceImpl<RoleMenu, String, RoleMenuDao> implements RoleMenuService {

    @DataSourceChange(slave = false)
    @Override
    public int save(String roleId, String[] menuIds) {
        if (roleId == null) {
            return 0;
        }
        getDao().deleteByRoleId(roleId);

        List<RoleMenu> list = new ArrayList<RoleMenu>();
        for (String menuId : menuIds) {
            if (menuId == null) {
                continue;
            }
            RoleMenu rm = new RoleMenu();
            rm.setId(KeyUtils.getKey());
            rm.setRoleId(roleId);
            rm.setMenuId(menuId);
            list.add(rm);
        }
        return batchSave(list);
    }
}