/**
 * MenuController.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.controller.base;

import com.applet.base.BaseController;
import com.applet.utils.*;
import com.yunfeisoft.enumeration.YesNoEnum;
import com.yunfeisoft.model.Menu;
import com.yunfeisoft.service.inter.MenuService;
import com.yunfeisoft.service.inter.RoleMenuService;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: MenuController</p>
 * <p>Description: 菜单管理Controller</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
@Controller
public class MenuController extends BaseController {

    @Autowired
    private MenuService menuService;
    @Autowired
    private RoleMenuService roleMenuService;

    /**
     * 添加菜单管理
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/menu/save", method = RequestMethod.POST)
    @ResponseBody
    public Response save(Menu record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "name", "菜单名称不能为空");
        validator.required(request, "category", "菜单类型不能为空");
        validator.required(request, "code", "菜单编号不能为空");
        validator.required(request, "orderBy", "排序序号不能为空");
        validator.zIndex(request, "orderBy", "排序序号非法");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }
        Boolean duplicateName = menuService.isDuplicateName(record.getId(), record.getName());
        if (duplicateName) {
            return ResponseUtils.warn("该名称已存在");
        }
        Boolean duplicateCode = menuService.isDuplicateCode(record.getId(), record.getCode());
        if (duplicateCode) {
            return ResponseUtils.warn("该编号已存在");
        }
        record.setId(KeyUtils.getKey());
        record.setState(YesNoEnum.YES_ACCPET.getValue());
        String parentId = ServletRequestUtils.getStringParameter(request, "parentId", Constants.ROOT);
        if (StringUtils.isBlank(parentId)) {
            parentId = Constants.ROOT;
            record.setParentId(parentId);
        }
        menuService.save(record);
        return ResponseUtils.success("信息添加成功");
    }

    /**
     * 修改菜单管理
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/menu/modify", method = RequestMethod.POST)
    @ResponseBody
    public Response modify(Menu record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "id", "参数错误");
        validator.required(request, "name", "菜单名称不能为空");
        validator.required(request, "category", "菜单类型不能为空");
        validator.required(request, "code", "菜单编号不能为空");
        validator.required(request, "orderBy", "排序序号不能为空");
        validator.zIndex(request, "orderBy", "排序序号非法");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }
        Boolean duplicateName = menuService.isDuplicateName(record.getId(), record.getName());
        if (duplicateName) {
            return ResponseUtils.warn("该名称已存在");
        }
        Boolean duplicateCode = menuService.isDuplicateCode(record.getId(), record.getCode());
        if (duplicateCode) {
            return ResponseUtils.warn("该编号已存在");
        }
        menuService.modify(record);
        return ResponseUtils.success("修改成功");
    }

    /**
     * 查询菜单管理
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/menu/query", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response query(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        Menu record = menuService.load(id);
        if (!Constants.ROOT.equals(record.getParentId())) {
            Menu parent = menuService.load(record.getParentId());
            record.setParent(parent);
        }
        return ResponseUtils.success(record);

    }

    /**
     * 分页查询菜单管理
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/menu/list", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response list(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> params = new HashMap<String, Object>();
        String searchInput = ServletRequestUtils.getStringParameter(request, "searchInput", null);
        String parentId = ServletRequestUtils.getStringParameter(request, "parentId", null);

        params.put("searchInput", searchInput);
        params.put("parentId", parentId);
        initParams(params, request);

        Page<Menu> data = menuService.queryPage(params);
        return ResponseUtils.success(data);
    }

    /**
     * 查询所有可用的菜单
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/menu/availableList", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response availableList(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("state", YesNoEnum.YES_ACCPET.getValue());
        List<Menu> data = menuService.query(params);
        List<Tree> treeList = new ArrayList<Tree>();
        for (Menu menu : data) {
            Tree tree = new Tree(menu.getId(), menu.getParentId(), menu.getName());
            treeList.add(tree);
        }
        return ResponseUtils.success(treeList);
    }

    /**
     * 拖拽组织机构信息改变从属节点
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/menu/drag", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response drag(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        String targetId = ServletRequestUtils.getStringParameter(request, "targetId", null);
        if (StringUtils.isBlank(id) || StringUtils.isBlank(targetId)) {
            return ResponseUtils.warn("拖拽参数错误");
        }

        menuService.modifyWithDrag(id, targetId);
        return ResponseUtils.success("拖拽成功");
    }

    /**
     * 批量删除菜单
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/web/menu/delete", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Response remove(HttpServletRequest request) {
        String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
        if (StringUtils.isEmpty(ids)) {
            return ResponseUtils.warn("请选择要删除的菜单");
        }
        menuService.batchRemove(ids.split(","));
        return ResponseUtils.success("删除成功");
    }

    /**
     * 禁用菜单，该操作会级联禁用其子菜单
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/web/menu/stop", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Response stop(HttpServletRequest request) {
        String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
        if (StringUtils.isEmpty(ids)) {
            return ResponseUtils.warn("请选择停用 的菜单");
        }
        String[] idArray = ids.split(",");
        List<String> childrenIds = new ArrayList<>();
        for (int i = 0; i < idArray.length; i++) {
            List<Menu> list = menuService.queryChildren(idArray[i]);
            for (Menu menu : list) {
                childrenIds.add(menu.getId());
            }
        }
        ApiUtils.removeDuplicate(childrenIds);
        menuService.modifyState(childrenIds.toArray(new String[0]), YesNoEnum.NO_CANCEL.getValue());
        return ResponseUtils.success("停用成功");
    }

    /**
     * 启用菜单信息,只级联其父类菜单
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/web/menu/accept", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Response accept(HttpServletRequest request) {
        String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
        if (StringUtils.isEmpty(ids)) {
            return ResponseUtils.warn("请选择启用的菜单");
        }
        String[] idArray = ids.split(",");
        List<String> parentIds = new ArrayList<>();
        for (int i = 0; i < idArray.length; i++) {
            List<Menu> list = menuService.queryParentList(idArray[i]);
            for (Menu menu : list) {
                parentIds.add(menu.getId());
            }
        }
        ApiUtils.removeDuplicate(parentIds);
        menuService.modifyState(parentIds.toArray(new String[0]), YesNoEnum.YES_ACCPET.getValue());
        return ResponseUtils.success("启用成功");
    }

    /**
     * 菜单树列表
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/web/menu/tree", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Response tree(HttpServletRequest request) {
        List<Tree> treeList = new ArrayList<Tree>();
        Map<String, Object> params = new HashMap<>();
        List<Menu> menuList = menuService.query(params);
        for (Menu menu : menuList) {
            Tree tree = new Tree(menu.getId(), menu.getParentId(), menu.getName(), menu);
            treeList.add(tree);
        }
        return ResponseUtils.success(treeList);
    }

    /**
     * 获取某角色的菜单树列表
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/web/menu/queryTreeByRoleId", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Response queryTreeByRoleId(HttpServletRequest request) {
        String roleId = ServletRequestUtils.getStringParameter(request, "roleId", null);
        if (StringUtils.isBlank(roleId)) {
            return ResponseUtils.warn("参数错误");
        }
        List<Tree> treeList = new ArrayList<Tree>();
        List<Menu> menuList = menuService.queryByRoleId(roleId);
        for (Menu menu : menuList) {
            Tree tree = new Tree(menu.getId(), menu.getParentId(), menu.getName());
            treeList.add(tree);
        }
        return ResponseUtils.success(treeList);
    }

    /**
     * 保存某角色的菜单
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/web/menu/saveRoleMenu", method = {RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Response saveRoleMenu(HttpServletRequest request) {
        String roleId = ServletRequestUtils.getStringParameter(request, "roleId", null);
        if (StringUtils.isBlank(roleId)) {
            return ResponseUtils.warn("参数错误");
        }

        String menuIdStr = ServletRequestUtils.getStringParameter(request, "menuIds", "");
        roleMenuService.save(roleId, menuIdStr.split(","));
        return ResponseUtils.success("保存成功");
    }
}
