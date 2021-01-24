package com.yunfeisoft.business.dao.inter;

import com.applet.base.BaseDao;
import com.applet.utils.Page;
import com.yunfeisoft.business.model.ChatRecord;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ChatRecordDao
 * Description: 聊天记录Dao
 * Author: Jackie liu
 * Date: 2020-05-26
 */
public interface ChatRecordDao extends BaseDao<ChatRecord, String> {

    public Page<ChatRecord> queryPage(Map<String, Object> params);

    public List<ChatRecord> queryList(Map<String, Object> params);
}