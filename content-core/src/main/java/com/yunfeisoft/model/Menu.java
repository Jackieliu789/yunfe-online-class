package com.yunfeisoft.model;

import com.applet.base.BaseModel;
import com.yunfeisoft.enumeration.YesNoEnum;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;

@Entity
@Table(name = "TS_MENU")
public class Menu extends BaseModel implements Serializable {

    /**
     * <p>Field serialVersionUID: 序列号</p>
     */
    private static final long serialVersionUID = 1L;

    //父id
    @Column
    private String parentId;

    //名称
    @Column
    private String name;

    //排序
    @Column
    private Integer orderBy;

    //菜单图标
    @Column
    private String icon;

    //状态（1启用，2停用）
    @Column
    private Integer state;

    //描述
    @Column
    private String remark;

    //类别(1:菜单,2:按钮,3:其它)
    @Column
    private Integer category;

    //编码
    @Column
    private String code;

    //请求路径
    @Column
    private String url;

    private Menu parent;

    public String getCategoryStr() {
        return Category.valueOf(category);
    }

    public String getStateStr() {
        if (state != null) {
            return YesNoEnum.valueOfValidateLabel(state);
        }
        return null;
    }

    public Menu getParent() {
        return parent;
    }

    public void setParent(Menu parent) {
        this.parent = parent;
    }

    public String getParentId() {
        return parentId;
    }

    public void setParentId(String parentId) {
        this.parentId = parentId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getOrderBy() {
        return orderBy;
    }

    public void setOrderBy(Integer orderBy) {
        this.orderBy = orderBy;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public Integer getCategory() {
        return category;
    }

    public void setCategory(Integer category) {
        this.category = category;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public enum Category {
        MENU(1, "菜单"),
        BUTTON(2, "按钮"),
        SWITCH(3, "开关"),
        OTHER(4, "其它"),
        APPLET(5, "小程序");

        private int value;
        private String lable;

        public static String valueOf(int value) {
            Category[] values = Category.values();
            for (Category menuCategoryEnum : values) {
                if (value == menuCategoryEnum.getValue()) {
                    return menuCategoryEnum.getLable();
                }
            }
            return null;
        }

        private Category(int value, String lable) {
            this.value = value;
            this.lable = lable;
        }

        public Integer getValue() {
            return value;
        }

        public String getLable() {
            return lable;
        }

    }

}