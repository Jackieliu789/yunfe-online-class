/**
 * RoleUserDao.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.inter;

import com.applet.base.BaseDao;
import com.yunfeisoft.model.RoleUser;

/**
 * <p>ClassName: RoleUserDao</p>
 * <p>Description: 用户角色关系Dao</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
public interface RoleUserDao extends BaseDao<RoleUser, String> {

    public int deleteByUserId(String userId);

    public int delete(String userId, String roleId);
}