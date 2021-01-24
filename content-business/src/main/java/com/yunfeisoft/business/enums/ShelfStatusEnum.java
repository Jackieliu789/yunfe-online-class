package com.yunfeisoft.business.enums;

/**
 * 上架状态
 */
public enum ShelfStatusEnum {

    SHELFING(1, "待上架"),
    UPPER_SHELF(2, "已上架"),
    LOWER_SHELF(3, "已下架"),
    TIME_SHELF(4, "定时上架");

    private int value;
    private String label;

    private ShelfStatusEnum(int value, String label) {
        this.value = value;
        this.label = label;
    }

    public static String valueOf(Integer value) {
        if (value == null) {
            return null;
        }
        for (ShelfStatusEnum loop : ShelfStatusEnum.values()) {
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
