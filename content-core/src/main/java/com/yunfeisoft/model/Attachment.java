package com.yunfeisoft.model;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import com.applet.base.BaseModel;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "TC_ATTACHMENT")
public class Attachment extends BaseModel implements Serializable {

    /**
     * <p>Field serialVersionUID: 序列号</p>
     */
    private static final long serialVersionUID = 1L;

    //实体外键
    @Column
    private String refId;

    //原始名称
    @Column
    private String originalName;

    //路径
    @Column
    private String path;

    //类别，业务中使用
    @Column
    private Integer category;

    //大小
    @Column
    @JsonSerialize(using = ToStringSerializer.class)
    private Long size;

    //类型(pic,doc,xls,ppt,txt...)
    @Column
    private String type;

    //创建日期
    @Temporal(TemporalType.TIMESTAMP)
    @Column
    private Date createTime;

    //创建人id
    @Column
    private String createId;

    public String getRefId() {
        return refId;
    }

    public void setRefId(String refId) {
        this.refId = refId;
    }

    public String getOriginalName() {
        return originalName;
    }

    public void setOriginalName(String originalName) {
        this.originalName = originalName;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public Integer getCategory() {
        return category;
    }

    public void setCategory(Integer category) {
        this.category = category;
    }

    public Long getSize() {
        return size;
    }

    public void setSize(Long size) {
        this.size = size;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getCreateId() {
        return createId;
    }

    public void setCreateId(String createId) {
        this.createId = createId;
    }

}