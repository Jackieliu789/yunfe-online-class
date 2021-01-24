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
import com.yunfeisoft.business.model.PmsCourseItem;
import com.yunfeisoft.business.model.PmsCourseUser;
import com.yunfeisoft.business.service.inter.PmsCourseItemService;
import com.yunfeisoft.business.service.inter.PmsCourseUserService;
import com.yunfeisoft.enumeration.YesNoEnum;
import com.yunfeisoft.model.Attachment;
import com.yunfeisoft.model.User;
import com.yunfeisoft.service.inter.AttachmentService;
import com.yunfeisoft.task.ParticipateUserSaveTask;
import com.yunfeisoft.utils.ApiUtils;
import com.yunfeisoft.utils.GenerateUserSig;
import com.yunfeisoft.utils.SysConfigCache;
import com.yunfeisoft.utils.TEduBoardUserSig;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * ClassName: PmsCourseItemController
 * Description: 互动课堂-课节表Controller
 * Author: Jackie liu
 * Date: 2020-03-27
 */
@Controller
public class PmsCourseItemController extends BaseController {

    @Autowired
    private PmsCourseItemService pmsCourseItemService;
    @Autowired
    private PmsCourseUserService pmsCourseUserService;
    @Autowired
    private GenerateUserSig generateUserSig;
    @Autowired
    private TEduBoardUserSig tEduBoardUserSig;
    @Autowired
    private FileOperation fileOperation;
    @Autowired
    private AttachmentService attachmentService;
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
    private ThreadPoolManager threadPoolManager;

