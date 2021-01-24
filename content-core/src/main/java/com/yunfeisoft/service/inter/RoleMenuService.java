/**
 * RoleMenuService.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.inter;

import com.applet.base.BaseService;
import com.yunfeisoft.model.RoleMenu;

/**
 * <p>ClassName: RoleMenuService</p>
 * <p>Description: 角色菜单service接口</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
public interface RoleMenuService extends BaseService<RoleMenu, String> {

    public int save(String roleId, String[] menuIds);

}