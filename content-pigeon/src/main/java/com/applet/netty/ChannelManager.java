package com.applet.netty;

import com.applet.push.inter.PushManager;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.http.websocketx.TextWebSocketFrame;
import io.netty.util.AttributeKey;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * 通道管理
 * Created by Jackie Liu on 2017/7/12.
 */
public final class ChannelManager implements PushManager<ChannelHandlerContext> {

    private static final ConcurrentHashMap<String, CopyOnWriteArrayList<ChannelHandlerContext>> contextMap = new ConcurrentHashMap<String, CopyOnWriteArrayList<ChannelHandlerContext>>();

    @Override
    public void addChannel(String roomId, String deviceId, ChannelHandlerContext ctx) {
        CopyOnWriteArrayList<ChannelHandlerContext> list = contextMap.get(roomId);
        if (list == null) {
            list = new CopyOnWriteArrayList<ChannelHandlerContext>();
            CopyOnWriteArrayList<ChannelHandlerContext> result = contextMap.putIfAbsent(roomId, list);
            if (result != null) {
                list = result;
            }
        }

        ctx.attr(AttributeKey.valueOf("deviceId")).set(deviceId);
        ctx.attr(AttributeKey.valueOf("roomId")).set(roomId);
        list.add(ctx);
    }

    @Override
    public void remove(ChannelHandlerContext ctx) {
        String roomId = ctx.attr(AttributeKey.<String>valueOf("roomId")).get();
        if (StringUtils.isBlank(roomId)) {
            return;
        }
        CopyOnWriteArrayList<ChannelHandlerContext> list = contextMap.get(roomId);
        if (list == null) {
            return;
        }
        list.remove(ctx);
        if (CollectionUtils.isEmpty(list)) {
            contextMap.remove(roomId);
        }
    }

    @Override
    public boolean send(String roomId, String message) {
        if (StringUtils.isBlank(roomId) || StringUtils.isBlank(message)) {
            return false;
        }
        CopyOnWriteArrayList<ChannelHandlerContext> list = contextMap.get(roomId);
        if (list == null || list.isEmpty()) {
            return false;
        }

        for (ChannelHandlerContext ctx : list) {
            if (ctx.channel().isActive()) {
                ctx.writeAndFlush(new TextWebSocketFrame(message));
            }
        }
        return true;
    }

    @Override
    public boolean send(String roomId, String[] deviceIds, String message) {
        if (ArrayUtils.isEmpty(deviceIds)) {
            return send(roomId, message);
        }
        CopyOnWriteArrayList<ChannelHandlerContext> list = contextMap.get(roomId.trim());
        if (list == null || list.isEmpty()) {
            return false;
        }

        List<String> strings = Arrays.asList(deviceIds);
        for (ChannelHandlerContext ctx : list) {
            String id = ctx.attr(AttributeKey.<String>valueOf("deviceId")).get();
            if (ctx.channel().isActive() && strings.indexOf(id) >= 0) {
                ctx.writeAndFlush(new TextWebSocketFrame(message));
            }
        }
        return true;
    }
}
