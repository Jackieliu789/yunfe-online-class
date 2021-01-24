package com.yunfeisoft.controller.business;

import com.applet.base.BaseModel;
import com.applet.session.DomainModel;
import com.applet.session.SessionModel;
import com.applet.session.UserSession;
import com.applet.utils.AjaxUtils;
import com.applet.utils.WebUtils;
import com.yunfeisoft.utils.SysConfigCache;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Jackie Liu on 2017/3/18.
 */
@Controller
public class ViewController {

    private Logger log = LoggerFactory.getLogger(ViewController.class);

    @Autowired
    private DomainModel domainModel;
    @Value("${file.request.url}")
    private String fileRequestUrl;
    @Value("${netty.url}")
    private String webSocketUrl;
    @Autowired
    private SysConfigCache sysConfigCache;
    @Autowired
    private UserSession userSession;

    /**
     * js、css页面随机参数，防止缓存
     */
    private static final long PAGE_RANDOM = System.currentTimeMillis();

    @RequestMapping("/view/{dir1}/{dir2}/{page}")
    public String view(@PathVariable("dir1") String dir1, @PathVariable("dir2") String dir2, @PathVariable("page") String page, HttpServletRequest request) {
        if (StringUtils.isEmpty(dir1) || StringUtils.isEmpty(dir2)
                || StringUtils.isEmpty(page)) {
            return "404";
        }
        gainParams(request);
        return dir1 + "/" + dir2 + "/" + page;
    }

    @RequestMapping("/view/{dir}/{page}")
    public String view(@PathVariable("dir") String dir, @PathVariable("page") String page, HttpServletRequest request) {
        if (StringUtils.isEmpty(dir) || StringUtils.isEmpty(page)) {
            return "404";
        }
        gainParams(request);
        return dir + "/" + page;
    }

    @RequestMapping("/{page}")
    public String page(@PathVariable("page") String page, HttpServletRequest request) {
        if (StringUtils.isEmpty(page)) {
            return "404";
        }
        gainParams(request);
        return page;
    }

    @RequestMapping("/v/index")
    public String index(HttpServletRequest request) {
        gainParams(request);
        Map<String, String> configMap = sysConfigCache.getConfig();
        if ("1".equals(configMap.get("leafletFlag"))) {
            return "index";
        }
        return "login";
    }

    private void gainParams(HttpServletRequest request) {
        Map<String, Object> paramsMap = new HashMap<String, Object>();
        WebUtils.gainParams(paramsMap);
        request.setAttribute("params", paramsMap);

        paramsMap.put("contextPath", domainModel.getWebDomain());
        paramsMap.put("pageRandom", PAGE_RANDOM);
        paramsMap.put("fileRequestUrl", fileRequestUrl);
        paramsMap.put("webSocketUrl", webSocketUrl);

        Map<String, String> configMap = sysConfigCache.getConfig();
        if (MapUtils.isNotEmpty(configMap)) {
            paramsMap.putAll(configMap);
        }

        SessionModel sessionModel = userSession.getSessionModel();
        if (sessionModel != null) {
            BaseModel user = sessionModel.getUser();
            request.setAttribute("user", user);
        }
    }

    @RequestMapping("/web/keepAlive")
    public void keepAlive(HttpServletRequest request, HttpServletResponse response) {
        AjaxUtils.ajaxJsonSuccessMessage("SUCCESS");
    }

    @RequestMapping("/json")
    public void json(@RequestBody String jsonStr) {
        log.info("jsonStr = " + jsonStr);
    }
}
