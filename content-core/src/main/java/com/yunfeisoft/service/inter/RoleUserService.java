/**
 * RoleUserService.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.inter;

import com.applet.base.BaseService;
import com.yunfeisoft.model.RoleUser;

/**
 * <p>ClassName: RoleUserService</p>
 * <p>Description: 用户角色关系service接口</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
public interface RoleUserService extends BaseService<RoleUser, String> {

    public int save(String userId, String[] roleIds);

    public int remove(String userId, String roleId);
}