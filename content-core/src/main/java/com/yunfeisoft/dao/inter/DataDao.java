/**
 * DataDao.java
 * Created at 2017-07-13
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.inter;

import com.applet.base.BaseDao;
import com.yunfeisoft.model.Data;

import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: DataDao</p>
 * <p>Description: 通用内容管理Dao</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-13</p>
 */
public interface DataDao extends BaseDao<Data, String> {

    public int deleteByRefId(String refId);

    public int deleteByRefId(String refId, int type);

    public List<Data> query(Map<String, Object> params);

    public int saveOrUpdate(String refId, String content);

    public String loadByRefId(String refId);

    public int saveOrUpdate(String refId, String content, int type);

    public String loadByRefId(String refId, int type);
}