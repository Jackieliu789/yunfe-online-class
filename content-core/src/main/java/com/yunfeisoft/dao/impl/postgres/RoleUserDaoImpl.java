/**
 * RoleUserDaoImpl.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.impl.postgres;

import com.applet.base.BaseDaoImpl;
import com.applet.sql.builder.WhereBuilder;
import com.yunfeisoft.dao.inter.RoleUserDao;
import com.yunfeisoft.model.RoleUser;
import org.springframework.stereotype.Repository;

/**
 * <p>ClassName: RoleUserDaoImpl</p>
 * <p>Description: 用户角色关系Dao实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Repository
public class RoleUserDaoImpl extends BaseDaoImpl<RoleUser, String> implements RoleUserDao {

    @Override
    public int deleteByUserId(String userId) {
        if (userId == null) {
            return 0;
        }

        WhereBuilder wb = new WhereBuilder();
        wb.andEquals("userId", userId);
        return deleteByCondition(wb);
    }

    @Override
    public int delete(String userId, String roleId) {
        if (userId == null || roleId == null) {
            return 0;
        }
        WhereBuilder wb = new WhereBuilder();
        wb.andEquals("userId", userId);
        wb.andEquals("roleId", roleId);
        return deleteByCondition(wb);
    }
}