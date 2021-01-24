package com.yunfeisoft.business.model;

import com.applet.base.ServiceModel;
import com.applet.utils.DateUtils;
import com.yunfeisoft.business.enums.ShelfStatusEnum;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.Date;

/**
 * ClassName: PmsCourse
 * Description: 互动课堂-课程表
 *
 * @Author: Jackie liu
 * Date: 2020-03-27
 */
@Entity
@Table(name = "PMS_COURSE")
public class PmsCourse extends ServiceModel implements Serializable {

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
     * 简介
     */
    @Column
    private String intro;

    /**
     * 封面路径
     */
    @Column
    private String coverPath;

    /**
     * 上架状态(1上架，2下架)
     */
    @Column
    private Integer shelfStatus;

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
     * 学员人数
     */
    @Column
    private Integer studentNum;

    /**
     * 课节数量
     */
    @Column
    private Integer itemNum;

    /**
     * 已上课节数量
     */
    @Column
    private Integer overItemNum;

    private String content;

    public String getShelfStatusStr() {
        return ShelfStatusEnum.valueOf(shelfStatus);
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIntro() {
        return intro;
    }

    public void setIntro(String intro) {
        this.intro = intro;
    }

    public String getCoverPath() {
        return coverPath;
    }

    public void setCoverPath(String coverPath) {
        this.coverPath = coverPath;
    }

    public Integer getShelfStatus() {
        return shelfStatus;
    }

    public void setShelfStatus(Integer shelfStatus) {
        this.shelfStatus = shelfStatus;
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

    public Integer getStudentNum() {
        return studentNum;
    }

    public void setStudentNum(Integer studentNum) {
        this.studentNum = studentNum;
    }

    public Integer getItemNum() {
        return itemNum;
    }

    public void setItemNum(Integer itemNum) {
        this.itemNum = itemNum;
    }

    public Integer getOverItemNum() {
        return overItemNum;
    }

    public void setOverItemNum(Integer overItemNum) {
        this.overItemNum = overItemNum;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

}