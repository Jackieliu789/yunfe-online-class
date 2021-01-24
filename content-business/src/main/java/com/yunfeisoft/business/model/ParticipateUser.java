package com.yunfeisoft.business.model;

import com.applet.base.ServiceModel;
import com.applet.sql.record.TransientField;
import com.applet.utils.DateUtils;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;

/**
 * ClassName: ParticipateUser
 * Description: 课程参与用户(进入直播间上课的用户)
 *
 * @Author: Jackie liu
 * Date: 2020-05-26
 */
@Entity
@Table(name = "TT_PARTICIPATE_USER")
public class ParticipateUser extends ServiceModel implements Serializable {

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

    @TransientField
    private String userName;

    public long getDuration() {
        return DateUtils.timeDiff(getCreateTime(), getModifyTime());
    }

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

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
}