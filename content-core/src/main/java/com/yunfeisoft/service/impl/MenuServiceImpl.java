/**
 * MenuServiceImpl.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.dao.inter.MenuDao;
import com.yunfeisoft.model.Menu;
import com.yunfeisoft.service.inter.MenuService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: MenuServiceImpl</p>
 * <p>Description: 菜单管理service实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Service("menuService")
public class MenuServiceImpl extends BaseServiceImpl<Menu, String, MenuDao> implements MenuService {

    @DataSourceChange(slave = true)
    @Override
    public List<Menu> queryByUserId(String userId) {
        return getDao().queryByUserId(userId);
    }

    @DataSourceChange(slave = true)
    @Override
    public List<Menu> queryByRoleId(String roleId) {
        return getDao().queryByRoleId(roleId);
    }

    @DataSourceChange(slave = true)
    @Override
    public List<Menu> query(Map<String, Object> params) {
        return getDao().query(params);
    }

    @DataSourceChange(slave = true)
    @Override
    public Page<Menu> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @DataSourceChange(slave = false)
    @Override
    public int batchRemove(String[] ids) {
        return getDao().batchRemove(ids);
    }

    @DataSourceChange(slave = false)
    @Override
    public int modifyState(String[] ids, int state) {
        return getDao().modifyState(ids, state);
    }

    @Override
    @DataSourceChange(slave = false)
    public int modifyWithDrag(String id, String targetId) {
        Menu old = load(id);
        old.setParentId(targetId);
        return modify(old);
    }

    @DataSourceChange(slave = true)
    @Override
    public Boolean isDuplicateName(String id, String name) {
        return getDao().isDuplicateName(id, name);
    }

    @DataSourceChange(slave = true)
    @Override
    public Boolean isDuplicateCode(String id, String code) {
        return getDao().isDuplicateCode(id, code);
    }

    @DataSourceChange(slave = true)
    @Override
    public List<Menu> queryParentList(String id) {
        return getDao().queryParentList(id);
    }

    @DataSourceChange(slave = true)
    @Override
    public List<Menu> queryChildren(String id) {
        return getDao().queryChildren(id);
    }

}