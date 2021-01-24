/**
 * UserController.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.controller.base;

import com.alibaba.excel.EasyExcel;
import com.applet.base.BaseController;
import com.applet.utils.*;
import com.yunfeisoft.enumeration.YesNoEnum;
import com.yunfeisoft.model.Organization;
import com.yunfeisoft.model.User;
import com.yunfeisoft.service.inter.OrganizationService;
import com.yunfeisoft.service.inter.UserService;
import com.yunfeisoft.utils.ApiUtils;
import com.yunfeisoft.utils.UserExcelListener;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

/**
 * <p>ClassName: UserController</p>
 * <p>Description: 用户管理Controller</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Controller
public class UserController extends BaseController {

    @Autowired
    private UserService userService;
    @Autowired
    private OrganizationService organizationService;

    /**
     * 添加用户管理
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/save", method = RequestMethod.POST)
    @ResponseBody
    public Response save(User record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "orgId", "所属组织机构为空");
        validator.required(request, "name", "姓名为空");
        validator.required(request, "policeNo", "警号为空");
        validator.required(request, "phone", "手机号码为空");
        validator.mobile(request, "phone", "手机号码格式非法");
        //validator.required(request, "idcard", "身份证号为空");
        //validator.idCard(request, "idcard", "身份证号码格式非法");
        validator.required(request, "pass", "登录密码为空");
        validator.email(request, "email", "Email格式非法");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        boolean exist = userService.isDuplicateName(record.getId(), record.getOrgId(), record.getName());
        if (exist) {
            return ResponseUtils.warn("该名称已经存在");
        }

        exist = userService.isDuplicatePoliceNo(record.getId(), record.getPoliceNo());
        if (exist) {
            return ResponseUtils.warn("该警号已经存在");
        }

        /*exist = userService.isDuplicateIdCard(record.getId(), record.getIdcard());
        if (exist) {
            return ResponseUtils.warn("该身份证号已经存在");
        }*/

        String pass = ServletRequestUtils.getStringParameter(request, "pass", Constants.DEFAULT_PASSWORD);
        record.setId(KeyUtils.getKey());
        record.setState(YesNoEnum.YES_ACCPET.getValue());
        record.setCreateTime(new Date());
        record.setPass(MD5Utils.encrypt(pass));
        record.setIsSys(YesNoEnum.NO_CANCEL.getValue());
        userService.save(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 修改用户管理
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/modify", method = RequestMethod.POST)
    @ResponseBody
    public Response modify(User record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "id", "参数错误");
        validator.required(request, "orgId", "所属组织机构为空");
        validator.required(request, "name", "姓名为空");
        validator.required(request, "policeNo", "警号为空");
        validator.required(request, "phone", "手机号码为空");
        validator.mobile(request, "phone", "手机号码格式非法");
        //validator.required(request, "idcard", "身份证号为空");
        //validator.idCard(request, "idcard", "身份证号码格式非法");
        validator.email(request, "email", "Email格式非法");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        boolean exist = userService.isDuplicateName(record.getId(), record.getOrgId(), record.getName());
        if (exist) {
            return ResponseUtils.warn("该名称已经存在");
        }

        exist = userService.isDuplicatePoliceNo(record.getId(), record.getPoliceNo());
        if (exist) {
            return ResponseUtils.warn("该警号已经存在");
        }

        /*exist = userService.isDuplicateIdCard(record.getId(), record.getIdcard());
        if (exist) {
            return ResponseUtils.warn("该身份证号已经存在");
        }*/

        userService.modify(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 修改用户个人资料
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/modifyInfo", method = RequestMethod.POST)
    @ResponseBody
    public Response modifyInfo(User record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "name", "姓名为空");
        validator.required(request, "phone", "手机号码为空");
        validator.mobile(request, "phone", "手机号码格式非法");
        validator.email(request, "email", "Email格式非法");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        User user = ApiUtils.getLoginUser();

        boolean exist = userService.isDuplicateName(user.getId(), record.getOrgId(), record.getName());
        if (exist) {
            return ResponseUtils.warn("该名称已经存在");
        }

        record.setId(user.getId());
        userService.modify(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 修改用户密码
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/modifyPass", method = RequestMethod.POST)
    @ResponseBody
    public Response modifyPass(HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "oldPass", "原密码为空");
        validator.required(request, "newPass", "新密码为空");
        validator.required(request, "confirmPass", "确认密码为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        String oldPass = ServletRequestUtils.getStringParameter(request, "oldPass", null);
        String newPass = ServletRequestUtils.getStringParameter(request, "newPass", null);
        String confirmPass = ServletRequestUtils.getStringParameter(request, "confirmPass", null);

        User loginUser = ApiUtils.getLoginUser();
        loginUser.setSimplePass(null);
        User user = userService.load(loginUser.getId());

        if (!MD5Utils.validPassword(oldPass, user.getPass())) {
            return ResponseUtils.warn("原密码错误");
        }

        if (!newPass.equals(confirmPass)) {
            return ResponseUtils.warn("新密码和确认密码不一致");
        }

        if (!ValidateUtils.validatePasswordReg2(newPass)) {
            return ResponseUtils.warn("新密码格式不合法");
        }

        User record = new User();
        record.setId(user.getId());
        record.setPass(MD5Utils.encrypt(newPass));
        userService.modify(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 查询用户管理
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/query", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response query(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        User user = userService.queryById(id);
        if (user != null && user.getOrgId() != null) {
            Organization organization = organizationService.load(user.getOrgId());
            user.setOrganization(organization);
        }
        return ResponseUtils.success("success", user);
    }

    /**
     * 分页查询用户管理
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/list", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response list(HttpServletRequest request, HttpServletResponse response) {
        String searchInput = ServletRequestUtils.getStringParameter(request, "searchInput", null);
        String orgId = ServletRequestUtils.getStringParameter(request, "orgId", null);

        Map<String, Object> params = new HashMap<String, Object>();
        initParams(params, request);
        params.put("searchInput", searchInput);
        params.put("orgId", orgId);

        Page<User> page = userService.queryPage(params);
        return ResponseUtils.success(page);
    }

    /**
     * 批量停用
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/stop", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response stop(HttpServletRequest request, HttpServletResponse response) {
        String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
        if (StringUtils.isEmpty(ids)) {
            return ResponseUtils.warn("请勾选用户");
        }
        String[] idArr = ids.split(",");
        userService.modifyState(idArr, YesNoEnum.NO_CANCEL.getValue());
        return ResponseUtils.success("停用成功");
    }

    /**
     * 批量启用用户信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/accept", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response accept(HttpServletRequest request, HttpServletResponse response) {
        String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
        if (StringUtils.isEmpty(ids)) {
            return ResponseUtils.warn("请勾选用户");
        }
        String[] idArr = ids.split(",");
        userService.modifyState(idArr, YesNoEnum.YES_ACCPET.getValue());
        return ResponseUtils.success("启用成功");
    }

    /**
     * 变更用户单位信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/changeOrg", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response changeOrg(HttpServletRequest request, HttpServletResponse response) {
        String userId = ServletRequestUtils.getStringParameter(request, "userId", null);
        String orgId = ServletRequestUtils.getStringParameter(request, "orgId", null);
        if (StringUtils.isBlank(userId)) {
            return ResponseUtils.warn("参数错误");
        }
        if (StringUtils.isBlank(orgId)) {
            return ResponseUtils.warn("请选中单位");
        }

        User user = new User();
        user.setId(userId);
        user.setOrgId(orgId);
        userService.modify(user);
        return ResponseUtils.success("变更成功");
    }

    /**
     * 批量删除用户信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/remove", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response remove(HttpServletRequest request, HttpServletResponse response) {
        String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
        if (StringUtils.isEmpty(ids)) {
            return ResponseUtils.warn("参数错误");
        }
        String[] idArr = ids.split(",");
        userService.remove(idArr);
        return ResponseUtils.success("删除成功");
    }

    /**
     * 根据角色id获取用户信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/queryByRoleId", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response queryByRoleId(HttpServletRequest request, HttpServletResponse response) {
        String roleId = ServletRequestUtils.getStringParameter(request, "roleId", null);
        if (StringUtils.isBlank(roleId)) {
            return ResponseUtils.warn("参数错误");
        }
        List<User> userList = userService.queryByRoleId(roleId);
        return ResponseUtils.success("success", userList);
    }


    /**
     * 根据组织机构ID获取该组织及其下属组织的警员信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/queryByOrgId", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response queryByOrgId(HttpServletRequest request, HttpServletResponse response) {
        //获取当前登录人信息
        User loginUser = ApiUtils.getLoginUser();
        List<User> userList = userService.queryByOrgId(loginUser.getOrgId());

        List<Tree> treeList = new ArrayList<Tree>();
        for (User user : userList) {
            Tree tree = new Tree(user.getId(), user.getOrgId(), user.getName(), user);
            treeList.add(tree);
        }
        return ResponseUtils.success(treeList);
    }

    /**
     * 批量重置用户密码
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/resetPass", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response resetPass(HttpServletRequest request, HttpServletResponse response) {
        String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
        if (StringUtils.isEmpty(ids)) {
            return ResponseUtils.warn("参数错误");
        }
        String[] idArr = ids.split(",");
        userService.modifyPass(idArr, MD5Utils.encrypt(Constants.DEFAULT_PASSWORD));
        return ResponseUtils.success("重置密码成功");
    }

    /**
     * 选择用户弹框
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/userList", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response userList(HttpServletRequest request, HttpServletResponse response) {
        String searchInput = ServletRequestUtils.getStringParameter(request, "name", null);
        Map<String, Object> params = new HashMap<String, Object>();
        initParams(params, request);
        params.put("searchInput", searchInput);
        Page<User> page = userService.queryPage(params);
        return ResponseUtils.success(page);
    }

    /**
     * 选择用户弹框
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/queryList", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response queryList(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> params = new HashMap<String, Object>();
        initParams(params, request);
        params.put("state", YesNoEnum.YES_ACCPET.getValue());

        List<User> list = userService.queryList(params);
        return ResponseUtils.success(list);
    }

    /**
     * 组织机构用户树
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/userOrgTree", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response userOrgTree(HttpServletRequest request, HttpServletResponse response) {
        User loginUser = ApiUtils.getLoginUser();

        Map<String, Object> params = new HashMap<String, Object>();
        if (loginUser.getIsSys() != YesNoEnum.YES_ACCPET.getValue()) {
            params.put("idPath", new String[]{loginUser.getTopOrgId()});
        }
        List<Organization> orgList = organizationService.queryList(params);

        List<String> idList = new ArrayList<>();
        List<Map<String, Object>> resultList = new ArrayList<>();
        for (Organization organization : orgList) {
            idList.add(organization.getId());

            Map<String, Object> item = new HashMap<>();
            item.put("id", organization.getId());
            item.put("pId", organization.getParentId());
            item.put("name", organization.getName());
            item.put("isUser", false);
            resultList.add(item);
        }

        params.clear();
        params.put("state", YesNoEnum.YES_ACCPET.getValue());
        params.put("orgIds", idList);

        List<User> list = userService.queryList(params);

        for (User user : list) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", user.getId());
            item.put("pId", user.getOrgId());
            item.put("name", user.getName());
            item.put("isUser", true);
            resultList.add(item);
        }
        return ResponseUtils.success(resultList);
    }

    /**
     * 导入excel
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/user/importExcel", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response importExcel(@RequestParam("file") MultipartFile file, HttpServletRequest request, HttpServletResponse response) {
        String orgId = ServletRequestUtils.getStringParameter(request, "_orgId", null);
        if (StringUtils.isBlank(orgId)) {
            return ResponseUtils.warn("请选择所属组织机构");
        }
        if (file == null) {
            return ResponseUtils.warn("读取上传Excel为空");
        }
        try {
            User user = ApiUtils.getLoginUser();
            EasyExcel.read(file.getInputStream(), User.class, new UserExcelListener(orgId, user.getId())).sheet().doRead();
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseUtils.success("解析导入文件异常");
        }
        return ResponseUtils.success("导入成功");
    }
}