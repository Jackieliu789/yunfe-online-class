package com.yunfeisoft.business.enums;

import com.yunfeisoft.business.model.PmsCourseItem;

/**
 * 上课状态(1未开始，2授课中，3已结束)
 */
public enum ClassStatusEnum {

    NOT_BEGIN(1, "未开始"),
    TEACHING(2, "授课中"),
    OVER(3, "已结束");

    private int value;
    private String label;

    private ClassStatusEnum(int value, String label) {
        this.value = value;
        this.label = label;
    }

    public static String valueOf(Integer value) {
        if (value == null) {
            return null;
        }
        for (ClassStatusEnum loop : ClassStatusEnum.values()) {
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
