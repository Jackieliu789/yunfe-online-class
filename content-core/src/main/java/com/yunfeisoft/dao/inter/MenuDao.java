/**
 * MenuDao.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.inter;

import com.applet.base.BaseDao;
import com.applet.utils.Page;
import com.yunfeisoft.model.Menu;

import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: MenuDao</p>
 * <p>Description: 菜单管理Dao</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
public interface MenuDao extends BaseDao<Menu, String> {

    public List<Menu> queryByUserId(String userId);

    public List<Menu> queryByRoleId(String roleId);

    public List<Menu> query(Map<String, Object> params);

    public Page<Menu> queryPage(Map<String, Object> params);

    public int batchRemove(String[] ids);

    public int modifyState(final String[] ids, final int state);

    public Boolean isDuplicateName(String id, String name);

    public Boolean isDuplicateCode(String id, String code);

    public List<Menu> queryParentList(String id);

    public List<Menu> queryChildren(String id);
}