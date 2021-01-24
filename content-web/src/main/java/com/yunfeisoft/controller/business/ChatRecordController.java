package com.yunfeisoft.controller.business;

import com.applet.base.BaseController;
import com.applet.excel.BuildFileCallBack;
import com.applet.excel.ExportXlsFileTemplate;
import com.applet.excel.FileExport;
import com.applet.utils.*;
import com.yunfeisoft.business.model.ChatRecord;
import com.yunfeisoft.business.service.inter.ChatRecordService;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * ClassName: ChatRecordController
 * Description: 聊天记录Controller
 * Author: Jackie liu
 * Date: 2020-05-26
 */
@Controller
public class ChatRecordController extends BaseController {

    @Autowired
    private ChatRecordService chatRecordService;

    /**
     * 添加聊天记录
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    /*@RequestMapping(value = "/web/chatRecord/save", method = RequestMethod.POST)
    @ResponseBody
    public Response save(ChatRecord record, HttpServletRequest request, HttpServletResponse response) {
        chatRecordService.save(record);
        return ResponseUtils.success("保存成功");
    }*/

    /**
     * 修改聊天记录
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    /*@RequestMapping(value = "/web/chatRecord/modify", method = RequestMethod.POST)
    @ResponseBody
    public Response modify(ChatRecord record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "id", "参数错误");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }
        chatRecordService.modify(record);
        return ResponseUtils.success("保存成功");
    }*/

    /**
     * 查询聊天记录
     *
     * @param request
     * @param response
     * @return
     */
    /*@RequestMapping(value = "/web/chatRecord/query", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response query(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        ChatRecord record = chatRecordService.load(id);
        return ResponseUtils.success(record);
    }*/

    /**
     * 分页查询聊天记录
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/chatRecord/list", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response list(HttpServletRequest request, HttpServletResponse response) {
        String roomId = ServletRequestUtils.getStringParameter(request, "roomId", "_no_");

        Map<String, Object> params = new HashMap<String, Object>();
        initParams(params, request);
        params.put("roomId", roomId);

        Page<ChatRecord> page = chatRecordService.queryPage(params);
        return ResponseUtils.success(page);
    }

    /**
     * 批量删除聊天记录
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/chatRecord/delete", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response delete(HttpServletRequest request, HttpServletResponse response) {
        String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
        if (StringUtils.isBlank(ids)) {
            return ResponseUtils.warn("参数错误");
        }
        chatRecordService.remove(ids.split(","));
        return ResponseUtils.success("删除成功");
    }

    /**
     * 导出信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/chatRecord/export", method = {RequestMethod.POST, RequestMethod.GET})
    public void exportFile(HttpServletRequest request, HttpServletResponse response) {
        try {
            String roomId = ServletRequestUtils.getStringParameter(request, "roomId", "_no_");

            Map<String, Object> params = new HashMap<String, Object>();
            params.put("roomId", roomId);
            List<ChatRecord> list = chatRecordService.queryList(params);

            final FileExport<ChatRecord> exp = new ExportXlsFileTemplate<>(list, response);
            exp.setTitle(new String[]{"姓名", "内容", "时间"});
            exp.buildFile(new BuildFileCallBack<ChatRecord>() {
                @Override
                public void execute(ChatRecord t) {
                    exp.appendData(t.getUserName());
                    exp.appendData(t.getContent());//
                    exp.appendData(t.getCreateTimeStr());
                }
            });
            exp.write(response, "chat_" + DateUtils.getNowTime());
        } catch (IOException e) {
            e.printStackTrace();
            AjaxUtils.ajaxJsonErrorMessage("导出失败");
        }
    }
}
