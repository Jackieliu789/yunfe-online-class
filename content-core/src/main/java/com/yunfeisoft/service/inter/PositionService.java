/**
 * PositionService.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.inter;

import com.applet.base.BaseService;
import com.applet.utils.Page;
import com.yunfeisoft.model.Position;

import java.util.Map;

/**
 * <p>ClassName: PositionService</p>
 * <p>Description: 职务管理service接口</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
public interface PositionService extends BaseService<Position, String> {

    public Page<Position> queryPage(Map<String, Object> params);

    public int batchRemove(String[] ids);

    public int modifyState(String[] ids, int state);

    public Boolean isDuplicateName(String id, String name);

    public Boolean isDuplicateCode(String id, String code);

}