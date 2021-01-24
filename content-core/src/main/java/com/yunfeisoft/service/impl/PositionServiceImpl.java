/**
 * PositionServiceImpl.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.dao.inter.PositionDao;
import com.yunfeisoft.model.Position;
import com.yunfeisoft.service.inter.PositionService;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * <p>ClassName: PositionServiceImpl</p>
 * <p>Description: 职务管理service实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Service("positionService")
public class PositionServiceImpl extends BaseServiceImpl<Position, String, PositionDao> implements PositionService {

    @Override
    @DataSourceChange(slave = true)
    public Page<Position> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @Override
    @DataSourceChange(slave = false)
    public int batchRemove(String[] ids) {
        return getDao().batchRemove(ids);
    }

    @Override
    @DataSourceChange(slave = false)
    public int modifyState(String[] ids, int state) {
        return getDao().modifyState(ids, state);
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

}