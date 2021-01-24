package com.yunfeisoft.business.service.inter;

import com.applet.base.BaseService;
import com.yunfeisoft.business.model.PmsCourseItem;
import com.applet.utils.Page;

import java.util.List;
import java.util.Map;

/**
 * ClassName: PmsCourseItemService
 * Description: 互动课堂-课节表service接口
 * Author: Jackie liu
 * Date: 2020-03-27
 */
public interface PmsCourseItemService extends BaseService<PmsCourseItem, String> {

    public Page<PmsCourseItem> queryPage(Map<String, Object> params);

    public List<PmsCourseItem> queryList(Map<String, Object> params);

    public int modifyInviteCode(String id, String inviteCode);

    public int modifySort(String id, int sort);

    public int modifyClassStatus(String id, int classStatus);

    public int queryOverCount(String courseId);
}