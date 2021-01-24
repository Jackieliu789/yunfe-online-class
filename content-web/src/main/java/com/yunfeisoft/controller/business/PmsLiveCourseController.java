package com.yunfeisoft.controller.business;

import com.applet.base.BaseController;
import com.applet.base.BaseModel;
import com.applet.file.FileOperation;
import com.applet.session.DomainModel;
import com.applet.session.SessionModel;
import com.applet.session.UserSession;
import com.applet.thread.ThreadPoolManager;
import com.applet.utils.*;
import com.applet.weixin.WXOpenApi;
import com.applet.weixin.model.WXACode;
import com.yunfeisoft.business.enums.ClassStatusEnum;
import com.yunfeisoft.business.enums.ShelfStatusEnum;
import com.yunfeisoft.business.model.PmsLiveCourse;
import com.yunfeisoft.business.model.PmsLiveCourseUser;
import com.yunfeisoft.business.service.inter.PmsLiveCourseService;
import com.yunfeisoft.business.service.inter.PmsLiveCourseUserService;
import com.yunfeisoft.enumeration.YesNoEnum;
import com.yunfeisoft.model.Attachment;
import com.yunfeisoft.model.User;
import com.yunfeisoft.service.inter.AttachmentService;
import com.yunfeisoft.service.inter.DataService;
import com.yunfeisoft.task.ParticipateUserSaveTask;
import com.yunfeisoft.utils.ApiUtils;
import com.yunfeisoft.utils.GenerateUserSig;
import com.yunfeisoft.utils.SysConfigCache;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * ClassName: PmsLiveCourseController
 * Description: 直播课堂表Controller
 * Author: Jackie liu
 * Date: 2020-03-29
 */
@Controller
public class PmsLiveCourseController extends BaseController {

    @Autowired
    private PmsLiveCourseService pmsLiveCourseService;
    @Autowired
    private DataService dataService;
    @Autowired
    private GenerateUserSig generateUserSig;
    @Autowired
    private StringRedisTemplate redisTemplate;
    @Autowired
    private UserSession userSession;
    @Autowired
    private DomainModel domainModel;
    @Autowired
    private SysConfigCache sysConfigCache;
    @Autowired
    private WXOpenApi wxOpenApi;
    @Autowired
    private FileOperation fileOperation;
    @Autowired
    private AttachmentService attachmentService;
    @Autowired
    private PmsLiveCourseUserService pmsLiveCourseUserService;
    @Autowired
    private ThreadPoolManager threadPoolManager;

