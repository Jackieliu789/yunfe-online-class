package com.yunfeisoft.business.dao.impl.postgres;

import com.applet.base.ServiceDaoImpl;
import com.applet.base.ServiceModel;
import com.yunfeisoft.business.dao.inter.VideoRoomIdSeqDao;
import org.springframework.stereotype.Repository;

/**
 * ClassName: MeetingDaoImpl
 * Description: 会议表Dao实现
 * Author: Jackie liu
 * Date: 2020-03-29
 */
@Repository
public class VideoRoomIdSeqDaoImpl extends ServiceDaoImpl<ServiceModel, String> implements VideoRoomIdSeqDao {

    @Override
    public int querySeq() {
        String sql = "select nextval('video_room_id_seq')";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }
}