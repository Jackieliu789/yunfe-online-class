package com.yunfeisoft.model;

import com.applet.base.BaseModel;
import com.applet.utils.DateUtils;
import com.yunfeisoft.enumeration.YesNoEnum;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "TS_ROLE")
public class Role extends BaseModel implements Serializable {

    /**
     * <p>
     * Field serialVersionUID: 序列号
     * </p>
     */
    private static final long serialVersionUID = 1L;

    // 名称
    @Column
    private String name;

    // 状态（1启用，2停用）
    @Column
    private Integer state;

    // 创建人id
    @Column
    private String createId;

    // 创建日期
    @Temporal(TemporalType.TIMESTAMP)
    @Column
    private Date createTime;

    // 是否系统角色（1是，2否）
    @Column
    private Integer isSys;

    // 描述
    @Column
    private String remark;

    @Transient
    private String createName;

    public String getCreateName() {
        return createName;
    }

    public void setCreateName(String createName) {
        this.createName = createName;
    }

    public String getStateStr() {
        return YesNoEnum.valueOfValidateLabel(state);
    }

    public String getIsSysStr() {
        return YesNoEnum.valueOf(isSys);
    }

    public String getCreateTimeStr() {
        if (createTime != null) {
            return DateUtils.dateTimeToString(createTime);
        }
        return null;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public String getCreateId() {
        return createId;
    }

    public void setCreateId(String createId) {
        this.createId = createId;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Integer getIsSys() {
        return isSys;
    }

    public void setIsSys(Integer isSys) {
        this.isSys = isSys;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }
}