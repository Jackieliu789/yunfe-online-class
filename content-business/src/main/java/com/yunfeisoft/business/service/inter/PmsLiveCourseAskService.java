package com.yunfeisoft.business.service.inter;

import com.applet.base.BaseService;
import com.applet.utils.Page;
import com.yunfeisoft.business.model.PmsLiveCourseAsk;

import java.util.Map;

/**
 * ClassName: PmsLiveCourseAskService
 * Description: 直播课堂提问表service接口
 * Author: Jackie liu
 * Date: 2020-04-15
 */
public interface PmsLiveCourseAskService extends BaseService<PmsLiveCourseAsk, String> {

    public Page<PmsLiveCourseAsk> queryPage(Map<String, Object> params);
}