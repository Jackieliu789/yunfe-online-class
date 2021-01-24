package com.yunfeisoft.controller.business;

import com.applet.base.BaseController;
import com.applet.utils.*;
import com.yunfeisoft.business.enums.ShelfStatusEnum;
import com.yunfeisoft.business.model.PmsCourse;
import com.yunfeisoft.business.model.PmsCourseUser;
import com.yunfeisoft.business.service.inter.PmsCourseService;
import com.yunfeisoft.business.service.inter.PmsCourseUserService;
import com.yunfeisoft.enumeration.YesNoEnum;
import com.yunfeisoft.model.User;
import com.yunfeisoft.service.inter.DataService;
import com.yunfeisoft.utils.ApiUtils;
import com.yunfeisoft.utils.GenerateUserSig;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
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
 * ClassName: PmsCourseController
 * Description: 互动课堂-课程表Controller
 * Author: Jackie liu
 * Date: 2020-03-27
 */
@Controller
public class PmsCourseController extends BaseController {

    @Autowired
    private PmsCourseService pmsCourseService;
    @Autowired
    private DataService dataService;
    @Autowired
    private PmsCourseUserService pmsCourseUserService;
    @Autowired
    private GenerateUserSig generateUserSig;
    @Autowired
    private StringRedisTemplate redisTemplate;

    /**
     * 添加互动课堂-课程表
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourse/save", method = RequestMethod.POST)
    @ResponseBody
    public Response save(PmsCourse record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "name", "课程名称为空");
        validator.required(request, "coverPath", "课程封面为空");
        validator.required(request, "content", "课程详情为空");

        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        record.setId(KeyUtils.getKey());
        record.setShelfStatus(ShelfStatusEnum.UPPER_SHELF.getValue());
        record.setItemNum(0);
        record.setStudentNum(0);
        record.setOverItemNum(0);
        pmsCourseService.save(record);

        //textSearchHelper.addSubject(record.getId());
        return ResponseUtils.success("保存成功");
    }

    /**
     * 修改互动课堂-课程表
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourse/modify", method = RequestMethod.POST)
    @ResponseBody
    public Response modify(PmsCourse record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "id", "参数错误");
        validator.required(request, "name", "课程名称为空");
        validator.required(request, "coverPath", "课程封面为空");
        validator.required(request, "content", "课程详情为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }
        pmsCourseService.modify(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 查询互动课堂-课程表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourse/query", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response query(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        PmsCourse record = pmsCourseService.load(id);
        if (record != null) {
            String content = dataService.loadByRefId(id);
            record.setContent(content);
        }
        return ResponseUtils.success(record);
    }

    /**
     * 分页查询互动课堂-课程表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourse/list", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response list(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> params = new HashMap<String, Object>();
        initParams(params, request);

        User user = ApiUtils.getLoginUser();
        if (user.getIsSys() == YesNoEnum.NO_CANCEL.getValue()) {
            params.put("createId", user.getId());
        }

        Page<PmsCourse> page = pmsCourseService.queryPage(params);
        return ResponseUtils.success(page);
    }

    /**
     * 批量删除互动课堂-课程表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourse/delete", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response delete(HttpServletRequest request, HttpServletResponse response) {
        String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
        if (StringUtils.isBlank(ids)) {
            return ResponseUtils.warn("参数错误");
        }
        pmsCourseService.remove(ids.split(","));
        return ResponseUtils.success("删除成功");
    }

    /**
     * 下架互动课堂-课程表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourse/lowerShelf", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response lowerShelf(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        pmsCourseService.modifyShelfStatus(id, ShelfStatusEnum.LOWER_SHELF.getValue());
        return ResponseUtils.success("下架成功");
    }

    /**
     * 上架互动课堂-课程表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourse/upperShelf", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response upperShelf(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        pmsCourseService.modifyShelfStatus(id, ShelfStatusEnum.UPPER_SHELF.getValue());
        return ResponseUtils.success("上架成功");
    }

    /**
     * 添加互动课堂-老师信息
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourse/saveCourseTeacher", method = RequestMethod.POST)
    @ResponseBody
    public Response saveCourseTeacher(PmsCourseUser record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "courseId", "所属课程为空");
        validator.required(request, "userId", "所选老师为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        record.setType(PmsCourseUser.TypeEnum.TEACHER.getValue());
        pmsCourseUserService.save(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 添加互动课堂-学生信息
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourse/saveCourseStudent", method = RequestMethod.POST)
    @ResponseBody
    public Response saveCourseStudent(PmsCourseUser record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "courseId", "所属课程为空");
        validator.required(request, "userId", "所选学生为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        record.setType(PmsCourseUser.TypeEnum.STUDENT.getValue());
        pmsCourseUserService.saveCourseStudent(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 添加互动课堂-学生信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourse/saveCourseStudents", method = RequestMethod.POST)
    @ResponseBody
    public Response saveCourseStudents(HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "courseId", "所属课程为空");
        validator.required(request, "userIds", "所选学生为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        String userIds = ServletRequestUtils.getStringParameter(request, "userIds", null);
        String courseId = ServletRequestUtils.getStringParameter(request, "courseId", null);

        List<PmsCourseUser> pmsCourseUserList = new ArrayList<>();
        String[] ids = userIds.split(",");
        for (String id : ids) {
            PmsCourseUser record = new PmsCourseUser();
            record.setType(PmsCourseUser.TypeEnum.STUDENT.getValue());
            record.setCourseId(courseId);
            record.setUserId(id);
            pmsCourseUserList.add(record);
        }

        pmsCourseUserService.saveCourseStudents(courseId, pmsCourseUserList);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 查询互动课堂-老师信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourse/queryCourseTeacher", method = RequestMethod.POST)
    @ResponseBody
    public Response queryCourseUser(HttpServletRequest request, HttpServletResponse response) {
        String courseId = ServletRequestUtils.getStringParameter(request, "courseId", "_no_");

        Map<String, Object> params = new HashMap<>();
        params.put("courseId", courseId);
        params.put("type", PmsCourseUser.TypeEnum.TEACHER.getValue());

        List<PmsCourseUser> courseUsers = pmsCourseUserService.queryList(params);
        return ResponseUtils.success(courseUsers);
    }

    /**
     * 查询互动课堂-学生信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourse/queryCourseStudent", method = RequestMethod.POST)
    @ResponseBody
    public Response queryCourseStudent(HttpServletRequest request, HttpServletResponse response) {
        String courseId = ServletRequestUtils.getStringParameter(request, "courseId", "_no_");

        Map<String, Object> params = new HashMap<>();
        params.put("courseId", courseId);
        params.put("type", PmsCourseUser.TypeEnum.STUDENT.getValue());

        List<PmsCourseUser> courseUsers = pmsCourseUserService.queryList(params);
        return ResponseUtils.success(courseUsers);
    }

    /**
     * 删除互动课堂-用户信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourse/removeCourseUser", method = RequestMethod.POST)
    @ResponseBody
    public Response removeCourseUser(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        pmsCourseUserService.removeCourseStudent(id);
        return ResponseUtils.success("删除成功");
    }
}
