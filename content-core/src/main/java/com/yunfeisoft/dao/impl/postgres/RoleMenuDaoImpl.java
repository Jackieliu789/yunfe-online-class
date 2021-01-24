/**
 * RoleMenuDaoImpl.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.impl.postgres;

import com.applet.base.BaseDaoImpl;
import com.applet.sql.builder.WhereBuilder;
import com.yunfeisoft.dao.inter.RoleMenuDao;
import com.yunfeisoft.model.RoleMenu;
import org.springframework.stereotype.Repository;

/**
 * <p>ClassName: RoleMenuDaoImpl</p>
 * <p>Description: 角色菜单Dao实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Repository
public class RoleMenuDaoImpl extends BaseDaoImpl<RoleMenu, String> implements RoleMenuDao {

    @Override
    public int deleteByRoleId(String roleId) {
        if (roleId == null) {
            return 0;
        }
        WhereBuilder wb = new WhereBuilder();
        wb.andEquals("roleId", roleId);
        return deleteByCondition(wb);
    }
}