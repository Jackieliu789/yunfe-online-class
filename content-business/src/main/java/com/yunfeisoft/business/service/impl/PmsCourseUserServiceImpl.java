package com.yunfeisoft.business.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.PmsCourseDao;
import com.yunfeisoft.business.dao.inter.PmsCourseUserDao;
import com.yunfeisoft.business.model.PmsCourse;
import com.yunfeisoft.business.model.PmsCourseUser;
import com.yunfeisoft.business.service.inter.PmsCourseUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsCourseUserServiceImpl
 * Description: 互动课堂-课程学生/老师表service实现
 * Author: Jackie liu
 * Date: 2020-03-27
 */
@Service("pmsCourseUserService")
public class PmsCourseUserServiceImpl extends BaseServiceImpl<PmsCourseUser, String, PmsCourseUserDao> implements PmsCourseUserService {

    @Autowired
    private PmsCourseDao pmsCourseDao;

    @Override
    @DataSourceChange(slave = true)
    public Page<PmsCourseUser> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @Override
    public List<PmsCourseUser> queryList(Map<String, Object> params) {
        return getDao().queryList(params);
    }

    @Override
    public int saveCourseStudent(PmsCourseUser pmsCourseUser) {
        int count = getDao().queryCount(pmsCourseUser.getCourseId(), PmsCourseUser.TypeEnum.STUDENT.getValue());
        PmsCourse course = new PmsCourse();
        course.setId(pmsCourseUser.getCourseId());
        course.setStudentNum(count + 1);
        pmsCourseDao.update(course);
        return getDao().insert(pmsCourseUser);
    }

    @Override
    public int saveCourseStudents(String courseId, List<PmsCourseUser> pmsCourseUserList) {
        int count = getDao().queryCount(courseId, PmsCourseUser.TypeEnum.STUDENT.getValue());
        PmsCourse course = new PmsCourse();
        course.setId(courseId);
        course.setStudentNum(count + pmsCourseUserList.size());
        pmsCourseDao.update(course);

        return getDao().batchInsert(pmsCourseUserList);
    }

    @Override
    public int removeCourseStudent(String id) {
        PmsCourseUser pmsCourseUser = getDao().load(id);
        if (pmsCourseUser.getType() == PmsCourseUser.TypeEnum.STUDENT.getValue()) {
            int count = getDao().queryCount(pmsCourseUser.getCourseId(), PmsCourseUser.TypeEnum.STUDENT.getValue());
            PmsCourse course = new PmsCourse();
            course.setId(pmsCourseUser.getCourseId());
            course.setStudentNum(count - 1);
            pmsCourseDao.update(course);
        }
        return getDao().delete(id);
    }
}