package com.yunfeisoft.business.service.inter;

import com.applet.base.BaseService;
import com.yunfeisoft.business.model.ChatRecord;
import com.applet.utils.Page;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ChatRecordService
 * Description: 聊天记录service接口
 * Author: Jackie liu
 * Date: 2020-05-26
 */
public interface ChatRecordService extends BaseService<ChatRecord, String> {

    public Page<ChatRecord> queryPage(Map<String, Object> params);

    public List<ChatRecord> queryList(Map<String, Object> params);
}