    /**
     * 添加直播课堂表
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/save", method = RequestMethod.POST)
    @ResponseBody
    public Response save(PmsLiveCourse record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "name", "直播名称为空");
        validator.required(request, "coverPath", "直播封面为空");
        validator.required(request, "beginDate", "上课开始时间为空");
        validator.required(request, "endDate", "上课结束时间为空");
        validator.required(request, "inviteCode", "邀请码为空");
        validator.required(request, "content", "直播详情为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        if (StringUtils.isNotBlank(record.getInviteCode())) {
            record.setInviteCode(MD5Utils.encrypt(record.getInviteCode()));
        }

        User user = ApiUtils.getLoginUser();

        record.setId(KeyUtils.getKey());
        record.setShelfStatus(ShelfStatusEnum.UPPER_SHELF.getValue());
        record.setClassStatus(ClassStatusEnum.NOT_BEGIN.getValue());
        record.setTeacherId(user.getId());
        record.setType(PmsLiveCourse.LiveCourseTypeEnum.SINGLE.getValue());

        pmsLiveCourseService.save(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 修改直播课堂表
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/modify", method = RequestMethod.POST)
    @ResponseBody
    public Response modify(PmsLiveCourse record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "id", "参数错误");
        validator.required(request, "name", "直播名称为空");
        validator.required(request, "coverPath", "直播封面为空");
        validator.required(request, "beginDate", "上课开始时间为空");
        validator.required(request, "endDate", "上课结束时间为空");
        validator.required(request, "inviteCode", "邀请码为空");
        validator.required(request, "content", "直播详情为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }
        record.setInviteCode(null);
        pmsLiveCourseService.modify(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 查询直播课堂表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/query", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response query(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        PmsLiveCourse record = pmsLiveCourseService.load(id);
        if (record != null) {
            String content = dataService.loadByRefId(id);
            record.setContent(content);
        }
        return ResponseUtils.success(record);
    }

    /**
     * 分页查询直播课堂表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/list", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response list(HttpServletRequest request, HttpServletResponse response) {
        String name = ServletRequestUtils.getStringParameter(request, "name", null);

        Map<String, Object> params = new HashMap<String, Object>();
        initParams(params, request);
        params.put("name", name);

        User user = ApiUtils.getLoginUser();
        if (user.getIsSys() == YesNoEnum.NO_CANCEL.getValue()) {
            params.put("createId", user.getId());
        }

        Page<PmsLiveCourse> page = pmsLiveCourseService.queryPage(params);
        return ResponseUtils.success(page);
    }

    /**
     * 批量删除直播课堂表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/delete", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response delete(HttpServletRequest request, HttpServletResponse response) {
        String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
        if (StringUtils.isBlank(ids)) {
            return ResponseUtils.warn("参数错误");
        }
        pmsLiveCourseService.remove(ids.split(","));
        return ResponseUtils.success("删除成功");
    }

    /**
     * 下架直播课程
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/lowerShelf", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response lowerShelf(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        pmsLiveCourseService.modifyShelfStatus(id, ShelfStatusEnum.LOWER_SHELF.getValue());
        return ResponseUtils.success("下架成功");
    }

    /**
     * 上架直播课程
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/upperShelf", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response upperShelf(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        pmsLiveCourseService.modifyShelfStatus(id, ShelfStatusEnum.UPPER_SHELF.getValue());
        return ResponseUtils.success("上架成功");
    }

    /**
     * 设置授课老师信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/saveTeacher", method = RequestMethod.POST)
    @ResponseBody
    public Response saveTeacher(HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "id", "参数错误");
        validator.required(request, "teacherId", "所选老师为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        String teacherId = ServletRequestUtils.getStringParameter(request, "teacherId", null);

        PmsLiveCourse pmsLiveCourse = new PmsLiveCourse();
        pmsLiveCourse.setId(id);
        pmsLiveCourse.setTeacherId(teacherId);
        pmsLiveCourseService.modify2(pmsLiveCourse);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 设置邀请码
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/modifyInviteCode", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response modifyInviteCode(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        String inviteCode = ServletRequestUtils.getStringParameter(request, "inviteCode", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        if (StringUtils.isBlank(inviteCode)) {
            return ResponseUtils.warn("邀请码为空");
        }
        pmsLiveCourseService.modifyInviteCode(id, MD5Utils.encrypt(inviteCode));
        return ResponseUtils.success("设置邀请码成功");
    }

    /**
     * 删除邀请码
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/removeInviteCode", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response removeInviteCode(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        pmsLiveCourseService.modifyInviteCode(id, null);
        return ResponseUtils.success("清除邀请码成功");
    }

    /**
     * 查询我的直播课堂表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/queryMyList", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response queryMyList(HttpServletRequest request, HttpServletResponse response) {
        String date = ServletRequestUtils.getStringParameter(request, "date", DateUtils.getNowTime());
        String beginDate = date + " 00:00:00";
        String endDate = date + " 23:59:59";

        User user = ApiUtils.getLoginUser();
        Map<String, Object> params = new HashMap<>();
        params.put("beginDate", beginDate);
        params.put("endDate", endDate);
        params.put("userId", user.getId());

        List<PmsLiveCourse> list = pmsLiveCourseService.queryList(params);
        return ResponseUtils.success(list);
    }

    private void saveParticipateUser(String roomId) {
        User user = ApiUtils.getLoginUser();
        if (user == null || StringUtils.isBlank(user.getId())) {
            return;
        }

        threadPoolManager.executeTask(new ParticipateUserSaveTask(roomId, user.getId()));
    }

    /**
     * 老师进入直播课堂
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/toClassRoom", method = RequestMethod.POST)
    @ResponseBody
    public Response toClassRoom(HttpServletRequest request, HttpServletResponse response) {
        String cid = ServletRequestUtils.getStringParameter(request, "cid", null);
        if (StringUtils.isBlank(cid)) {
            return ResponseUtils.warn("参数错误");
        }

        User user = ApiUtils.getLoginUser();
        String userId = user.getId();

        //加载内容到缓存
        PmsLiveCourse course = pmsLiveCourseService.load(cid);

        if (course.getClassStatus() == ClassStatusEnum.OVER.getValue()) {
            return ResponseUtils.warn("该课程已结束直播");
        }

        course.setIntro(null);
        String data = FastJsonUtils.objToJson(course);
        long time = DateUtils.timeDiff(course.getBeginDate(), course.getEndDate());
        redisTemplate.opsForValue().set(course.getId(), data, time + 10, TimeUnit.MINUTES);

        //如果不需要邀请码返回签名、课程名称
        String userSig = generateUserSig.genUserSig(userId);
        String screenSig = generateUserSig.genUserSig(userId + "_screen");
        String url = "";
        if (course.getType() != null && course.getType() == PmsLiveCourse.LiveCourseTypeEnum.MULTI.getValue()) {
            url = String.format("/view/business/pmsLiveCourse/course_live_multi.htm?cid=%s&s=%s&sc=%s&n=%s&rid=%d&cp=%s", cid, userSig, screenSig, course.getName(), course.getRoomId(), course.getCoverPath());
        } else {
            url = String.format("/view/business/pmsLiveCourse/course_live.htm?cid=%s&s=%s&sc=%s&n=%s&rid=%d&cp=%s", cid, userSig, screenSig, course.getName(), course.getRoomId(), course.getCoverPath());
        }
        saveParticipateUser(cid);
        return ResponseUtils.success("success", url);
    }

    /**
     * 分享页面判断去哪个课程页面
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/live/course/share/{id}", method = {RequestMethod.POST, RequestMethod.GET})
    public String toStudentClassRoom(@PathVariable("id") String id, HttpServletRequest request, HttpServletResponse response) {
        if (StringUtils.isBlank(id)) {
            return "redirect:" + domainModel.getWebDomain() + "/share_error.htm?error=1";
        }

        //缓存获取课程
        String data = redisTemplate.opsForValue().get(id);
        if (StringUtils.isBlank(data)) {
            return "redirect:" + domainModel.getWebDomain() + "/share_error.htm?error=2";
        }
        PmsLiveCourse course = FastJsonUtils.jsonToObj(data, PmsLiveCourse.class);

        if (course.getClassStatus() == ClassStatusEnum.OVER.getValue()) {
            return "redirect:" + domainModel.getWebDomain() + "/share_error.htm?error=3";
        }

        long time = DateUtils.timeDiff(new Date(), course.getBeginDate());
        if (time > 10) {
            return "redirect:" + domainModel.getWebDomain() + "/share_error.htm?error=4&date=" + DateUtils.dateTimeToString(course.getBeginDate());
        }

        //判断是否需要邀请码
        if (StringUtils.isNotBlank(course.getInviteCode())) {
            return "redirect:" + domainModel.getWebDomain() + "/live_code_check.htm?cid=" + id;
        }

        //返回课程名称、用户签名
        SessionModel sessionModel = userSession.getSessionModel();
        BaseModel baseModel = null;
        if (sessionModel == null) {
            User user = new User();
            user.setId(KeyUtils.getKey());
            user.setName("邀请码临时用户");

            sessionModel = new SessionModel();
            sessionModel.setUser(user);
            sessionModel.setToken(user.getId());
            user.setToken(sessionModel.getToken());

            userSession.storageSessionModel(sessionModel);
            request.setAttribute(Constants.SESSION_MODEL, sessionModel);

            baseModel = user;
        } else {
            baseModel = sessionModel.getUser();
        }

        //如果不需要邀请码返回签名、课程名称
        String userSig = generateUserSig.genUserSig(baseModel.getId());

        String url = "";
        if (course.getType() != null && course.getType() == PmsLiveCourse.LiveCourseTypeEnum.MULTI.getValue()) {
            url = String.format("%s/view/business/pmsLiveCourse/course_live_multi_stu.htm?cid=%s&s=%s&n=%s&rid=%d&cp=%s", domainModel.getWebDomain(), id, userSig, course.getName(), course.getRoomId(), course.getCoverPath());
        } else {
            url = String.format("%s/view/business/pmsLiveCourse/course_live_stu.htm?cid=%s&s=%s&n=%s&rid=%d&cp=%s", domainModel.getWebDomain(), id, userSig, course.getName(), course.getRoomId(), course.getCoverPath());
        }
        saveParticipateUser(id);
        return "redirect:" + url;
    }

    /**
     * 判断去哪个课程页面
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/liveCourse/check/invit/code", method = RequestMethod.POST)
    @ResponseBody
    public Response checkInvitCodeMiniApp(HttpServletRequest request, HttpServletResponse response) {
        return checkInvitCode(request, response);
    }

    /**
     * 判断去哪个课程页面
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/pmsLiveCourse/check/invit/code", method = RequestMethod.POST)
    @ResponseBody
    public Response checkInvitCode(HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "cid", "课程参数错误");
        validator.required(request, "code", "邀请码为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        String cid = ServletRequestUtils.getStringParameter(request, "cid", null);
        String code = ServletRequestUtils.getStringParameter(request, "code", null);

        //缓存获取code
        String data = redisTemplate.opsForValue().get(cid);
        if (StringUtils.isBlank(data)) {
            return ResponseUtils.warn("请等待主讲人进入直播间");
        }
        PmsLiveCourse course = FastJsonUtils.jsonToObj(data, PmsLiveCourse.class);
        //验证code是否正确
        if (!MD5Utils.validPassword(code, course.getInviteCode())) {
            return ResponseUtils.warn("邀请码不正确");
        }

        //返回课程名称、用户签名
        SessionModel sessionModel = userSession.getSessionModel();
        BaseModel baseModel = null;
        if (sessionModel == null) {
            User user = new User();
            user.setId(KeyUtils.getKey());
            user.setName("邀请码临时用户");

            sessionModel = new SessionModel();
            sessionModel.setUser(user);
            sessionModel.setToken(user.getId());
            user.setToken(sessionModel.getToken());

            userSession.storageSessionModel(sessionModel);
            request.setAttribute(Constants.SESSION_MODEL, sessionModel);

            baseModel = user;
        } else {
            baseModel = sessionModel.getUser();
        }

        String userSig = generateUserSig.genUserSig(baseModel.getId());

        String app = ServletRequestUtils.getStringParameter(request, "app", null);
        if ("miniapp".equals(app)) {
            Map<String, String> config = sysConfigCache.getConfig();
            Map<String, Object> resultMap = new HashMap<>();
            resultMap.put("videoKey", config.get("videoKey"));
            resultMap.put("cid", cid);
            resultMap.put("userSig", userSig);
            resultMap.put("n", course.getName());
            resultMap.put("uid", baseModel.getId());
            resultMap.put("rid", course.getRoomId());
            resultMap.put("hid", course.getTeacherId());
            resultMap.put("coverPath", course.getCoverPath());

            User user = (User) sessionModel.getUser();
            if (user != null) {
                resultMap.put("userName", user.getName());
                resultMap.put("userPhoto", user.getHeadPhoto());
            }
            saveParticipateUser(cid);
            return ResponseUtils.success("success", resultMap);
        }

        String url = "";
        if (course.getType() != null && course.getType() == PmsLiveCourse.LiveCourseTypeEnum.MULTI.getValue()) {
            url = String.format("/view/business/pmsLiveCourse/course_live_multi_stu.htm?cid=%s&s=%s&n=%s&rid=%d&cp=%s", cid, userSig, course.getName(), course.getRoomId(), course.getCoverPath());
        } else {
            url = String.format("/view/business/pmsLiveCourse/course_live_stu.htm?cid=%s&s=%s&n=%s&rid=%d&cp=%s", cid, userSig, course.getName(), course.getRoomId(), course.getCoverPath());
        }
        saveParticipateUser(cid);
        return ResponseUtils.success("success", url);
    }

    /**
     * 小程序端分享码进入课堂
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/liveCourse/share", method = RequestMethod.POST)
    @ResponseBody
    public Response toStudentMiniappClassRoom(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("该直播间不存在");
        }

        //缓存获取课程
        String data = redisTemplate.opsForValue().get(id);
        if (StringUtils.isBlank(data)) {
            return ResponseUtils.warn("请等待主讲人进入直播间");
        }
        PmsLiveCourse course = FastJsonUtils.jsonToObj(data, PmsLiveCourse.class);

        if (course.getClassStatus() == ClassStatusEnum.OVER.getValue()) {
            return ResponseUtils.warn("该课程已结束直播");
        }

        //判断是否需要邀请码
        if (StringUtils.isNotBlank(course.getInviteCode())) {
            return ResponseUtils.warn("inviteCode");
        }

        User user = ApiUtils.getLoginUser();
        //如果不需要邀请码返回签名、课程名称
        String userSig = generateUserSig.genUserSig(user.getId());

        Map<String, String> config = sysConfigCache.getConfig();
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("videoKey", config.get("videoKey"));
        resultMap.put("cid", id);
        resultMap.put("userSig", userSig);
        resultMap.put("n", course.getName());
        resultMap.put("uid", user.getId());
        resultMap.put("rid", course.getRoomId());
        resultMap.put("hid", course.getTeacherId());
        resultMap.put("coverPath", course.getCoverPath());
        resultMap.put("userName", user.getName());
        resultMap.put("userPhoto", user.getHeadPhoto());

        saveParticipateUser(id);
        return ResponseUtils.success(resultMap);
    }

    /**
     * 获取小程序码
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/wxacode", method = RequestMethod.POST)
    @ResponseBody
    public Response wxacode(HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "id", "参数错误");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        String id = ServletRequestUtils.getStringParameter(request, "id", null);

        PmsLiveCourse course = pmsLiveCourseService.load(id);

        String page = "";
        if (course.getType() != null && course.getType() == PmsLiveCourse.LiveCourseTypeEnum.MULTI.getValue()) {
            page = "pages/live-course-multi/live-course-multi";
        } else {
            page = "pages/live-course/live-course";
        }

        WXACode wxaCode = wxOpenApi.getWXACode(page, id);
        if (wxaCode == null) {
            return ResponseUtils.warn("获取小程序码失败");
        }

        if (wxaCode.getBuffer() == null) {
            return ResponseUtils.warn("获取小程序码失败，错误信息：" + wxaCode.getErrcode() + "=>" + wxaCode.getErrmsg());
        }

        InputStream is = null;
        try {
            is = new ByteArrayInputStream(wxaCode.getBuffer());
            Attachment uploadFile = new Attachment();
            uploadFile.setId(KeyUtils.getKey());
            uploadFile.setRefId(Constants.DEFAULT_VALUE);
            uploadFile.setCreateTime(new Date());
            uploadFile.setSize((long) is.available());
            uploadFile.setOriginalName("wxacode.jpg");
            uploadFile.setCategory(0);
            uploadFile.setType("pic");
            String fileName = fileOperation.save(is, KeyUtils.getKey() + ".jpg");
            uploadFile.setPath(fileName);
            attachmentService.save(uploadFile);

            return ResponseUtils.success("success", fileName);
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseUtils.warn("保存文件异常");
        } finally {
            IOUtils.closeQuietly(is);
        }
        //return ResponseUtils.warn("获取小程序码失败");
    }

    /**
     * 添加嘉宾
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/saveUser", method = RequestMethod.POST)
    @ResponseBody
    public Response saveCourseStudent(PmsLiveCourseUser record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "liveCourseId", "所属直播课程为空");
        validator.required(request, "userId", "所选嘉宾为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        pmsLiveCourseUserService.save(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 查询嘉宾列表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/queryUsers", method = RequestMethod.POST)
    @ResponseBody
    public Response queryCourseUser(HttpServletRequest request, HttpServletResponse response) {
        String liveCourseId = ServletRequestUtils.getStringParameter(request, "liveCourseId", "_no_");
        List<PmsLiveCourseUser> users = pmsLiveCourseUserService.queryByCourseId(liveCourseId);
        return ResponseUtils.success(users);
    }

    /**
     * 删除嘉宾
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsLiveCourse/removeUser", method = RequestMethod.POST)
    @ResponseBody
    public Response removeCourseUser(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        pmsLiveCourseUserService.remove(id);
        return ResponseUtils.success("删除成功");
    }
}