    /**
     * 添加互动课堂-课节表
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/save", method = RequestMethod.POST)
    @ResponseBody
    public Response save(PmsCourseItem record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "courseId", "所属课程为空");
        validator.required(request, "name", "课节名称为空");
        validator.required(request, "type", "班型为空");
        validator.required(request, "beginDate", "上课开始时间为空");
        validator.required(request, "endDate", "上课结束时间为空");
        validator.required(request, "teacherId", "讲师为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }
        if (ArrayUtils.isEmpty(record.getUserIds())) {
            return ResponseUtils.warn("学员为空");
        }

        if (StringUtils.isNotBlank(record.getInviteCode())) {
            record.setInviteCode(MD5Utils.encrypt(record.getInviteCode()));
        }

        record.setSort(0);
        record.setClassStatus(ClassStatusEnum.NOT_BEGIN.getValue());
        record.setRecordStatus(YesNoEnum.NO_CANCEL.getValue());
        record.setStudentNum(record.getUserIds().length);

        pmsCourseItemService.save(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 修改互动课堂-课节表
     *
     * @param record
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/modify", method = RequestMethod.POST)
    @ResponseBody
    public Response modify(PmsCourseItem record, HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "id", "参数错误");
        validator.required(request, "courseId", "所属课程为空");
        validator.required(request, "name", "课节名称为空");
        validator.required(request, "type", "班型为空");
        validator.required(request, "beginDate", "上课开始时间为空");
        validator.required(request, "endDate", "上课结束时间为空");
        validator.required(request, "teacherId", "讲师为空");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }
        if (ArrayUtils.isEmpty(record.getUserIds())) {
            return ResponseUtils.warn("学员为空");
        }
        record.setInviteCode(null);

        pmsCourseItemService.modify(record);
        return ResponseUtils.success("保存成功");
    }

    /**
     * 查询互动课堂-课节表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/query", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response query(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        PmsCourseItem record = pmsCourseItemService.load(id);
        if (record != null) {
            Map<String, Object> params = new HashMap<>();
            params.put("courseId", id);
            params.put("type", PmsCourseUser.TypeEnum.STUDENT.getValue());
            List<PmsCourseUser> users = pmsCourseUserService.queryList(params);
            List<String> userIds = new ArrayList<>();
            for (PmsCourseUser pmsCourseUser : users) {
                userIds.add(pmsCourseUser.getUserId());
            }
            record.setUserIds(userIds.toArray(new String[]{}));
            //record.setCourseUserList(users);

            /*String sig = ServletRequestUtils.getStringParameter(request, "sig", null);
            if (StringUtils.isNotBlank(sig)) {
                User user = ApiUtils.getLoginUser();
                String userSig = generateUserSig.genUserSig(user.getId());
                String screenSig = generateUserSig.genUserSig(user.getId() + "_screen");
                record.setVideoSig(userSig);
                record.setScreenSig(screenSig);
            }*/
        }
        return ResponseUtils.success(record);
    }

    /**
     * 查询互动课堂-课节 用户信息表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/queryUsers", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response query2(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        Map<String, Object> params = new HashMap<>();
        params.put("courseId", id);
        params.put("type", PmsCourseUser.TypeEnum.STUDENT.getValue());
        List<PmsCourseUser> users = pmsCourseUserService.queryList(params);
        return ResponseUtils.success(users);
    }

    /**
     * 查询我的互动课堂-课节表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/queryMyList", method = {RequestMethod.POST, RequestMethod.GET})
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

        List<PmsCourseItem> list = pmsCourseItemService.queryList(params);
        return ResponseUtils.success(list);
    }

    /**
     * 分页查询互动课堂-课节表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/list", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response list(HttpServletRequest request, HttpServletResponse response) {
        String name = ServletRequestUtils.getStringParameter(request, "name", null);
        String courseId = ServletRequestUtils.getStringParameter(request, "courseId", null);

        Map<String, Object> params = new HashMap<String, Object>();
        initParams(params, request);
        params.put("name", name);
        params.put("courseId", courseId);

        Page<PmsCourseItem> page = pmsCourseItemService.queryPage(params);
        return ResponseUtils.success(page);
    }

    /**
     * 批量删除互动课堂-课节表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/delete", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response delete(HttpServletRequest request, HttpServletResponse response) {
        String ids = ServletRequestUtils.getStringParameter(request, "ids", null);
        if (StringUtils.isBlank(ids)) {
            return ResponseUtils.warn("参数错误");
        }
        pmsCourseItemService.remove(ids.split(","));
        return ResponseUtils.success("删除成功");
    }

    /**
     * 设置排序
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/modifySort", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response modifySort(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        int sort = ServletRequestUtils.getIntParameter(request, "sort", -1);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        if (sort < 0) {
            return ResponseUtils.warn("排序值不合法");
        }
        pmsCourseItemService.modifySort(id, sort);
        return ResponseUtils.success("设置排序成功");
    }

    /**
     * 设置邀请码
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/modifyInviteCode", method = {RequestMethod.POST, RequestMethod.GET})
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
        pmsCourseItemService.modifyInviteCode(id, MD5Utils.encrypt(inviteCode));
        return ResponseUtils.success("设置邀请码成功");
    }

    /**
     * 删除邀请码
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/removeInviteCode", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response removeInviteCode(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        pmsCourseItemService.modifyInviteCode(id, null);
        return ResponseUtils.success("清除邀请码成功");
    }

    /**
     * 上传附件
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/uploadAttachment", method = RequestMethod.POST)
    @ResponseBody
    public Response attachment(HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "courseItemId", "参数错误");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        String courseItemId = ServletRequestUtils.getStringParameter(request, "courseItemId", null);
        try {
            //创建一个通用的多部分解析器
            CommonsMultipartResolver resolver = new CommonsMultipartResolver(request.getSession().getServletContext());

            List<MultipartFile> fileList = null;
            //判断是否有文件上传,即多部分请求
            if (resolver.isMultipart(request)) {
                //转换成多部分request
                MultipartHttpServletRequest multiReq = (MultipartHttpServletRequest) request;
                fileList = multiReq.getFiles("files");
            }
            if (CollectionUtils.isEmpty(fileList)) {
                return ResponseUtils.warn("上传文件为空");
            }

            final List<Attachment> list = new ArrayList<Attachment>();
            BaseModel user = ApiUtils.getLogin();
            for (MultipartFile file : fileList) {
                if (file.getSize() <= 0) {
                    continue;
                }
                Attachment attachment = new Attachment();
                list.add(attachment);

                attachment.setId(KeyUtils.getKey());
                attachment.setRefId(courseItemId);
                attachment.setCreateTime(new Date());
                if (user != null) {
                    attachment.setCreateId(user.getId());
                }
                attachment.setSize(file.getSize());
                attachment.setOriginalName(file.getOriginalFilename());
                attachment.setCategory(0);

                String[] pics = {"jpg", "png", "jpeg", "gif", "bmp"};
                String extName = FilenameUtils.getExtension(file.getOriginalFilename()).toLowerCase();
                if (Arrays.asList(pics).indexOf(extName) >= 0) {
                    attachment.setType("pic");
                } else {
                    attachment.setType(extName);
                }

                String fileName = fileOperation.save(file.getInputStream(), KeyUtils.getKey() + "." + extName);
                attachment.setPath(fileName);
            }

            attachmentService.batchSave(list);

            return ResponseUtils.success(list);
        } catch (IOException e) {
            log.error("", e);
            return ResponseUtils.error("上传文件失败");
        }
    }

    /**
     * 查询附件信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/queryAttachments", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response queryAttachments(HttpServletRequest request, HttpServletResponse response) {
        String courseItemId = ServletRequestUtils.getStringParameter(request, "courseItemId", null);
        if (StringUtils.isBlank(courseItemId)) {
            return ResponseUtils.warn("参数错误");
        }

        List<Attachment> attachmentList = attachmentService.queryByRefId(courseItemId);
        return ResponseUtils.success(attachmentList);
    }

    /**
     * 删除附件信息
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/removeAttachment", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response removeAttachment(HttpServletRequest request, HttpServletResponse response) {
        String attachmentId = ServletRequestUtils.getStringParameter(request, "attachmentId", null);
        if (StringUtils.isBlank(attachmentId)) {
            return ResponseUtils.warn("参数错误");
        }

        Attachment attachment = new Attachment();
        attachment.setId(attachmentId);
        attachment.setRefId(Constants.DEFAULT_VALUE);
        attachmentService.modify(attachment);
        return ResponseUtils.success("删除成功");
    }

    private void saveParticipateUser(String roomId) {
        User user = ApiUtils.getLoginUser();
        if (user == null || StringUtils.isBlank(user.getId())) {
            return;
        }

        threadPoolManager.executeTask(new ParticipateUserSaveTask(roomId, user.getId()));
    }

    /**
     * 判断去哪个课程页面
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/toClassRoom", method = RequestMethod.POST)
    @ResponseBody
    public Response toClassRoom(HttpServletRequest request, HttpServletResponse response) {
        String cid = ServletRequestUtils.getStringParameter(request, "cid", null);
        if (StringUtils.isBlank(cid)) {
            return ResponseUtils.warn("参数错误");
        }

        PmsCourseItem pmsCourseItem = null;
        String data = redisTemplate.opsForValue().get(cid);
        if (StringUtils.isNotBlank(data)) {
            pmsCourseItem = FastJsonUtils.jsonToObj(data, PmsCourseItem.class);
        } else {
            pmsCourseItem = pmsCourseItemService.load(cid);
        }
        if (pmsCourseItem == null) {
            return ResponseUtils.warn("该互动课节不存在");
        }

        if (pmsCourseItem.getClassStatus() == ClassStatusEnum.OVER.getValue()) {
            return ResponseUtils.warn("该课程已结束直播");
        }

        long time = DateUtils.timeDiff(new Date(), pmsCourseItem.getBeginDate());
        if (time > 10) {
            return ResponseUtils.warn("请在互动课节开始时间前10分钟进入教室<br/>开始时间为：" + DateUtils.dateTimeToString(pmsCourseItem.getBeginDate()));
        }

        if (StringUtils.isBlank(data)) {
            data = FastJsonUtils.objToJson(pmsCourseItem);
            long time1 = DateUtils.timeDiff(pmsCourseItem.getBeginDate(), pmsCourseItem.getEndDate());
            redisTemplate.opsForValue().set(pmsCourseItem.getId(), data, time1 + 20, TimeUnit.MINUTES);
        }

        User user = ApiUtils.getLoginUser();
        String userId = user.getId();

        String url = "";
        if (userId.equals(pmsCourseItem.getTeacherId())) {
            String userSig = generateUserSig.genUserSig(userId);
            String screenSig = generateUserSig.genUserSig(userId + "_screen");
            if (pmsCourseItem.getType() == PmsCourseItem.TypeStatusEnum._1v49.getValue()) {
                url = String.format("/view/business/pmsCourse/course_small.htm?cid=%s&s=%s&sc=%s&n=%s&rid=%d", cid, userSig, screenSig, pmsCourseItem.getName(), pmsCourseItem.getRoomId());
            } else {
                url = String.format("/view/business/pmsCourse/course_large.htm?cid=%s&s=%s&sc=%s&n=%s&rid=%d", cid, userSig, screenSig, pmsCourseItem.getName(), pmsCourseItem.getRoomId());
            }
        } else {
            String userSig = generateUserSig.genUserSig(userId);
            if (pmsCourseItem.getType() == PmsCourseItem.TypeStatusEnum._1v49.getValue()) {
                url = String.format("/view/business/pmsCourse/course_small_stu.htm?cid=%s&s=%s&t=%s&n=%s&rid=%d&mv=%s", cid, userSig, pmsCourseItem.getTeacherId(), pmsCourseItem.getName(), pmsCourseItem.getRoomId(), pmsCourseItem.getMuteVoice());
            } else {
                url = String.format("/view/business/pmsCourse/course_large_stu.htm?cid=%s&s=%s&t=%s&n=%s&rid=%d&mv=%s", cid, userSig, pmsCourseItem.getTeacherId(), pmsCourseItem.getName(), pmsCourseItem.getRoomId(), pmsCourseItem.getMuteVoice());
            }
        }

        Map<String, String> config = sysConfigCache.getConfig();
        if ("1".equals(config.get("openBoardFlag"))) {
            String sig = tEduBoardUserSig.genUserSig(userId);
            String p = String.format("&_bk=%s&_bs=%s", config.get("boardKey"), sig);
            url += p;
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
    @RequestMapping(value = "/course/share/{id}", method = {RequestMethod.POST, RequestMethod.GET})
    public String toStudentClassRoom(@PathVariable("id") String id, HttpServletRequest request, HttpServletResponse response) {
        if (StringUtils.isBlank(id)) {
            return "redirect:" + domainModel.getWebDomain() + "/share_error.htm?error=1";
        }

        SessionModel sessionModel = userSession.getSessionModel();
        if (sessionModel == null) {
            return "redirect:" + domainModel.getWebDomain() + "/course_code_check.htm?cid=" + id;
        }
        String userId = sessionModel.getUser().getId();

        //缓存获取课程
        PmsCourseItem pmsCourseItem = null;
        String data = redisTemplate.opsForValue().get(id);
        if (StringUtils.isNotBlank(data)) {
            pmsCourseItem = FastJsonUtils.jsonToObj(data, PmsCourseItem.class);
        } else {
            pmsCourseItem = pmsCourseItemService.load(id);
        }
        if (pmsCourseItem == null) {
            return "redirect:" + domainModel.getWebDomain() + "/share_error.htm?error=1";
        }

        if (pmsCourseItem.getClassStatus() == ClassStatusEnum.OVER.getValue()) {
            return "redirect:" + domainModel.getWebDomain() + "/share_error.htm?error=3";
        }

        if (StringUtils.isBlank(data)) {
            data = FastJsonUtils.objToJson(pmsCourseItem);
            long time1 = DateUtils.timeDiff(pmsCourseItem.getBeginDate(), pmsCourseItem.getEndDate());
            redisTemplate.opsForValue().set(pmsCourseItem.getId(), data, time1 + 20, TimeUnit.MINUTES);
        }

        long time = DateUtils.timeDiff(new Date(), pmsCourseItem.getBeginDate());
        if (time > 10) {
            return "redirect:" + domainModel.getWebDomain() + "/share_error.htm?error=4&date=" + DateUtils.dateTimeToString(pmsCourseItem.getBeginDate());
        }

        //判断是否需要邀请码
        if (StringUtils.isNotBlank(pmsCourseItem.getInviteCode())) {
            return "redirect:" + domainModel.getWebDomain() + "/course_code_check.htm?cid=" + id;
        }

        //如果不需要邀请码返回签名、课程名称
        String userSig = generateUserSig.genUserSig(userId);
        String url = "";
        if (pmsCourseItem.getType() == PmsCourseItem.TypeStatusEnum._1v49.getValue()) {
            url = String.format("/view/business/pmsCourse/course_small_stu.htm?cid=%s&s=%s&t=%s&n=%s&rid=%d&mv=%s", id, userSig, pmsCourseItem.getTeacherId(), pmsCourseItem.getName(), pmsCourseItem.getRoomId(), pmsCourseItem.getMuteVoice());
        } else {
            url = String.format("/view/business/pmsCourse/course_large_stu.htm?cid=%s&s=%s&t=%s&n=%s&rid=%d&mv=%s", id, userSig, pmsCourseItem.getTeacherId(), pmsCourseItem.getName(), pmsCourseItem.getRoomId(), pmsCourseItem.getMuteVoice());
        }

        Map<String, String> config = sysConfigCache.getConfig();
        if ("1".equals(config.get("openBoardFlag"))) {
            String sig = tEduBoardUserSig.genUserSig(userId);
            String p = String.format("&_bk=%s&_bs=%s", config.get("boardKey"), sig);
            url += p;
        }

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
    @RequestMapping(value = "/web/pmsCourseItem/check/invit/code", method = RequestMethod.POST)
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
        PmsCourseItem pmsCourseItem = FastJsonUtils.jsonToObj(data, PmsCourseItem.class);
        //验证code是否正确
        if (!MD5Utils.validPassword(code, pmsCourseItem.getInviteCode())) {
            return ResponseUtils.warn("邀请码不正确");
        }

        //返回课程名称、用户签名
        User user = ApiUtils.getLoginUser();
        String userSig = generateUserSig.genUserSig(user.getId());

        String app = ServletRequestUtils.getStringParameter(request, "app", null);

        Map<String, String> config = sysConfigCache.getConfig();
        if ("miniapp".equals(app)) {
            Map<String, Object> resultMap = new HashMap<>();
            resultMap.put("cid", cid);
            resultMap.put("uid", user.getId());
            resultMap.put("userSig", userSig);
            resultMap.put("n", pmsCourseItem.getName());
            resultMap.put("videoKey", config.get("videoKey"));
            resultMap.put("rid", pmsCourseItem.getRoomId());
            resultMap.put("t", pmsCourseItem.getTeacherId());
            resultMap.put("un", user.getName());
            resultMap.put("mv", pmsCourseItem.getMuteVoice());

            if ("1".equals(config.get("openBoardFlag"))) {
                resultMap.put("_bk", config.get("boardKey"));

                String sig = tEduBoardUserSig.genUserSig(user.getId());
                resultMap.put("_bs", sig);

            }

            saveParticipateUser(cid);
            return ResponseUtils.success(resultMap);
        }

        String url = "";
        if (pmsCourseItem.getType() == PmsCourseItem.TypeStatusEnum._1v49.getValue()) {
            url = String.format("/view/business/pmsCourse/course_small_stu.htm?cid=%s&s=%s&t=%s&n=%s&rid=%d&mv=%s", cid, userSig, pmsCourseItem.getTeacherId(), pmsCourseItem.getName(), pmsCourseItem.getRoomId(), pmsCourseItem.getMuteVoice());
        } else {
            url = String.format("/view/business/pmsCourse/course_large_stu.htm?cid=%s&s=%s&t=%s&n=%s&rid=%d&mv=%s", cid, userSig, pmsCourseItem.getTeacherId(), pmsCourseItem.getName(), pmsCourseItem.getRoomId(), pmsCourseItem.getMuteVoice());
        }

        if ("1".equals(config.get("openBoardFlag"))) {
            String sig = tEduBoardUserSig.genUserSig(user.getId());
            String p = String.format("&_bk=%s&_bs=%s", config.get("boardKey"), sig);
            url += p;
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
    @RequestMapping(value = "/web/course/share", method = RequestMethod.POST)
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
        PmsCourseItem pmsCourseItem = FastJsonUtils.jsonToObj(data, PmsCourseItem.class);

        if (pmsCourseItem.getClassStatus() == ClassStatusEnum.OVER.getValue()) {
            return ResponseUtils.warn("该课程已结束直播");
        }

        //判断是否需要邀请码
        if (StringUtils.isNotBlank(pmsCourseItem.getInviteCode())) {
            return ResponseUtils.warn("inviteCode");
        }

        User user = ApiUtils.getLoginUser();
        //如果不需要邀请码返回签名、会议名称
        String userSig = generateUserSig.genUserSig(user.getId());

        Map<String, String> config = sysConfigCache.getConfig();
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("cid", id);
        resultMap.put("uid", user.getId());
        resultMap.put("userSig", userSig);
        resultMap.put("n", pmsCourseItem.getName());
        resultMap.put("videoKey", config.get("videoKey"));
        resultMap.put("rid", pmsCourseItem.getRoomId());
        resultMap.put("t", pmsCourseItem.getTeacherId());
        resultMap.put("un", user.getName());
        resultMap.put("mv", pmsCourseItem.getMuteVoice());

        if ("1".equals(config.get("openBoardFlag"))) {
            String sig = tEduBoardUserSig.genUserSig(user.getId());
            resultMap.put("_bs", sig);
            resultMap.put("_bk", config.get("boardKey"));
        }

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
    @RequestMapping(value = "/web/pmsCourseItem/wxacode", method = RequestMethod.POST)
    @ResponseBody
    public Response wxacode(HttpServletRequest request, HttpServletResponse response) {
        Validator validator = new Validator();
        validator.required(request, "id", "参数错误");
        if (validator.isError()) {
            return ResponseUtils.warn(validator.getMessage());
        }

        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        PmsCourseItem pmsCourseItem = pmsCourseItemService.load(id);

        String page = null;
        if (pmsCourseItem.getType() == PmsCourseItem.TypeStatusEnum._1v49.getValue()) {
            page = "pages/small-class/small-class";
        } else if (pmsCourseItem.getType() == PmsCourseItem.TypeStatusEnum._1vN.getValue()) {
            page = "pages/large-class/large-class";
        }

        if (StringUtils.isBlank(page)) {
            return ResponseUtils.warn("课程班型错误");
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
     * 课程是否静音
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/pmsCourseItem/muteVoice", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response muteVoice(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        String mute = ServletRequestUtils.getStringParameter(request, "mute", null);
        if (StringUtils.isBlank(id)) {
            return ResponseUtils.warn("参数错误");
        }
        if (StringUtils.isBlank(mute)) {
            return ResponseUtils.warn("是否静音参数失败");
        }

        //缓存获取课程
        String data = redisTemplate.opsForValue().get(id);
        if (StringUtils.isBlank(data)) {
            return ResponseUtils.warn("获取课程数据缓存失败");
        }
        PmsCourseItem pmsCourseItem = FastJsonUtils.jsonToObj(data, PmsCourseItem.class);
        pmsCourseItem.setMuteVoice(mute);

        data = FastJsonUtils.objToJson(pmsCourseItem);
        long time1 = DateUtils.timeDiff(pmsCourseItem.getBeginDate(), pmsCourseItem.getEndDate());
        redisTemplate.opsForValue().set(pmsCourseItem.getId(), data, time1 + 20, TimeUnit.MINUTES);
        return ResponseUtils.success("操作成功");
    }
}
