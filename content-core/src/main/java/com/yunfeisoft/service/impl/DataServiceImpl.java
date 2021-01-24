/**
 * DataServiceImpl.java
 * Created at 2017-07-13
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.yunfeisoft.dao.inter.DataDao;
import com.yunfeisoft.model.Data;
import com.yunfeisoft.service.inter.DataService;
import org.springframework.stereotype.Service;

/**
 * <p>ClassName: DataServiceImpl</p>
 * <p>Description: 通用内容管理service实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-13</p>
 */
@Service("dataService")
public class DataServiceImpl extends BaseServiceImpl<Data, String, DataDao> implements DataService {

    @DataSourceChange(slave = false)
    @Override
    public int saveOrUpdate(String refId, String content) {
        /*if (StringUtils.isEmpty(refId) || StringUtils.isEmpty(content)) {
            return 0;
        }

        getDao().deleteByRefId(refId);

        final int LENGTH = 255;
        final int CONTENT_LENGTH = content.length();
        List<Data> list = new ArrayList<Data>();
        int size = (int) Math.ceil(CONTENT_LENGTH / Double.valueOf(LENGTH));
        for (int i = 0; i < size; i ++) {
            Data data = new Data();
            data.setId(KeyUtils.getKey());
            data.setNum(i);
            data.setRefId(refId);

            if (i == size - 1) {
                data.setContent(content.substring(i * LENGTH, CONTENT_LENGTH));
            } else {
                data.setContent(content.substring(i * LENGTH, (i + 1) * LENGTH));
            }
            list.add(data);
        }

        return getDao().batchInsert(list);*/
        return getDao().saveOrUpdate(refId, content);
    }

    @DataSourceChange(slave = true)
    @Override
    public String loadByRefId(String refId) {
        /*Map<String, Object> param = new HashMap<String, Object>();
        param.put("refId", refId);
        List<Data> list = getDao().query(param);
        StringBuilder sb = new StringBuilder();
        for (Data data : list) {
            sb.append(data.getContent());
        }
        return sb.toString();*/
        return getDao().loadByRefId(refId);
    }

    @Override
    public String loadByRefId(String refId, int type) {
        return getDao().loadByRefId(refId, type);
    }
}