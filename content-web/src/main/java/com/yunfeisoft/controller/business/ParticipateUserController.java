package com.yunfeisoft.controller.business;

import com.applet.base.BaseController;
import com.applet.excel.BuildFileCallBack;
import com.applet.excel.ExportXlsFileTemplate;
import com.applet.excel.FileExport;
import com.applet.utils.*;
import com.yunfeisoft.business.model.ParticipateUser;
import com.yunfeisoft.business.service.inter.ParticipateUserService;
import com.yunfeisoft.model.User;
import com.yunfeisoft.utils.ApiUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * ClassName: ParticipateUserController
 * Description: 课程参与用户(进入直播间上课的用户)Controller
 * Author: Jackie liu
 * Date: 2020-05-26
 */
@Controller
public class ParticipateUserController extends BaseController {

    @Autowired
    private ParticipateUserService participateUserService;

    /**
     * 添加课程参与用户(进入直播间上课的用户)
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/participateUser/save", method = RequestMethod.POST)
    @ResponseBody
    public Response save(ParticipateUser record, HttpServletRequest request, HttpServletResponse response) {
        String roomId = ServletRequestUtils.getStringParameter(request, "roomId", null);
        if (StringUtils.isBlank(roomId)) {
            return ResponseUtils.warn("房间号为空，无法保存进度");
        }

        User user = ApiUtils.getLoginUser();
        record.setUserId(user.getId());
        record.setModifyTime(new Date());

        participateUserService.modifyTime(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 修改课程参与用户(进入直播间上课的用户)
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    /*@RequestMapping(value = "/web/participateUser/modify", method = RequestMethod.POST)
    @ResponseBody
    public Response modify(ParticipateUser record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "id", "参数错误");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }
        participateUserService.modify(record);
        return ResponseUtils.success("保存成功");
    }*/

    /**
     * 查询课程参与用户(进入直播间上课的用户)
     *
     * @param request
     * @param response
     * @return
     */
    /*@RequestMapping(value = "/web/participateUser/query", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response query(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        ParticipateUser record = participateUserService.load(id);
        return ResponseUtils.success(record);
    }*/

    /**
     * 分页查询课程参与用户(进入直播间上课的用户)
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/participateUser/list", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response list(HttpServletRequest request, HttpServletResponse response) {
        String roomId = ServletRequestUtils.getStringParameter(request, "roomId", "_no_");

        Map<String, Object> params = new HashMap<String, Object>();
        initParams(params, request);
        params.put("roomId", roomId);

        Page<ParticipateUser> page = participateUserService.queryPage(params);
        return ResponseUtils.success(page);
    }

    /**
     * 批量删除课程参与用户(进入直播间上课的用户)
     *
     * @param request
     * @param response
     * @return
     */
    /*@RequestMapping(value = "/web/participateUser/delete", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response delete(HttpServletRequest request, HttpServletResponse response) {
        String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
        if (StringUtils.isBlank(ids)) {
            return ResponseUtils.warn("参数错误");
        }
        participateUserService.remove(ids.split(","));
        return ResponseUtils.success("删除成功");
    }*/

    /**
     * 导出信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/participateUser/export", method = {RequestMethod.POST, RequestMethod.GET})
    public void exportFile(HttpServletRequest request, HttpServletResponse response) {
        try {
            String roomId = ServletRequestUtils.getStringParameter(request, "roomId", "_no_");

            Map<String, Object> params = new HashMap<String, Object>();
            params.put("roomId", roomId);
            List<ParticipateUser> list = participateUserService.queryList(params);

            final FileExport<ParticipateUser> exp = new ExportXlsFileTemplate<>(list, response);
            exp.setTitle(new String[]{"姓名", "进入时间", "离开时间", "时长"});
            exp.buildFile(new BuildFileCallBack<ParticipateUser>() {
                @Override
                public void execute(ParticipateUser t) {
                    exp.appendData(t.getUserName());
                    exp.appendData(t.getCreateTimeStr());
                    exp.appendData(t.getModifyTimeStr());
                    exp.appendData(t.getDuration());
                }
            });
            exp.write(response, "pu_" + DateUtils.getNowTime());
        } catch (IOException e) {
            e.printStackTrace();
            AjaxUtils.ajaxJsonErrorMessage("导出失败");
        }
    }
}
