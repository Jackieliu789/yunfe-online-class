package com.yunfeisoft.model;

import com.applet.base.BaseModel;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;

@Entity
@Table(name = "TR_ROLE_MENU")
public class RoleMenu extends BaseModel implements Serializable {

    /**
     * <p>Field serialVersionUID: 序列号</p>
     */
    private static final long serialVersionUID = 1L;

    //菜单id
    @Column
    private String menuId;

    //角色id
    @Column
    private String roleId;

    public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }
}