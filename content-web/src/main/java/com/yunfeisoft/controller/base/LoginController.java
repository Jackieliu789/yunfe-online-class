/**
 * LoginController.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.controller.base;

import com.applet.base.BaseController;
import com.applet.session.SessionModel;
import com.applet.session.UserSession;
import com.applet.utils.*;
import com.applet.weixin.WXOpenApi;
import com.applet.weixin.model.WXAppletOpenId;
import com.yunfeisoft.enumeration.YesNoEnum;
import com.yunfeisoft.model.Menu;
import com.yunfeisoft.model.Organization;
import com.yunfeisoft.model.Role;
import com.yunfeisoft.model.User;
import com.yunfeisoft.service.inter.MenuService;
import com.yunfeisoft.service.inter.OrganizationService;
import com.yunfeisoft.service.inter.RoleService;
import com.yunfeisoft.service.inter.UserService;
import com.yunfeisoft.utils.ApiUtils;
import com.yunfeisoft.utils.SysConfigCache;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: LoginController</p>
 * <p>Description: 用户登录Controller</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Controller
public class LoginController extends BaseController {

    @Autowired
    private UserService userService;
    @Autowired
    private UserSession userSession;
    @Autowired
    private MenuService menuService;
    @Autowired
    private OrganizationService organizationService;
    @Autowired
    private RoleService roleService;
    @Value("${log.open}")
    private boolean logOpen;
    @Autowired
    private WXOpenApi wxOpenApi;
    @Autowired
    private SysConfigCache sysConfigCache;
    @Value("${file.request.url}")
    private String fileRequestUrl;

    /**
     * 用户登录
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/loginIn", method = RequestMethod.POST)
    @ResponseBody
    public Response login(HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "account", "账号为空");
        validator.required(request, "pass", "密码为空");
        //validator.required(request, "yzmCode", "验证码为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        String account = ServletRequestUtils.getStringParameter(request, "account", null);
        String pass = ServletRequestUtils.getStringParameter(request, "pass", null);

        List<User> userList = userService.queryByAccount(account);

        if (userList.isEmpty()) {
            return ResponseUtils.warn("该账号不存在");
        }
        if (userList.size() > 1) {
            return ResponseUtils.warn("该账号重复，请联系管理员");
        }

        User user = userList.get(0);
        if (!MD5Utils.validPassword(pass, user.getPass())) {
            return ResponseUtils.warn("密码错误");
        }
        boolean isComplexPass = ValidateUtils.validatePasswordReg2(pass);
        if (!isComplexPass) {
            user.setSimplePass(true);
        }
        getAuthority(user);

        SessionModel sessionModel = new SessionModel();
        sessionModel.setUser(user);
        sessionModel.setToken(KeyUtils.getKey());
        user.setToken(sessionModel.getToken());

        userSession.storageSessionModel(sessionModel);
        request.setAttribute(Constants.SESSION_MODEL, sessionModel);

        String openId = request.getHeader("authority-id");
        if (StringUtils.isNotBlank(openId)) {
            User us = new User();
            us.setId(user.getId());
            us.setOpenId(openId);
            userService.modify(us);
        }

        return ResponseUtils.success("success", "/view/frame/index.htm");
    }

    /**
     * 微信用户绑定账号
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/applet/bindAccount", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response bindAccount(HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "account", "账号为空");
        validator.required(request, "pass", "密码为空");
        validator.required(request, "openId", "OpenId为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        String account = ServletRequestUtils.getStringParameter(request, "account", null);
        String pass = ServletRequestUtils.getStringParameter(request, "pass", null);

        List<User> userList = userService.queryByAccount(account);

        if (userList.isEmpty()) {
            return ResponseUtils.warn("该账号不存在");
        }
        if (userList.size() > 1) {
            return ResponseUtils.warn("该账号重复，请联系管理员");
        }

        User user = userList.get(0);
        if (!MD5Utils.validPassword(pass, user.getPass())) {
            return ResponseUtils.warn("密码错误");
        }

        SessionModel sessionModel = new SessionModel();
        sessionModel.setUser(user);
        sessionModel.setToken(KeyUtils.getKey());
        user.setToken(sessionModel.getToken());

        userSession.storageSessionModel(sessionModel);
        request.setAttribute(Constants.SESSION_MODEL, sessionModel);

        String openId = ServletRequestUtils.getStringParameter(request, "openId", null);
        User modifyUser = new User();
        modifyUser.setId(user.getId());
        modifyUser.setOpenId(openId);
        userService.modify(modifyUser);

        return ResponseUtils.success("success", sessionModel.getToken());
    }

    /**
     * 微信用户使用openId登录
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/applet/loginIn", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response appletLogin(HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "openId", "OpenId为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        String openId = ServletRequestUtils.getStringParameter(request, "openId", null);

        List<User> userList = userService.queryByOpenId(openId);

        if (userList.isEmpty()) {
            return ResponseUtils.warn("该账号不存在");
        }
        if (userList.size() > 1) {
            return ResponseUtils.warn("该账号重复，请联系管理员");
        }

        User user = userList.get(0);
        SessionModel sessionModel = new SessionModel();
        sessionModel.setUser(user);
        sessionModel.setToken(openId);
        user.setToken(sessionModel.getToken());

        userSession.storageSessionModel(sessionModel);
        request.setAttribute(Constants.SESSION_MODEL, sessionModel);

        return ResponseUtils.success("success", sessionModel.getToken());
    }

    /**
     * 获取微信openId
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/applet/getOpenid", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response getOpenid(HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "code", "Code为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        String code = ServletRequestUtils.getStringParameter(request, "code", null);
        WXAppletOpenId appletOpenId = wxOpenApi.getAppletOpenId(code);
        if (appletOpenId == null) {
            return ResponseUtils.warn("获取认证信息失败");
        }

        String openId = appletOpenId.getOpenid();
        if (StringUtils.isBlank(openId)) {
            return ResponseUtils.warn("获取认证ID信息失败");
        }

        /*List<User> userList = userService.queryByOpenId(openId);
        if (CollectionUtils.isEmpty(userList)) {
            String name = ServletRequestUtils.getStringParameter(request, "name", null);
            String headimgurl = ServletRequestUtils.getStringParameter(request, "headimgurl", null);

            User user = new User();
            user.setName(name);
            user.setState(YesNoEnum.YES_ACCPET.getValue());
            user.setHeadPhoto(headimgurl);
            user.setIsSys(YesNoEnum.NO_CANCEL.getValue());
            user.setOpenId(openId);

            Map<String, String> config = sysConfigCache.getConfig();
            user.setOrgId(config.get("defaultOrgId"));
            userService.save(user);
        }*/

        return ResponseUtils.success("success", appletOpenId);
    }

    /**
     * 获取用户的角色、菜单、组织机构信息
     *
     * @param user 登录用户实例
     */
    private void getAuthority(User user) {
        if (user.getIsSys() == YesNoEnum.YES_ACCPET.getValue()) {
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("state", YesNoEnum.YES_ACCPET.getValue());
            List<Menu> menuList = menuService.query(params);
            user.setMenuList(menuList);
        } else {
            List<Role> roleList = roleService.queryByUserId(user.getId());
            List<Menu> menuList = menuService.queryByUserId(user.getId());

            user.setRoleList(roleList);
            user.setMenuList(menuList);
        }

        Organization organization = organizationService.load(user.getOrgId());
        user.setOrganization(organization);
    }

    /**
     * 用户登出
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/loginOut", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response loginOut(HttpServletRequest request, HttpServletResponse response) {
        /*if (userSession instanceof ServletSession && sessionModel != null) {
            ServletSession servletSession = (ServletSession) userSession;
            servletSession.removeKeys(sessionModel.getUser().getId(), sessionModel.getToken());
            log.info("Login out UserSession remove device keys by user id : " + sessionModel.getUser().getId());
        }*/

        userSession.removeSession();
        log.info("Login out UserSession remove");
        return ResponseUtils.success("安全退出成功");
    }

    /**
     * 微信用户获取微信菜单
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/queryMenus", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response queryMenus(HttpServletRequest request, HttpServletResponse response) {
        User user = ApiUtils.getLoginUser();
        List<Menu> menuList = null;
        if (user.getIsSys() == YesNoEnum.YES_ACCPET.getValue()) {
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("state", YesNoEnum.YES_ACCPET.getValue());
            menuList = menuService.query(params);
        } else {
            menuList = menuService.queryByUserId(user.getId());
        }

        List<Menu> list = new ArrayList<>();
        for (Menu menu : menuList) {
            if (menu.getCategory() != Menu.Category.APPLET.getValue()) {
                continue;
            }
            list.add(menu);
        }

        return ResponseUtils.success(list);
    }

    /**
     * 获取登录用户信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/loginUser", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response loginUser(HttpServletRequest request, HttpServletResponse response) {
        User user = ApiUtils.getLoginUser();
        return ResponseUtils.success(user);
    }

    /**
     * 登录验证码
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/yzm", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public void yzm(HttpServletRequest request, HttpServletResponse response) {
        // 设置响应的类型格式为图片格式
        response.setContentType("image/jpeg");
        //禁止图像缓存。
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);


        VerifyCode vCode = new VerifyCode(100, 40, 4, 10);
        userSession.setVerifyCode(vCode.getCode());
        //session.setAttribute("code", vCode.getCode());
        try {
            vCode.write(response.getOutputStream());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取参数信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/config", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response webConfig(HttpServletRequest request, HttpServletResponse response) {
        Map<String, String> config = sysConfigCache.getConfig();

        Map<String, String> configMap = new HashMap<>();
        configMap.putAll(config);
        configMap.remove("videoSecret");

        String logoImagePath = configMap.get("logoImagePath");
        if (StringUtils.isNotBlank(logoImagePath)) {
            String loginImageUrl = new StringBuilder().append(fileRequestUrl)
                    .append(logoImagePath).toString();
            configMap.put("logoImagePath", loginImageUrl);
        }

        return ResponseUtils.success(configMap);
    }

    /**
     * 获取参数信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/config/get", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response miniAppConfig(HttpServletRequest request, HttpServletResponse response) {
        Map<String, String> config = sysConfigCache.getConfig();

        Map<String, String> configMap = new HashMap<>();
        configMap.putAll(config);
        configMap.remove("videoSecret");

        String logoImagePath = configMap.get("logoImagePath");
        if (StringUtils.isNotBlank(logoImagePath)) {
            String loginImageUrl = new StringBuilder().append(fileRequestUrl)
                    .append(logoImagePath).toString();
            configMap.put("logoImagePath", loginImageUrl);
        }

        return ResponseUtils.success("success", configMap.get("miniAppCheck"));
    }

    /**
     * 记录日志
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/log", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response log(HttpServletRequest request, HttpServletResponse response) {
        Constants.is_log = true;
        return ResponseUtils.success(Constants.is_log);
    }

    /**
     * 不记录日志
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/unLog", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response isLog(HttpServletRequest request, HttpServletResponse response) {
        Constants.is_log = false;
        return ResponseUtils.success(Constants.is_log);
    }
}
