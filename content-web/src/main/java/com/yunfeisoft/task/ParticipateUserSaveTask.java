package com.yunfeisoft.task;

import com.applet.utils.SpringContextHelper;
import com.yunfeisoft.business.model.ParticipateUser;
import com.yunfeisoft.business.service.inter.ParticipateUserService;

/**
 * 保存课程参与用户(进入直播间上课的用户)
 */
public class ParticipateUserSaveTask implements Runnable {

    private String roomId;
    private String userId;

    public ParticipateUserSaveTask(String roomId, String userId) {
        this.roomId = roomId;
        this.userId = userId;
    }

    @Override
    public void run() {
        ParticipateUser participateUser = new ParticipateUser();
        participateUser.setRoomId(roomId);
        participateUser.setUserId(userId);

        ParticipateUserService participateUserService = SpringContextHelper.getBean(ParticipateUserService.class);
        participateUserService.save(participateUser);
    }

}
