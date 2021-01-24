package com.yunfeisoft.controller.business;

import com.applet.base.BaseController;
import com.applet.utils.Page;
import com.applet.utils.Response;
import com.applet.utils.ResponseUtils;
import com.applet.utils.Validator;
import com.yunfeisoft.business.model.PmsLiveCourseAsk;
import com.yunfeisoft.business.service.inter.PmsLiveCourseAskService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

/**
 * ClassName: PmsLiveCourseAskController
 * Description: 直播课堂提问表Controller
 * Author: Jackie liu
 * Date: 2020-04-15
 */
@Controller
public class PmsLiveCourseAskController extends BaseController {

    @Autowired
    private PmsLiveCourseAskService pmsLiveCourseAskService;

    /**
     * 添加直播课堂提问表
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourseAsk/save", method = RequestMethod.POST)
    @ResponseBody
    public Response save(PmsLiveCourseAsk record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "liveCourseId", "直播课参数为空");
        validator.required(request, "content", "提问内容为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }
        pmsLiveCourseAskService.save(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 查询直播课堂提问表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourseAsk/query", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response query(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        PmsLiveCourseAsk record = pmsLiveCourseAskService.load(id);
        return ResponseUtils.success(record);
    }

    /**
     * 分页查询直播课堂提问表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourseAsk/list", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response list(HttpServletRequest request, HttpServletResponse response) {
        String liveCourseId = ServletRequestUtils.getStringParameter(request, "liveCourseId", "_no_");
        Map<String, Object> params = new HashMap<String, Object>();
        initParams(params, request);
        params.put("liveCourseId", liveCourseId);
        Page<PmsLiveCourseAsk> page = pmsLiveCourseAskService.queryPage(params);
        return ResponseUtils.success(page);
    }

    /**
     * 批量删除直播课堂提问表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourseAsk/delete", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response delete(HttpServletRequest request, HttpServletResponse response) {
        String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
        if (StringUtils.isBlank(ids)) {
            return ResponseUtils.warn("参数错误");
        }
        pmsLiveCourseAskService.remove(ids.split(","));
        return ResponseUtils.success("删除成功");
    }
}
