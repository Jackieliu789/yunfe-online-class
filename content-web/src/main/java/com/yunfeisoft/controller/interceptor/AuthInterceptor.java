package com.yunfeisoft.controller.interceptor;

import com.applet.session.DomainModel;
import com.applet.session.SessionModel;
import com.applet.session.UserSession;
import com.applet.utils.AjaxUtils;
import com.applet.utils.Constants;
import com.yunfeisoft.service.inter.UserService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 登录验证拦截器
 */
public class AuthInterceptor extends HandlerInterceptorAdapter {

    private static final Logger log = Logger.getLogger(AuthInterceptor.class);

    @Autowired
    private UserSession userSession;
    @Autowired
    private DomainModel domainModel;
    @Autowired
    private UserService userService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        SessionModel sessionModel = userSession.getSessionModel();
        if (sessionModel != null) {
            request.setAttribute(Constants.SESSION_MODEL, sessionModel);
            userSession.resetSessionTime();
            return true;
        }
        String uri = request.getRequestURI().replaceFirst(request.getContextPath(), "");
        if (uri.startsWith("/view")) {
            response.sendRedirect(domainModel.getWebDomain() + "/time-out.htm");
        } else {
            AjaxUtils.ajaxJsonErrorMessage("会话失效，请重新登录");
        }
        return false;
    }

}
