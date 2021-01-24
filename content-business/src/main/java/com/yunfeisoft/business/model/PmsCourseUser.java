package com.yunfeisoft.business.model;

import com.applet.base.ServiceModel;
import com.applet.sql.record.TransientField;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;

/**
 * ClassName: PmsCourseUser
 * Description: 互动课堂-课程学生/老师表
 *
 * @Author: Jackie liu
 * Date: 2020-03-27
 */
@Entity
@Table(name = "PMS_COURSE_USER")
public class PmsCourseUser extends ServiceModel implements Serializable {

    /**
     * Field serialVersionUID: 序列号
     */
    private static final long serialVersionUID = 1L;

    /**
     * 课程id
     */
    @Column
    private String courseId;

    /**
     * 学生id
     */
    @Column
    private String userId;

    /**
     * 类别(1学生、2老师)
     */
    @Column
    private Integer type;

    @TransientField
    private String userName;
    @TransientField
    private String orgName;

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getOrgName() {
        return orgName;
    }

    public void setOrgName(String orgName) {
        this.orgName = orgName;
    }

    public enum TypeEnum {

        STUDENT(1, "学生"),
        TEACHER(2, "老师");

        private int value;
        private String label;

        private TypeEnum(int value, String label) {
            this.value = value;
            this.label = label;
        }

        public static String valueOf(Integer value) {
            if (value == null) {
                return null;
            }
            for (TypeEnum loop : TypeEnum.values()) {
                if (value == loop.getValue()) {
                    return loop.getLabel();
                }
            }
            return null;
        }

        public int getValue() {
            return value;
        }

        public String getLabel() {
            return label;
        }
    }
}