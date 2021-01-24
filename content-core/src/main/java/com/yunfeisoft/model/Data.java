package com.yunfeisoft.model;

import com.applet.base.BaseModel;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;

@Entity
@Table(name = "TC_DATA")
public class Data extends BaseModel implements Serializable {

    /**
     * <p>Field serialVersionUID: 序列号</p>
     */
    private static final long serialVersionUID = 1L;

    //实体外键
    @Column
    @JsonSerialize(using = ToStringSerializer.class)
    private String refId;

    //内容
    @Column
    private String content;

    //序号
    @Column
    private Integer num;

    //类别
    @Column
    private Integer type;

    public String getRefId() {
        return refId;
    }

    public void setRefId(String refId) {
        this.refId = refId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getNum() {
        return num;
    }

    public void setNum(Integer num) {
        this.num = num;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }
}