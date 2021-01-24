package com.yunfeisoft.business.model;

import com.applet.base.ServiceModel;
import com.applet.sql.record.TransientField;
import com.applet.utils.DateUtils;
import com.yunfeisoft.business.enums.ClassStatusEnum;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * ClassName: Meeting
 * Description: 会议表
 *
 * @Author: Jackie liu
 * Date: 2020-03-29
 */
@Entity
@Table(name = "MEETING")
public class Meeting extends ServiceModel implements Serializable {

    /**
     * Field serialVersionUID: 序列号
     */
    private static final long serialVersionUID = 1L;

    /**
     * 名称
     */
    @Column
    private String name;

    /**
     * 开始时间
     */
    @Column
    private Date beginDate;

    /**
     * 结束时间
     */
    @Column
    private Date endDate;

    /**
     * 上课状态(1未开始，2会议中，3已结束)
     */
    @Column
    private Integer status;

    /**
     * 主持人id
     */
    @Column
    private String hostId;

    /**
     * 邀请码
     */
    @Column
    private String inviteCode;

    /**
     * 参会人数
     */
    @Column
    private Integer userNum;

    /**
     * 直播间id
     */
    @Column
    private Integer roomId;

    @TransientField
    private String hostName;

    private List<MeetingUser> userList;

    public String getStatusStr() {
        return ClassStatusEnum.valueOf(status);
    }

    public String getBeginDateStr() {
        if (beginDate == null) {
            return null;
        }
        return DateUtils.dateToString(beginDate, "yyyy-MM-dd HH:mm");
    }

    public String getEndDateStr() {
        if (endDate == null) {
            return null;
        }
        return DateUtils.dateToString(endDate, "yyyy-MM-dd HH:mm");
    }

    public String getBeginDateStr2() {
        if (beginDate == null) {
            return null;
        }
        return DateUtils.dateToString(beginDate, "MM/dd HH:mm");
    }

    public String getEndDateStr2() {
        if (endDate == null) {
            return null;
        }
        return DateUtils.dateToString(endDate, "HH:mm");
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getBeginDate() {
        return beginDate;
    }

    public void setBeginDate(Date beginDate) {
        this.beginDate = beginDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getHostId() {
        return hostId;
    }

    public void setHostId(String hostId) {
        this.hostId = hostId;
    }

    public String getInviteCode() {
        return inviteCode;
    }

    public void setInviteCode(String inviteCode) {
        this.inviteCode = inviteCode;
    }

    public String getHostName() {
        return hostName;
    }

    public void setHostName(String hostName) {
        this.hostName = hostName;
    }

    public Integer getUserNum() {
        return userNum;
    }

    public void setUserNum(Integer userNum) {
        this.userNum = userNum;
    }

    public List<MeetingUser> getUserList() {
        return userList;
    }

    public void setUserList(List<MeetingUser> userList) {
        this.userList = userList;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }
}