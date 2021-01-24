package com.yunfeisoft.business.service.inter;

import com.applet.base.BaseService;
import com.yunfeisoft.business.model.PmsCourse;
import com.applet.utils.Page;

import java.util.Map;

/**
 * ClassName: PmsCourseService
 * Description: 互动课堂-课程表service接口
 * Author: Jackie liu
 * Date: 2020-03-27
 */
public interface PmsCourseService extends BaseService<PmsCourse, String> {

    public Page<PmsCourse> queryPage(Map<String, Object> params);

    public int modifyShelfStatus(String id, int status);
}