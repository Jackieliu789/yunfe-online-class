package com.yunfeisoft.model;

import com.applet.base.BaseModel;
import com.applet.utils.DateUtils;
import com.yunfeisoft.enumeration.YesNoEnum;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "TS_POSITION")
public class Position extends BaseModel implements Serializable {

	/**
	 * <p>
	 * Field serialVersionUID: 序列号
	 * </p>
	 */
	private static final long serialVersionUID = 1L;

	// 名称
	@Column
	private String name;

	// 编码
	@Column
	private String code;

	// 描述
	@Column
	private String remark;

	//状态码 1：启用 ,2：停用
	@Column
	private Integer state;
	
	// 创建日期
	@Temporal(TemporalType.TIMESTAMP)
	@Column
	private Date createTime;

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

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Integer getState() {
		return state;
	}

	public void setState(Integer state) {
		this.state = state;
	}

}