/**
 * DataService.java
 * Created at 2017-07-13
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.inter;

import com.applet.base.BaseService;
import com.yunfeisoft.model.Data;

/**
 * <p>ClassName: DataService</p>
 * <p>Description: 通用内容管理service接口</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-13</p>
 */
public interface DataService extends BaseService<Data, String> {

    public int saveOrUpdate(String refId, String content);

    public String loadByRefId(String refId);

    public String loadByRefId(String refId, int type);
}