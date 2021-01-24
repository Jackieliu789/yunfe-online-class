package com.yunfeisoft.controller.business;

import com.applet.base.BaseController;
import com.applet.utils.Response;
import com.applet.utils.ResponseUtils;
import com.yunfeisoft.business.model.SysConfig;
import com.yunfeisoft.business.service.inter.SysConfigService;
import com.yunfeisoft.utils.SysConfigCache;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

/**
 * ClassName: SysConfigController
 * Description: 系统配置Controller
 * Author: Jackie liu
 * Date: 2019-11-05
 */
@Controller
public class SysConfigController extends BaseController {

    @Autowired
    private SysConfigService sysConfigService;
    @Autowired
    private SysConfigCache sysConfigCache;

    /**
     * 添加系统配置
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/sysConfig/save", method = RequestMethod.POST)
    @ResponseBody
    public Response save(HttpServletRequest request, HttpServletResponse response) {
        Enumeration<String> params = request.getParameterNames();
        List<SysConfig> configList = new ArrayList<>();
        while (params.hasMoreElements()) {
            String paramName = (String) params.nextElement();
            String paramValue = ServletRequestUtils.getStringParameter(request, paramName, null);
            if (StringUtils.isBlank(paramValue)) {
                paramValue = null;
            }
            SysConfig record = new SysConfig();
            record.setKey(paramName);
            record.setValue(paramValue);
            configList.add(record);
        }

        sysConfigService.batchSave(configList);
        sysConfigCache.cleanCache();
        return ResponseUtils.success("保存成功");
    }

    /**
     * 分页查询系统配置
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/sysConfig/list", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response list(HttpServletRequest request, HttpServletResponse response) {
        //Map<String, Object> params = new HashMap<String, Object>();
        //initParams(params, request);
        //Page<SysConfig> page = sysConfigService.queryPage(params);
        List<SysConfig> list = sysConfigService.queryList(null);
        return ResponseUtils.success(list);
    }
}
