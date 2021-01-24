/**
 * AttachmentDao.java
 * Created at 2017-07-13
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.dao.inter;

import com.applet.base.BaseDao;
import com.yunfeisoft.model.Attachment;

import java.util.List;

/**
 * <p>ClassName: AttachmentDao</p>
 * <p>Description: 通用附件管理Dao</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-13</p>
 */
public interface AttachmentDao extends BaseDao<Attachment, String> {

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
    public int deleteRefId(String[] refIdArr);


    /**
     * 批量更新外键
     *
     * @param attachmentIds 附件id数组
     * @param refId         外键id
     * @param category      附件类型
     * @return
     */
    //public int updateRefId(long[] attachmentIds, Long refId, int category);

    /**
     * 批量更新外键
     *
     * @param attachmentIds 附件id数组
     * @param refId         外键id
     * @param category      附件类型
     * @param isDelete      是否清空refId的引用
     * @return
     */
    public int updateRefId(String[] attachmentIds, String refId, int category, boolean isDelete);

    /**
     * 批量更新外键
     *
     * @param attachmentIds 附件id数组
     * @param refId         外键id
     * @return
     */
    public int updateRefId(String[] attachmentIds, String refId);

    /**
     * 批量更新外键
     *
     * @param attachmentIds 附件id数组
     * @param refId         外键id
     * @param category      附件类型
     * @return
     */
    //public int updateRefId(Long[] attachmentIds, Long refId, int category);

    /**
     * 根据外键id和附件类型查询附件列表
     *
     * @param refId
     * @param category
     * @return
     */
    public List<Attachment> queryByRefIdAndCategory(String refId, int category);

}