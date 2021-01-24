package com.yunfeisoft.business.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.PmsCourseDao;
import com.yunfeisoft.business.model.PmsCourse;
import com.yunfeisoft.business.service.inter.PmsCourseService;
import com.yunfeisoft.dao.inter.DataDao;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * ClassName: PmsCourseServiceImpl
 * Description: 互动课堂-课程表service实现
 * Author: Jackie liu
 * Date: 2020-03-27
 */
@Service("pmsCourseService")
public class PmsCourseServiceImpl extends BaseServiceImpl<PmsCourse, String, PmsCourseDao> implements PmsCourseService {

    @Autowired
    private DataDao dataDao;

    @Override
    @DataSourceChange(slave = true)
    public Page<PmsCourse> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @Override
    public int modifyShelfStatus(String id, int status) {
        if (StringUtils.isBlank(id)) {
            return 0;
        }

        PmsCourse pmsCourse = new PmsCourse();
        pmsCourse.setId(id);
        pmsCourse.setShelfStatus(status);
        return getDao().update(pmsCourse);
    }

    @Override
    public int save(PmsCourse pmsCourse) {
        if (StringUtils.isNotBlank(pmsCourse.getContent())) {
            dataDao.saveOrUpdate(pmsCourse.getId(), pmsCourse.getContent());
        }
        return super.save(pmsCourse);
    }

    @Override
    public int modify(PmsCourse pmsCourse) {
        if (StringUtils.isNotBlank(pmsCourse.getContent())) {
            dataDao.saveOrUpdate(pmsCourse.getId(), pmsCourse.getContent());
        }
        return super.modify(pmsCourse);
    }

    @Override
    public int modifyForce(PmsCourse pmsCourse) {
        if (StringUtils.isNotBlank(pmsCourse.getContent())) {
            dataDao.saveOrUpdate(pmsCourse.getId(), pmsCourse.getContent());
        }
        return super.modifyForce(pmsCourse);
    }

}