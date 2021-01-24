/**
 * PositionController.java
 * Created at 2017-07-06
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.controller.base;

import com.applet.base.BaseController;
import com.applet.utils.*;
import com.yunfeisoft.enumeration.YesNoEnum;
import com.yunfeisoft.model.Position;
import com.yunfeisoft.service.inter.PositionService;
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
import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**
 * <p>ClassName: PositionController</p>
 * <p>Description: 职务管理Controller</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-06</p>
 */
/**
 * Created by Jackie Liu on 2017/3/18.
 */

@Controller
public class PositionController extends BaseController {

	@Autowired
	private PositionService positionService;

	/**
	 * 添加职务管理
	 *
	 * @param record
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/web/position/save", method = RequestMethod.POST)
	@ResponseBody
	public Response save(Position record, HttpServletRequest request, HttpServletResponse response) {
		Validator validator = new Validator();
		validator.required(request, "name", "名称输入不能为空");
		validator.required(request, "code", "编码不能为空");
		if (validator.isError()) {
			return ResponseUtils.warn(validator.getMessage());
		}
		Boolean duplicateName = positionService.isDuplicateName(record.getId(), record.getName());
		if(duplicateName){
			return ResponseUtils.warn("该职务名称已存在");
		}
		Boolean duplicateCode = positionService.isDuplicateCode(record.getId(), record.getCode());
		if(duplicateCode){
			return ResponseUtils.warn("该职务编码已存在");
		}
		Date date = new Date();
		record.setCreateTime(date);
		record.setId(KeyUtils.getKey());
		record.setState(YesNoEnum.YES_ACCPET.getValue());

		positionService.save(record);
		return ResponseUtils.success("保存成功");
	}

	/**
	 * 修改职务管理
	 *
	 * @param record
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/web/position/modify", method = RequestMethod.POST)
	@ResponseBody
	public Response modify(Position record, HttpServletRequest request, HttpServletResponse response) {
		Validator validator = new Validator();
		validator.required(request, "id", "参数错误");
		validator.required(request, "name", "名称输入不能为空");
		validator.required(request, "code", "编码不能为空");
		if (validator.isError()) {
			return ResponseUtils.warn(validator.getMessage());
		}
		Boolean duplicateName = positionService.isDuplicateName(record.getId(), record.getName());
		if(duplicateName){
			return ResponseUtils.warn("该职务名称已存在");
		}
		Boolean duplicateCode = positionService.isDuplicateCode(record.getId(), record.getCode());
		if(duplicateCode){
			return ResponseUtils.warn("该职务编码已存在");
		}
		positionService.modify(record);
		return ResponseUtils.success("修改成功");
	}

	/**
	 * 查询职务管理
	 *
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/web/position/query", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Response query(HttpServletRequest request, HttpServletResponse response) {
		String id = ServletRequestUtils.getStringParameter(request, "id", null);
		if (StringUtils.isBlank(id)) {
			return ResponseUtils.warn("参数错误");
		}
		Position record = positionService.load(id);
		return ResponseUtils.success(record);
	}

	/**
	 * 分页查询职务管理
	 *
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/web/position/list", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public PageResponse list(HttpServletRequest request, HttpServletResponse response) {
		HashMap<String, Object> params = new HashMap<String, Object>();
		String searchInput = ServletRequestUtils.getStringParameter(request, "searchInput", null);
		params.put("searchInput", searchInput);
		initParams(params, request);
		Page<Position> data = positionService.queryPage(params);
		return ResponseUtils.success(data);
	}
	
	@RequestMapping(value = "/web/position/queryTree", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response queryTree(HttpServletRequest request, HttpServletResponse response) {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("rows", 10000);
		Page<Position> page = positionService.queryPage(params);
        List<Position> list = page.getData();
        List<Tree> treeList = new ArrayList<Tree>();
        for (Position position : list) {
            Tree tree = new Tree(position.getId(), Constants.ROOT, position.getName(), position);
            treeList.add(tree);
        }
        return ResponseUtils.success(treeList);
    }

	/**
	 * 删除职务列表信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "/web/position/delete", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Response remove(HttpServletRequest request) {
		String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
		if (StringUtils.isEmpty(ids)) {
			return ResponseUtils.warn("没有选中删除记录");
		}
		String[] arr = ids.split(",");
		positionService.batchRemove(arr);
		return ResponseUtils.success("删除成功");
	}

	/**
	 * 停用职务
	 * 
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/web/position/stop", method = { RequestMethod.POST, RequestMethod.GET })
	public Response stop(HttpServletRequest request, HttpServletResponse response) {
		String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
		if (StringUtils.isEmpty(ids)) {
			return ResponseUtils.warn("请选择启用的职务");
		}
		positionService.modifyState(ids.split(","), YesNoEnum.NO_CANCEL.getValue());
		return ResponseUtils.success("停用成功");
	}

	/**
	 * 启用职务
	 * 
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/web/position/accpet", method = { RequestMethod.POST, RequestMethod.GET })
	public Response accpet(HttpServletRequest request, HttpServletResponse response) {
		String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
		if (StringUtils.isEmpty(ids)) {
			return ResponseUtils.warn("参数错误");
		}
		positionService.modifyState(ids.split(","), YesNoEnum.YES_ACCPET.getValue());
		return ResponseUtils.success("启用成功");
	}
}
