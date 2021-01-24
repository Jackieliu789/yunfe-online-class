package com.yunfeisoft.business.model;

import com.applet.base.ServiceModel;
import com.applet.sql.record.TransientField;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;

/**
 * ClassName: MeetingUser
 * Description: 会议-用户表
 *
 * @Author: Jackie liu
 * Date: 2020-03-29
 */
@Entity
@Table(name = "MEETING_USER")
public class MeetingUser extends ServiceModel implements Serializable {

    /**
     * Field serialVersionUID: 序列号
     */
    private static final long serialVersionUID = 1L;

    /**
     * 会议id
     */
    @Column
    private String meetingId;

    /**
     * 用户id
     */
    @Column
    private String userId;

    @TransientField
    private String userName;


    public String getMeetingId() {
        return meetingId;
    }

    public void setMeetingId(String meetingId) {
        this.meetingId = meetingId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
}