package com.yunfeisoft.model;

import com.alibaba.excel.annotation.ExcelProperty;
import com.applet.base.BaseModel;
import com.applet.utils.DateUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yunfeisoft.enumeration.YesNoEnum;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;

@Entity
@Table(name = "TS_USER")
public class User extends BaseModel implements Serializable {

    /**
     * <p>Field serialVersionUID: 序列号</p>
     */
    private static final long serialVersionUID = 1L;

    //姓名
    @ExcelProperty("姓名")
    @Column
    private String name;

    //性别(男：1  女：2)
    @Column
    private Integer gender;

    //手机号码
    @ExcelProperty("手机号")
    @Column
    private String phone;

    //电子邮件
    @Column
    private String email;

    //组织机构id
    @Column
    private String orgId;

    //状态(启用：1  停用：2)
    @Column
    private Integer state;

    //警号
    @Column
    private String policeNo;

    //身份证号
    @ExcelProperty("身份证号")
    @Column
    private String idcard;

    //头像
    @Column
    private String headPhoto;

    //固定电话
    @Column
    private String telephone;

    //创建时间
    @Temporal(TemporalType.TIMESTAMP)
    @Column
    private Date createTime;

    //密码
    @Column
    private String pass;

    //职务id
    @Column
    private String positionId;

    //职务名称
    @Transient
    private String positionName;

    //机构名称
    @Transient
    private String orgName;

    //是否系统用户
    @Column
    private Integer isSys;

    //微信openid
    @Column
    private String openId;

    //密码是否不合规则
    private Boolean simplePass;
    private List<Role> roleList;
    private List<Menu> menuList;
    private Organization organization;
    private String topOrgId;

    @ExcelProperty("性别")
    @Transient
    private String sexStr;

    private String token;

    public String getStateStr() {
        if (state != null) {
            return YesNoEnum.valueOfValidateLabel(state);
        }
        return null;
    }

    public String getCreateTimeStr() {
        if (createTime != null) {
            return DateUtils.dateTimeToString(createTime);
        }
        return null;
    }

    public String getMenuJsonArray() {
        if (menuList == null) {
            return "[]";
        }
        List<Menu> list = new ArrayList<Menu>();
        for (Menu menu : menuList) {
            if (Objects.equals(menu.getCategory(), Menu.Category.MENU.getValue())) {
                list.add(menu);
            }
        }

        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.writeValueAsString(list);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getTopOrgId() {
        if (organization == null || StringUtils.isBlank(organization.getIdPath())) {
            return orgId;
        }
        if (StringUtils.isBlank(topOrgId)) {
            topOrgId = organization.getIdPath().split("/")[0];
        }
        return topOrgId;
    }

    public List<Role> getRoleList() {
        return roleList;
    }

    public void setRoleList(List<Role> roleList) {
        this.roleList = roleList;
    }

    public List<Menu> getMenuList() {
        return menuList;
    }

    public void setMenuList(List<Menu> menuList) {
        this.menuList = menuList;
    }

    public Organization getOrganization() {
        return organization;
    }

    public void setOrganization(Organization organization) {
        this.organization = organization;
    }

    public Integer getIsSys() {
        return isSys;
    }

    public void setIsSys(Integer isSys) {
        this.isSys = isSys;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getGender() {
        return gender;
    }

    public void setGender(Integer gender) {
        this.gender = gender;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public String getPoliceNo() {
        return policeNo;
    }

    public void setPoliceNo(String policeNo) {
        this.policeNo = policeNo;
    }

    public String getIdcard() {
        return idcard;
    }

    public void setIdcard(String idcard) {
        this.idcard = idcard;
    }

    public String getHeadPhoto() {
        return headPhoto;
    }

    public void setHeadPhoto(String headPhoto) {
        this.headPhoto = headPhoto;
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

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }

    public String getPositionId() {
        return positionId;
    }

    public void setPositionId(String positionId) {
        this.positionId = positionId;
    }

    public String getPositionName() {
        return positionName;
    }

    public void setPositionName(String positionName) {
        this.positionName = positionName;
    }

    public String getOrgName() {
        return orgName;
    }

    public void setOrgName(String orgName) {
        this.orgName = orgName;
    }

    public Boolean getSimplePass() {
        return simplePass;
    }

    public void setSimplePass(Boolean simplePass) {
        this.simplePass = simplePass;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getOpenId() {
        return openId;
    }

    public void setOpenId(String openId) {
        this.openId = openId;
    }

    public String getSexStr() {
        return sexStr;
    }

    public void setSexStr(String sexStr) {
        this.sexStr = sexStr;
    }

    /**
     * 判断是否有权限
     *
     * @param code 菜单或按钮的编号
     * @return
     */
    public boolean hasAuthority(String code) {
        if (CollectionUtils.isEmpty(menuList) || StringUtils.isBlank(code)) {
            return false;
        }
        for (Menu menu : menuList) {
            if (menu.getCode().equals(code)) {
                return true;
            }
        }
        return false;
    }

}