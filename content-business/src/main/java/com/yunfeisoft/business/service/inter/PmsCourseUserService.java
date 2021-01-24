package com.yunfeisoft.business.service.inter;

import com.applet.base.BaseService;
import com.applet.utils.Page;
import com.yunfeisoft.business.model.PmsCourseUser;

import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsCourseUserService
 * Description: 互动课堂-课程学生/老师表service接口
 * Author: Jackie liu
 * Date: 2020-03-27
 */
public interface PmsCourseUserService extends BaseService<PmsCourseUser, String> {

    public Page<PmsCourseUser> queryPage(Map<String, Object> params);

    public List<PmsCourseUser> queryList(Map<String, Object> params);

    public int saveCourseStudent(PmsCourseUser pmsCourseUser);

    public int saveCourseStudents(String courseId, List<PmsCourseUser> pmsCourseUserList);

    public int removeCourseStudent(String id);
}