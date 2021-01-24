/**
 * RoleService.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.inter;

import com.applet.base.BaseService;
import com.applet.utils.Page;
import com.yunfeisoft.model.Role;

import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: RoleService</p>
 * <p>Description: 角色管理service接口</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
public interface RoleService extends BaseService<Role, String> {

    public List<Role> queryByUserId(String userId);

    public List<Role> query(Map<String, Object> params);

    public Page<Role> queryPage(Map<String, Object> params);

    public int batchRemove(String[] ids);

    public int modifyState(String[] ids, int state);

    public Boolean isDuplicateName(String id, String name);
}