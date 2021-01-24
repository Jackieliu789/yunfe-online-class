/**
 * MenuService.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.inter;

import com.applet.base.BaseService;
import com.applet.utils.Page;
import com.yunfeisoft.model.Menu;

import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: MenuService</p>
 * <p>Description: 菜单管理service接口</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
public interface MenuService extends BaseService<Menu, String> {

    public List<Menu> queryByUserId(String userId);

    public List<Menu> queryByRoleId(String roleId);

    public List<Menu> query(Map<String, Object> params);

    public Page<Menu> queryPage(Map<String, Object> params);

    public int batchRemove(String[] ids);

    public int modifyState(String[] ids, int state);

    public Boolean isDuplicateName(String id, String name);

    public Boolean isDuplicateCode(String id, String code);

    /**
     * 查询所有的父父节点，包括自己
     *
     * @param id
     * @return
     */
    public List<Menu> queryParentList(String id);

    /**
     * 查询所有的子子节点，包括自己
     *
     * @param id
     * @return
     */
    public List<Menu> queryChildren(String id);

    /**
     * 拖拽变换组织节点从属
     *
     * @param id       要变换的节点id
     * @param targetId 变换到目标节点id
     * @return
     */
    public int modifyWithDrag(String id, String targetId);
}