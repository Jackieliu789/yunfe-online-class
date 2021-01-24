/**
 * AttachmentController.java
 * Created at 2017-07-13
 * Created by Jackie liu
 * Copyright (C) 2014, All rights reserved.
 */
package com.yunfeisoft.controller.base;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.applet.base.BaseController;
import com.applet.base.BaseModel;
import com.applet.file.FileOperation;
import com.applet.utils.*;
import com.yunfeisoft.model.Attachment;
import com.yunfeisoft.model.User;
import com.yunfeisoft.service.inter.AttachmentService;
import com.yunfeisoft.utils.ApiUtils;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

/**
 * <p>ClassName: AttachmentController</p>
 * <p>Description: 通用附件管理Controller</p>
 * <p>Author: Jackie liu</p>
 * <p>Date: 2017-07-13</p>
 */
@Controller
public class AttachmentController extends BaseController {

    @Autowired
    private AttachmentService attachmentService;
    @Autowired
    private FileOperation fileOperation;
    @Value("${file.request.url}")
    private String fileRequestUrl;

    /**
     * 上传附件
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/attachment/upload", method = RequestMethod.POST)
    @ResponseBody
    public Response upload(HttpServletRequest request, HttpServletResponse response) {
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
            JSONArray jsonArray = new JSONArray();
            for (MultipartFile file : fileList) {
                if (file.getSize() <= 0) {
                    continue;
                }
                Attachment uploadFile = new Attachment();
                list.add(uploadFile);

                uploadFile.setId(KeyUtils.getKey());
                uploadFile.setRefId(Constants.DEFAULT_VALUE);
                uploadFile.setCreateTime(new Date());
                if (user != null) {
                    uploadFile.setCreateId(user.getId());
                }
                uploadFile.setSize(file.getSize());
                uploadFile.setOriginalName(file.getOriginalFilename().replaceAll(",", "_").replaceAll("，", "_"));
                uploadFile.setCategory(0);

                String[] pics = {"jpg", "png", "jpeg", "gif", "bmp"};
                String extName = FilenameUtils.getExtension(file.getOriginalFilename()).toLowerCase();
                if (Arrays.asList(pics).indexOf(extName) >= 0) {
                    uploadFile.setType("pic");
                } else {
                    uploadFile.setType(extName);
                }

                String fileName = fileOperation.save(file.getInputStream(), KeyUtils.getKey() + "." + extName);

                uploadFile.setPath(fileName);

                JSONObject json = new JSONObject();
                json.put("id", String.valueOf(uploadFile.getId()));
                json.put("name", uploadFile.getOriginalName());
                json.put("path", uploadFile.getPath());
                json.put("size", uploadFile.getSize());
                jsonArray.add(json);
            }

            attachmentService.batchSave(list);

            return ResponseUtils.success(jsonArray);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return ResponseUtils.error("上传文件失败");
    }

    /**
     * ueditor上传附件
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/attachment/ueupload", method = RequestMethod.POST)
    public void ueupload(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> result = new HashMap<>();
        result.put("state", "SUCCESS");
        result.put("type", "");
        result.put("url", "");
        result.put("name", "");
        result.put("originalName", "");
        result.put("size", "");

        PrintWriter writer = null;
        try {
            writer = response.getWriter();
            //创建一个通用的多部分解析器
            CommonsMultipartResolver resolver = new CommonsMultipartResolver(request.getSession().getServletContext());

            MultipartFile multipartFile = null;
            //判断是否有文件上传,即多部分请求
            if (resolver.isMultipart(request)) {
                //转换成多部分request
                MultipartHttpServletRequest multiReq = (MultipartHttpServletRequest) request;
                multipartFile = multiReq.getFile("upfile");
            }
            if (multipartFile == null) {
                result.put("state", "上传文件为空");
                writer.print(JSON.toJSONString(result));
                //writer.flush();
                return;
            }

            BaseModel user = ApiUtils.getLogin();
            Attachment uploadFile = new Attachment();

            uploadFile.setId(KeyUtils.getKey());
            uploadFile.setRefId(Constants.DEFAULT_VALUE);
            uploadFile.setCreateTime(new Date());
            if (user != null) {
                uploadFile.setCreateId(user.getId());
            }
            uploadFile.setSize(multipartFile.getSize());
            uploadFile.setOriginalName(multipartFile.getOriginalFilename().replaceAll(",", "_").replaceAll("，", "_"));
            uploadFile.setCategory(0);

            String[] pics = {"jpg", "png", "jpeg", "gif", "bmp"};
            String extName = FilenameUtils.getExtension(multipartFile.getOriginalFilename()).toLowerCase();
            if (Arrays.asList(pics).indexOf(extName) >= 0) {
                uploadFile.setType("pic");
            } else {
                uploadFile.setType(extName);
            }

            String fileName = fileOperation.save(multipartFile.getInputStream(), KeyUtils.getKey() + "." + extName);

            uploadFile.setPath(fileName);

            attachmentService.save(uploadFile);

            result.put("type", extName);
            result.put("url", uploadFile.getPath());
            result.put("name", uploadFile.getOriginalName());
            result.put("originalName", uploadFile.getOriginalName());
            result.put("size", uploadFile.getSize());

            writer.print(JSON.toJSONString(result));
            //writer.flush();
            return;
        } catch (IOException e) {
            e.printStackTrace();
        }
        result.put("state", "上传文件失败");
        writer.print(JSON.toJSONString(result));
        //writer.flush();
        return;
    }

    /**
     * 小程序上传附件
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/attachment/appletUpload", method = RequestMethod.POST)
    public void appletUpload(HttpServletRequest request, HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
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
                Map<String, Object> jsonMap = new HashMap();
                jsonMap.put("code", CommonReturnCode.WARN.code());
                jsonMap.put("message", "上传文件为空");
                jsonMap.put("success", false);
                String jsonString = JSON.toJSONString(jsonMap, new SerializerFeature[]{SerializerFeature.WriteMapNullValue});
                AjaxUtils.ajax(jsonString, "text/json");
                System.out.println("#########################3");
                return;
            }

            System.out.println("######################### list = " + fileList.size());

            final List<Attachment> list = new ArrayList<Attachment>();
            BaseModel user = ApiUtils.getLogin();
            JSONArray jsonArray = new JSONArray();
            for (MultipartFile file : fileList) {
                if (file.getSize() <= 0) {
                    continue;
                }
                Attachment uploadFile = new Attachment();
                list.add(uploadFile);

                uploadFile.setId(KeyUtils.getKey());
                uploadFile.setRefId(Constants.DEFAULT_VALUE);
                uploadFile.setCreateTime(new Date());
                if (user != null) {
                    uploadFile.setCreateId(user.getId());
                }
                uploadFile.setSize(file.getSize());
                uploadFile.setOriginalName(file.getOriginalFilename().replaceAll(",", "_").replaceAll("，", "_"));
                uploadFile.setCategory(0);

                String[] pics = {"jpg", "png", "jpeg", "gif", "bmp"};
                String extName = FilenameUtils.getExtension(file.getOriginalFilename()).toLowerCase();
                if (Arrays.asList(pics).indexOf(extName) >= 0) {
                    uploadFile.setType("pic");
                } else {
                    uploadFile.setType(extName);
                }

                String fileName = fileOperation.save(file.getInputStream(), KeyUtils.getKey() + "." + extName);

                uploadFile.setPath(fileName);

                JSONObject json = new JSONObject();
                json.put("id", String.valueOf(uploadFile.getId()));
                json.put("name", uploadFile.getOriginalName());
                json.put("path", uploadFile.getPath());
                json.put("size", uploadFile.getSize());
                jsonArray.add(json);
            }

            attachmentService.batchSave(list);

            Map<String, Object> jsonMap = new HashMap();
            jsonMap.put("code", CommonReturnCode.SUCCESS.code());
            jsonMap.put("message", "success");
            jsonMap.put("success", true);
            jsonMap.put("data", jsonArray);
            String jsonString = JSON.toJSONString(jsonMap, new SerializerFeature[]{SerializerFeature.WriteMapNullValue});
            AjaxUtils.ajax(jsonString, "text/json");
            System.out.println("#########################2");
            return;
            //return ResponseUtils.success(jsonArray);
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.println("#########################");
        Map<String, Object> jsonMap = new HashMap();
        jsonMap.put("code", CommonReturnCode.WARN.code());
        jsonMap.put("message", "上传文件失败");
        jsonMap.put("success", false);
        String jsonString = JSON.toJSONString(jsonMap, new SerializerFeature[]{SerializerFeature.WriteMapNullValue});
        AjaxUtils.ajax(jsonString, "text/json");
    }

    @RequestMapping(value = "/wx/attachment/upload", method = RequestMethod.POST)
    @ResponseBody
    public Response wxupload(HttpServletRequest request, HttpServletResponse response) {
        return upload(request, response);
    }

    @RequestMapping(value = "/api/attachment/upload", method = RequestMethod.POST)
    @ResponseBody
    public Response apiUpload(HttpServletRequest request, HttpServletResponse response) {
        return upload(request, response);
    }

    /**
     * im上传附件
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/attachment/imUpload", method = RequestMethod.POST)
    @ResponseBody
    public Response imUpload(HttpServletRequest request, HttpServletResponse response) {
        try {
            //创建一个通用的多部分解析器
            CommonsMultipartResolver resolver = new CommonsMultipartResolver(request.getSession().getServletContext());

            MultipartFile multipartFile = null;
            //判断是否有文件上传,即多部分请求
            if (resolver.isMultipart(request)) {
                //转换成多部分request
                MultipartHttpServletRequest multiReq = (MultipartHttpServletRequest) request;
                multipartFile = multiReq.getFile("file");
            }
            if (multipartFile == null) {
                return ResponseUtils.imWarn("上传文件为空");
            }

            User user = ApiUtils.getLoginUser();
            Attachment attachment = new Attachment();

            attachment.setId(KeyUtils.getKey());
            attachment.setRefId(Constants.DEFAULT_VALUE);
            attachment.setCreateTime(new Date());
            attachment.setCreateId(user.getId());
            attachment.setSize(multipartFile.getSize());
            attachment.setOriginalName(multipartFile.getOriginalFilename());
            attachment.setCategory(-1);

            String[] pics = {"jpg", "png", "jpeg", "gif", "bmp"};
            String extName = FilenameUtils.getExtension(multipartFile.getOriginalFilename()).toLowerCase();
            if (Arrays.asList(pics).indexOf(extName) >= 0) {
                attachment.setType("pic");
            } else {
                attachment.setType(extName);
            }

            String fileName = fileOperation.save(multipartFile.getInputStream(), KeyUtils.getKey() + "." + extName);
            attachment.setPath(fileName);

            String src = new StringBuilder()
                    .append("redirect:")
                    .append(fileRequestUrl)
                    .append(attachment.getPath())
                    .append("?filename=")
                    .append(attachment.getOriginalName())
                    .toString();

            Map<String, Object> resultMap = new HashMap<>();
            resultMap.put("name", attachment.getOriginalName());
            resultMap.put("src", src);

            attachmentService.save(attachment);

            return ResponseUtils.imSuccess(resultMap);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return ResponseUtils.imWarn("上传文件失败");
    }

    /**
     * 下载附件
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/attachment/download", method = {RequestMethod.POST, RequestMethod.GET})
    public String download(HttpServletRequest request, HttpServletResponse response) {
        String id = ServletRequestUtils.getStringParameter(request, "id", null);
        return downloadPath(id, request, response);
    }

    /**
     * 下载附件
     *
     * @param id
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/attachment/download/{id}", method = {RequestMethod.POST, RequestMethod.GET})
    public String downloadPath(@PathVariable("id") String id, HttpServletRequest request, HttpServletResponse response) {
        if (StringUtils.isBlank(id)) {
            AjaxUtils.ajaxText("参数错误");
            return null;
        }
        Attachment attachment = attachmentService.load(id);
        if (attachment == null) {
            AjaxUtils.ajaxText("该文件不存在");
            return null;
        }
        return new StringBuilder().append("redirect:").append(fileRequestUrl)
                .append(attachment.getPath()).append("?filename=").append(attachment.getOriginalName()).toString();
    }

    /**
     * 将文件转成base64字符串
     *
     * @param id
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/web/attachment/read/{id}", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Response readBase64(@PathVariable("id") String id, HttpServletRequest request, HttpServletResponse response) {
        if (StringUtils.isBlank(id)) {
            AjaxUtils.ajaxText("参数错误");
            return null;
        }
        Attachment attachment = attachmentService.load(id);
        if (attachment == null) {
            AjaxUtils.ajaxText("该文件不存在");
            return null;
        }

        byte[] byteArray = fileOperation.read(attachment.getPath());
        if (byteArray == null) {
            return ResponseUtils.warn("文件转码错误");
        }
        return ResponseUtils.success("success", Base64.encodeBase64String(byteArray));
    }
}
