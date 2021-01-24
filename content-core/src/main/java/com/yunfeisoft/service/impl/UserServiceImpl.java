/**
 * UserServiceImpl.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.dao.inter.UserDao;
import com.yunfeisoft.model.User;
import com.yunfeisoft.service.inter.UserService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: UserServiceImpl</p>
 * <p>Description: 用户管理service实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Service("userService")
public class UserServiceImpl extends BaseServiceImpl<User, String, UserDao> implements UserService {

    @DataSourceChange(slave = false)
    @Override
    public List<User> queryByAccount(String account) {
        return getDao().queryByAccount(account);
    }

    @Override
    public List<User> queryByOpenId(String openId) {
        return getDao().queryByOpenId(openId);
    }

    @DataSourceChange(slave = true)
    @Override
    public List<User> queryByPhoneOrIdCard(String phoneOrIdCard) {
        return getDao().queryByPhoneOrIdCard(phoneOrIdCard);
    }

    @Override
    public List<User> queryList(Map<String, Object> params) {
        return getDao().queryList(params);
    }

    @DataSourceChange(slave = false)
    @Override
    public List<User> queryByRoleId(String roleId) {
        return getDao().queryByRoleId(roleId);
    }

    @DataSourceChange(slave = false)
    @Override
    public boolean isDuplicateName(String id, String orgId, String name) {
        return getDao().isDuplicateName(id, orgId, name);
    }

    @DataSourceChange(slave = false)
    @Override
    public boolean isDuplicatePoliceNo(String id, String policeNo) {
        return getDao().isDuplicatePoliceNo(id, policeNo);
    }

    @DataSourceChange(slave = false)
    @Override
    public boolean isDuplicateIdCard(String id, String idCard) {
        return getDao().isDuplicateIdCard(id, idCard);
    }

    @DataSourceChange(slave = false)
    @Override
    public Page<User> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @DataSourceChange(slave = true)
    @Override
    public int modifyState(String[] ids, int state) {
        return getDao().modifyState(ids, state);
    }

    @DataSourceChange(slave = true)
    @Override
    public List<User> queryByOrgId(String orgId) {
        return getDao().queryByOrgId(orgId);
    }

    @Override
    public User queryById(String id) {
        return getDao().queryById(id);
    }

    @Override
    public int modifyPass(String[] ids, String pass) {
        return getDao().modifyPass(ids, pass);
    }

}