package com.yunfeisoft.business.service.inter;

import com.applet.base.BaseService;
import com.yunfeisoft.business.model.PmsLiveCourseUser;
import com.applet.utils.Page;

import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsLiveCourseUserService
 * Description: 直播课堂-用户表service接口
 * Author: Jackie liu
 * Date: 2020-04-15
 */
public interface PmsLiveCourseUserService extends BaseService<PmsLiveCourseUser, String> {

    public Page<PmsLiveCourseUser> queryPage(Map<String, Object> params);

    public List<PmsLiveCourseUser> queryByCourseId(String courseId);
}