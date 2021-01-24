package com.yunfeisoft.model;

import com.applet.base.BaseModel;
import org.joda.time.DateTime;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "TS_ORGANIZATION")
public class Organization extends BaseModel implements Serializable {

    /**
     * <p>Field serialVersionUID: 序列号</p>
     */
    private static final long serialVersionUID = 1L;

    //父id
    @Column
    private String parentId;

    //id路径
    @Column
    private String idPath;

    //code路径
    @Column
    private String codePath;

    //编码
    @Column
    private String code;

    //名称
    @Column
    private String name;

    //联系人
    @Column
    private String linkmanId;

    //类别(市局，分县局，支队.....)
    @Column
    private Integer category;

    //备注
    @Column
    private String remark;

    //联系电话
    @Column
    private String telephone;

    //创建时间
    @Temporal(TemporalType.TIMESTAMP)
    @Column
    private Date createTime;

    //区域id
    /*@Column
    private String areaId;*/

    private Organization parentOrg;

    @Transient
    private String areaName;

    public String getCreateTimeStr() {
        if (createTime != null) {
            return new DateTime(createTime).toString("yyyy-MM-dd HH:mm:ss");
        }
        return null;
    }

    public String getCategoryStr() {
        if (category != null) {
            return Category.valueOf(category);
        }
        return null;
    }

    public Organization getParentOrg() {
        return parentOrg;
    }

    public void setParentOrg(Organization parentOrg) {
        this.parentOrg = parentOrg;
    }

    public String getParentId() {
        return parentId;
    }

    public void setParentId(String parentId) {
        this.parentId = parentId;
    }

    public String getIdPath() {
        return idPath;
    }

    public void setIdPath(String idPath) {
        this.idPath = idPath;
    }

    public String getCodePath() {
        return codePath;
    }

    public void setCodePath(String codePath) {
        this.codePath = codePath;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLinkmanId() {
        return linkmanId;
    }

    public void setLinkmanId(String linkmanId) {
        this.linkmanId = linkmanId;
    }

    public Integer getCategory() {
        return category;
    }

    public void setCategory(Integer category) {
        this.category = category;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public enum Category {
        /*TING_THIS(5, "厅本级"),
        SHI_JU(10, "市局(市辖区)"),
        FEN_JU(15, "分局"),
        XIAN_JU(20, "县局"),
        ZHI_DUI(25, "支队"),
        KE_SHI(30, "科(室)"),
        PAI_CHU_SUO(35, "派出所"),
        DA_DUI(40, "大队"),
        ZHONG_DUI(45, "中队"),
        OTHER(50, "其他");*/

        GROUP(5, "集团"),
        BRANCH_OFFICE(10, "分公司"),
        DEPARTMENT(15, "部门"),
        KE_SHI(20, "科(室)"),
        OTHER(25, "其他");

        private int value;
        private String label;

        private Category(int value, String label) {
            this.value = value;
            this.label = label;
        }

        public static String valueOf(int value) {
            for (Category loop : Category.values()) {
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

    /*public String getAreaId() {
        return areaId;
    }

    public void setAreaId(String areaId) {
        this.areaId = areaId;
    }*/

    public String getAreaName() {
        return areaName;
    }

    public void setAreaName(String areaName) {
        this.areaName = areaName;
    }
}