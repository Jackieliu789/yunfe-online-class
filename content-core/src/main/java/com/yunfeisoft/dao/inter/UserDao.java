/**
 * UserDao.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.inter;

import com.applet.base.BaseDao;
import com.applet.utils.Page;
import com.yunfeisoft.model.User;

import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: UserDao</p>
 * <p>Description: 用户管理Dao</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
public interface UserDao extends BaseDao<User, String> {

    public List<User> queryByAccount(String account);

    public List<User> queryByOpenId(String openId);

    public List<User> queryByPhoneOrIdCard(String phoneOrIdCard);

    public List<User> queryList(Map<String, Object> params);

    public List<User> queryByRoleId(String roleId);

    public boolean isDuplicateName(String id, String orgId, String name);

    public boolean isDuplicatePoliceNo(String id, String policeNo);

    public boolean isDuplicateIdCard(String id, String idCard);

    public Page<User> queryPage(Map<String, Object> params);

    public int modifyState(String[] ids, int state);

    public List<User> queryByOrgId(String orgId);

    public User queryById(String id);

    public int modifyPass(String[] ids, String pass);

    /**
     * 查询当前用户未添加的好友
     *
     * @param userId
     * @return
     */
    public List<User> queryStranger(String userId);
}