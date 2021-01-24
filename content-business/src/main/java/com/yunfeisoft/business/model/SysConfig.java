package com.yunfeisoft.business.model;

import com.applet.base.ServiceModel;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;

/**
 * ClassName: SysConfig
 * Description: 系统配置
 *
 * @Author: Jackie liu
 * Date: 2019-11-05
 */
@Entity
@Table(name = "TT_SYS_CONFIG")
public class SysConfig extends ServiceModel implements Serializable {

    /**
     * Field serialVersionUID: 序列号
     */
    private static final long serialVersionUID = 1L;

    /**
     * 字段名称
     */
    @Column
    private String key;

    /**
     * 值
     */
    @Column
    private String value;


    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }


}