package com.yunfeisoft.controller.business;

import com.applet.base.BaseController;
import com.applet.file.FileOperation;
import com.applet.session.DomainModel;
import com.applet.session.SessionModel;
import com.applet.session.UserSession;
import com.applet.thread.ThreadPoolManager;
import com.applet.utils.*;
import com.applet.weixin.WXOpenApi;
import com.applet.weixin.model.WXACode;
import com.yunfeisoft.business.enums.ClassStatusEnum;
import com.yunfeisoft.business.model.Meeting;
import com.yunfeisoft.business.model.MeetingUser;
import com.yunfeisoft.business.service.inter.MeetingService;
import com.yunfeisoft.business.service.inter.MeetingUserService;
import com.yunfeisoft.enumeration.YesNoEnum;
import com.yunfeisoft.model.Attachment;
import com.yunfeisoft.model.User;
import com.yunfeisoft.service.inter.AttachmentService;
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
 * ClassName: MeetingController
 * Description: 会议表Controller
 * Author: Jackie liu
 * Date: 2020-03-29
 */
@Controller
public class MeetingController extends BaseController {

    @Autowired
    private MeetingService meetingService;
    @Autowired
    private MeetingUserService meetingUserService;
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
    private ThreadPoolManager threadPoolManager;

    /**
     * 添加会议表
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/save", method = RequestMethod.POST)
    @ResponseBody
    public Response save(Meeting record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "name", "会议名称为空");
        validator.required(request, "beginDate", "会议开始时间为空");
        validator.required(request, "endDate", "会议结束时间为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        if (StringUtils.isNotBlank(record.getInviteCode())) {
            record.setInviteCode(MD5Utils.encrypt(record.getInviteCode()));
        }

        User user = ApiUtils.getLoginUser();
        record.setHostId(user.getId());
        record.setStatus(ClassStatusEnum.NOT_BEGIN.getValue());
        record.setUserNum(0);

        meetingService.save(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 修改会议表
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/modify", method = RequestMethod.POST)
    @ResponseBody
    public Response modify(Meeting record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "id", "参数错误");
        validator.required(request, "name", "会议名称为空");
        validator.required(request, "beginDate", "会议开始时间为空");
        validator.required(request, "endDate", "会议结束时间为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        record.setInviteCode(null);

        meetingService.modify(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 查询会议表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/query", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response query(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        Meeting record = meetingService.load(id);
        return ResponseUtils.success(record);
    }

    /**
     * 分页查询会议表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/list", method = {RequestMethod.POST, RequestMethod.GET})
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

        Page<Meeting> page = meetingService.queryPage(params);
        return ResponseUtils.success(page);
    }

    /**
     * 批量删除会议表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/delete", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response delete(HttpServletRequest request, HttpServletResponse response) {
        String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
        if (StringUtils.isBlank(ids)) {
            return ResponseUtils.warn("参数错误");
        }
        meetingService.remove(ids.split(","));
        return ResponseUtils.success("删除成功");
    }

    /**
     * 设置主持人
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/saveHost", method = RequestMethod.POST)
    @ResponseBody
    public Response saveTeacher(HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "id", "参数错误");
        validator.required(request, "hostId", "所选主持人为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        String hostId = ServletRequestUtils.getStringParameter(request, "hostId", null);

        Meeting meeting = new Meeting();
        meeting.setId(id);
        meeting.setHostId(hostId);
        meetingService.modify(meeting);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 设置邀请码
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/modifyInviteCode", method = {RequestMethod.POST, RequestMethod.GET})
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
        meetingService.modifyInviteCode(id, MD5Utils.encrypt(inviteCode));
        return ResponseUtils.success("设置邀请码成功");
    }

    /**
     * 删除邀请码
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/removeInviteCode", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response removeInviteCode(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        meetingService.modifyInviteCode(id, null);
        return ResponseUtils.success("清除邀请码成功");
    }

    /**
     * 添加参会人员
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/saveUser", method = RequestMethod.POST)
    @ResponseBody
    public Response saveCourseStudent(MeetingUser record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "meetingId", "所属会议为空");
        validator.required(request, "userId", "所选人员为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        meetingUserService.save(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 查询参会人员列表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/queryUsers", method = RequestMethod.POST)
    @ResponseBody
    public Response queryCourseUser(HttpServletRequest request, HttpServletResponse response) {
        String meetingId = ServletRequestUtils.getStringParameter(request, "meetingId", "_no_");
        List<MeetingUser> users = meetingUserService.queryByMeetingId(meetingId);
        return ResponseUtils.success(users);
    }

    /**
     * 删除参会人员
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/removeUser", method = RequestMethod.POST)
    @ResponseBody
    public Response removeCourseUser(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        meetingUserService.remove(id);
        return ResponseUtils.success("删除成功");
    }

    /**
     * 查询我的会议
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/queryMyList", method = {RequestMethod.POST, RequestMethod.GET})
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

        List<Meeting> list = meetingService.queryList(params);
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
     * 参会人员进入会议室
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/toMeetingRoom", method = RequestMethod.POST)
    @ResponseBody
    public Response toMeetingRoom(HttpServletRequest request, HttpServletResponse response) {
        String mid = ServletRequestUtils.getStringParameter(request, "mid", null);
        if (StringUtils.isBlank(mid)) {
            return ResponseUtils.warn("参数错误");
        }

        Meeting meeting = null;
        String data = redisTemplate.opsForValue().get(mid);
        if (StringUtils.isNotBlank(data)) {
            meeting = FastJsonUtils.jsonToObj(data, Meeting.class);
        } else {
            meeting = meetingService.load(mid);
        }
        if (meeting == null) {
            return ResponseUtils.warn("该会议不存在");
        }

        if (meeting.getStatus() == ClassStatusEnum.OVER.getValue()) {
            return ResponseUtils.warn("该会议已结束");
        }

        long time = DateUtils.timeDiff(new Date(), meeting.getBeginDate());
        if (time > 10) {
            return ResponseUtils.warn("请在会议开始时间前10分钟进入会议室<br/>开始时间为：" + DateUtils.dateTimeToString(meeting.getBeginDate()));
        }

        User user = ApiUtils.getLoginUser();
        String userId = user.getId();

        //加载内容到缓存
        if (StringUtils.isBlank(data)) {
            data = FastJsonUtils.objToJson(meeting);
            long time1 = DateUtils.timeDiff(meeting.getBeginDate(), meeting.getEndDate());
            redisTemplate.opsForValue().set(meeting.getId(), data, time1 + 20, TimeUnit.MINUTES);
        }
        //如果不需要邀请码返回签名、会议名称
        String userSig = generateUserSig.genUserSig(userId);
        String screenSig = generateUserSig.genUserSig(userId + "_screen");
        String url = String.format("/view/business/meeting/meeting_live.htm?mid=%s&s=%s&sc=%s&n=%s&h=%s&rid=%d", mid, userSig, screenSig, meeting.getName(), meeting.getHostId(), meeting.getRoomId());

        saveParticipateUser(mid);
        return ResponseUtils.success("success", url);
    }

    /**
     * 分享页面判断去哪个课程页面
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/meeting/share/{id}", method = {RequestMethod.POST, RequestMethod.GET})
    public String toStudentClassRoom(@PathVariable("id") String id, HttpServletRequest request, HttpServletResponse response) {
        if (StringUtils.isBlank(id)) {
            return "redirect:" + domainModel.getWebDomain() + "/share_error.htm?error=1";
        }

        SessionModel sessionModel = userSession.getSessionModel();
        if (sessionModel == null) {
            return "redirect:" + domainModel.getWebDomain() + "/meeting_code_check.htm?mid=" + id;
        }
        String userId = sessionModel.getUser().getId();

        //缓存获取课程
        Meeting meeting = null;
        String data = redisTemplate.opsForValue().get(id);
        if (StringUtils.isNotBlank(data)) {
            meeting = FastJsonUtils.jsonToObj(data, Meeting.class);
        } else {
            meeting = meetingService.load(id);
        }
        if (meeting == null) {
            return "redirect:" + domainModel.getWebDomain() + "/share_error.htm?error=1";
        }

        if (meeting.getStatus() == ClassStatusEnum.OVER.getValue()) {
            return "redirect:" + domainModel.getWebDomain() + "/share_error.htm?error=3";
        }

        if (StringUtils.isBlank(data)) {
            data = FastJsonUtils.objToJson(meeting);
            long time1 = DateUtils.timeDiff(meeting.getBeginDate(), meeting.getEndDate());
            redisTemplate.opsForValue().set(meeting.getId(), data, time1 + 20, TimeUnit.MINUTES);
        }

        long time = DateUtils.timeDiff(new Date(), meeting.getBeginDate());
        if (time > 10) {
            return "redirect:" + domainModel.getWebDomain() + "/share_error.htm?error=4&date=" + DateUtils.dateTimeToString(meeting.getBeginDate());
        }

        //判断是否需要邀请码
        if (StringUtils.isNotBlank(meeting.getInviteCode())) {
            return "redirect:" + domainModel.getWebDomain() + "/meeting_code_check.htm?mid=" + id;
        }

        //如果不需要邀请码返回签名、会议名称
        String userSig = generateUserSig.genUserSig(userId);
        String screenSig = generateUserSig.genUserSig(userId + "_screen");
        String url = String.format("/view/business/meeting/meeting_live.htm?mid=%s&s=%s&sc=%s&n=%s&h=%s&rid=%d", id, userSig, screenSig, meeting.getName(), meeting.getHostId(), meeting.getRoomId());

        saveParticipateUser(id);
        return "redirect:" + domainModel.getWebDomain() + url;
    }

    /**
     * 邀请码验证
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/check/invit/code", method = RequestMethod.POST)
    @ResponseBody
    public Response checkInvitCode(HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "mid", "会议参数错误");
        validator.required(request, "code", "邀请码为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        String mid = ServletRequestUtils.getStringParameter(request, "mid", null);
        String code = ServletRequestUtils.getStringParameter(request, "code", null);

        //缓存获取code
        String data = redisTemplate.opsForValue().get(mid);
        if (StringUtils.isBlank(data)) {
            return ResponseUtils.warn("请等待主讲人进入直播间");
        }
        Meeting meeting = FastJsonUtils.jsonToObj(data, Meeting.class);
        //验证code是否正确
        if (!MD5Utils.validPassword(code, meeting.getInviteCode())) {
            return ResponseUtils.warn("邀请码不正确");
        }

        //返回会议名称、用户签名
        User user = ApiUtils.getLoginUser();
        String userId = user.getId();

        String app = ServletRequestUtils.getStringParameter(request, "app", null);
        if ("miniapp".equals(app)) {
            Map<String, String> config = sysConfigCache.getConfig();
            String userSig = generateUserSig.genUserSig(userId);

            Map<String, Object> resultMap = new HashMap<>();
            resultMap.put("mid", mid);
            resultMap.put("uid", userId);
            resultMap.put("userSig", userSig);
            resultMap.put("n", meeting.getName());
            resultMap.put("videoKey", config.get("videoKey"));
            resultMap.put("rid", meeting.getRoomId());
            resultMap.put("h", meeting.getHostId());
            saveParticipateUser(mid);
            return ResponseUtils.success(resultMap);
        }

        String userSig = generateUserSig.genUserSig(userId);
        String screenSig = generateUserSig.genUserSig(userId + "_screen");
        String url = String.format("/view/business/meeting/meeting_live.htm?mid=%s&s=%s&sc=%s&n=%s&h=%s&rid=%d", mid, userSig, screenSig, meeting.getName(), meeting.getHostId(), meeting.getRoomId());
        saveParticipateUser(mid);
        return ResponseUtils.success("success", url);
    }

    /**
     * 小程序端分享码进入课堂
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/share", method = RequestMethod.POST)
    @ResponseBody
    public Response toStudentMiniappClassRoom(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("该直播间不存在");
        }

        //缓存获取会议
        String data = redisTemplate.opsForValue().get(id);
        if (StringUtils.isBlank(data)) {
            return ResponseUtils.warn("请等待主讲人进入直播间");
        }
        Meeting meeting = FastJsonUtils.jsonToObj(data, Meeting.class);

        if (meeting.getStatus() == ClassStatusEnum.OVER.getValue()) {
            return ResponseUtils.warn("该会议已结束");
        }

        //判断是否需要邀请码
        if (StringUtils.isNotBlank(meeting.getInviteCode())) {
            return ResponseUtils.warn("inviteCode");
        }

        User user = ApiUtils.getLoginUser();
        //如果不需要邀请码返回签名、会议名称
        String userSig = generateUserSig.genUserSig(user.getId());

        Map<String, String> config = sysConfigCache.getConfig();
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("mid", id);
        resultMap.put("uid", user.getId());
        resultMap.put("userSig", userSig);
        resultMap.put("n", meeting.getName());
        resultMap.put("videoKey", config.get("videoKey"));
        resultMap.put("rid", meeting.getRoomId());
        resultMap.put("h", meeting.getHostId());

        saveParticipateUser(id);
        return ResponseUtils.success(resultMap);
    }

    /**
     * 小程序端客服验证(小程序审核时使用)
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/custome/service", method = RequestMethod.POST)
    @ResponseBody
    public Response customerService(HttpServletRequest request, HttpServletResponse response) {
        String userId = KeyUtils.getKey();
        String userSig = generateUserSig.genUserSig(userId);

        Map<String, String> config = sysConfigCache.getConfig();
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("uid", userId);
        resultMap.put("userSig", userSig);
        resultMap.put("n", "客服");
        resultMap.put("videoKey", config.get("videoKey"));
        resultMap.put("rid", 1002);
        return ResponseUtils.success(resultMap);
    }

    /**
     * 获取小程序码
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/meeting/wxacode", method = RequestMethod.POST)
    @ResponseBody
    public Response wxacode(HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "id", "参数错误");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        String id = ServletRequestUtils.getStringParameter(request, "id", null);

        String page = "pages/meeting/meeting";
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
}
