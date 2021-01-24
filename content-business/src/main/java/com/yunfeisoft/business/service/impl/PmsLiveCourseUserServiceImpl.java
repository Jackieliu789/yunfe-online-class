package com.yunfeisoft.business.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.PmsLiveCourseDao;
import com.yunfeisoft.business.dao.inter.PmsLiveCourseUserDao;
import com.yunfeisoft.business.model.PmsLiveCourse;
import com.yunfeisoft.business.model.PmsLiveCourseUser;
import com.yunfeisoft.business.service.inter.PmsLiveCourseUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsLiveCourseUserServiceImpl
 * Description: 直播课堂-用户表service实现
 * Author: Jackie liu
 * Date: 2020-04-15
 */
@Service("pmsLiveCourseUserService")
public class PmsLiveCourseUserServiceImpl extends BaseServiceImpl<PmsLiveCourseUser, String, PmsLiveCourseUserDao> implements PmsLiveCourseUserService {

    @Autowired
    private PmsLiveCourseDao pmsLiveCourseDao;

    @Override
    @DataSourceChange(slave = true)
    public Page<PmsLiveCourseUser> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @Override
    public List<PmsLiveCourseUser> queryByCourseId(String courseId) {
        return getDao().queryByCourseId(courseId);
    }

    @Override
    public int save(PmsLiveCourseUser pmsLiveCourseUser) {
        PmsLiveCourse course = new PmsLiveCourse();
        course.setId(pmsLiveCourseUser.getLiveCourseId());
        course.setType(PmsLiveCourse.LiveCourseTypeEnum.MULTI.getValue());
        pmsLiveCourseDao.update(course);
        return super.save(pmsLiveCourseUser);
    }

    @Override
    public int remove(String id) {
        PmsLiveCourseUser courseUser = load(id);
        int count = getDao().queryCount(courseUser.getLiveCourseId());
        if (count <= 1) {
            PmsLiveCourse course = new PmsLiveCourse();
            course.setId(courseUser.getLiveCourseId());
            course.setType(PmsLiveCourse.LiveCourseTypeEnum.SINGLE.getValue());
            pmsLiveCourseDao.update(course);
        }
        return super.remove(id);
    }
}