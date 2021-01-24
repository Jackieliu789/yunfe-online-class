/**
 * DataDaoImpl.java
 * Created at 2017-07-13
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.impl.postgres;

import com.applet.base.BaseDaoImpl;
import com.applet.sql.builder.WhereBuilder;
import com.applet.utils.KeyUtils;
import com.yunfeisoft.dao.inter.DataDao;
import com.yunfeisoft.model.Data;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: DataDaoImpl</p>
 * <p>Description: 通用内容管理Dao实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-13</p>
 */
@Repository
public class DataDaoImpl extends BaseDaoImpl<Data, String> implements DataDao {

    @Override
    public int deleteByRefId(String refId) {
        if (refId == null) {
            return 0;
        }
        WhereBuilder qc = new WhereBuilder();
        qc.andEquals("refId", refId);
        return deleteByCondition(qc);
    }

    @Override
    public int deleteByRefId(String refId, int type) {
        if (refId == null) {
            return 0;
        }
        WhereBuilder qc = new WhereBuilder();
        qc.andEquals("refId", refId);
        qc.andEquals("type", type);
        return deleteByCondition(qc);
    }

    @Override
    public List<Data> query(Map<String, Object> params) {
        WhereBuilder qc = new WhereBuilder();
        qc.setOrderByWithAsc("num");
        if (params != null) {
            qc.andEquals("refId", params.get("refId"));
            qc.andEquals("type", params.get("type"));
        }
        return query(qc);
    }

    @Override
    public int saveOrUpdate(String refId, String content) {
        if (refId == null) {
            return 0;
        }
        deleteByRefId(refId);

        if (StringUtils.isEmpty(content)) {
            return 0;
        }

        final int LENGTH = 255;
        final int CONTENT_LENGTH = content.length();
        List<Data> list = new ArrayList<Data>();
        int size = (int) Math.ceil(CONTENT_LENGTH / Double.valueOf(LENGTH));
        for (int i = 0; i < size; i++) {
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

        return batchInsert(list);
    }

    @Override
    public String loadByRefId(String refId) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("refId", refId);
        List<Data> list = query(param);
        StringBuilder sb = new StringBuilder();
        for (Data data : list) {
            sb.append(data.getContent());
        }
        return sb.toString();
    }

    @Override
    public int saveOrUpdate(String refId, String content, int type) {
        if (refId == null) {
            return 0;
        }
        deleteByRefId(refId, type);

        if (StringUtils.isEmpty(content)) {
            return 0;
        }

        final int LENGTH = 255;
        final int CONTENT_LENGTH = content.length();
        List<Data> list = new ArrayList<Data>();
        int size = (int) Math.ceil(CONTENT_LENGTH / Double.valueOf(LENGTH));
        for (int i = 0; i < size; i++) {
            Data data = new Data();
            data.setId(KeyUtils.getKey());
            data.setNum(i);
            data.setType(type);
            data.setRefId(refId);

            if (i == size - 1) {
                data.setContent(content.substring(i * LENGTH, CONTENT_LENGTH));
            } else {
                data.setContent(content.substring(i * LENGTH, (i + 1) * LENGTH));
            }
            list.add(data);
        }

        return batchInsert(list);
    }

    @Override
    public String loadByRefId(String refId, int type) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("refId", refId);
        param.put("type", type);
        List<Data> list = query(param);
        StringBuilder sb = new StringBuilder();
        for (Data data : list) {
            sb.append(data.getContent());
        }
        return sb.toString();
    }
}