/**
 * AttachmentService.java
 * Created at 2017-07-13
 * Created by Jackie liu
 * Copyright (C) 2014 , All rights reserved.
 */
package com.yunfeisoft.service.inter;


import com.applet.base.BaseService;
import com.yunfeisoft.model.Attachment;

import java.util.List;

/**
 * <p>ClassName: AttachmentService</p>
 * <p>Description: 通用附件管理service接口</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-13</p>
 */
public interface AttachmentService extends BaseService<Attachment, String> {

    /**
     * <p>Description: 根据外键id查询附件信息</p>
     *
     * @param refId 外键
     * @return response
     */
    public List<Attachment> queryByRefId(String refId);

    /**
     * <p>Description: 批量删除附件外键</p>
     *
     * @param refIdArr 外键id数组
     */
    public int removeRefId(String[] refIdArr);

    /**
     * 更新附件外键
     *
     * @param attachmentIds 附件id数组
     * @param refId         外键
     * @return
     */
    public int modifyRefId(String[] attachmentIds, String refId);

    /**
     * 更新附件外键以及附件类别
     *
     * @param attachmentIds 附件id数组
     * @param refId         外键
     * @param category      类别
     * @param isDelete      是否删除外键id
     * @return
     */
    public int modifyRefId(String[] attachmentIds, String refId, int category, boolean isDelete);

    /**
     * 根据外键id和category查询附件信息
     *
     * @param refId
     * @param category
     * @return
     */
    public List<Attachment> queryByRefIdAndCategory(String refId, int category);

}