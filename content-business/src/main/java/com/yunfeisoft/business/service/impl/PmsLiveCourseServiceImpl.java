package com.yunfeisoft.business.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.PmsLiveCourseDao;
import com.yunfeisoft.business.dao.inter.VideoRoomIdSeqDao;
import com.yunfeisoft.business.model.PmsLiveCourse;
import com.yunfeisoft.business.service.inter.PmsLiveCourseService;
import com.yunfeisoft.dao.inter.DataDao;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsLiveCourseServiceImpl
 * Description: 直播课堂表service实现
 * Author: Jackie liu
 * Date: 2020-03-29
 */
@Service("pmsLiveCourseService")
public class PmsLiveCourseServiceImpl extends BaseServiceImpl<PmsLiveCourse, String, PmsLiveCourseDao> implements PmsLiveCourseService {

    @Autowired
    private DataDao dataDao;
    @Autowired
    private VideoRoomIdSeqDao videoRoomIdSeqDao;

    @Override
    @DataSourceChange(slave = true)
    public Page<PmsLiveCourse> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @Override
    public List<PmsLiveCourse> queryList(Map<String, Object> params) {
        return getDao().queryList(params);
    }

    @Override
    public int modifyShelfStatus(String id, int shelfStatus) {
        if (StringUtils.isBlank(id)) {
            return 0;
        }

        PmsLiveCourse pmsLiveCourse = new PmsLiveCourse();
        pmsLiveCourse.setId(id);
        pmsLiveCourse.setShelfStatus(shelfStatus);
        return getDao().update(pmsLiveCourse);
    }

    @Override
    public int modifyClassStatusWithDate(int classStatus) {
        return getDao().modifyClassStatusWithDate(classStatus);
    }

    @Override
    public int modify2(PmsLiveCourse pmsLiveCourse) {
        return getDao().update(pmsLiveCourse);
    }

    @Override
    public int modifyInviteCode(String id, String inviteCode) {
        return getDao().modifyInviteCode(id, inviteCode);
    }

    @Override
    public int save(PmsLiveCourse pmsLiveCourse) {
        pmsLiveCourse.setRoomId(videoRoomIdSeqDao.querySeq());
        int result = super.save(pmsLiveCourse);
        if (StringUtils.isNotBlank(pmsLiveCourse.getContent())) {
            dataDao.saveOrUpdate(pmsLiveCourse.getId(), pmsLiveCourse.getContent());
        }
        return result;
    }

    @Override
    public int modify(PmsLiveCourse pmsLiveCourse) {
        if (StringUtils.isNotBlank(pmsLiveCourse.getContent())) {
            dataDao.saveOrUpdate(pmsLiveCourse.getId(), pmsLiveCourse.getContent());
        }
        return super.modify(pmsLiveCourse);
    }
}