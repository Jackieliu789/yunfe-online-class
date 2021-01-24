package com.applet.netty;

import io.netty.handler.codec.http.FullHttpRequest;
import io.netty.handler.codec.http.HttpMethod;
import io.netty.handler.codec.http.QueryStringDecoder;
import io.netty.handler.codec.http.multipart.Attribute;
import io.netty.handler.codec.http.multipart.HttpPostRequestDecoder;
import io.netty.handler.codec.http.multipart.InterfaceHttpData;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Http请求参数封装
 * Created by Jackie Liu on 2017/7/11.
 */
public class HttpRequestParser {

    private FullHttpRequest request;

    /**
     * 构造一个解析器
     *
     * @param request
     */
    public HttpRequestParser(FullHttpRequest request) {
        this.request = request;
    }

    /**
     * 解析请求参数
     *
     * @return 包含所有请求参数的键值对, 如果没有参数, 则返回空Map
     * @throws IOException
     */
    public Map<String, String> parse() throws IOException {
        HttpMethod method = request.getMethod();

        Map<String, String> parmMap = new HashMap<>();

        if (HttpMethod.GET == method) {
            // 是GET请求
            QueryStringDecoder decoder = new QueryStringDecoder(request.getUri());
            for (Map.Entry<String, List<String>> entry : decoder.parameters().entrySet()) {
                parmMap.put(entry.getKey(), entry.getValue().get(0));
            }
        } else if (HttpMethod.POST == method) {
            // 是POST请求
            HttpPostRequestDecoder decoder = new HttpPostRequestDecoder(request);
            decoder.offer(request);

            List<InterfaceHttpData> parmList = decoder.getBodyHttpDatas();

            for (InterfaceHttpData parm : parmList) {

                Attribute data = (Attribute) parm;
                parmMap.put(data.getName(), data.getValue());
            }
        }
        return parmMap;
    }
}
