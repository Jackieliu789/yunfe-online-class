package com.yunfeisoft.business.model;

import com.applet.base.ServiceModel;
import com.applet.sql.record.TransientField;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;

/**
 * ClassName: PmsLiveCourseAsk
 * Description: 直播课堂提问表
 *
 * @Author: Jackie liu
 * Date: 2020-04-15
 */
@Entity
@Table(name = "PMS_LIVE_COURSE_ASK")
public class PmsLiveCourseAsk extends ServiceModel implements Serializable {

    /**
     * Field serialVersionUID: 序列号
     */
    private static final long serialVersionUID = 1L;

    /**
     * 直播课堂id
     */
    @Column
    private String liveCourseId;

    /**
     * 提问内容
     */
    @Column
    private String content;

	@TransientField
	private String createName;

    public String getLiveCourseId() {
        return liveCourseId;
    }

    public void setLiveCourseId(String liveCourseId) {
        this.liveCourseId = liveCourseId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

	public String getCreateName() {
		return createName;
	}

	public void setCreateName(String createName) {
		this.createName = createName;
	}
}