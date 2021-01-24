package com.yunfeisoft.business.dao.inter;

import com.applet.base.BaseDao;
import com.applet.base.BaseModel;
import com.applet.base.ServiceModel;

/**
 * ClassName: VideoRoomIdSeqDao
 * Description: 直播间id生成Dao
 * Author: Jackie liu
 * Date: 2020-03-29
 */
public interface VideoRoomIdSeqDao extends BaseDao<ServiceModel, String> {

    public int querySeq();

}