package com.yunfeisoft.business.model;

import com.applet.base.ServiceModel;
import com.applet.sql.record.TransientField;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;

/**
 * ClassName: PmsLiveCourseUser
 * Description: 直播课堂-用户表
 *
 * @Author: Jackie liu
 * Date: 2020-04-15
 */
@Entity
@Table(name = "PMS_LIVE_COURSE_USER")
public class PmsLiveCourseUser extends ServiceModel implements Serializable {

    /**
     * Field serialVersionUID: 序列号
     */
    private static final long serialVersionUID = 1L;

    /**
     * 直播课堂id
     */
    @Column
    private String liveCourseId;

    /**
     * 用户id
     */
    @Column
    private String userId;

    @TransientField
    private String userName;


    public String getLiveCourseId() {
        return liveCourseId;
    }

    public void setLiveCourseId(String liveCourseId) {
        this.liveCourseId = liveCourseId;
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