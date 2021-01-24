package com.yunfeisoft.enumeration;

/**
 * Created by Jackie Liu on 2017/4/4.
 */
public enum YesNoEnum {

    YES_ACCPET(1, "是", "已启用"),
    NO_CANCEL(2, "否", "已停用");

    private int value;
    private String label;
    private String validate;

    private YesNoEnum(int value, String label, String validate) {
        this.value = value;
        this.label = label;
        this.validate = validate;
    }

    public static String valueOf(Integer value) {
        if (value == null) {
            return null;
        }
        for (YesNoEnum loop : YesNoEnum.values()) {
            if (value == loop.getValue()) {
                return loop.getLabel();
            }
        }
        return null;
    }

    public static String valueOfValidateLabel(Integer value) {
        if (value == null) {
            return null;
        }
        for (YesNoEnum loop : YesNoEnum.values()) {
            if (value == loop.getValue()) {
                return loop.getValidate();
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

    public String getValidate() {
        return validate;
    }
}
