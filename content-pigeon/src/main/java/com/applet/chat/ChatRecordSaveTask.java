package com.applet.chat;

import com.alibaba.fastjson.JSONObject;
import com.applet.utils.SpringContextHelper;
import com.yunfeisoft.business.model.ChatRecord;
import com.yunfeisoft.business.service.inter.ChatRecordService;
import org.apache.commons.lang3.StringUtils;

/**
 * 聊天记录保存任务
 */
public class ChatRecordSaveTask implements Runnable {

    private String roomId;

    private String msg;

    public ChatRecordSaveTask(String roomId, String msg) {
        this.roomId = roomId;
        this.msg = msg;
    }

    @Override
    public void run() {
        if (StringUtils.isBlank(msg) || StringUtils.isBlank(roomId)) {
            return;
        }
        JSONObject json = JSONObject.parseObject(msg);
        JSONObject data = json.getJSONObject("msg");

        ChatRecord chatRecord = new ChatRecord();
        chatRecord.setRoomId(roomId);
        chatRecord.setUserId(data.getString("uid"));
        chatRecord.setContent(data.getString("msg"));

        ChatRecordService chatRecordService = SpringContextHelper.getBean(ChatRecordService.class);
        chatRecordService.save(chatRecord);
    }
}
