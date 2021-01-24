/**
 * RoleController.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.controller.base;

import com.applet.base.BaseController;
import com.applet.utils.*;
import com.yunfeisoft.enumeration.YesNoEnum;
import com.yunfeisoft.model.Role;
import com.yunfeisoft.model.User;
import com.yunfeisoft.service.inter.RoleService;
import com.yunfeisoft.service.inter.RoleUserService;
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
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>ClassName: RoleController</p>
 * <p>Description: 角色管理Controller</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
/**
 * Created by Jackie Liu on 2017/3/18.
 */
@Controller
public class RoleController extends BaseController {

	@Autowired
	private RoleService roleService;
	@Autowired
	private RoleUserService roleUserService;

	/**
	 * 添加角色管理
	 *
	 * @param record
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/web/role/save", method = RequestMethod.POST)
	@ResponseBody
	public Response save(Role record, HttpServletRequest request, HttpServletResponse response) {
		Validator validator = new Validator();
		validator.required(request, "name", "角色名称不能为空");
		validator.required(request, "isSys", "系统角色不能为空");
		if (validator.isError()) {
			return ResponseUtils.warn(validator.getMessage());
		}
		Boolean duplicateName = roleService.isDuplicateName(record.getId(), record.getName());
		if(duplicateName){
			return ResponseUtils.warn("该角色名称已存在");
		}
		record.setId(KeyUtils.getKey());
		Date date = new Date();
		record.setCreateTime(date);
		User user = ApiUtils.getLoginUser();
		record.setCreateId(user.getId());
		record.setState(YesNoEnum.YES_ACCPET.getValue());
		roleService.save(record);
		return ResponseUtils.success("添加信息成功");
	}

	/**
	 * 修改角色管理
	 *
	 * @param record
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/web/role/modify", method = RequestMethod.POST)
	@ResponseBody
	public Response modify(Role record, HttpServletRequest request) {
		Validator validator = new Validator();
		validator.required(request, "id", "参数错误");
		validator.required(request, "name", "角色名称不能为空");
		validator.required(request, "isSys", "系统角色不能为空");
		if (validator.isError()) {
			return ResponseUtils.warn(validator.getMessage());
		}
		Boolean duplicateName = roleService.isDuplicateName(record.getId(), record.getName());
		if(duplicateName){
			return ResponseUtils.warn("该角色名称已存在");
		}
		roleService.modify(record);
		return ResponseUtils.success("修改成功");
	}

	/**
	 * 查询角色管理
	 *
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/web/role/query", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Response query(HttpServletRequest request, HttpServletResponse response) {
		String id = ServletRequestUtils.getStringParameter(request, "id", null);
		if (StringUtils.isBlank(id)) {
			return ResponseUtils.warn("参数错误");
		}
		Role record = roleService.load(id);
		return ResponseUtils.success(record);
	}

	/**
	 * 分页查询角色管理
	 *
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/web/role/list", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Response list(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> params = new HashMap<String, Object>();
		String name = ServletRequestUtils.getStringParameter(request, "name", null);
		params.put("name", name);
		initParams(params, request);
		Page<Role> data = roleService.queryPage(params);
 		return ResponseUtils.success(data);
	}

	/**
	 * 查询所有可用的角色信息
	 *
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/web/role/availableList", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Response availableList(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("state", YesNoEnum.YES_ACCPET.getValue());
		List<Role> data = roleService.query(params);
		return ResponseUtils.success(data);
	}

	/**
	 * 获取某用户配置的角色
	 *
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/web/role/queryByUserId", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Response queryByUserId(HttpServletRequest request, HttpServletResponse response) {
		String userId = ServletRequestUtils.getStringParameter(request, "userId", null);
		if (StringUtils.isBlank(userId)) {
			return ResponseUtils.warn("参数错误");
		}
		List<Role> data = roleService.queryByUserId(userId);
		return ResponseUtils.success(data);
	}

	/**
	 * 配置某用户的角色
	 *
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/web/role/addUserRole", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Response addUserRole(HttpServletRequest request, HttpServletResponse response) {
		String userId = ServletRequestUtils.getStringParameter(request, "userId", null);
		if (StringUtils.isBlank(userId)) {
			return ResponseUtils.warn("参数错误");
		}

		String roleIdStr = ServletRequestUtils.getStringParameter(request, "roleIds", "");
		String[] array = roleIdStr.split(",");

		roleUserService.save(userId, array);
		return ResponseUtils.success("保存成功");
	}

	/**
	 * 批量删除角色信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/web/role/delete", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Response remove(HttpServletRequest request) {
		String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
		if (StringUtils.isEmpty(ids)) {
			return ResponseUtils.warn("请选中删除信息");
		}
		roleService.batchRemove(ids.split(","));
		return ResponseUtils.success("删除成功");
	}

	/**
	 * 批量停用角色信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/web/role/stop", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Response stop(HttpServletRequest request) {
		String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
		if (StringUtils.isEmpty(ids)) {
			return ResponseUtils.warn("请选中停用角色信息");
		}
		roleService.modifyState(ids.split(","), YesNoEnum.NO_CANCEL.getValue());
		return ResponseUtils.success("停用成功");
	}

	/**
	 * 批量启用角色信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/web/role/accpet", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Response accept(HttpServletRequest request) {
		String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
		if (StringUtils.isEmpty(ids)) {
			return ResponseUtils.warn("请选中启用角色信息");
		}
		roleService.modifyState(ids.split(","), YesNoEnum.YES_ACCPET.getValue());
		return ResponseUtils.success("启用成功");
	}

    /**
     * 删除角色的用户
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/web/role/removeUser", method = { RequestMethod.POST, RequestMethod.GET })
    @ResponseBody
    public Response removeUser(HttpServletRequest request) {
		String roleId = ServletRequestUtils.getStringParameter(request, "roleId", null);
		String userId = ServletRequestUtils.getStringParameter(request, "userId", null);
        if (StringUtils.isBlank(roleId) || StringUtils.isBlank(userId)) {
            return ResponseUtils.warn("参数错误");
        }
        roleUserService.remove(userId, roleId);
        return ResponseUtils.success("删除成功");
    }
}
