package com.yunfeisoft.model;

import com.applet.base.BaseModel;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;

@Entity
@Table(name = "TR_ROLE_USER")
public class RoleUser extends BaseModel implements Serializable {

    /**
     * <p>Field serialVersionUID: 序列号</p>
     */
    private static final long serialVersionUID = 1L;

    //用户id
    @Column
    private String userId;

    //角色id
    @Column
    private String roleId;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }
}