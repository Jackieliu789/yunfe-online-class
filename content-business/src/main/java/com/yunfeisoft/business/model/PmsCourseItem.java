package com.yunfeisoft.business.model;

import com.applet.base.ServiceModel;
import com.applet.sql.record.TransientField;
import com.applet.utils.DateUtils;
import com.yunfeisoft.business.enums.ClassStatusEnum;
import org.apache.commons.lang3.StringUtils;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * ClassName: PmsCourseItem
 * Description: 互动课堂-课节表
 *
 * @Author: Jackie liu
 * Date: 2020-03-27
 */
@Entity
@Table(name = "PMS_COURSE_ITEM")
public class PmsCourseItem extends ServiceModel implements Serializable {

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
     * 老师id
     */
    @Column
    private String teacherId;

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
     * 排序
     */
    @Column
    private Integer sort;

    /**
     * 上课状态(1未开始，2授课中，3已结束)
     */
    @Column
    private Integer classStatus;

    /**
     * 班型(1-1v49，2-1vN)
     */
    @Column
    private Integer type;

    /**
     * 录制状态(1录制，2不录制)
     */
    @Column
    private Integer recordStatus;

    /**
     * 邀请码(加密)
     */
    @Column
    private String inviteCode;

    /**
     * 学生人数
     */
    @Column
    private Integer studentNum;

    /**
     * 直播间id
     */
    @Column
    private Integer roomId;

    @TransientField
    private String teacherName;
    /**
     * 封面路径
     */
    @TransientField
    private String coverPath;

    /**
     * 是否静音，1是、2否
     */
    private String muteVoice;

    private String[] userIds;
    private List<PmsCourseUser> courseUserList;

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

    public String getTypeStr() {
        return TypeStatusEnum.valueOf(type);
    }

    public String getClassStatusStr() {
        return ClassStatusEnum.valueOf(classStatus);
    }

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    public String getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(String teacherId) {
        this.teacherId = teacherId;
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

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Integer getClassStatus() {
        return classStatus;
    }

    public void setClassStatus(Integer classStatus) {
        this.classStatus = classStatus;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public Integer getRecordStatus() {
        return recordStatus;
    }

    public void setRecordStatus(Integer recordStatus) {
        this.recordStatus = recordStatus;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }

    public String getInviteCode() {
        return inviteCode;
    }

    public void setInviteCode(String inviteCode) {
        this.inviteCode = inviteCode;
    }

    public Integer getStudentNum() {
        return studentNum;
    }

    public void setStudentNum(Integer studentNum) {
        this.studentNum = studentNum;
    }

    public String[] getUserIds() {
        return userIds;
    }

    public void setUserIds(String[] userIds) {
        this.userIds = userIds;
    }

    public List<PmsCourseUser> getCourseUserList() {
        return courseUserList;
    }

    public void setCourseUserList(List<PmsCourseUser> courseUserList) {
        this.courseUserList = courseUserList;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    public String getCoverPath() {
        return coverPath;
    }

    public void setCoverPath(String coverPath) {
        this.coverPath = coverPath;
    }

    public String getMuteVoice() {
        if (StringUtils.isBlank(muteVoice)) {
            return "2";
        }

        return muteVoice;
    }

    public void setMuteVoice(String muteVoice) {
        this.muteVoice = muteVoice;
    }

    /**
     * 班型
     */
    public enum TypeStatusEnum {

        _1v49(1, "1v49"),
        _1vN(2, "1vN");

        private int value;
        private String label;

        private TypeStatusEnum(int value, String label) {
            this.value = value;
            this.label = label;
        }

        public static String valueOf(Integer value) {
            if (value == null) {
                return null;
            }
            for (TypeStatusEnum loop : TypeStatusEnum.values()) {
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