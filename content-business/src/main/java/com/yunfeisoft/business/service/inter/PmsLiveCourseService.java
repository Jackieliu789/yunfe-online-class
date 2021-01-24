package com.yunfeisoft.business.service.inter;

import com.applet.base.BaseService;
import com.yunfeisoft.business.model.PmsLiveCourse;
import com.applet.utils.Page;

import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsLiveCourseService
 * Description: 直播课堂表service接口
 * Author: Jackie liu
 * Date: 2020-03-29
 */
public interface PmsLiveCourseService extends BaseService<PmsLiveCourse, String> {

    public Page<PmsLiveCourse> queryPage(Map<String, Object> params);

    public List<PmsLiveCourse> queryList(Map<String, Object> params);

    public int modifyShelfStatus(String id, int shelfStatus);

    public int modifyClassStatusWithDate(int classStatus);

    public int modify2(PmsLiveCourse pmsLiveCourse);

    public int modifyInviteCode(String id, String inviteCode);
}