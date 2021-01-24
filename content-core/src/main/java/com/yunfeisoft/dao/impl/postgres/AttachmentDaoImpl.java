/**
 * AttachmentDaoImpl.java
 * Created at 2017-07-13
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.impl.postgres;

import com.applet.base.BaseDaoImpl;
import com.applet.sql.builder.WhereBuilder;
import com.applet.utils.Constants;
import com.yunfeisoft.dao.inter.AttachmentDao;
import com.yunfeisoft.model.Attachment;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * <p>ClassName: AttachmentDaoImpl</p>
 * <p>Description: 通用附件管理Dao实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-13</p>
 */
@Repository
public class AttachmentDaoImpl extends BaseDaoImpl<Attachment, String> implements AttachmentDao {

    @Override
    public List<Attachment> queryByRefId(String refId) {
        if (refId == null) {
            return new ArrayList<>();
        }
        WhereBuilder queryCondition = new WhereBuilder();
        queryCondition.andEquals("refId", refId);
        return query(queryCondition);
    }

    @Override
    public int deleteRefId(final String[] refIdArr) {
        if (refIdArr == null || refIdArr.length == 0) {
            return 0;
        }
        String sql = String.format("UPDATE %s SET REF_ID_ = ? WHERE REF_ID_ = ?", domainModelAnalysis.getTableName());
        return jdbcTemplate.batchUpdate(sql, new BatchPreparedStatementSetter() {
            @Override
            public void setValues(PreparedStatement preparedStatement, int i) throws SQLException {
                preparedStatement.setString(1, Constants.DEFAULT_VALUE);
                preparedStatement.setString(2, refIdArr[i]);
            }

            @Override
            public int getBatchSize() {
                return refIdArr.length;
            }
        }).length;
    }

    /*@Override
    public int updateRefId(final long[] attachmentIds, final Long refId, final int category) {
        return updateRefId(attachmentIds, refId, category, true);
    }*/

    @Override
    public int updateRefId(final String[] attachmentIds, final String refId, final int category, boolean isDelete) {
        //清空关联附件
        if (refId != null && isDelete) {
            deleteRefId(new String[]{refId});
        }
        if (attachmentIds == null || attachmentIds.length == 0
                || refId == null) {
            return 0;
        }
        String sql = String.format("UPDATE %s SET REF_ID_ = ?, CATEGORY_ = ? WHERE ID_ = ?", domainModelAnalysis.getTableName());
        return jdbcTemplate.batchUpdate(sql, new BatchPreparedStatementSetter() {
            @Override
            public void setValues(PreparedStatement preparedStatement, int i) throws SQLException {
                preparedStatement.setString(1, refId);
                preparedStatement.setInt(2, category);
                preparedStatement.setString(3, attachmentIds[i]);
            }

            @Override
            public int getBatchSize() {
                return attachmentIds.length;
            }
        }).length;
    }

    @Override
    public int updateRefId(String[] attachmentIds, String refId) {
        return updateRefId(attachmentIds, refId, 0, true);
    }

    /*@Override
    public int updateRefId(Long[] attachmentIds, Long refId, int category) {
        if (refId == null) {
            return 0;
        }
        long[] ids = null;
        if (attachmentIds != null) {
            ids = new long[attachmentIds.length];
            for (int i = 0; i < attachmentIds.length; i ++) {
                ids[i] = attachmentIds[i];
            }
        }

        return updateRefId(ids, refId, category);
    }*/

    @Override
	public List<Attachment> queryByRefIdAndCategory(String refId, int category) {
		if (refId == null) {
            return new ArrayList<>();
        }
        WhereBuilder queryCondition = new WhereBuilder();
        queryCondition.andEquals("refId", refId);
        queryCondition.andEquals("category", category);
        return query(queryCondition);
	}
}