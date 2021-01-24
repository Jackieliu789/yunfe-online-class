/**
 * OrganizationController.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.controller.base;

import com.applet.base.BaseController;
import com.applet.utils.*;
import com.yunfeisoft.enumeration.YesNoEnum;
import com.yunfeisoft.model.Organization;
import com.yunfeisoft.model.User;
import com.yunfeisoft.service.inter.OrganizationService;
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
import java.util.*;

/**
 * <p>ClassName: OrganizationController</p>
 * <p>Description: 组织机构Controller</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
/**
 * Created by Jackie Liu on 2017/3/18.
 */
@Controller
public class OrganizationController extends BaseController {

    @Autowired
    private OrganizationService organizationService;

    /**
     * 添加组织机构
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/organization/save", method = RequestMethod.POST)
    @ResponseBody
    public Response save(Organization record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "code", "请输入编码");
        validator.required(request, "name", "请输入名称");
        validator.required(request, "category", "请选择类别");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        boolean isDuplicate = organizationService.isDuplicateCode(record.getId(), record.getCode());
        if (isDuplicate) {
            return ResponseUtils.warn("该编码已经存在");
        }

        isDuplicate = organizationService.isDuplicateName(record.getId(), record.getName());
        if (isDuplicate) {
            return ResponseUtils.warn("该名称已经存在");
        }

        if (record.getParentId() == null) {
            record.setParentId(Constants.ROOT);
        }
        record.setId(KeyUtils.getKey());
        record.setCreateTime(new Date());
        organizationService.save(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 修改组织机构
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/organization/modify", method = RequestMethod.POST)
    @ResponseBody
    public Response modify(Organization record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "id", "参数错误");
        validator.required(request, "code", "请输入编码");
        validator.required(request, "name", "请输入名称");
        validator.required(request, "category", "请选择类别");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        boolean isDuplicate = organizationService.isDuplicateCode(record.getId(), record.getCode());
        if (isDuplicate) {
            return ResponseUtils.warn("该编码已经存在");
        }

        isDuplicate = organizationService.isDuplicateName(record.getId(), record.getName());
        if (isDuplicate) {
            return ResponseUtils.warn("该名称已经存在");
        }

        record.setParentId(null);
        organizationService.modify(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 查询组织机构
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/organization/query", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response query(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        Organization record = organizationService.queryById(id);
        if (record.getParentId() == null
                && !Constants.ROOT.equals(record.getParentId())) {
            Organization parent = organizationService.load(record.getParentId());
            record.setParentOrg(parent);
        }
        return ResponseUtils.success("success", record);
    }

    /**
     * 分页查询组织机构
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/organization/list", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response list(HttpServletRequest request, HttpServletResponse response) {
        String searchInput = ServletRequestUtils.getStringParameter(request, "searchInput", null);
        String parentId = ServletRequestUtils.getStringParameter(request, "parentId", null);

        Map<String, Object> params = new HashMap<String, Object>();
        initParams(params, request);
        params.remove("parentId");
        params.put("searchInput", searchInput);
        params.put("idPath", parentId);

        Page<Organization> page = organizationService.queryPage(params);
        return ResponseUtils.success(page);
    }

    /**
     * 拖拽组织机构信息改变从属节点
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/organization/drag", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response drag(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        String targetId = ServletRequestUtils.getStringParameter(request, "targetId", null);
        if (StringUtils.isBlank(id) || StringUtils.isBlank(targetId)) {
            return ResponseUtils.warn("拖拽参数错误");
        }

        organizationService.modifyWithDrag(id, targetId);
        return ResponseUtils.success("拖拽成功");
    }

    /**
     * 获取所有组织机构信息列表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/organization/tree", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response getTree(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> params = new HashMap<>();

        //传了名称，则根据名称进行模糊搜索
        String orgName = ServletRequestUtils.getStringParameter(request, "searchName", null);
        if (StringUtils.isNotEmpty(orgName)) {
            params.put("name", orgName);
        }

        User user = ApiUtils.getLoginUser();
        if (user.getIsSys() != YesNoEnum.YES_ACCPET.getValue()) {
            params.put("idPath", user.getTopOrgId());
        }

        List<Organization> list = organizationService.queryList(params);

        List<Tree> treeList = new ArrayList<Tree>();
        for (Organization record : list) {
            Tree tree = new Tree(record.getId(), record.getParentId(), record.getName());
            treeList.add(tree);
        }
        return ResponseUtils.success(treeList);
    }
}
