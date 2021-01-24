package com.yunfeisoft.task;

import com.yunfeisoft.business.enums.ClassStatusEnum;
import com.yunfeisoft.business.model.PmsCourse;
import com.yunfeisoft.business.model.PmsCourseItem;
import com.yunfeisoft.business.service.inter.MeetingService;
import com.yunfeisoft.business.service.inter.PmsCourseItemService;
import com.yunfeisoft.business.service.inter.PmsCourseService;
import com.yunfeisoft.business.service.inter.PmsLiveCourseService;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 把到期的直播课状态设置为完毕
 */
public class LiveBroadcastOverTask implements Runnable {

    @Autowired
    private PmsLiveCourseService pmsLiveCourseService;
    @Autowired
    private PmsCourseItemService pmsCourseItemService;
    @Autowired
    private MeetingService meetingService;
    @Autowired
    private PmsCourseService pmsCourseService;

    @Override
    public void run() {
        meetingService.modifyStatusWithDate(ClassStatusEnum.OVER.getValue());
        pmsLiveCourseService.modifyClassStatusWithDate(ClassStatusEnum.OVER.getValue());

        Map<String, Object> params = new HashMap<>();
        params.put("minEndDate", new Date());
        params.put("notClassStatus", ClassStatusEnum.OVER.getValue());
        List<PmsCourseItem> pmsCourseItemList = pmsCourseItemService.queryList(params);
        for (PmsCourseItem pmsCourseItem : pmsCourseItemList) {
            PmsCourse course = new PmsCourse();
            course.setId(pmsCourseItem.getCourseId());
            int count = pmsCourseItemService.queryOverCount(pmsCourseItem.getCourseId());
            course.setOverItemNum(count + 1);
            pmsCourseService.modify(course);

            pmsCourseItemService.modifyClassStatus(pmsCourseItem.getId(), ClassStatusEnum.OVER.getValue());
        }
    }

}
