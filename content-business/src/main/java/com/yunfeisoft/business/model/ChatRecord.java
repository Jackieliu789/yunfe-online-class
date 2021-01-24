package com.yunfeisoft.business.model;

import com.applet.base.ServiceModel;
import com.applet.sql.record.TransientField;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;

/**
 * ClassName: ChatRecord
 * Description: 聊天记录
 *
 * @Author: Jackie liu
 * Date: 2020-05-26
 */
@Entity
@Table(name = "TT_CHAT_RECORD")
public class ChatRecord extends ServiceModel implements Serializable {

    /**
     * Field serialVersionUID: 序列号
     */
    private static final long serialVersionUID = 1L;

    /**
     * 直播间id
     */
    @Column
    private String roomId;

    /**
     * 用户id
     */
    @Column
    private String userId;

    /**
     * 提问内容
     */
    @Column
    private String content;

    @TransientField
    private String userName;

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
}