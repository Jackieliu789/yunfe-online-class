/**
 * AttachmentServiceImpl.java
 * Created at 2017-07-13
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.yunfeisoft.dao.inter.AttachmentDao;
import com.yunfeisoft.model.Attachment;
import com.yunfeisoft.service.inter.AttachmentService;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>ClassName: AttachmentServiceImpl</p>
 * <p>Description: 通用附件管理service实现</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-13</p>
 */
@Service("attachmentService")
public class AttachmentServiceImpl extends BaseServiceImpl<Attachment, String, AttachmentDao> implements AttachmentService {

    @DataSourceChange(slave = true)
    @Override
    public List<Attachment> queryByRefId(String refId) {
        return getDao().queryByRefId(refId);
    }

    @DataSourceChange(slave = false)
    @Override
    public int removeRefId(String[] refIdArr) {
        return getDao().deleteRefId(refIdArr);
    }

    @DataSourceChange(slave = false)
    @Override
    public int modifyRefId(String[] attachmentIds, String refId) {
        return modifyRefId(attachmentIds, refId, 0, true);
    }

    @DataSourceChange(slave = false)
    @Override
    public int modifyRefId(String[] attachmentIds, String refId, int category, boolean isDelete) {
        if (refId == null) {
            return 0;
        }

        getDao().updateRefId(attachmentIds, refId, category, isDelete);
        return attachmentIds.length > 0 ? attachmentIds.length : 1;
    }
    
    @DataSourceChange(slave = true)
	@Override
	public List<Attachment> queryByRefIdAndCategory(String refId, int category) {
		return getDao().queryByRefIdAndCategory(refId, category);
	}
}