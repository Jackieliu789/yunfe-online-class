package com.yunfeisoft.utils;

import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import com.applet.utils.Constants;
import com.applet.utils.KeyUtils;
import com.applet.utils.MD5Utils;
import com.applet.utils.SpringContextHelper;
import com.yunfeisoft.dao.inter.UserDao;
import com.yunfeisoft.enumeration.YesNoEnum;
import com.yunfeisoft.model.User;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class UserExcelListener extends AnalysisEventListener<User> {

    private static final Logger logger = LoggerFactory.getLogger(UserExcelListener.class);

    private List<User> list = new ArrayList<User>();
    private String orgId;
    private String userId;
    private UserDao userDao;

    public UserExcelListener(String orgId, String userId) {
        this.orgId = orgId;
        this.userId = userId;
    }

    /**
     * 这个每一条数据解析都会来调用
     *
     * @param analysisContext
     */
    @Override
    public void invoke(User user, AnalysisContext analysisContext) {
        if (StringUtils.isBlank(user.getName()) || StringUtils.isBlank(user.getPhone())) {
            return;
        }

        List<User> userList = getUserDao().queryByAccount(user.getPhone());
        if (CollectionUtils.isNotEmpty(userList)) {
            return;
        }

        if ("男".equals(user.getSexStr())) {
            user.setGender(1);
        } else if ("女".equals(user.getSexStr())) {
            user.setGender(2);
        } else { //未知
            user.setGender(3);
        }

        user.setId(KeyUtils.getKey());
        user.setOrgId(orgId);
        user.setPoliceNo(user.getPhone());
        user.setState(YesNoEnum.YES_ACCPET.getValue());
        user.setCreateTime(new Date());
        user.setPass(MD5Utils.encrypt(Constants.DEFAULT_PASSWORD));
        user.setIsSys(YesNoEnum.NO_CANCEL.getValue());
        list.add(user);
    }

    /**
     * 所有数据解析完成了 都会来调用
     *
     * @param analysisContext
     */
    @Override
    public void doAfterAllAnalysed(AnalysisContext analysisContext) {
        if (CollectionUtils.isEmpty(list)) {
            return;
        }

        TransactionTemplate transactionTemplate = SpringContextHelper.getBean(TransactionTemplate.class);
        transactionTemplate.execute(new TransactionCallback<Integer>() {
            @Override
            public Integer doInTransaction(TransactionStatus transactionStatus) {
                getUserDao().batchInsert(list);
                return 1;
            }
        });
    }

    public UserDao getUserDao() {
        if (userDao == null) {
            userDao = SpringContextHelper.getBean(UserDao.class);
        }
        return userDao;
    }
}
