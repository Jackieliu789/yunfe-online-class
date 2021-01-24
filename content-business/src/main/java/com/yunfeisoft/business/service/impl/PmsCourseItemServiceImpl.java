package com.yunfeisoft.business.service.impl;

import com.applet.base.BaseServiceImpl;
import com.applet.sql.separation.DataSourceChange;
import com.applet.utils.Page;
import com.yunfeisoft.business.dao.inter.PmsCourseDao;
import com.yunfeisoft.business.dao.inter.PmsCourseItemDao;
import com.yunfeisoft.business.dao.inter.PmsCourseUserDao;
import com.yunfeisoft.business.dao.inter.VideoRoomIdSeqDao;
import com.yunfeisoft.business.model.PmsCourse;
import com.yunfeisoft.business.model.PmsCourseItem;
import com.yunfeisoft.business.model.PmsCourseUser;
import com.yunfeisoft.business.service.inter.PmsCourseItemService;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsCourseItemServiceImpl
 * Description: 互动课堂-课节表service实现
 * Author: Jackie liu
 * Date: 2020-03-27
 */
@Service("pmsCourseItemService")
public class PmsCourseItemServiceImpl extends BaseServiceImpl<PmsCourseItem, String, PmsCourseItemDao> implements PmsCourseItemService {

    @Autowired
    private PmsCourseUserDao pmsCourseUserDao;
    @Autowired
    private PmsCourseDao pmsCourseDao;
    @Autowired
    private VideoRoomIdSeqDao videoRoomIdSeqDao;

    @Override
    @DataSourceChange(slave = true)
    public Page<PmsCourseItem> queryPage(Map<String, Object> params) {
        return getDao().queryPage(params);
    }

    @Override
    public List<PmsCourseItem> queryList(Map<String, Object> params) {
        return getDao().queryList(params);
    }

    @Override
    public int modifyInviteCode(String id, String inviteCode) {
        return getDao().modifyInviteCode(id, inviteCode);
    }

    @Override
    public int modifySort(String id, int sort) {
        return getDao().modifySort(id, sort);
    }

    @Override
    public int modifyClassStatus(String id, int classStatus) {
        if (StringUtils.isBlank(id)) {
            return 0;
        }

        PmsCourseItem pmsCourseItem = new PmsCourseItem();
        pmsCourseItem.setId(id);
        pmsCourseItem.setClassStatus(classStatus);
        return getDao().update(pmsCourseItem);
    }

    @Override
    public int queryOverCount(String courseId) {
        return getDao().queryOverCount(courseId);
    }

    private void setCourseDate(PmsCourse course, PmsCourseItem pmsCourseItem) {
        PmsCourseItem item = getDao().queryMaxAndMinDate(course.getId());
        if (item == null || item.getBeginDate() == null || item.getEndDate() == null) {
            course.setBeginDate(pmsCourseItem.getBeginDate());
            course.setEndDate(pmsCourseItem.getEndDate());
            return;
        }
        Date beginDate = pmsCourseItem.getBeginDate();
        Date endDate = pmsCourseItem.getEndDate();
        if (beginDate.getTime() >= item.getBeginDate().getTime()) {
            beginDate = item.getBeginDate();
        }

        if (endDate.getTime() <= item.getEndDate().getTime()) {
            endDate = item.getEndDate();
        }

        course.setBeginDate(beginDate);
        course.setEndDate(endDate);
    }

    @Override
    public int save(PmsCourseItem pmsCourseItem) {
        PmsCourse course = new PmsCourse();
        course.setId(pmsCourseItem.getCourseId());
        setCourseDate(course, pmsCourseItem);

        int count = getDao().queryCount(pmsCourseItem.getCourseId());
        course.setItemNum(count + 1);

        pmsCourseDao.update(course);

        pmsCourseItem.setRoomId(videoRoomIdSeqDao.querySeq());
        int result = super.save(pmsCourseItem);
        if (ArrayUtils.isNotEmpty(pmsCourseItem.getUserIds())) {
            List<PmsCourseUser> userList = new ArrayList<>();
            for (String userId : pmsCourseItem.getUserIds()) {
                PmsCourseUser pmsCourseUser = new PmsCourseUser();
                pmsCourseUser.setCourseId(pmsCourseItem.getId());
                pmsCourseUser.setUserId(userId);
                pmsCourseUser.setType(PmsCourseUser.TypeEnum.STUDENT.getValue());
                userList.add(pmsCourseUser);
            }
            pmsCourseUserDao.batchInsert(userList);
        }
        return result;
    }

    @Override
    public int modify(PmsCourseItem pmsCourseItem) {
        PmsCourse course = new PmsCourse();
        course.setId(pmsCourseItem.getCourseId());
        setCourseDate(course, pmsCourseItem);
        pmsCourseDao.update(course);

        pmsCourseUserDao.deleteByRefId(pmsCourseItem.getId());
        if (ArrayUtils.isNotEmpty(pmsCourseItem.getUserIds())) {
            List<PmsCourseUser> userList = new ArrayList<>();
            for (String userId : pmsCourseItem.getUserIds()) {
                PmsCourseUser pmsCourseUser = new PmsCourseUser();
                pmsCourseUser.setCourseId(pmsCourseItem.getId());
                pmsCourseUser.setUserId(userId);
                pmsCourseUser.setType(PmsCourseUser.TypeEnum.STUDENT.getValue());
                userList.add(pmsCourseUser);
            }
            pmsCourseUserDao.batchInsert(userList);
        }
        return super.modify(pmsCourseItem);
    }
}