package com.yunfeisoft.business.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.ChatRecordDao;
import com.yunfeisoft.business.model.ChatRecord;
import com.yunfeisoft.business.service.inter.ChatRecordService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ChatRecordServiceImpl
 * Description: 聊天记录service实现
 * Author: Jackie liu
 * Date: 2020-05-26
 */
@Service("chatRecordService")
public class ChatRecordServiceImpl extends BaseServiceImpl<ChatRecord, String, ChatRecordDao> implements ChatRecordService {

    @Override
    @DataSourceChange(slave = true)
    public Page<ChatRecord> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @Override
    public List<ChatRecord> queryList(Map<String, Object> params) {
        return getDao().queryList(params);
    }
}